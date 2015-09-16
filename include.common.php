<?php
//error_reporting(0);
require dirname(__FILE__).'/composer/vendor/autoload.php';


if(!defined('TAGS_TO_PRESERVE')){define('TAGS_TO_PRESERVE','');}
$jsVersion = defined('CACHE_VALUE')?CACHE_VALUE:"v".VERSION;
$cssVersion = defined('CACHE_VALUE')?CACHE_VALUE:"v".VERSION;


include (APP_BASE_PATH."utils/SessionUtils.php");
include (APP_BASE_PATH."utils/InputCleaner.php");
include (APP_BASE_PATH."utils/LogManager.php");


$_REQUEST = InputCleaner::cleanParameters($_REQUEST);
$_GET = InputCleaner::cleanParameters($_GET);
$_POST = InputCleaner::cleanParameters($_POST);



//Find timezone diff with GMT
$dateTimeZoneColombo = new DateTimeZone("Asia/Colombo");
$dateTimeColombo = new DateTime("now", $dateTimeZoneColombo);
$dateTimeColomboStr = $dateTimeColombo->format("Y-m-d H:i:s");
$dateTimeNow = date("Y-m-d H:i:s");

$diffHoursBetweenServerTimezoneWithGMT = (strtotime($dateTimeNow) - (strtotime($dateTimeColomboStr) - 5.5*60*60))/(60*60);