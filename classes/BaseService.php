<?php

/*
This file is part of Ice Framework.

Ice Framework is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ice Framework is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ice Framework. If not, see <http://www.gnu.org/licenses/>.

------------------------------------------------------------------

Original work Copyright (c) 2012 [Gamonoid Media Pvt. Ltd]  
Developer: Thilina Hasantha (thilina.hasantha[at]gmail.com / facebook.com/thilinah)
 */


/**
 * BaseService class serves as the core logic for managing the application and for handling most 
 * of the tasks related to retriving and saving data. This can be referred within any module using
 * BaseService::getInstance()
 * 
 @class BaseService
 */

class BaseService{
	
	var $nonDeletables = array();
	var $errros = array();
	public $userTables = array();
	var $currentUser = null;
	var $db = null;
	var $auditManager = null;
	var $notificationManager = null;
	var $settingsManager = null;
	var $fileFields = null;
	var $moduleManagers = null;
	var $emailSender = null;
    var $user = null;
	
	private static $me = null;
	
	private function __construct(){
	
	}
	
	/**
	 * Get the only instance created for BaseService
	 * @method getInstance
	 * @return {BaseService} BaseService object
	 */
	
	public static function getInstance(){
		if(empty(self::$me)){
			self::$me = new BaseService();
		}

		return self::$me;
	}
	
	/**
	 * Get an array of objects from database
	 * @method get
	 * @param $table {String} model class name of the table to retive data (e.g for Users table model class name is User)
	 * @param $mappingStr {String} a JSON string to specify fields of the $table should be mapped to other tables (e.g {"profile":["Profile","id","first_name+last_name"]} : this is how the profile field in Users table is mapped to Profile table. In this case users profile field will get filled by Profile first name and last name. The original value in User->profile field will get moved to User->profile_id)
	 * @param $filterStr {String} a JSON string to specify the ordering of the items (e.g {"job_title":"2","department":"2"}  - this will select only items having job_title = 2 and department = 2)
	 * @param $orderBy {String} a string to specify the ordering (e.g in_time desc)
	 * @param string $limit {String} a string to specify the limit (e.g limit 2)
	 * @return {Array} an array of objects of type $table
	 */
	public function get($table,$mappingStr = null, $filterStr = null, $orderBy = null, $limit = null){
		
		if(!empty($mappingStr)){
		$map = json_decode($mappingStr);
		}
		$obj = new $table();
		
		$this->checkSecureAccess("get",$obj);
		
		$query = "";
		$queryData = array();
		if(!empty($filterStr)){
			$filter = json_decode($filterStr, true);
			
			if(!empty($filter)){
				foreach($filter as $k=>$v){
					LogManager::getInstance()->info($filterStr);
					if($v == '__myid__'){
						$v = $this->getCurrentProfileId();
					}
					$query.=" and ".$k."=?";
					$queryData[] = $v;
				}	
			}	
		}
		
		if(empty($orderBy)){
			$orderBy = "";
		}else{
			$orderBy = " ORDER BY ".$orderBy;
		}
		
		
		if(in_array($table, $this->userTables)){
			$cemp = $this->getCurrentProfileId();
			if(!empty($cemp)){
				$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
				$list = $obj->Find($signInMappingField." = ?".$query.$orderBy, array_merge(array($cemp),$queryData));	
			}else{
				$list = array();
			}
					
		}else{
			$list = $obj->Find("1=1".$query.$orderBy,$queryData);	
		}	
		
		if(!empty($mappingStr) && count($map)>0){
			$list = $this->populateMapping($list, $map);
		}

		return $list;
	}
	
	public function buildDefaultFilterQuery($filter){
		$query = "";
		$queryData = array();
		foreach($filter as $k=>$v){
			if(empty($v)){
				continue;
			}
			$vArr = json_decode($v);
			if(is_array($vArr)){
				if(empty($vArr)){
					continue;
				}
				$v = $vArr;
				$length = count($v);
				for($i=0; $i<$length; $i++){
					$query.=$k." like ?";
					
					if($i == 0){
						$query.=" and (";
					}
					
					if($i < $length -1){
						$query.=" or ";
					}else{
						$query.=")";
					}
					$queryData[] = "%".$v[$i]."%";
				}
					
			}else{
				if(!empty($v) && $v != 'NULL'){
					$query.=" and ".$k."=?";
                    if($v == '__myid__'){
                        $v = $this->getCurrentProfileId();
                    }
					$queryData[] = $v;
				}
					
			}
				
		}

		return array($query, $queryData);
	}


    public function getSortingData($req){
        $data = array();
        $data['sorting'] = $req['sorting'];

        $columns = json_decode($req['cl'],true);

        $data['column'] = $columns[$req['iSortCol_0']];

        $data['order'] = $req['sSortDir_0'];

        return $data;
    }
	
	/**
	 * An extention of get method for the use of data tables with ability to search
	 * @method getData
	 * @param $table {String} model class name of the table to retive data (e.g for Users table model class name is User)
	 * @param $mappingStr {String} a JSON string to specify fields of the $table should be mapped to other tables (e.g {"profile":["Profile","id","first_name+last_name"]} : this is how the profile field in Users table is mapped to Profile table. In this case users profile field will get filled by Profile first name and last name. The original value in User->profile field will get moved to User->profile_id)
	 * @param $filterStr {String} a JSON string to specify the ordering of the items (e.g {"job_title":"2","department":"2"}  - this will select only items having job_title = 2 and department = 2)
	 * @param $orderBy {String} a string to specify the ordering (e.g in_time desc)
	 * @param string $limit {String} a string to specify the limit (e.g limit 2)
	 * @param string $searchColumns {String} a JSON string to specify names of searchable fields (e.g ["id","employee_id","first_name","last_name","mobile_phone","department","gender","supervisor"])
	 * @param string $searchTerm {String} a string to specify term to search
	 * @param string $isSubOrdinates {Boolean} a Boolean to specify if we only need to retive subordinates. Any item is a subordinate item if the item has "profile" field defined and the value of "profile" field is equal to id of one of the subordinates of currenly logged in profile id. (Any Profile is a subordinate of curently logged in Profile if the supervisor field of a Profile is set to the id of currently logged in Profile)
	 * @param string $skipProfileRestriction {Boolean} default if false - TODO - I'll explain this later
	 * @return {Array} an array of objects of type $table
	 */
	public function getData($table,$mappingStr = null, $filterStr = null, $orderBy = null, $limit = null, $searchColumns = null, $searchTerm = null, $isSubOrdinates = false, $skipProfileRestriction = false, $sortData = array()){
		if(!empty($mappingStr)){
		$map = json_decode($mappingStr);
		}
		$obj = new $table();
		$this->checkSecureAccess("get",$obj);
		$query = "";
		$queryData = array();
		if(!empty($filterStr)){
			$filter = json_decode($filterStr);
			if(!empty($filter)){
				LogManager::getInstance()->debug("Building filter query");
				if(method_exists($obj,'getCustomFilterQuery')){
					LogManager::getInstance()->debug("Method: getCustomFilterQuery exists");
					$response = $obj->getCustomFilterQuery($filter);
					$query = $response[0];
					$queryData = $response[1];
				}else{
					LogManager::getInstance()->debug("Method: getCustomFilterQuery not found");
					$defaultFilterResp = $this->buildDefaultFilterQuery($filter);	
					$query = $defaultFilterResp[0];
					$queryData = $defaultFilterResp[1];
				}
				
				
			}

			LogManager::getInstance()->debug("Filter Query:".$query);
			LogManager::getInstance()->debug("Filter Query Data:".json_encode($queryData));
		}
		
		
		if(!empty($searchTerm) && !empty($searchColumns)){
			$searchColumnList = json_decode($searchColumns);
            $searchColumnList = array_diff($searchColumnList, $obj->getVirtualFields());
            if(!empty($searchColumnList)){
                $tempQuery = " and (";
                foreach($searchColumnList as $col){

                    if($tempQuery != " and ("){
                        $tempQuery.=" or ";
                    }
                    $tempQuery.=$col." like ?";
                    $queryData[] = "%".$searchTerm."%";
                }
                $query.= $tempQuery.")";
            }

		}

        if(!empty($sortData) && $sortData['sorting']."" == "1" && isset($sortData['column'])){

            $orderBy = " ORDER BY ".$sortData['column']." ".$sortData['order'];

        }else{
            if(empty($orderBy)){
                $orderBy = "";
            }else{
                $orderBy = " ORDER BY ".$orderBy;
            }
        }



		
		if(empty($limit)){
			$limit = "";	
		}
		
		
		
		if(in_array($table, $this->userTables) && !$skipProfileRestriction){
			
			$cemp = $this->getCurrentProfileId();
			if(!empty($cemp)){
				if(!$isSubOrdinates){
					array_unshift($queryData, $cemp);
					//$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
                    $signInMappingField = $obj->getUserOnlyMeAccessField();
                    LogManager::getInstance()->debug("Data Load Query (x1):"."1=1".$signInMappingField." = ?".$query.$orderBy.$limit);
                    LogManager::getInstance()->debug("Data Load Query Data (x1):".json_encode($queryData));
                    $list = $obj->Find($signInMappingField." = ?".$query.$orderBy.$limit, $queryData);
				}else{
					$profileClass = ucfirst(SIGN_IN_ELEMENT_MAPPING_FIELD_NAME);
					$subordinate = new $profileClass();
					$subordinates = $subordinate->Find("supervisor = ?",array($cemp));
					$subordinatesIds = "";
					foreach($subordinates as $sub){
						if($subordinatesIds != ""){
							$subordinatesIds.=",";
						}
						$subordinatesIds.=$sub->id;
					}
					$subordinatesIds.="";
					//$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
                    $signInMappingField = $obj->getUserOnlyMeAccessField();
                    LogManager::getInstance()->debug("Data Load Query (x2):"."1=1".$signInMappingField." in (".$subordinatesIds.") ".$query.$orderBy.$limit);
                    LogManager::getInstance()->debug("Data Load Query Data (x2):".json_encode($queryData));
					$list = $obj->Find($signInMappingField." in (".$subordinatesIds.") ".$query.$orderBy.$limit, $queryData);
				}
					
			}else{
				$list = array();
			}
					
		}else if($isSubOrdinates){
            $cemp = $this->getCurrentProfileId();
            if(!empty($cemp)){
                $profileClass = ucfirst(SIGN_IN_ELEMENT_MAPPING_FIELD_NAME);
                $subordinate = new $profileClass();
                $subordinates = $subordinate->Find("supervisor = ?",array($cemp));
                $subordinatesIds = "";
                foreach($subordinates as $sub){
                    if($subordinatesIds != ""){
                        $subordinatesIds.=",";
                    }
                    $subordinatesIds.=$sub->id;
                }
                $subordinatesIds.="";
                //$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
                $signInMappingField = $subordinate->getUserOnlyMeAccessField();
                LogManager::getInstance()->debug("Data Load Query (a1):".$signInMappingField." in (".$subordinatesIds.") ".$query.$orderBy.$limit);
                $list = $obj->Find($signInMappingField." in (".$subordinatesIds.") ".$query.$orderBy.$limit, $queryData);
            }else{
                $list = $obj->Find("1=1".$query.$orderBy.$limit,$queryData);
            }
		}else{
			$list = $obj->Find("1=1".$query.$orderBy.$limit,$queryData);
		}	

        if(!$list){
            LogManager::getInstance()->debug("Get Data Error:".$obj->ErrorMsg());
        }
		
		LogManager::getInstance()->debug("Data Load Query:"."1=1".$query.$orderBy.$limit);
		LogManager::getInstance()->debug("Data Load Query Data:".json_encode($queryData));

        $processedList = array();
        foreach($list as $obj){
            $processedList[] = $obj->postProcessGetData($obj);
        }

        $list = $processedList;
		
		if(!empty($mappingStr) && count($map)>0){
			$list = $this->populateMapping($list, $map);
		}
		
		
		return $list;
	}
	
	
	/**
	 * Propulate field mappings for a given set of objects
	 * @method populateMapping
	 * @param $list {Array} array of model objects
	 * @param $map {Array} an associative array of Mappings (e.g {"profile":["Profile","id","first_name+last_name"]})
	 * @return {Array} array of populated objects
	 */
	
	public function populateMapping($list,$map){
		$listNew = array();
		if(empty($list)){
			return $listNew;
		}
		foreach($list as $item){
			$item = $this->populateMappingItem($item, $map);
			$listNew[] = $item;	
		}
		return 	$listNew;
	}
	
	public function populateMappingItem($item,$map){
		foreach($map as $k=>$v){
			$fTable = $v[0];
			$tObj = new $fTable();
			$tObj->Load($v[1]."= ?",array($item->$k));
			
			if($tObj->$v[1] == $item->$k){
				$v[2] = str_replace("+"," ",$v[2]);
				$values = explode(" ", $v[2]);
				if(count($values) == 1){
					$idField = $k."_id";
					$item->$idField = $item->$k;
					$item->$k = $tObj->$v[2];	
					
				}else{
					$objVal = "";
					foreach($values as $v){
						if($objVal != ""){
							$objVal .= " ";	
						}
						$objVal .= $tObj->$v;
					}
					$idField = $k."_id";
					$item->$idField = $item->$k;
					$item->$k = $objVal;
				}
			}	
		}
		return 	$item;
	}
	
	/**
	 * Retive one element from db
	 * @method getElement
	 * @param $table {String} model class name of the table to get data (e.g for Users table model class name is User)
	 * @param $table {Integer} id of the item to get from $table 
	 * @param $mappingStr {String} a JSON string to specify fields of the $table should be mapped to other tables (e.g {"profile":["Profile","id","first_name+last_name"]} : this is how the profile field in Users table is mapped to Profile table. In this case users profile field will get filled by Profile first name and last name. The original value in User->profile field will get moved to User->profile_id)
	 * @param $skipSecurityCheck {Boolean} if true won't check whether the user has access to that object
	 * @return {Object} an object of type $table
	 */
	
	public function getElement($table,$id,$mappingStr = null, $skipSecurityCheck = false){
		$obj = new $table();
		
		
		if(in_array($table, $this->userTables)){
			$cemp = $this->getCurrentProfileId();
			if(!empty($cemp)){
				$obj->Load("id = ?", array($id));	
			}else{
			}
					
		}else{
			$obj->Load("id = ?",array($id));
		}
		
		if(!$skipSecurityCheck){
			$this->checkSecureAccess("element",$obj);
		}
		
		if(!empty($mappingStr)){
			$map = json_decode($mappingStr);	
		}
		if($obj->id == $id){
			if(!empty($mappingStr)){
				foreach($map as $k=>$v){
					$fTable = $v[0];
					$tObj = new $fTable();
					$tObj->Load($v[1]."= ?",array($obj->$k));
					if($tObj->$v[1] == $obj->$k){
						$name = $k."_Name";
						$values = explode("+", $v[2]);
						if(count($values) == 1){
							$idField = $name."_id";
							$obj->$idField = $obj->$name;
							$obj->$name = $tObj->$v[2];	
						}else{
							$objVal = "";
							foreach($values as $v){
								if($objVal != ""){
									$objVal .= " ";	
								}
								$objVal .= $tObj->$v;
							}
							$idField = $name."_id";
							$obj->$idField = $obj->$name;
							$obj->$name = $objVal;
						}
					}	
				}
			}
			return 	$obj;
		}
		return null;
	}
	
	/**
	 * Add an element to a given table
	 * @method addElement
	 * @param $table {String} model class name of the table to add data (e.g for Users table model class name is User)
	 * @param $obj {Array} an associative array with field names and values for the new object. If the object id is not empty an existing object will be updated
	 * @return {Object} newly added or updated element of type $table
	 */
	
	public function addElement($table,$obj){
		$isAdd = true;
		$ele = new $table();
		if(class_exists("ProVersion")){
			$pro = new ProVersion();
			$subscriptionTables = $pro->getSubscriptionTables();
			if(in_array($table,$subscriptionTables)){
				$resp = $pro->subscriptionCheck($obj);
				if($resp->getStatus() != IceResponse::SUCCESS){
					return $resp;
				}
			}
		}
		
		if(!empty($obj['id'])){
			$isAdd = false;
			$ele->Load('id = ?',array($obj['id']));	
		}
		
		foreach($obj as $k=>$v){
			if($k == 'id' || $k == 't' || $k == 'a'){
				continue;	
			}
			if($v == "NULL"){
				$v = null;	
			}
			$ele->$k = $v;	
		}
		
		
		if(empty($obj['id'])){	
			if(in_array($table, $this->userTables)){
				$cemp = $this->getCurrentProfileId();
				if(!empty($cemp)){
					$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
					$ele->$signInMappingField = $cemp;	
				}else{
					return new IceResponse(IceResponse::ERROR,"Profile id is not set");
				}		
			}
		}
		
		$this->checkSecureAccess("save",$ele);
		
		$resp =$ele->validateSave($ele);
		if($resp->getStatus() != IceResponse::SUCCESS){
			return $resp;
		}
		
		if($isAdd){
			if(empty($ele->created)){
				$ele->created = date("Y-m-d H:i:s");
			}
		}
		
		if(empty($ele->updated)){
			$ele->updated = date("Y-m-d H:i:s");
		}
		if($isAdd){
			$ele = $ele->executePreSaveActions($ele)->getData();
		}else{
			$ele = $ele->executePreUpdateActions($ele)->getData();
		}
		
		
		$ok = $ele->Save();
		if(!$ok){
			
			$error = $ele->ErrorMsg();
			
			LogManager::getInstance()->info($error);
			
			if($isAdd){
				$this->audit(IceConstants::AUDIT_ERROR, "Error occured while adding an object to ".$table." \ Error: ".$error);
			}else{
				$this->audit(IceConstants::AUDIT_ERROR, "Error occured while editing an object in ".$table." [id:".$ele->id."] \ Error: ".$error);
			}
			return new IceResponse(IceResponse::ERROR,$this->findError($error));		
		}
		
		if($isAdd){
			$ele->executePostSaveActions($ele);
			$this->audit(IceConstants::AUDIT_ADD, "Added an object to ".$table." [id:".$ele->id."]");
		}else{
			$ele->executePostUpdateActions($ele);
			$this->audit(IceConstants::AUDIT_EDIT, "Edited an object in ".$table." [id:".$ele->id."]");
		}
		
		return new IceResponse(IceResponse::SUCCESS,$ele);
	}
	
	/**
	 * Delete an element if not the $table and $id is defined as a non deletable
	 * @method deleteElement
	 * @param $table {String} model class name of the table to delete data (e.g for Users table model class name is User)
	 * @param $id {Integer} id of the item to delete
	 * @return NULL
	 */
	public function deleteElement($table,$id){
		$fileFields = $this->fileFields;
		$ele = new $table();
		
		$ele->Load('id = ?',array($id));

		$this->checkSecureAccess("delete",$ele);
		
		if(isset($this->nonDeletables[$table])){
			$nonDeletableTable = $this->nonDeletables[$table];
			if(!empty($nonDeletableTable)){
				foreach($nonDeletableTable as $field => $value){
					if($ele->$field == $value){
						return "This item can not be deleted";
					}
				}
			}	
		}

		$ok = $ele->Delete();
		if(!$ok){
			$error = $ele->ErrorMsg();
			LogManager::getInstance()->info($error);
			return $this->findError($error);	
		}else{
			//Backup
			if($table == "Profile"){
				$newObj = $this->cleanUpAdoDB($ele);
				$dataEntryBackup = new DataEntryBackup();
				$dataEntryBackup->tableType = $table;
				$dataEntryBackup->data = json_encode($newObj);
				$dataEntryBackup->Save();
			}
			
			$this->audit(IceConstants::AUDIT_DELETE, "Deleted an object in ".$table." [id:".$ele->id."]");
		}
		
		
		
		if(isset($fileFields[$table])){
			foreach($fileFields[$table] as $k=>$v){
				if(!empty($ele->$k)){
					FileService::getInstance()->deleteFileByField($ele->$k,$v);
				}
					
			}
		}
		
		return null;
	}
	
	/**
	 * Get associative array of by retriving data from $table using $key field ans key and $value field as value. Mainly used for getting data for populating option lists of select boxes when adding and editing items
	 * @method getFieldValues
	 * @param $table {String} model class name of the table to get data (e.g for Users table model class name is User)
	 * @param $key {String} key field name
	 * @param $value {String} value field name (multiple fileds cam be concatinated using +) - e.g first_name+last_name
	 * @param $method {String} if not empty, use this menthod to get only a selected set of objects from db instead of retriving all objects. This method should be defined in class $table and should return an array of objects of type $table
	 * @return {Array} associative array
	 */
	
	public function getFieldValues($table,$key,$value,$method,$methodParams = NULL){
		
		$values = explode("+", $value);
		
		$ret = array();
		$ele = new $table();
		if(!empty($method)){
			LogManager::getInstance()->debug("Call method for getFieldValues:".$method);
			LogManager::getInstance()->debug("Call method params for getFieldValues:".json_decode($methodParams));
			if(method_exists($ele,$method)){
				if(!empty($methodParams)){
					$list = $ele->$method(json_decode($methodParams));
				}else{
					$list = $ele->$method(array());
				}
			}else{
				LogManager::getInstance()->debug("Could not find method:".$method." in Class:".$table);
				$list = $ele->Find('1 = 1',array());
			}
			
		}else{
			$list = $ele->Find('1 = 1',array());
		}
		
		foreach($list as $obj){
			if(count($values) == 1){
				$ret[$obj->$key] = $obj->$value;	
			}else{
				$objVal = "";
				foreach($values as $v){
					if($objVal != ""){
						$objVal .= " ";	
					}
					$objVal .= $obj->$v;
				}
				$ret[$obj->$key] = $objVal;
			}
		}	
		return $ret;
	}
	
	public function setNonDeletables($table, $field, $value){
		if(!isset($this->nonDeletables[$table])){
			$this->nonDeletables[$table] = array();	
		}
		$this->nonDeletables[$table][$field] = $value;
	}
	
	public function setSqlErrors($errros){
		$this->errros = $errros;	
	}
	
	public function setUserTables($userTables){
		$this->userTables = $userTables;	
	}
	
	/**
	 * Set the current logged in user
	 * @method setCurrentUser
	 * @param $currentUser {User} the current logged in user
	 * @return None
	 */
	
	public function setCurrentUser($currentUser){
		$this->currentUser = $currentUser;	
	}
	

	public function findError($error){
		foreach($this->errros as $k=>$v){
			if(strstr($error, $k)){
				return $v;
			}else{
				$keyParts = explode("|", $k);
				if(count($keyParts) >= 2){
					if(strstr($error, $keyParts[0]) && strstr($error, $keyParts[1])){
						return $v;
					}
				}
			}
		}	
		return $error;
	}
	
	/**
	 * Get the currently logged in user from session
	 * @method getCurrentUser
	 * @return {User} currently logged in user from session
	 */
	
	public function getCurrentUser(){
        if(!empty($this->currentUser)){
            return $this->currentUser;
        }
		$user = SessionUtils::getSessionObject('user');
		return $user;
	}
	
	/**
	 * Get the Profile id attached to currently logged in user. if the user is switched, this will return the id of switched Profile instead of currently logged in users Prifile id
	 * @method getCurrentProfileId
	 * @return {Integer}
	 */
	public function getCurrentProfileId(){
		if (!class_exists('SessionUtils')) {
			include (APP_BASE_PATH."include.common.php");
		}
		$adminEmpId = SessionUtils::getSessionObject('admin_current_profile');
		$user = SessionUtils::getSessionObject('user');
		if(empty($adminEmpId) && !empty($user)){
			$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
			return $user->$signInMappingField;
		}
		return $adminEmpId;
	}
	
	/**
	 * Get User by profile id
	 * @method getUserFromProfileId
	 * @param $profileId {Integer} profile id
	 * @return {User} user object
	 */
	
	public function getUserFromProfileId($profileId){
		$user = new User();
		$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
		$user->load($signInMappingField." = ?",array($profileId));
		if($user->$signInMappingField == $profileId){
			return $user;
		}
		return null;
	}

	
	public function setCurrentAdminProfile($profileId){
		if (!class_exists('SessionUtils')) {
			include (APP_BASE_PATH."include.common.php");
		}
		
		if($profileId == "-1"){
			SessionUtils::saveSessionObject('admin_current_profile',null);
			return;
		}
		
		if($this->currentUser->user_level == 'Admin'){
			SessionUtils::saveSessionObject('admin_current_profile',$profileId);
					
		}else if($this->currentUser->user_level == 'Manager'){
			$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
			$signInMappingFieldTable = ucfirst($signInMappingField);
			$subordinate = new $signInMappingFieldTable();
			$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
			$subordinates = $subordinate->Find("supervisor = ?",array($this->currentUser->$signInMappingField));
			$subFound = false;
			foreach($subordinates as $sub){
				if($sub->id == $profileId){
					$subFound = true;
					break;
				}
			}
			
			if(!$subFound){
				return;	
			}
			
			SessionUtils::saveSessionObject('admin_current_profile',$profileId);
			
		}
	}
	
	public function cleanUpAdoDB($obj){
		unset($obj->_table);	
		unset($obj->_dbat);	
		unset($obj->_tableat);	
		unset($obj->_where);	
		unset($obj->_saved);	
		unset($obj->_lasterr);	
		unset($obj->_original);	
		unset($obj->foreignName);	
		
		return $obj;
	}
	
	public function setDB($db){
		$this->db = $db;
	}
	
	public function getDB(){
		return $this->db;
	}
	
	public function checkSecureAccessOld($type,$object){
		
		$accessMatrix = array();
		if($this->currentUser->user_level == 'Admin'){
			$accessMatrix = $object->getAdminAccess();
			if (in_array($type, $accessMatrix)) {
				return true;
			}
		}else if($this->currentUser->user_level == 'Manager'){
			$accessMatrix = $object->getManagerAccess();
			if (in_array($type, $accessMatrix)) {
				return true;
			}else{
				$accessMatrix = $object->getUserOnlyMeAccess();
				$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
				if (in_array($type, $accessMatrix) && $_REQUEST[$object->getUserOnlyMeAccessField()] == $this->currentUser->$signInMappingField) {
					return true;	
				}
				
				if (in_array($type, $accessMatrix)) {
					
					$field = $object->getUserOnlyMeAccessField();
					$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
					if($this->currentUser->$signInMappingField."" == $object->$field){
						return true;
					}
					
				}
			}
			
		}else{
			$accessMatrix = $object->getUserAccess();
			if (in_array($type, $accessMatrix)) {
				return true;
			}else{
				$accessMatrix = $object->getUserOnlyMeAccess();
				$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
				if (in_array($type, $accessMatrix) && $_REQUEST[$object->getUserOnlyMeAccessField()] == $this->currentUser->$signInMappingField) {
					return true;	
				}
				
				if (in_array($type, $accessMatrix)) {
					
					$field = $object->getUserOnlyMeAccessField();
					$signInMappingField = SIGN_IN_ELEMENT_MAPPING_FIELD_NAME;
					if($this->currentUser->$signInMappingField."" == $object->$field){
						return true;
					}
					
				}
			}
		}
		
		$ret['status'] = "ERROR";
		$ret['message'] = "Access violation";
		echo json_encode($ret);
		exit();
	}
	
	/**
	 * Use user level security functions defined in model classes to check whether a given action type is allowed to be executed by the current user on a given object
	 * @method checkSecureAccess
	 * @param $type {String} Action type
	 * @param $object {Object} object to test access
	 * @return {Boolen} true or exit
	 */
	
	public function checkSecureAccess($type,$object){

        if(!empty($this->currentUser->user_roles)){
            return true;
        }
		
		$accessMatrix = array();
		
		//Construct permission method
		$permMethod = "get".$this->currentUser->user_level."Access";
        if(method_exists($object,$permMethod)){
            $accessMatrix = $object->$permMethod();
        }else{
            $accessMatrix = $object->getDefaultAccessLevel();
        }

		if (in_array($type, $accessMatrix)) {
			//The user has required permission, so return true
			return true;
		}else{
			//Now we need to check whther the user has access to his own records
			$accessMatrix = $object->getUserOnlyMeAccess();
			
			$userOnlyMeAccessRequestField = $object->getUserOnlyMeAccessRequestField();
			
			//This will check whether user can access his own records using a value in request
			if(isset($_REQUEST[$object->getUserOnlyMeAccessField()]) && isset($this->currentUser->$userOnlyMeAccessRequestField)){
				if (in_array($type, $accessMatrix) && $_REQUEST[$object->getUserOnlyMeAccessField()] == $this->currentUser->$userOnlyMeAccessRequestField) {
					return true;
				}
			}
			
			//This will check whether user can access his own records using a value in requested object
			if (in_array($type, $accessMatrix)) {
				$field = $object->getUserOnlyMeAccessField();
				if($this->currentUser->$userOnlyMeAccessRequestField == $object->$field){
					return true;
				}
			
			}
		}
		
		$ret['status'] = "ERROR";
		$ret['message'] = "Access violation";
		echo json_encode($ret);
		exit();
	}
	
	
	
	public function getInstanceId(){
		$settings = new Setting();
		$settings->Load("name = ?",array("Instance : ID"));
		
		if($settings->name != "Instance : ID" || empty($settings->value)){
			$settings->value = md5(time());
			$settings->name = "Instance : ID";
			$settings->Save();
		}
		
		return $settings->value;
	}
	
	public function setInstanceKey($key){
		$settings = new Setting();
		$settings->Load("name = ?",array("Instance: Key"));
		if($settings->name != "Instance: Key"){
			$settings->name = "Instance: Key";
			
		}
		$settings->value = $key;
		$settings->Save();
	}
	
	public function getInstanceKey(){
		$settings = new Setting();
		$settings->Load("name = ?",array("Instance: Key"));
		if($settings->name != "Instance: Key"){
			return null;	
		}
		return $settings->value;
	}
	
	public function validateInstance(){
		$instanceId = $this->getInstanceId();
		if(empty($instanceId)){
			return true;
		}
	
		$key = $this->getInstanceKey();
	
		if(empty($key)){
			return false;
		}
	
		$data = AesCtr::decrypt($key, $instanceId, 256);
		$arr = explode("|",$data);
		if($arr[0] == KEY_PREFIX && $arr[1] == $instanceId){
			return true;
		}
	
		return false;
	}
	
	public function loadModulePermissions($group, $name, $userLevel){
		$module = new Module();
		$module->Load("update_path = ?",array($group.">".$name));
		$arr = array();
		$arr['user'] = json_decode($module->user_levels,true);
		$arr['user_roles'] = !empty($module->user_roles)?json_decode($module->user_roles,true):array();

		
		$permission = new Permission();
		$modulePerms = $permission->Find("module_id = ? and user_level = ?",array($module->id,$userLevel));

		
		$perms = array();
		foreach($modulePerms as $p){
			$perms[$p->permission] = $p->value;
		}
		
		$arr['perm'] = $perms;
		
		return $arr;
	}
	
	public function getGAKey(){
		return "";
	}
	
	/**
	 * Set the audit manager
	 * @method setAuditManager
	 * @param $auditManager {AuditManager}
	 */
	
	public function setAuditManager($auditManager){
		$this->auditManager = $auditManager;
	}
	
	/**
	 * Set the NotificationManager
	 * @method setNotificationManager
	 * @param $notificationManager {NotificationManager}
	 */
	
	public function setNotificationManager($notificationManager){
		$this->notificationManager = $notificationManager;
	}
	
	/**
	 * Set the SettingsManager
	 * @method setSettingsManager
	 * @param $settingsManager {SettingsManager}
	 */
	
	public function setSettingsManager($settingsManager){
		$this->settingsManager = $settingsManager;
	}
	
	public function setFileFields($fileFields){
		$this->fileFields = $fileFields;
	}
	
	public function audit($type, $data){
		if(!empty($this->auditManager)){
			$this->auditManager->addAudit($type, $data);
		}
	}
	
	public function fixJSON($json){
		$noJSONRequests = SettingsManager::getInstance()->getSetting("System: Do not pass JSON in request");
		if($noJSONRequests."" == "1"){
			$json = str_replace("|",'"',$json);
		}
		return $json;
	}
	
	public function addModuleManager($moduleManager){
		if(empty($this->moduleManagers)){
			$this->moduleManagers = array();
		}
		$this->moduleManagers[] = $moduleManager;
	}
	
	public function getModuleManagers(){
		return $this->moduleManagers;
	}
	
	public function setEmailSender($emailSender){
		$this->emailSender = $emailSender;
	}
	
	public function getEmailSender(){
		return $this->emailSender;
	}

    public function getFieldNameMappings($type){
        $fieldNameMap = new FieldNameMapping();
        $data = $fieldNameMap->Find("type = ?",array($type));
        return $data;
    }
    
    public function getCustomFields($type){
    	$customField = new CustomField();
    	$data = $customField->Find("type = ?",array($type));
    	return $data;
    }
}

class IceConstants{
	const AUDIT_AUTHENTICATION = "Authentication";
	const AUDIT_ADD = "Add";
	const AUDIT_EDIT = "Edit";
	const AUDIT_DELETE = "Delete";
	const AUDIT_ERROR = "Error";
	const AUDIT_ACTION = "User Action";
	
	const NOTIFICATION_LEAVE = "Leave Module";
	const NOTIFICATION_TIMESHEET = "Time Module";
}