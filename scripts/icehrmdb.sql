create table `CompanyStructures` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`title` tinytext not null,
	`description` text not null,
	`address` text default NULL,
	`type` enum('Company','Head Office','Regional Office','Department','Unit','Sub Unit','Other') default NULL,
	`country` varchar(2) not null default '0',
	`parent` bigint(20) NULL,
	CONSTRAINT `Fk_CompanyStructures_Own` FOREIGN KEY (`parent`) REFERENCES `CompanyStructures` (`id`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Country` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`code` char(2) not null default '',
	`namecap` varchar(80) null default '',
	`name` varchar(80) not null default '',
	`iso3` char(3) default null,
	`numcode` smallint(6) default null,
	UNIQUE KEY `code` (`code`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Province` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(40) not null default '',
	`code` char(2) not null default '',
	`country` char(2) not null default 'US',
	CONSTRAINT `Fk_Province_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`code`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `CurrencyTypes` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`code` varchar(3) not null default '',
	`name` varchar(70) not null default '',
	primary key  (`id`),
	UNIQUE KEY `CurrencyTypes_code` (`code`)
) engine=innodb default charset=utf8;

create table `PayGrades` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	`currency` varchar(3) not null,
	`min_salary` decimal(12,2) DEFAULT 0.00,
	`max_salary` decimal(12,2) DEFAULT 0.00,
	CONSTRAINT `Fk_PayGrades_CurrencyTypes` FOREIGN KEY (`currency`) REFERENCES `CurrencyTypes` (`code`),
	primary key(`id`)
) engine=innodb default charset=utf8;

create table `JobTitles` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`code` varchar(10) not null default '',
	`name` varchar(100) default null,
	`description` varchar(200) default null,
	`specification` varchar(400) default null,
	primary key(`id`)
) engine=innodb default charset=utf8;

create table `EmploymentStatus` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	`description` varchar(400) default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Skills` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	`description` varchar(400) default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Educations` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	`description` varchar(400) default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Certifications` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	`description` varchar(400) default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Languages` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	`description` varchar(400) default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Nationality` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Employees` (
	 `id` bigint(20) NOT NULL AUTO_INCREMENT,
	 `employee_id` varchar(50) default null,
	 `first_name` varchar(100) default '' not null,
	 `middle_name` varchar(100) default null,
	 `last_name` varchar(100) default null,
	 `nationality` bigint(20) default null,
	 `birthday` DATETIME default '0000-00-00 00:00:00',
	 `gender` enum('Male','Female') default NULL,
	 `marital_status` enum('Married','Single','Divorced','Widowed','Other') default NULL,
	 `ssn_num` varchar(100) default NULL,
	 `nic_num` varchar(100) default NULL,
	 `other_id` varchar(100) default NULL,
	 `driving_license` varchar(100) default NULL,
	 `driving_license_exp_date` date default '0000-00-00',
	 `employment_status` bigint(20) default null,
	 `job_title` bigint(20) default null,
	 `pay_grade` bigint(20) null,
	 `work_station_id` varchar(100) default NULL,
	 `address1` varchar(100) default NULL,
	 `address2` varchar(100) default NULL,
	 `city` varchar(150) default NULL,
	 `country` char(2) default null,
	 `province` bigint(20) default null,
	 `postal_code` varchar(20) default null,
	 `home_phone` varchar(50) default null,
	 `mobile_phone` varchar(50) default null,
	 `work_phone` varchar(50) default null,
	 `work_email` varchar(100) default null,
	 `private_email` varchar(100) default null,
	 `joined_date` DATETIME default '0000-00-00 00:00:00',
	 `confirmation_date` DATETIME default '0000-00-00 00:00:00',
	 `supervisor` bigint(20) default null,
	 `department` bigint(20) default null,
	 `custom1` varchar(250) default null,
	 `custom2` varchar(250) default null,
	 `custom3` varchar(250) default null,
	 `custom4` varchar(250) default null,
	 `custom5` varchar(250) default null,
	 `custom6` varchar(250) default null,
	 `custom7` varchar(250) default null,
	 `custom8` varchar(250) default null,
	 `custom9` varchar(250) default null,
	 `custom10` varchar(250) default null,
	 `termination_date` DATETIME default '0000-00-00 00:00:00',
	 `notes` text default null,
	 `status` enum('Active','Terminated') default 'Active',
   `ethnicity` bigint(20) default null,
   `immigration_status` bigint(20) default null,
	 CONSTRAINT `Fk_Employee_Nationality` FOREIGN KEY (`nationality`) REFERENCES `Nationality` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_JobTitle` FOREIGN KEY (`job_title`) REFERENCES `JobTitles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_EmploymentStatus` FOREIGN KEY (`employment_status`) REFERENCES `EmploymentStatus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`code`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_Province` FOREIGN KEY (`province`) REFERENCES `Province` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_Supervisor` FOREIGN KEY (`supervisor`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_CompanyStructures` FOREIGN KEY (`department`) REFERENCES `CompanyStructures` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 CONSTRAINT `Fk_Employee_PayGrades` FOREIGN KEY (`pay_grade`) REFERENCES `PayGrades` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	 primary key  (`id`),
	 unique key `employee_id` (`employee_id`)

) engine=innodb default charset=utf8;

create table `ArchivedEmployees` (
	 `id` bigint(20) NOT NULL AUTO_INCREMENT,
	 `ref_id` bigint(20) NOT NULL,
	 `employee_id` varchar(50) default null,
	 `first_name` varchar(100) default '' not null,
	 `last_name` varchar(100) default '' not null,
	 `gender` enum('Male','Female') default NULL,
	 `ssn_num` varchar(100) default '',
	 `nic_num` varchar(100) default '',
	 `other_id` varchar(100) default '',
	 `work_email` varchar(100) default null,
	 `joined_date` DATETIME default '0000-00-00 00:00:00',
	 `confirmation_date` DATETIME default '0000-00-00 00:00:00',
	 `supervisor` bigint(20) default null,
	 `department` bigint(20) default null,
	 `termination_date` DATETIME default '0000-00-00 00:00:00',
	 `notes` text default null,
	 `data` longtext default null,
	 primary key  (`id`)

) engine=innodb default charset=utf8;

create table `UserRoles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) default null,
  primary key  (`id`),
  unique key `name` (`name`)
) engine=innodb default charset=utf8;

create table `Users` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`username` varchar(100) default null,
	`email` varchar(100) default null,
	`password` varchar(100) default null,
	`employee` bigint(20) null,
	`default_module` bigint(20) null,
	`user_level` enum('Admin','Employee','Manager','Other') default NULL,
  `user_roles` text null,
	`last_login` timestamp default '0000-00-00 00:00:00',
	`last_update` timestamp default '0000-00-00 00:00:00',
	`created` timestamp default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_User_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	primary key  (`id`),
	unique key `username` (`username`)
) engine=innodb default charset=utf8;


create table `EmployeeSkills` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`skill_id` bigint(20) NULL,
	`employee` bigint(20) NOT NULL,
	`details` varchar(400) default null,
	CONSTRAINT `Fk_EmployeeSkills_Skills` FOREIGN KEY (`skill_id`) REFERENCES `Skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeSkills_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`),
	unique key (`employee`,`skill_id`)
) engine=innodb default charset=utf8;

create table `EmployeeEducations` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`education_id` bigint(20) NULL,
	`employee` bigint(20) NOT NULL,
	`institute` varchar(400) default null,
	`date_start` date default '0000-00-00',
	`date_end` date default '0000-00-00',
	CONSTRAINT `Fk_EmployeeEducations_Educations` FOREIGN KEY (`education_id`) REFERENCES `Educations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeEducations_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeCertifications` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`certification_id` bigint(20) NULL,
	`employee` bigint(20) NOT NULL,
	`institute` varchar(400) default null,
	`date_start` date default '0000-00-00',
	`date_end` date default '0000-00-00',
	CONSTRAINT `Fk_EmployeeCertifications_Certifications` FOREIGN KEY (`certification_id`) REFERENCES `Certifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeCertifications_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`),
	unique key (`employee`,`certification_id`)
) engine=innodb default charset=utf8;


create table `EmployeeLanguages` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`language_id` bigint(20) NULL,
	`employee` bigint(20) NOT NULL,
	`reading` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') default NULL,
	`speaking` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') default NULL,
	`writing` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') default NULL,
	`understanding` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') default NULL,
	CONSTRAINT `Fk_EmployeeLanguages_Languages` FOREIGN KEY (`language_id`) REFERENCES `Languages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeLanguages_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`),
	unique key (`employee`,`language_id`)
) engine=innodb default charset=utf8;

create table `EmergencyContacts` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`name` varchar(100) NOT NULL,
	`relationship` varchar(100) default null,
	`home_phone` varchar(15) default null,
	`work_phone` varchar(15) default null,
	`mobile_phone` varchar(15) default null,
	CONSTRAINT `Fk_EmergencyContacts_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeDependents` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`name` varchar(100) NOT NULL,
	`relationship` enum('Child','Spouse','Parent','Other') default NULL,
	`dob` date default '0000-00-00',
	`id_number` varchar(25) default null,
	CONSTRAINT `Fk_EmployeeDependents_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;



create table `LeaveTypes` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`supervisor_leave_assign` enum('Yes','No') default 'Yes',
	`employee_can_apply` enum('Yes','No') default 'Yes',
	`apply_beyond_current` enum('Yes','No') default 'Yes',
	`leave_accrue` enum('No','Yes') default 'No',
	`carried_forward` enum('No','Yes') default 'No',
	`default_per_year` decimal(10,3) NOT NULL,
	`carried_forward_percentage` int(11) NULL default 0,
	`carried_forward_leave_availability` int(11) NULL default 365,
	`propotionate_on_joined_date` enum('No','Yes') default 'No',
	`leave_group` bigint(20) NULL,
	`leave_color` varchar(10) NULL,
	primary key  (`id`),
	unique key (`name`)
) engine=innodb default charset=utf8;

create table `LeaveRules` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`leave_type` bigint(20) NOT NULL,
	`job_title` bigint(20) NULL,
	`employment_status` bigint(20) NULL,
	`employee` bigint(20) NULL,
	`supervisor_leave_assign` enum('Yes','No') default 'Yes',
	`employee_can_apply` enum('Yes','No') default 'Yes',
	`apply_beyond_current` enum('Yes','No') default 'Yes',
	`leave_accrue` enum('No','Yes') default 'No',
	`carried_forward` enum('No','Yes') default 'No',
	`default_per_year` decimal(10,3) NOT NULL,
	`carried_forward_percentage` int(11) NULL default 0,
	`carried_forward_leave_availability` int(11) NULL default 365,
	`propotionate_on_joined_date` enum('No','Yes') default 'No',
	`leave_group` bigint(20) NULL,
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `LeaveGroups` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`details` text default null,
	`created` timestamp NULL default '0000-00-00 00:00:00',
	`updated` timestamp NULL default '0000-00-00 00:00:00',
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `LeaveGroupEmployees` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`leave_group` bigint(20) NOT NULL,
	`created` timestamp NULL default '0000-00-00 00:00:00',
	`updated` timestamp NULL default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_LeaveGroupEmployees_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_LeaveGroupEmployees_LeaveGroups` FOREIGN KEY (`leave_group`) REFERENCES `LeaveGroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`),
	unique key `LeaveGroupEmployees_employee` (`employee`)
) engine=innodb default charset=utf8;

create table `LeavePeriods` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`date_start` date default '0000-00-00',
	`date_end` date default '0000-00-00',
	`status` enum('Active','Inactive') default 'Inactive',
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `WorkDays` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`status` enum('Full Day','Half Day','Non-working Day') default 'Full Day',
	`country` bigint(20) DEFAULT NULL,
	primary key  (`id`),
	unique key `workdays_name_country` (`name`,`country`)
) engine=innodb default charset=utf8;

create table `HoliDays` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`dateh` date default '0000-00-00',
	`status` enum('Full Day','Half Day') default 'Full Day',
	`country` bigint(20) DEFAULT NULL,
	primary key  (`id`),
	unique key `holidays_dateh_country` (`dateh`,`country`)
) engine=innodb default charset=utf8;

create table `EmployeeLeaves` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`leave_type` bigint(20) NOT NULL,
	`leave_period` bigint(20) NOT NULL,
	`date_start` date default '0000-00-00',
	`date_end` date default '0000-00-00',
	`details` text default null,
	`status` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled') default 'Pending',
	`attachment` varchar(100) NULL,
	CONSTRAINT `Fk_EmployeeLeaves_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeLeaves_LeaveTypes` FOREIGN KEY (`leave_type`) REFERENCES `LeaveTypes` (`id`),
	CONSTRAINT `Fk_EmployeeLeaves_LeavePeriods` FOREIGN KEY (`leave_period`) REFERENCES `LeavePeriods` (`id`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeLeaveLog` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee_leave` bigint(20) NOT NULL,
	`user_id` bigint(20) NULL,
	`data` varchar(500) NOT NULL,
	`status_from` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled') default 'Pending',
	`status_to` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled') default 'Pending',
	`created` timestamp default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_EmployeeLeaveLog_EmployeeLeaves` FOREIGN KEY (`employee_leave`) REFERENCES `EmployeeLeaves` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeLeaveLog_Users` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeLeaveDays` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee_leave` bigint(20) NOT NULL,
	`leave_date` date default '0000-00-00',
	`leave_type` enum('Full Day','Half Day - Morning','Half Day - Afternoon','1 Hour - Morning','2 Hours - Morning','3 Hours - Morning','1 Hour - Afternoon','2 Hours - Afternoon','3 Hours - Afternoon') NOT NULL,
	CONSTRAINT `Fk_EmployeeLeaveDays_EmployeeLeaves` FOREIGN KEY (`employee_leave`) REFERENCES `EmployeeLeaves` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Files` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`filename` varchar(100) NOT NULL,
	`employee` bigint(20) NULL,
	`file_group` varchar(100) NOT NULL,
	primary key  (`id`),
	unique key `filename` (`filename`)
) engine=innodb default charset=utf8;

create table `Clients` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`details` text default null,
	`first_contact_date` date default '0000-00-00',
	`created` timestamp default '0000-00-00 00:00:00',
	`address` text default null,
	`contact_number` varchar(25) NULL,
	`contact_email` varchar(25) NULL,
	`company_url` varchar(500) NULL,
	`status` enum('Active','Inactive') default 'Active',
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Projects` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`client` bigint(20) NULL,
	`details` text default null,
	`created` timestamp default '0000-00-00 00:00:00',
	`status` enum('Active','Inactive') default 'Active',
	CONSTRAINT `Fk_Projects_Client` FOREIGN KEY (`client`) REFERENCES `Clients` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeTimeSheets` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`date_start` date NOT NULL,
	`date_end` date NOT NULL,
	`status` enum('Approved','Pending','Rejected','Submitted') default 'Pending',
	CONSTRAINT `Fk_EmployeeTimeSheets_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE KEY `EmployeeTimeSheetsKey` (`employee`,`date_start`,`date_end`),
	KEY `EmployeeTimeSheets_date_end` (`date_end`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeProjects` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`project` bigint(20) NULL,
	`date_start` date NULL,
	`date_end` date NULL,
	`status` enum('Current','Inactive','Completed') default 'Current',
	`details` text default null,
	CONSTRAINT `Fk_EmployeeProjects_Projects` FOREIGN KEY (`project`) REFERENCES `Projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeProjects_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE KEY `EmployeeProjectsKey` (`employee`,`project`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeTimeEntry` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`project` bigint(20) NULL,
	`employee` bigint(20) NOT NULL,
	`timesheet` bigint(20) NOT NULL,
	`details` text default null,
	`created` timestamp default '0000-00-00 00:00:00',
	`date_start` timestamp default '0000-00-00 00:00:00',
	`time_start` varchar(10) NOT NULL,
	`date_end` timestamp default '0000-00-00 00:00:00',
	`time_end` varchar(10) NOT NULL,
	`status` enum('Active','Inactive') default 'Active',
	CONSTRAINT `Fk_EmployeeTimeEntry_Projects` FOREIGN KEY (`project`) REFERENCES `Projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeTimeEntry_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeTimeEntry_EmployeeTimeSheets` FOREIGN KEY (`timesheet`) REFERENCES `EmployeeTimeSheets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	KEY `employee_project` (`employee`,`project`),
	KEY `employee_project_date_start` (`employee`,`project`,`date_start`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Documents` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`details` text default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeDocuments` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`document` bigint(20) NULL,
	`date_added` date NOT NULL,
	`valid_until` date NOT NULL,
	`status` enum('Active','Inactive','Draft') default 'Active',
	`details` text default null,
	`attachment` varchar(100) NULL,
	CONSTRAINT `Fk_EmployeeDocuments_Documents` FOREIGN KEY (`document`) REFERENCES `Documents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeDocuments_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `CompanyLoans` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`details` text default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeCompanyLoans` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`loan` bigint(20) NULL,
	`start_date` date NOT NULL,
	`last_installment_date` date NOT NULL,
	`period_months` bigint(20) NULL,
	`currency` bigint(20) NULL DEFAULT NULL,
	`amount` decimal(10,2) NOT NULL,
	`monthly_installment` decimal(10,2) NOT NULL,
	`status` enum('Approved','Repayment','Paid','Suspended') default 'Approved',
	`details` text default null,
	CONSTRAINT `Fk_EmployeeCompanyLoans_CompanyLoans` FOREIGN KEY (`loan`) REFERENCES `CompanyLoans` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeCompanyLoans_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Settings` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`value` text default null,
	`description` text default null,
	`meta` text default null,
	primary key  (`id`),
	UNIQUE KEY(`name`)
) engine=innodb default charset=utf8;


create table `Modules` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`menu` varchar(30) NOT NULL,
	`name` varchar(100) NOT NULL,
	`label` varchar(100) NOT NULL,
	`icon` VARCHAR( 50 ) NULL,
	`mod_group` varchar(30) NOT NULL,
	`mod_order` INT(11) NULL,
	`status` enum('Enabled','Disabled') default 'Enabled',
	`version` varchar(10) default '',
	`update_path` varchar(500) default '',
	`user_levels` varchar(500) NOT NULL,
  `user_roles` text null,
	primary key  (`id`),
	UNIQUE KEY `Modules_name_modgroup` (`name`,`mod_group`)
) engine=innodb default charset=utf8;

create table `Reports` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`details` text default null,
	`parameters` text default null,
	`query` text default null,
	`paramOrder` varchar(500) NOT NULL,
	`type` enum('Query','Class') default 'Query',
	primary key  (`id`),
	UNIQUE KEY `Reports_Name` (`name`)
) engine=innodb default charset=utf8;


create table `Attendance` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`in_time` timestamp default '0000-00-00 00:00:00',
	`out_time` timestamp default '0000-00-00 00:00:00',
	`note` varchar(500) default null,
	CONSTRAINT `Fk_Attendance_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	KEY `in_time` (`in_time`),
	KEY `out_time` (`out_time`),
	KEY `employee_in_time` (`employee`,`in_time`),
	KEY `employee_out_time` (`employee`,`out_time`),
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `Permissions` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`user_level` enum('Admin','Employee','Manager') default NULL,
	`module_id` bigint(20) NOT NULL,
	`permission` varchar(200) default null,
	`meta` varchar(500) default null,
	`value` varchar(200) default null,
	UNIQUE KEY `Module_Permission` (`user_level`,`module_id`,`permission`),
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `DataEntryBackups` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`tableType` varchar(200) default null,
	`data` longtext default null,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `AuditLog` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`time` datetime default '0000-00-00 00:00:00',
	`user` bigint(20) NOT NULL,
	`ip` varchar(100) NULL,
	`type` varchar(100) NOT NULL,
	`employee` varchar(300) NULL,
	`details` text default null,
	CONSTRAINT `Fk_AuditLog_Users` FOREIGN KEY (`user`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `Notifications` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`time` datetime default '0000-00-00 00:00:00',
	`fromUser` bigint(20) NULL,
	`fromEmployee` bigint(20) NULL,
	`toUser` bigint(20) NOT NULL,
	`image` varchar(500) default null,
	`message` text default null,
	`action` text default null,
	`type` varchar(100) NULL,
	`status` enum('Unread','Read') default 'Unread',
	CONSTRAINT `Fk_Notifications_Users` FOREIGN KEY (`touser`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`),
	KEY `toUser_time` (`toUser`,`time`),
	KEY `toUser_status_time` (`toUser`,`status`,`time`)
) engine=innodb default charset=utf8;

create table `Courses` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`code` varchar(300) NOT NULL,
	`name` varchar(300) NOT NULL,
	`description` text default null,
	`coordinator` bigint(20) NULL,
	`trainer` varchar(300) NULL,
	`trainer_info` text default null,
	`paymentType` enum('Company Sponsored','Paid by Employee') default 'Company Sponsored',
	`currency` varchar(3) not null,
	`cost` decimal(12,2) DEFAULT 0.00,
	`status` enum('Active','Inactive') default 'Active',
	`created` datetime default '0000-00-00 00:00:00',
	`updated` datetime default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_Courses_Employees` FOREIGN KEY (`coordinator`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `TrainingSessions` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(300) NOT NULL,
	`course` bigint(20) NOT NULL,
	`description` text default null,
	`scheduled` datetime default '0000-00-00 00:00:00',
	`dueDate` datetime default '0000-00-00 00:00:00',
	`deliveryMethod` enum('Classroom','Self Study','Online') default 'Classroom',
	`deliveryLocation` varchar(500) NULL,
	`status` enum('Pending','Approved','Completed','Cancelled') default 'Pending',
	`attendanceType` enum('Sign Up','Assign') default 'Sign Up',
	`attachment` varchar(300) NULL,
	`created` datetime default '0000-00-00 00:00:00',
	`updated` datetime default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_TrainingSessions_Courses` FOREIGN KEY (`course`) REFERENCES `Courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `EmployeeTrainingSessions` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`trainingSession` bigint(20) NULL,
	`feedBack` varchar(1500) NULL,
	`status` enum('Scheduled','Attended','Not-Attended') default 'Scheduled',
	CONSTRAINT `Fk_EmployeeTrainingSessions_TrainingSessions` FOREIGN KEY (`trainingSession`) REFERENCES `TrainingSessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeTrainingSessions_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `ImmigrationDocuments` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`details` text default null,
	`required` enum('Yes','No') default 'Yes',
	`alert_on_missing` enum('Yes','No') default 'Yes',
	`alert_before_expiry` enum('Yes','No') default 'Yes',
	`alert_before_day_number` int(11) NOT NULL,
	`created` timestamp NULL default '0000-00-00 00:00:00',
	`updated` timestamp NULL default '0000-00-00 00:00:00',
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeImmigrations` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`document` bigint(20) NULL,
	`documentname` varchar(150) NOT NULL,
	`valid_until` date NOT NULL,
	`status` enum('Active','Inactive','Draft') default 'Active',
	`details` text default null,
	`attachment1` varchar(100) NULL,
	`attachment2` varchar(100) NULL,
	`attachment3` varchar(100) NULL,
	`created` timestamp NULL default '0000-00-00 00:00:00',
	`updated` timestamp NULL default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_EmployeeImmigrations_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeImmigrations_ImmigrationDocuments` FOREIGN KEY (`document`) REFERENCES `ImmigrationDocuments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `EmployeeTravelRecords` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`type` enum('Local','International') default 'Local',
	`purpose` varchar(200) NOT NULL,
	`travel_from` varchar(200) NOT NULL,
	`travel_to` varchar(200) NOT NULL,
	`travel_date` datetime NULL default '0000-00-00 00:00:00',
	`return_date` datetime NULL default '0000-00-00 00:00:00',
	`details` varchar(500) default null,
	`attachment1` varchar(100) NULL,
	`attachment2` varchar(100) NULL,
	`attachment3` varchar(100) NULL,
	`created` timestamp NULL default '0000-00-00 00:00:00',
	`updated` timestamp NULL default '0000-00-00 00:00:00',
	CONSTRAINT `Fk_EmployeeTravelRecords_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;


create table `RestAccessTokens` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`userId` bigint(20) NOT NULL,
	`hash` varchar(32) default null,
	`token` varchar(500) default null,
	`created` DATETIME default '0000-00-00 00:00:00',
	`updated` DATETIME default '0000-00-00 00:00:00',
	primary key  (`id`),
	unique key `userId` (`userId`)
) engine=innodb default charset=utf8;

create table `FieldNameMappings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `textOrig` varchar(200) default null,
  `textMapped` varchar(200) default null,
  `display` enum('Form','Table and Form','Hidden') default 'Form',
  `created` DATETIME default '0000-00-00 00:00:00',
  `updated` DATETIME default '0000-00-00 00:00:00',
  primary key  (`id`),
  unique key `name` (`name`)
) engine=innodb default charset=utf8;

create table `CustomFields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `data` text default null,
  `display` enum('Form','Table and Form','Hidden') default 'Form',
  `created` DATETIME default '0000-00-00 00:00:00',
  `updated` DATETIME default '0000-00-00 00:00:00',
  primary key  (`id`)
) engine=innodb default charset=utf8;


create table `SalaryComponentType` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`code` varchar(10) NOT NULL,
	`name` varchar(100) NOT NULL,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `SalaryComponent` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
  `componentType` bigint(20) NULL,
  `details` text default null,
  CONSTRAINT `Fk_SalaryComponent_SalaryComponentType` FOREIGN KEY (`componentType`) REFERENCES `SalaryComponentType` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `ImmigrationStatus` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Ethnicity` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeImmigrationStatus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `status` bigint(20) NOT NULL,
  CONSTRAINT `Fk_EmployeeImmigrationStatus_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeImmigrationStatus_Type` FOREIGN KEY (`status`) REFERENCES `ImmigrationStatus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  primary key  (`id`)
) engine=innodb default charset=utf8;

create table `EmployeeEthnicity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `ethnicity` bigint(20) NOT NULL,
  CONSTRAINT `Fk_EmployeeEthnicity_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeEthnicity_Ethnicity` FOREIGN KEY (`ethnicity`) REFERENCES `Ethnicity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  primary key  (`id`)
) engine=innodb default charset=utf8;


create table `EmployeeSalary` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`employee` bigint(20) NOT NULL,
	`component` bigint(20) NOT NULL,
	`pay_frequency` enum('Hourly','Daily','Bi Weekly','Weekly','Semi Monthly','Monthly') default NULL,
	`currency` bigint(20) NULL,
	`amount` decimal(10,2) NOT NULL,
	`details` text default null,
	CONSTRAINT `Fk_EmployeeSalary_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `Fk_EmployeeSalary_Currency` FOREIGN KEY (`currency`) REFERENCES `CurrencyTypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Deductions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contributor` enum('Employee','Employer') default NULL,
  `type` enum('Fixed','Percentage') default NULL,
  `percentage_type` enum('On Component','On Component Type') default NULL,
  `componentType` bigint(20) NULL,
  `component` bigint(20) NULL,
  `rangeAmounts` text default null,
  `country` bigint(20) NULL,
  CONSTRAINT `Fk_Deductions_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  primary key  (`id`)
) engine=innodb default charset=utf8;

create table `Tax` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contributor` enum('Employee','Employer') default NULL,
  `type` enum('Fixed','Percentage') default NULL,
  `percentage_type` enum('On Component','On Component Type') default NULL,
  `componentType` bigint(20) NULL,
  `component` bigint(20) NULL,
  `rangeAmounts` text default null,
  `country` bigint(20) NULL,
  CONSTRAINT `Fk_Tax_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  primary key  (`id`)
) engine=innodb default charset=utf8;

create table `TaxRules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `apply` enum('Yes','No') default 'Yes',
  `application_type` enum('All','Condition - OR','Condition - AND') default 'All',
  `tax` bigint(20) NOT NULL,
  `job_title` bigint(20) NULL,
  `ethnicity` bigint(20) NULL,
  `nationality` bigint(20) NULL,
  `immigration_status` bigint(20) NULL,
  `pay_grade` bigint(20) NULL,
  `country` bigint(20) NULL,
  CONSTRAINT `Fk_TaxRules_Tax` FOREIGN KEY (`tax`) REFERENCES `Tax` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_TaxRules_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  primary key  (`id`)
) engine=innodb default charset=utf8;

create table `DeductionRules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `apply` enum('Yes','No') default 'Yes',
  `application_type` enum('All','Condition - OR','Condition - AND') default 'All',
  `deduction` bigint(20) NOT NULL,
  `job_title` bigint(20) NULL,
  `ethnicity` bigint(20) NULL,
  `nationality` bigint(20) NULL,
  `immigration_status` bigint(20) NULL,
  `pay_grade` bigint(20) NULL,
  `country` bigint(20) NULL,
  CONSTRAINT `Fk_DeductionRules_Deductions` FOREIGN KEY (`deduction`) REFERENCES `Deductions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_DeductionRules_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  primary key  (`id`)
) engine=innodb default charset=utf8;




