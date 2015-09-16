<?php
/*
This file is part of iCE Hrm.

iCE Hrm is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

iCE Hrm is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with iCE Hrm. If not, see <http://www.gnu.org/licenses/>.

------------------------------------------------------------------

Original work Copyright (c) 2012 [Gamonoid Media Pvt. Ltd]  
Developer: Thilina Hasantha (thilina.hasantha[at]gmail.com / facebook.com/thilinah)
 */

$moduleName = 'travel';
define('MODULE_PATH',dirname(__FILE__));
include APP_BASE_PATH.'header.php';
include APP_BASE_PATH.'modulejslibs.inc.php';
?><div class="span9">
			  
	<ul class="nav nav-tabs" id="modTab" style="margin-bottom:0px;margin-left:5px;border-bottom: none;">
		<li class="active"><a id="tabEmployeeImmigration" href="#tabPageEmployeeImmigration">Travel Documents</a></li>
		<li class=""><a id="tabEmployeeTravelRecord" href="#tabPageEmployeeTravelRecord">Travel History</a></li>
	</ul>
	 
	<div class="tab-content">
		<div class="tab-pane active" id="tabPageEmployeeImmigration">
			<div id="EmployeeImmigration" class="reviewBlock" data-content="List" style="padding-left:5px;">
		
			</div>
			<div id="EmployeeImmigrationForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">
		
			</div>
		</div>
		<div class="tab-pane" id="tabPageEmployeeTravelRecord">
			<div id="EmployeeTravelRecord" class="reviewBlock" data-content="List" style="padding-left:5px;">
		
			</div>
			<div id="EmployeeTravelRecordForm" class="reviewBlock" data-content="Form" style="padding-left:5px;display:none;">
		
			</div>
		</div>
	</div>

</div>
<script>
var modJsList = new Array();

modJsList['tabEmployeeImmigration'] = new EmployeeImmigrationAdapter('EmployeeImmigration');

<?php if(isset($modulePermissions['perm']['Add Immigrations']) && $modulePermissions['perm']['Add Immigrations'] == "No"){?>
modJsList['tabEmployeeImmigration'].setShowAddNew(false);
<?php }?>
<?php if(isset($modulePermissions['perm']['Delete Immigrations']) && $modulePermissions['perm']['Delete Immigrations'] == "No"){?>
modJsList['tabEmployeeImmigration'].setShowDelete(false);
<?php }?>
<?php if(isset($modulePermissions['perm']['Edit Immigrations']) && $modulePermissions['perm']['Edit Immigrations'] == "No"){?>
modJsList['tabEmployeeImmigration'].setShowEdit(false);
<?php }?>

modJsList['tabEmployeeTravelRecord'] = new EmployeeTravelRecordAdapter('EmployeeTravelRecord','EmployeeTravelRecord');

<?php if(isset($modulePermissions['perm']['Add Travel History']) && $modulePermissions['perm']['Add Travel History'] == "No"){?>
modJsList['tabEmployeeTravelRecord'].setShowAddNew(false);
<?php }?>
<?php if(isset($modulePermissions['perm']['Delete Travel History']) && $modulePermissions['perm']['Delete Travel History'] == "No"){?>
modJsList['tabEmployeeTravelRecord'].setShowDelete(false);
<?php }?>
<?php if(isset($modulePermissions['perm']['Edit Travel History']) && $modulePermissions['perm']['Edit Travel History'] == "No"){?>
modJsList['tabEmployeeTravelRecord'].setShowEdit(false);
<?php }?>

var modJs = modJsList['tabEmployeeImmigration'];

</script>
<?php include APP_BASE_PATH.'footer.php';?>      