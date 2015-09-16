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

function AttendanceAdapter(endPoint,tab,filter,orderBy) {
	this.initAdapter(endPoint,tab,filter,orderBy);
}

AttendanceAdapter.inherits(AdapterBase);



AttendanceAdapter.method('getDataMapping', function() {
	return [
	        "id",
	        "employee",
	        "in_time",
	        "out_time",
	        "note"
	];
});

AttendanceAdapter.method('getHeaders', function() {
	return [
			{ "sTitle": "ID" ,"bVisible":false},
			{ "sTitle": "Employee" },
			{ "sTitle": "Time-In" },
			{ "sTitle": "Time-Out"},
			{ "sTitle": "Note"}
	];
});

AttendanceAdapter.method('getFormFields', function() {
	return [
	        [ "employee", {"label":"Employee","type":"select2","allow-null":false,"remote-source":["Employee","id","first_name+last_name"]}],
	        [ "id", {"label":"ID","type":"hidden"}],
	        [ "in_time", {"label":"Time-In","type":"datetime"}],
	        [ "out_time", {"label":"Time-Out","type":"datetime", "validation":"none"}],
	        [ "note", {"label":"Note","type":"textarea","validation":"none"}]
	];
});

AttendanceAdapter.method('getFilters', function() {
	return [
	        [ "employee", {"label":"Employee","type":"select2","allow-null":false,"remote-source":["Employee","id","first_name+last_name"]}]
	        
	];
});


AttendanceAdapter.method('getCustomTableParams', function() {
	var that = this;
	var dataTableParams = {
			"aoColumnDefs": [ 
			                 {
			                	 "fnRender": function(data, cell){
			                		 return that.preProcessRemoteTableData(data, cell, 2)
			                	 } ,
			                	 "aTargets": [2]
			                 },
			                 {
			                	 "fnRender": function(data, cell){
			                		 return that.preProcessRemoteTableData(data, cell, 3)
			                	 } ,
			                	 "aTargets": [3]
			                 },
			                 {
			                	 "fnRender": function(data, cell){
			                		 return that.preProcessRemoteTableData(data, cell, 4)
			                	 } ,
			                	 "aTargets": [4]
			                 },
			                 {
			      				"fnRender": that.getActionButtons,
			      				"aTargets": [that.getDataMapping().length]
			      			}
			                 ]
	};
	return dataTableParams;
});

AttendanceAdapter.method('preProcessRemoteTableData', function(data, cell, id) {
	if(id == 2){
		if(cell == '0000-00-00 00:00:00' || cell == "" || cell == undefined || cell == null){
			return "";
		}
		return Date.parse(cell).toString('yyyy MMM d  <b>HH:mm</b>');
	}else if(id == 3){
		if(cell == '0000-00-00 00:00:00' || cell == "" || cell == undefined || cell == null){
			return "";
		}
		return Date.parse(cell).toString('MMM d  <b>HH:mm</b>');
	}else if(id == 4){
		if(cell != undefined && cell != null){
			if(cell.length > 10){
				return cell.substring(0,10)+"..";
			}
		}
		return cell;
	}
	
});



AttendanceAdapter.method('save', function() {
	var validator = new FormValidation(this.getTableName()+"_submit",true,{'ShowPopup':false,"LabelErrorClass":"error"});
	if(validator.checkValues()){
		var params = validator.getFormParameters();
		
		var msg = this.doCustomValidation(params);
		if(msg == null){
			var id = $('#'+this.getTableName()+"_submit #id").val();
			if(id != null && id != undefined && id != ""){
				$(params).attr('id',id);
			}
			
			var reqJson = JSON.stringify(params);
			var callBackData = [];
			callBackData['callBackData'] = [];
			callBackData['callBackSuccess'] = 'saveSuccessCallback';
			callBackData['callBackFail'] = 'saveFailCallback';
			
			this.customAction('savePunch','admin=attendance',reqJson,callBackData);
		}else{
			$("#"+this.getTableName()+'Form .label').html(msg);
			$("#"+this.getTableName()+'Form .label').show();
		}
		
	}
});


AttendanceAdapter.method('saveSuccessCallback', function(callBackData) {
	this.get(callBackData);
});


AttendanceAdapter.method('saveFailCallback', function(callBackData) {
	this.showMessage("Error saving attendance entry", callBackData);
});



/*
 Attendance Status
 */


function AttendanceStatusAdapter(endPoint,tab,filter,orderBy) {
    this.initAdapter(endPoint,tab,filter,orderBy);
}

AttendanceStatusAdapter.inherits(AdapterBase);



AttendanceStatusAdapter.method('getDataMapping', function() {
    return [
        "id",
        "employee",
        "status"
    ];
});

AttendanceStatusAdapter.method('getHeaders', function() {
    return [
        { "sTitle": "ID" ,"bVisible":false},
        { "sTitle": "Employee" },
        { "sTitle": "Clocked In Status" }
    ];
});

AttendanceStatusAdapter.method('getFormFields', function() {
    return [

    ];
});

AttendanceStatusAdapter.method('getFilters', function() {
    return [
        [ "employee", {"label":"Employee","type":"select2","allow-null":false,"remote-source":["Employee","id","first_name+last_name"]}]

    ];
});

AttendanceStatusAdapter.method('getActionButtonsHtml', function(id,data) {


    html = '<div class="online-button-_COLOR_"></div>';
    html = html.replace(/_BASE_/g,this.baseUrl);
    if(data[2] == "Not Clocked In"){
        html = html.replace(/_COLOR_/g,'gray');
    }else if(data[2] == "Clocked Out"){
        html = html.replace(/_COLOR_/g,'yellow');
    }else if(data[2] == "Clocked In"){
        html = html.replace(/_COLOR_/g,'green');
    }
    return html;
});