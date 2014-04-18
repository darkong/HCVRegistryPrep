*==============================================================================;
* Analyst: 		Adam Coutts
* Created: 		April 5, 2011
* Last updated:	June 11, 2012 by Erin Murray
* Purpose: 		Merge various source datasets into one, then process data - 
					standardize values, recode, etc.
*==============================================================================;


* Merge various data sources together into one dataset - do this in separate data step from data cleaning and 
	reformatting, for reasons of how SAS works;

* Only run sections of code in set statement that correspond to data sources of new data;

data set100;
* Be specific about which variables we want to keep from data sources;
set 
	set000 /*dataset template*/

	set001 (keep = account_address account_city account_name account_zip_code /*Quest data*/
	collection_date data_source date_of_birth laboratory ordering_doctor first_name occupation
	patient_address patient_city patient_zip_code patient_id last_name result_date sex
	test_name result_name order_name result_comment result_value units)

	set003 (keep = episode_date_3 census_tract data_source date_of_birth date_of_death /*AVSS data*/
	date_of_diagnosis date_of_onset diagnosis local_health_juris mmwr_year occupation patient_address
	patient_city patient_zip_code result_name result_value first_name patient_id last_name middle_name
	race_ethnicity episode_date_1 reporter_type sex ssn episode_date_2)

	set004 (keep = account_address account_city account_name account_zip_code data_source date_of_birth /*SF data*/
	local_health_juris occupation patient_city first_name patient_id last_name race_ethnicity episode_date_1 sex result_name result_value)

	set006 (keep = account_address account_city account_name account_zip_code census_tract data_source /*CalREDIE data*/
	date_of_birth date_of_death date_of_diagnosis date_of_onset diagnosis episode_date_1 episode_date_2 
	episode_date_3 episode_date_4 first_name laboratory last_name local_health_juris middle_name occupation 
	ordering_doctor patient_address patient_city patient_id patient_zip_code race_ethnicity sex ssn result_value result_name result_comment);


* Drop cases that have missing values for all variables - use an array to loop through all numeric and character
	variables, and count how many are not missing - if all character and numeric variables are missing, 
	then delete the case;


array chr(*) _character_;      
array num(*) _numeric_;   

count=0; 

do i = 1 to dim(chr);          
 if not missing(chr(i)) then count+1;
end;                            
do j = 1 to dim(num);           
 if not missing(num(j)) then count+1;     
end;   

if count=0 then delete; 
drop i j count;

run;

proc sort data = set100; by last_name first_name date_of_birth ssn; run;





/*DM 'LOG;CLEAR;OUT;CLEAR';*/

* Main data step where cleaning and reformatting of amalgamated data takes place;

data set101;
	set set100;

* Clean up patient street address information;

if patient_address ne '' then do;

	* Strip out unneeded characters;
	patient_address = upcase(strip(compbl(compress(patient_address,'.,!?>#-"'))));

	* Standardize way PO Box is spelled;
	patient_address = tranwrd (patient_address,'P BOX','PO BOX');
	patient_address = tranwrd (patient_address,'P O BOX','PO BOX');
	patient_address = tranwrd (patient_address,'P O B','PO BOX');
	patient_address = tranwrd (patient_address,'P OBOX','PO BOX');
	patient_address = tranwrd (patient_address,'P.O. BOX','PO BOX');
	patient_address = tranwrd (patient_address,'PO BX','PO BOX');
	patient_address = tranwrd (patient_address,'POBOX','PO BOX');
	patient_address = tranwrd (patient_address,'POST OFFICE BOX','PO BOX');
	patient_address = tranwrd (patient_address,'POST BOX','PO BOX');
	patient_address = compbl (tranwrd (patient_address,'PO BOX','PO BOX '));

	if length(patient_address) > 3 then do; 
	if substr(patient_address,1,4) = 'BOX ' then patient_address = catx (' ','PO',patient_address); 
	end;

	if length(patient_address) > 4 then do; 
	if substr(patient_address,1,4) = 'POB ' then patient_address = catx (' ','PO BOX',substr(patient_address,5)); 
	end;

	if length(patient_address) > 5 then do; 
	if substr(patient_address,1,6) = 'O BOX ' then patient_address = cat ('P',patient_address); 

	* If want to identify homeless and transient individuals then the following code will do that;
	if ((index(patient_address,"HOMEL") or index(patient_address,"HOML") or index(patient_address,"HOMM") or 
	index(patient_address,"OMELESS")) and index(patient_address,"SECUR")=0 and index(patient_address,"HOMELAND")=0) 
	or (index(patient_address,"HOME") and index(patient_address,"LESS")) then homeless='H'; *homeless;
	else if index(patient_address,"TRANS") and index(patient_address,"TRANSO")=0 and index(patient_address,"TRANSIT")=0 and 
	index(patient_address,"TRANSC")=0 then homeless='T'; *transient;
	else homeless='';

	* If address not given or missing, then set as blank; 
	* Commented out the code that also sets addresses of homeless and transient patients to missing.
		Of note, the above code identifying homless and transent individuals is MUCH better than the code that has been commented out below.;
	if anydigit(patient_address) = 0 & (index(patient_address,"UNK") > 0 | /*index(patient_address,"HOMELESS") > 0 | */
	index(patient_address,"NO ADDR") > 0 | /*index(patient_address,"TRANSIENT") > 0 | */
	index(patient_address,"NOT GIVEN") > 0 | patient_address in ("ADDRESS NOT AVAILABLE", "HAS NOT BEEN GIVEN", 
	/*"HOMLESS", "HOMMELESS",*/ "N/A", "NO ADDDRESS GIVEN", "NO ADRESS GIVEN", "NO AVAILABLE", "NO GIVEN ADDRESS", 
	"NO INFORMATION", "NO INFORMATION AVAILABLE", "NO LOCAL ADDRESS", "NO T GIVEN", "NON GIVEN", "NONE", "NONE GIVE", 
	"NONE GIVEN", "NOT AVAILABLE", "NOT AVAILABLE/NONE GIVEN", "NOT AVILABLE", "NOT NEEDED", "NOT PROVIDED", 
	"NOT REPORTED", "NULL"/*, "OMELESS", "TRANSCIENT"*/)) then patient_address = "";	end;

	* Use format to standardize patient city names;
	patient_city = put(strip(patient_city),$cities.); 

	* Deal with short patient addresses - first, one specific instance where a one letter address means
		the Ca Inst for Men prison, then, otherwise, set address as missing;
	if patient_address  = '0' & (patient_city = "CHINO" | patient_zip_code = 91710 | account_city = "CHINO" | 
		account_zip_code = 91710) then patient_address = "14901 S CENTRAL AVE";
	if length(patient_address) < 3 then patient_address = "";

	end;

* Do single recode needed for account address po boxes (the recodes above were for patient address);
	account_address = tranwrd (account_address,'P.O. BOX','PO BOX');
* Compress out extra spaces and punctuation;
	account_address = upcase(trim(compbl(compress(account_address,'.,!?>#-"'))));
* Use format to standardize account city names;
	account_city = put(strip(account_city),$cities.); 

* Delete account name and addresses with specific meaningless values;
if substr(account_name,1,12) = "DR NAME:____" then account_name = "";
if substr(account_address,1,12) = "ADDRESS:____" then account_address = "";

* There is no zip code '99999' in the USA - it is apparently a missing code;
if account_zip_code = 99999 then account_zip_code = .;
if patient_zip_code = 99999 then patient_zip_code = .;


* Deal with patient city values that are effectively missing, because length of city name is one or two characters;
if (length(patient_city) < 3 & length(patient_city) > 0) then do;
		* First, try to figure out from patient zip;
		if patient_zip_code ne . then patient_city = put (patient_zip_code,cityzip.);
		* Then resort to account information;
		else if account_city ne '' then patient_city = account_city;
		else if account_zip_code ne . then patient_city = put (account_zip_code,cityzip.);
		* If all else fails, just set as missing;
		else patient_city = '';
	end;

* Clean up sex values;
* Recode 'other' as 'transgender';
if sex = 'O' then sex = 'T';
* All unstandard values recoded to 'unknown';
if sex not in ('M','F','T','U') then sex = 'U';

if data_source ne "AVSS" then episode_date_3 = .;


* Standardize uppercase for name variables - also compress out numbers and characters;
first_name = compbl(strip(translate(upcase(first_name),' ',"01234567890,-;()?.'`%#[]~/\")));
middle_name = compbl(strip(translate(upcase(middle_name),' ',"01234567890,-;()?.'`%#[]~/\")));
* Use format on last name to recode some identified misspellings;
last_name = compbl(strip(translate(upcase(put(last_name,$lnamecln.)),' ',"01234567890,-;()?.'`%#[]~/\")));


* If "CDC" is part of first name, then assign prisoner status, and strip that part of the name out;
* First - situations where the "CDC" is a separate second part of the name;
if index(scanq(first_name,2),"CDC#") > 0 | scanq(first_name,2) = "CDC" then do;
	prison = "O";
	first_name = scanq(first_name,1);
	end;

* Second - where the "CDC" is all of the name;
if length (first_name) > 2 then do;
	if substr(first_name,1,3) = "CDC" then do;
		prison = "O";
		first_name = "";
		end; 
	end;

* Third - where its attached to the name, at the end;
if length (first_name) > 4 then do;
	if substr(first_name,(length(first_name)-4),4) = "CDC#" then do;
		prison = "O";
		first_name = substr(first_name,1, (length(first_name)-4));
		end;
	end;

* Delete first name that are 'unknown', or that have numbers in them (a number of names are 
	one alpha multiple numeric (prisoner number?));
if (strip(first_name) in ('UNKNOWN','UNK','UNKOWN','JR')) | (anydigit (first_name))
	then first_name = '';

* Middle name sometimes has strange value in it - delete if no letters in name value;
if anyalpha(middle_name) = 0 | middle_name="III" then middle_name = "";

* Strip off 'JR','SR',etc from end of names (and DR from beginning of first name);
if length (first_name) > 3 then do;
	if substr(first_name,length(first_name)-2,3) in (' SR',' II','III',' IV',' JR') then 
		first_name = substr(first_name,1,length(first_name)-3);
	end;

if length (first_name) > 2 then do;
	if substr(first_name,length(first_name)-1,2) in ('SR','JR') then 
		first_name = substr(first_name,1,length(first_name)-2);
	end;

if strip(scanq(first_name,1)) = "DR" then first_name = scanq(first_name,2);

if length (last_name) > 3 then do;
	if substr(last_name,length(last_name)-2,3) in (' SR',' II','III',' IV',' JR') then 
		last_name = substr(last_name,1,length(last_name)-3);
	* For last names with 'MC' and then a space - remove spaces;
	if substr(last_name,1,3) = "MC " then last_name = compress (last_name);	
	end;

if length (last_name) > 2 then do;
	if substr(last_name,length(last_name)-1,2) in ('SR','JR') then 
		last_name = substr(last_name,1,length(last_name)-2);
	end;

* If no first name, but there is a value for middle name, then take middle name;
if missing (strip(first_name)) & not missing (middle_name) then do;
	first_name = upcase(middle_name);
	middle_name = '';
	end;

* If first name has two parts, make the second part the middle name (if it is longer in length than existing middle name);
if anyalpha(scanq(first_name,2)) then do;
	first_name = scanq(first_name,1);
	if missing(last_name) then last_name = scanq(first_name,2);
	else if length(scanq(first_name,2)) > length(middle_name) then middle_name = scanq(first_name,2);
	end;

* If first name is a subset of middle name, make first name be the middle name;
if length(middle_name) > length(first_name) then do;
	if (index (middle_name,strip(first_name)) > 0 & length(first_name) > 3 |
		substr(middle_name,1,length(first_name)) = first_name) then do;
			first_name = middle_name;
			middle_name = "";
			end;
		end;

* If middle name is same or a subset of first name, then delete middle name;
if not missing(middle_name) & length(first_name) >= length(middle_name) then do;
 	if (middle_name = first_name | indexw(put(middle_name,$nickname.),first_name) | 
	indexw(put(first_name,$nickname.),middle_name) | (index (first_name,strip(middle_name)) > 0 & 
	length(middle_name) > 3) | (%normlev(middle_name,first_name)<=0.2) | 
	substr(first_name,1,length(middle_name)) = middle_name) then middle_name = "";
end;


* If last name is a subset of middle name, make last name be the middle name;
if length(middle_name) > length(last_name) then do;
	if (index (middle_name,strip(last_name)) > 0 & length(last_name) > 3 |
		substr(middle_name,1,length(last_name)) = last_name) then do;
			last_name = middle_name;
			middle_name = "";
			end;
		end;

* If middle name is same or a subset of last name, then delete middle name;
if not missing(middle_name) & length(last_name) >= length(middle_name) then do;
 	if (middle_name = last_name | indexw(put(middle_name,$nickname.),last_name) | 
	indexw(put(last_name,$nickname.),middle_name) | (index (last_name,strip(middle_name)) > 0 & 
	length(middle_name) > 3) | (%normlev(middle_name,last_name)<=0.2) | 
	substr(last_name,1,length(middle_name)) = middle_name) then middle_name = "";
end;


* Clean up and standardize ordering_doctor variable;
ordering_doctor = strip(compbl(tranwrd(upcase(translate (ordering_doctor,' ','~#./')),' MD','')));

* Flip name, if there is a comma in it;
if findc (ordering_doctor,',') > 1 & (length (ordering_doctor) > findc (ordering_doctor,',')) then do;
	name_1 = substr(ordering_doctor,1,(findc (ordering_doctor,',') - 1));
	name_2 = substr(ordering_doctor,(findc (ordering_doctor,',') + 1 ));
	ordering_doctor = catx (' ',name_2,name_1);
	end;

drop name_1 name_2;

ordering_doctor = compbl(translate (ordering_doctor,' ',','));
if ordering_doctor in ("NOT GIVEN", "NO ORDERING DOCTOR", "0", "UNKNOWN", "HOSPITAL") then ordering_doctor = "";


* Calculate whether episode is verified chronic Hep C case or not;
* For diagnosis	values that are legitimate, then set as 1 (verified case reported to the state);
if diagnosis in ("HEP YCAR","HEP-C-CR") then diagnosis = "Confirmed"; *impacts AVSS and STDCB-entered data;
if data_source in ("SF eFTP","EPIINFO") then diagnosis = "Confirmed"; *impacts SF data;
/*if diagnosis = "Confirmed" | data_source in ("SF eFTP","STD-CB entered CMRs") then diagnosis2 = 1; */
/** For diagnosis	values that are not legitimate, then set as 3 (not verified case);*/
/*if diagnosis in ("NPJ Incident","Not A Case","Not Reportable","Out of State",*/
/*	"Previously Reported","Probable","Suspect") then diagnosis2 = 3;*/


* Calculate case status for lab report data;
if data_source in ("Quest Lab", "Foundation Lab", "Other Lab", "ARUP Lab") then do;

	* Set default to 3 - not a chronic case;
	diagnosis2 = 3;

	* First, create numeric variable for units - exponent out logarithmically stored values;
	format newnum 8.3;

* Clean up and standardize result value variable;
	result_value = upcase(strip(tranwrd (tranwrd (compress(translate(tranwrd(result_value,
		'..','.'),'.',','),'<>'),' (H)',''),' H','')));
	if index(result_name,"GENOTYPE") and result_value in ("1A","1B","2A","2B","3A","3C","2A/2C","4A/4C/4D","6A/6B","6F", "1A/2B", "1A/3A", "1A/4", "1", "2", 
		"3", "4", "5", "6") then result_value = "GENOTYPE " || result_value;
	if result_value = "REACTIVE\" then result_value = "REACTIVE";

	if (anyalpha(result_value) = 0 & anydigit(result_value) > 0) then do;
		if units = "Log IU/mL" then newnum = 10**(input(result_value,8.));
			else newnum = input(result_value,8.);
		end;

	* Apply rules to verify episodes that indicate verified chronic status;
	if (result_name in ("HCV RNA QUANT TMA","HCV RNA QUANT bDNA w/RFLX TMA","HCV RNA",
		"HEPTIMAX (R) HCV RNA","HEPTIMAX(R) HCV RNA","HEPTIMAX (TM) HCV RNA") & newnum >= 5) then diagnosis2 = 2;
	else if (result_name = "HCV AB w/RFLX to RIBA" and result_value in ("POSITIVE","REACTIVE")) then diagnosis2 = 2;
	else if result_name = "HCV GENOTYPE LIPA" & (index (result_value,"GENOTYPE") > 0 | 
		result_comment in ("FORMERLY CLASSIFIED AS 7C",
		"THE VERSANT(R) LINE PROBE ASSAY CANNOT DISCRIMINATE BETWEEN SUBTYPE 2A AND 2C.")) then diagnosis2 = 2;
	else if (result_name = "HCV RNA QUANT REAL-TIME PCR" & (newnum >= 43 | index(result_value,"GENOTYPE")) > 0) 
		then diagnosis2 = 2;
	else if (result_name = "HCV RNA QUAL PCR" & (result_value in ("REACTIVE","DETECTED"))) then diagnosis2 = 2;
	else if (result_name = "HCV RNA QUAL TMA" & result_value in ("REACTIVE","DETECTED")) then diagnosis2 = 2;
	else if (result_name = "HCV RNA QUANT" & newnum >= 50) then diagnosis2 = 2;
	else if (result_name = "HCV RNA QUANT bDNA" & newnum >= 615) then diagnosis2 = 2;
	else if (result_name = "Signal to Cutoff Ratio" & (newnum >= 8 | index(result_comment,"HIGH S"))) then diagnosis2 = 2; 	
	else if (result_name = "HCV AB" & (index(result_comment,"HIGH S") | index(result_value,"11.00 POSITIVE"))) then diagnosis2 = 2; 
		* added data_source specification since foundation lab s/co is 11;
		* changed result_comment code to be a little bit less specific to allow for more variations in how a high s/co is written;
	* Set these Antigen band pattern results to 4 - to be used later in identifying cases who had two
			reactive bands in the same visit;
	else if (result_name in ("BAND PATTERN 5-1-1 (p)/cl00 (p)","C22P","NS5","C33C") & result_value = "REACTIVE")
			then diagnosis2 = 4;

	drop newnum;
	
end;

else if index(data_source,'CalREDIE')|data_source='STDCB-entered CMRs' then do;
	if result_value='POS' then diagnosis2=1;
end;

else if data_source='SF eFTP' then do;
	if result_name='GENOTYPE' | result_value='POS' then diagnosis2=1;
end;

else if data_source='AVSS' then do;
	if result_name='HCV PCR' and result_value='POS' then diagnosis2=1;
end;

else if data_source='EPIINFO' then do;
	if result_name='HCV PCR' and result_value='POS' then diagnosis2=1;
end;


* Standardize prison names - start with common street addresses and pobox numbers - use city
	specificity to recode them as prison-specific addresses, for use in later processes;
if (patient_address in ("PO BOX 29", " P O X 29") & patient_city = "REPRESA") then
	patient_address = "100 PRISON RD PO BOX 29";

if account_address ne '' then account_address = put(account_address,$prison.);
if patient_address ne '' then patient_address = put(patient_address,$prison.);
if account_name ne '' then account_name = put(account_name,$prison.);


* Set incarcerated variable to "not incarcerated" as a default;
prison = '-';


* For people who are inmates and most address information is missing but patient zip code 
	indicates a certain prison, then identify that record as that prison;

if (index(upcase(occupation),"INMATE") > 0 | index(patient_address,'INMATE') > 0 | index(first_name,'INMATE') > 0 | 
index(last_name,'INMATE') > 0) & patient_address = "" & account_name = "" & account_address = "" then do;

	if (sex ne "F" /*| put(first_name,$name_sex.) ne "F"*/) then do; *removed "heavily gendered" name macro as per discussion with Rachel McLean;
	if patient_zip_code = 95640 then patient_address = "MULE CREEK STATE PRISON";
	if patient_zip_code = 95531 then patient_address = "PELICAN BAY STATE PRISON";
	if patient_zip_code in (93401,93409) then patient_address = "CA MEN'S COLONY";
	if patient_zip_code = 92251 then patient_address = "CA STATE PRISON CENTINELA";
	* Two different prisons in these zip codes;
	if patient_zip_code in (93212, 93960, 96130) then prison = "M";
	end;

	if patient_zip_code = 93423 then patient_address = "ATASCADERO STATE HOSPITAL";
	if patient_zip_code = 95757 then patient_address = "RIO COSUMNES CORRECTIONAL CENTER";
	if patient_zip_code = 95814 then patient_address = "SACRAMENTO COUNTY MAIN JAIL";

	* Two different prisons in this zip codes;
	if patient_zip_code = 93610 & sex ne "M" then prison = "F";
	end;


* If have partial prision information, expand out to the rest of variables - invoke macro;
%prisonch
*if sex does not sorrespond to sex of prison assigned to, then set sex to missing;
if prison='M' and sex='F' then sex='';
if prison='F' and sex='M' then sex='';

* Create incarcerated variable - M for male state prison, F for female state prison, O for county jail
	and unknown jails/prisons;

if prison = '-' & (index(upcase(occupation),"INMATE") > 0 | index(upcase(patient_address),'INMATE') > 0 | 
index(upcase(first_name),'INMATE') > 0 | index(upcase(last_name),'INMATE') > 0 | index(first_name,'CDC') > 0 |
index (upcase(account_name),"JAIL") > 0 | index (upcase(account_name),"CORRECT") > 0 | 
index (upcase(account_name),"PRISON") > 0 | index (upcase(account_name),"DETENTION") > 0 | 
index (upcase(account_address),"JAIL") > 0 | index (upcase(account_address),"CORRECT") > 0 | 
index (upcase(account_address),"PRISON") > 0 | index (upcase(account_address),"DETENTION") > 0 | 
index (upcase(patient_address),"JAIL") > 0 | index (upcase(patient_address),"CORRECT") > 0 | 
index (upcase(patient_address),"PRISON") > 0 | index (upcase(patient_address),"DETENTION") > 0 |
index (upcase(patient_address),"CUSTODY") > 0 | index (upcase(patient_address),"INCARCER") > 0 | 
index (upcase(patient_address),"ENCARCER") > 0) then prison = "O";
* Zip codes that are state prison-only but that contain more than one prison;
if (account_zip_code in (95671,96127) | patient_zip_code in (95671,96127)) & prison in ('-','O') then prison = 'M';

if strip(occupation) in ('','Unknown') & prison ne '-' then occupation = 'Inmate';


* If in a male or female prison and sex is missing, then assign sex based on prison type;

if prison = "F" and strip(sex) in ('','U') then sex = "F";
if prison = "M" and strip(sex) in ('','U') then sex = "M";
if prison = "M" & put(first_name,$name_sex.) = 'M' & sex = "F" then sex = "M";
if prison = "F" & put(first_name,$name_sex.) = 'F' & sex = "M" then sex = "F";


* If patient zip code is in address but missing from patient zip code, then extract zip out from address;
* Do this procedure for all cases where final six characters are a space followed by 9 followed by four numbers
	(or the address starts with 9 and is only five digits long), and its not a po box number or an 
	inmate id number, and zip code is missing;
if (notdigit (substrn (patient_address,length(patient_address)-4,5)) = 0 & 
	((substrn (patient_address,length(patient_address)-5,2) = " 9") | 
	(length(compress(patient_address)) = 5 & (substrn (patient_address,1,1) = "9")))
	& (index(patient_address,'BOX') = 0 | index(patient_address,'ZIP')>0) & index(patient_address,'INMATE') = 0
	& index(patient_address,'480 ALTA') = 0 & patient_zip_code = . & length (patient_address) > 4) 
	then do;
		patient_zip_code = put (substrn (patient_address,length(patient_address)-4,5),5.);
		patient_address = substrn (patient_address,1,length(patient_address)-5);
		end;


if account_city = "FORT IRWIN" & account_zip_code in (.,0) then account_zip_code = 92310;

* If local health jurisdiction is missing, create a value;

	* Strip out leading and trailing blanks;
	local_health_juris = strip(upcase(local_health_juris));

	* Set 'unknown' values to missing;
	if local_health_juris = "UNKNOWN" then local_health_juris = "";

	* If address is one of the city-specific lhj, then code that;
	if missing(local_health_juris) & patient_city in ('Berkeley','Long Beach', 'Pasadena')
		then local_health_juris = patient_city;
	if missing(local_health_juris) & account_city in ('Berkeley','Long Beach', 'Pasadena') 
		then local_health_juris = account_city;

	* Otherwise derive lhj from the county mapping of zip code;
	if missing(local_health_juris) then local_health_juris = put (patient_zip_code,zipcnty.);
	* After that, if lhj then is just a zip code (without any letters in the value, ie an anyalpha of 0), 
		then set lhj to missing;
	if anyalpha(local_health_juris) = 0 then local_health_juris = "";

	if missing(local_health_juris) then local_health_juris = put (account_zip_code,zipcnty.);
	if anyalpha(local_health_juris) = 0 then local_health_juris = "";

	* If lhj is still missing, and zip indicates out of state location, then set lhj as such;
	if missing(local_health_juris) & (account_zip_code > 96162 | patient_zip_code > 96162 |
		(account_zip_code < 90000 & not missing (account_zip_code)) |
		(patient_zip_code < 90000 & not missing (patient_zip_code))) then local_health_juris = "OUT OF STATE";


* Large numbers of men look like they are in either High Desert or CCC state prisons, but are missing all 
	address information so that can't be specified.  Nonetheless, the numbers are to high to be 
	in county/local jail;
if prison = "O" & local_health_juris = "LASSEN" & sex = "M" then prison = "M";


* If date of death, diagnosis, onset are over 100 years before today (or for date of birth 110 years), then 
	add 100 years to them; 
if date_of_death < (today()- 36525) then date_of_death = 
	MDY(month(date_of_death),day(date_of_death),(year(date_of_death)+100));
if date_of_diagnosis < (today()- 36525) then date_of_diagnosis = 
	MDY(month(date_of_diagnosis),day(date_of_diagnosis),(year(date_of_diagnosis)+100));
if date_of_onset < (today()- 36525) then date_of_onset = 
	MDY(month(date_of_onset),day(date_of_onset),(year(date_of_onset)+100));
if date_of_birth < (today()- 40200) then date_of_birth = 
	MDY(month(date_of_birth),day(date_of_birth),(year(date_of_birth)+100));

* if (date_of_death = date_of_birth) & (year(date_of_death) < 2000) then date_of_death = .; *I'm not sure where & (year(date_of_death) < 2000) comes into play?;
if (date_of_death = date_of_birth) then date_of_death = .;
patient_id = strip(upcase(patient_id));
if race_ethnicity = '' then race_ethnicity = "Unknown";

* Delete impossible dates (before 1900, larger than today's date);
if date_of_birth < '01JAN1900'd | date_of_birth > "&sysdate9."d then date_of_birth = .;
if date_of_onset < '01JAN1900'd | date_of_onset > "&sysdate9."d then date_of_onset = .;
if date_of_diagnosis < '01JAN1900'd | date_of_diagnosis > "&sysdate9."d then date_of_diagnosis = .;
if date_of_death < '01JAN1900'd | date_of_death > "&sysdate9."d then date_of_death = .;
if episode_date_1 < '01JAN1900'd | episode_date_1 > "&sysdate9."d then episode_date_1 = .;
if episode_date_2 < '01JAN1900'd | episode_date_2 > "&sysdate9."d then episode_date_2 = .;
if collection_date < '01JAN1900'd | collection_date > "&sysdate9."d then collection_date = .;
if result_date < '01JAN1900'd | result_date > "&sysdate9."d then result_date = .;
if episode_date_3 < '01JAN1900'd | episode_date_3 > "&sysdate9."d then episode_date_3 = .;

* Remove labels;
attrib _all_ label=' '; 

* Do specific data cleaning;
%include "&homeloc.\51 Data_Cleaning.sas";

run; 


* Sort by patient ID - to prepare to merge with locally entered lab data forms;
proc sort data=set101; by patient_id descending result_date; run;


*Create macro vairable for largest ID in main02 dataset;
proc sql;
select max(id) into :maxid
from mainfldr.main02;
quit;

* Create an ID variable for deduplicating and other purposes - consists simply of record number - do this
	while data is sorted by last name, first name, dob;
proc sort data=set101; by last_name first_name date_of_birth; run;

data set101;
	set set101;
	id = &maxid+_n_;
	run;


* We may be able to find prison information just from doctor name - for situations where a given doctor name
		is only found to correlate with a single account name;

* Create dataset of ordering doctor names and account names;
proc sort data = set101 (keep = ordering_doctor account_name account_address account_city account_zip_code) 
	out = doc_accnt nodupkey; 
	by ordering_doctor account_name; 
	where not missing(account_name) & not missing (ordering_doctor);
	run;

* Delete (for doctor name - account name dataset) situations where ordering doctor name correlates with 
	more than one account name;
data doc_accnt;
	set doc_accnt;
	by ordering_doctor;
	if first.ordering_doctor & last.ordering_doctor;
	rename
	account_name = account_name2
	account_address = account_address2
	account_city = account_city2
	account_zip_code = account_zip_code2;
run;

proc sort data=set101; by ordering_doctor; run;

* Merge account name (and location) information in for cases where doctor name fills in a blank;
data set101 (drop = account_name2 account_address2 account_city2 account_zip_code2);
	merge set101 doc_accnt;
	by 	ordering_doctor;
	if missing(strip(account_name)) then account_name = account_name2;
	if missing(strip(account_address)) then account_address = account_address2;
	if missing(strip(account_city)) then account_city = account_city2;
	if missing(strip(account_zip_code)) then account_zip_code = account_zip_code2;

	* Do prison check again;
	%prisonch

	run;

data mainfldr.set101;
set set101;
run;
