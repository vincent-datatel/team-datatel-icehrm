ALTER TABLE  `LeaveTypes` ADD COLUMN  `leave_group` bigint(20) NULL;
ALTER TABLE  `Employees` ADD COLUMN  `termination_date` DATETIME default '0000-00-00 00:00:00';
ALTER TABLE  `Employees` ADD COLUMN  `notes` text default null;

REPLACE INTO `Settings` (`name`, `value`, `description`, `meta`) VALUES
('Attendance: Time-sheet Cross Check', '0',  'Only allow users to add an entry to a timesheet only if they have marked atteandance for the selected period','["value", {"label":"Value","type":"select","source":[["1","Yes"],["0","No"]]}]');