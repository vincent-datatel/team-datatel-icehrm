ALTER TABLE  `LeaveTypes` ADD COLUMN  `leave_group` bigint(20) NULL;
ALTER TABLE  `Employees` ADD COLUMN  `termination_date` DATETIME default '0000-00-00 00:00:00';
ALTER TABLE  `Employees` ADD COLUMN  `notes` text default null;

REPLACE INTO `Settings` (`name`, `value`, `description`, `meta`) VALUES
('Attendance: Time-sheet Cross Check', '0',  'Only allow users to add an entry to a timesheet only if they have marked atteandance for the selected period','["value", {"label":"Value","type":"select","source":[["1","Yes"],["0","No"]]}]');
REPLACE INTO `Reports` (`id`, `name`, `details`, `parameters`, `query`, `paramOrder`, `type`) VALUES
(2, 'Employee Leaves Report', 'This report list all employee leaves by employee, date range and leave status', '[\r\n[ "employee", {"label":"Employee","type":"select2multi","allow-null":true,"null-label":"All Employees","remote-source":["Employee","id","first_name+last_name"]}],\r\n[ "date_start", {"label":"Start Date","type":"date"}],\r\n[ "date_end", {"label":"End Date","type":"date"}],\r\n[ "status", {"label":"Leave Status","type":"select","source":[["NULL","All Statuses"],["Approved","Approved"],["Pending","Pending"],["Rejected","Rejected"]]}]\r\n]', 'EmployeeLeavesReport', '["employee","date_start","date_end","status"]', 'Class'),
(3, 'Employee Time Entry Report', 'This report list all employee time entries by employee, date range and project', '[\r\n[ "employee", {"label":"Employee","type":"select2multi","allow-null":true,"null-label":"All Employees","remote-source":["Employee","id","first_name+last_name"]}],\r\n[ "project", {"label":"Project","type":"select","allow-null":true,"remote-source":["Project","id","name"]}],\r\n[ "date_start", {"label":"Start Date","type":"date"}],\r\n[ "date_end", {"label":"End Date","type":"date"}]\r\n]', 'EmployeeTimesheetReport', '["employee","date_start","date_end","status"]', 'Class'),
(4, 'Employee Attendance Report', 'This report list all employee attendance entries by employee and date range', '[\r\n[ "employee", {"label":"Employee","type":"select2multi","allow-null":true,"null-label":"All Employees","remote-source":["Employee","id","first_name+last_name"]}],\r\n[ "date_start", {"label":"Start Date","type":"date"}],\r\n[ "date_end", {"label":"End Date","type":"date"}]\r\n]', 'EmployeeAttendanceReport', '["employee","date_start","date_end"]', 'Class');


INSERT INTO `Reports` (`name`, `details`, `parameters`, `query`, `paramOrder`, `type`) VALUES
('Active Employee Report', 'This report list employees who are currently active based on joined date and termination date ', 
'[\r\n[ "department", {"label":"Department","type":"select2","remote-source":["CompanyStructure","id","title"],"allow-null":true}]\r\n]',
 'ActiveEmployeeReport', 
 '["department"]', 'Class');

 
INSERT INTO `Reports` (`name`, `details`, `parameters`, `query`, `paramOrder`, `type`) VALUES
('New Hires Employee Report', 'This report list employees who are joined between given two dates ', 
'[[ "department", {"label":"Department","type":"select2","remote-source":["CompanyStructure","id","title"],"allow-null":true}],\r\n[ "date_start", {"label":"Start Date","type":"date"}],\r\n[ "date_end", {"label":"End Date","type":"date"}]\r\n]',
 'NewHiresEmployeeReport', 
 '["department","date_start","date_end"]', 'Class');
 
INSERT INTO `Reports` (`name`, `details`, `parameters`, `query`, `paramOrder`, `type`) VALUES
('Terminated Employee Report', 'This report list employees who are terminated between given two dates ', 
'[[ "department", {"label":"Department","type":"select2","remote-source":["CompanyStructure","id","title"],"allow-null":true}],\r\n[ "date_start", {"label":"Start Date","type":"date"}],\r\n[ "date_end", {"label":"End Date","type":"date"}]\r\n]',
 'TerminatedEmployeeReport', 
 '["department","date_start","date_end"]', 'Class');