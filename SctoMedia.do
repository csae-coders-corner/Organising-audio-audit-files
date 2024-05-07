/*******************************************************************************
* 07 - Extracting audio audits
********************************************************************************
*  Author: 			Prabhmeet Kaur Matta    
*  Created: 		January 2024         
*                                                                         
*  PURPOSE: Extract the audio audits to be shared with field coordinators
* 
*  OUTLINE: 	PART 1: 
*******************************************************************************/
********************************************************************************

**# 	PART 0: Set the global environment
********************************************************************************
* This is to ensure that the code is ran on the same version for everyone
clear all
ieboilstart, v(15.0)
`r(version)'


* For anyone running this code: copy the following code, paste it AFTER the paths from other people, and adapt it to your own folder path following the example below


* Note: Do not delete the existing paths when running your dofile. Instead, add your own path below. 
* The computer will automatically identify your own path based on your username and ignore the paths of other usernames.


* Prabhmeet
if "`c(username)'" == "Prabhmeet" {
	global data 	 		 "/Users/Prabhmeet/Dropbox/Data"
	global dofiles	 			  "/Users/Prabhmeet/Dropbox/Data/Code_Scripts"
	global shared_onedrive		  "/Users/Prabhmeet/Dropbox/Shared_data"
   } 

 * Directory  
 cd "$data"  
   

/*******************************************************************************
   PART 1: Data
*******************************************************************************/

* Import and save to dta
import delimited "$data/PILOT_WIDE.csv", clear
save "$data/Pilot_data.dta", replace


*******************************************************************************
**# PART 2: Rename the audio audits
*******************************************************************************
* From the forms, extract the names of the audio audits

use "$data/Pilot_data.dta", clear


/*
The command only works with data exported using SurveyCTO Sync, which 1) creates a local folder named `media' with all collected media files and 2) includes the file path (`media\filename') in the dataset. Data exported directly from the server console webpage or via the API contains URLs to files as opposed to just the file names assumed by this command.
To clean the string the loop below can be implemented
*/
* Clean the string 

foreach var of varlist audio_audit_modulec audio_audit_moduled audio_audit_modulee audio_audit_modulef audio_audit_moduleg audio_audit_moduleh audio_audit_modulei audio_audit_modulej audio_audit_modulek {
replace `var'  = subinstr(`var' , "https://firm.surveycto.com/view/submission-attachment/", "media/", .) 
replace  `var' =regexs(0) if regexm(`var',"^[^\?]*")==1
}


* ssc install scto //Install if needed


* Export the media files into the shared folder
local i = 1
local module `" "c" "d" "e" "f" "g" "h" "i" "j" "k" "'
foreach mod of local module {
sctomedia audio_audit_module`mod', 	   id(hhid) vars(matched_village uc) by(enumerator_name) media("$data/media") output("$shared_onedrive/0`i'_Module_`mod'") resolve(key)
local i = `i' + 1
}



*******************************************************************************
* End of code
*******************************************************************************



