ALTER TABLE `Attendance` ADD KEY `in_time` (`in_time`);
ALTER TABLE `Attendance` ADD KEY `out_time` (`out_time`);
ALTER TABLE `Attendance` ADD KEY `employee_in_time` (`employee`,`in_time`);
ALTER TABLE `Attendance` ADD KEY `employee_out_time` (`employee`,`out_time`);


ALTER TABLE `EmployeeTimeEntry` ADD KEY `employee_project` (`employee`,`project`);
ALTER TABLE `EmployeeTimeEntry` ADD KEY `employee_project_date_start` (`employee`,`project`,`date_start`);


REPLACE INTO `Reports` (`id`, `name`, `details`, `parameters`, `query`, `paramOrder`, `type`) VALUES
(5, 'Employee Time Tracking Report', 'This report list employee working hours and attendance details for each day for a given period ', '[\r\n[ "employee", {"label":"Employee","type":"select2","allow-null":false,"remote-source":["Employee","id","first_name+last_name"]}],\r\n[ "date_start", {"label":"Start Date","type":"date"}],\r\n[ "date_end", {"label":"End Date","type":"date"}]\r\n]', 'EmployeeTimeTrackReport', '["employee","date_start","date_end"]', 'Class');


INSERT INTO `Settings` (`name`, `value`, `description`, `meta`) VALUES
('Instance: Key', '',  'This can be generated from http://icehrm.com/generateInstanceKey.php','');

ALTER TABLE `LeaveTypes` ADD COLUMN `carried_forward_percentage` int(11) NULL default 0;
ALTER TABLE `LeaveTypes` ADD COLUMN `carried_forward_leave_availability` int(11) NULL default 365;
ALTER TABLE `LeaveTypes` ADD COLUMN `propotionate_on_joined_date` enum('No','Yes') default 'No';

ALTER TABLE `LeaveRules` ADD COLUMN `carried_forward_percentage` int(11) NULL default 0;
ALTER TABLE `LeaveRules` ADD COLUMN `carried_forward_leave_availability` int(11) NULL default 365;
ALTER TABLE `LeaveRules` ADD COLUMN `propotionate_on_joined_date` enum('No','Yes') default 'No';


UPDATE `LeaveTypes` set carried_forward_percentage = 100;
UPDATE `LeaveTypes` set carried_forward_leave_availability = 365;
UPDATE `LeaveTypes` set propotionate_on_joined_date = 'Yes';

UPDATE `LeaveRules` set carried_forward_percentage = 100;
UPDATE `LeaveRules` set carried_forward_leave_availability = 365;
UPDATE `LeaveRules` set propotionate_on_joined_date = 'Yes';

