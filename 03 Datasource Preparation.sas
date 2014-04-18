*=====================================================================;
* Analyst: 		Adam Coutts
* Created: 		March 27, 2011
* Last updated:	June 8, 2012 by Erin Murray
* Purpose: 		Prepare data from various datasets for merging - 
					rename data, recode, etc. - then save to perminent 
					datasets
*=====================================================================;

*** Only run code sections of relevant new data;

* Create empty template dataset, so as to standardize capitalization of variable names, variable order in 
		the dataset, and variable lengths - this template dataset will set the standard for the 
		merged dataset for all of those attributes because it will be the first one merged in;

data set000;
	attrib first_name length = $20. format = $20. informat = $20.;
	attrib last_name length = $35. format = $35. informat = $35.;
	attrib middle_name length = $20. format = $20. informat = $20.;
	attrib ssn length = 8. format = 9. informat = 9.;
	attrib sex length = $1. format = $1. informat = $1.;
	attrib race_ethnicity length = $35. format = $35. informat = $35.;
	attrib occupation length = $25. format = $25. informat = $25.;
	attrib date_of_birth length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib date_of_onset length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib date_of_diagnosis length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib mmwr_year length = 8. format = 6. informat = 6.; 
	attrib date_of_death length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib patient_address length = $50. format = $50. informat = $50.;
	attrib patient_city length = $25. format = $25. informat = $25.;
	attrib patient_zip_code length = 8. format = 8. informat = 8.;
	attrib census_tract length = $10. format = $10. informat = $10.;
	attrib account_name length = $40. format = $40. informat = $40.;
	attrib account_address length = $80. format = $80. informat = $80.;
	attrib account_city length = $24. format = $24. informat = $24.;
	attrib account_zip_code length = 8. format = 8. informat = 8.;
	attrib local_health_juris length = $20. format = $20. informat = $20.;
	attrib laboratory length = $50. format = $50. informat = $50.;
	attrib diagnosis length = $20. format = $20. informat = $20.;
	attrib diagnosis2 length = 8. format = 1. informat = 1.;
	attrib ordering_doctor length = $30. format = $30. informat = $30.;
	attrib episode_date_1 length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib episode_date_2 length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib episode_date_3 length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib episode_date_4 length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib collection_date length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib result_date length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib reporter_type length = $9. format = $9. informat = $9.;
	attrib prison length = $1. format = $1. informat = $1.;
	attrib test_name length = $45. format = $45. informat = $45.;
	attrib result_name length = $36. format = $36. informat = $36.;
	attrib order_name length = $41. format = $41. informat = $41.;
	attrib result_value length = $20. format = $20. informat = $20.;
	attrib result_comment length = $200. format = $200. informat = $200.;
	attrib patient_id length = $22. format = $22. informat = $22.;
	attrib id length = 8. format = 8. informat = 8.;
	attrib data_source length = $30. format = $30. informat = $30.;	
	run;


* Process Quest Lab data (already mostly processed in 02 Quest Lab Dataset Creation.sas file);

data set001;
	set questset;

	informat data_source $22. laboratory $50.;

	* Identify data source;
	data_source = "Quest Lab";

	* Add specific Quest lab location to laboratory name;
	laboratory = catx (' ',"Quest Diagnostics - ",put(originating_lab,$questloc.));

	* Rename variables to standardize them with other datasets;
	rename
		ordering_md = ordering_doctor
		patient_gender = sex
		DATE_OF_SERVICE = Result_Date
		accession_number = patient_id
		patient_dob = date_of_birth
		PATIENT_FIRST_NAME = first_name
		PATIENT_LAST_NAME = last_name
		;

	* Drop unneeded variables;
	drop account_state ORIGINATING_LAB account_phone account_zip_full;

	run;


* Process AVSS data;

data set003;
	set avss_final (rename = (ssn = ssn1));

* Create size and type of new variables that will be calculated;
	informat date_of_birth date_of_onset date_of_diagnosis date_of_death episode_date_2 episode_date_1 episode_date_3 MMDDYY10. 
		data_source $22. mmwr_year 6.0 race_ethnicity $35. census_tract $10. patient_address $50. 
	reporter_type $9. ssn 9. result_name $36. result_value $20.;

* Identify data source;
	data_source = "AVSS";

* Code date variables;
format date_of_birth date_of_onset date_of_diagnosis date_of_death episode_date_2 episode_date_1 episode_date_3 MMDDYY10.;
date_of_birth=dob;
date_of_onset=don;
date_of_diagnosis=ddx;
date_of_death=dth;
episode_date_2=td;
episode_date_1=dat;
episode_date_3=dup;

	census_tract = compress(ctr);
	patient_address = addr;
	if addr = "UNK" then addr = "UNKNOWN";

	* Recode mmwr year variable - believe that this has something to do with year of diagnosis;
	mmwr_year = input(year,6.0);
	if mmwr_year > 11 then mmwr_year = mmwr_year + 1900;
		else mmwr_year = mmwr_year + 2000;

	* Standardize two vaiables;
	race_ethnicity = put(re,$raceeth.);

	* Strip dots/periods out of census track values;
	census_tract = tranwrd (census_tract,'.','');

	* Standardize occupation information;
	occupation = propcase (occupation);
	occupation = tranwrd (occupation,'-',' ');
	occupation = tranwrd (occupation,'/',' ');
	if index (occupation,'Unempl') > 0 then occupation = "Unemployed";
	occupation = put(strip(occupation),$occup.); 
	
	* Clean ssn information - make unknown values blank, remove blanks and dashes, translate into numeric 
			(use compress function to keep only digits); 
	if ssn1 in ("000-00-0000","UNK","000000001","999999999","000-00-0001","999-99-9999") then ssn1 = '';
	if ssn1 notin ('','.') then ssn = put(compress (ssn1,"0123456789",'k'),9.);
		else ssn = .;		

	* Data clean incorrect birth year for one specific record;
	if 2900 < year(date_of_birth) < 3025 then date_of_birth = 
		MDY(month(date_of_birth),day(date_of_birth),(year(date_of_birth)-1000));

	* Create result_name and result_value variables using laboratory information available in AVSS data;
	format result_name $36. result_value $20.;
	if pcrhcv='POSITIVE' then do;
		result_name='HCV PCR';
		result_value='POS';
	end;

	* Rename variables to standardize them with other datasets;
	rename
		FNA = first_name
		MNA = middle_name
		LNA = last_name
		ID = patient_id
		DIS = diagnosis
		LHD = local_health_juris
		city = patient_city
		zip = patient_zip_code;

	* Drop unneeded variables;
	drop age year re  ctr addr pcrhcv rtyp ssn1 dob don ddx dth td dat dup;

	run;




* Process SF city/county data;

data set004;
	set SFeFTPData;

* Create size and type of new variables that will be calculated;
	informat data_source $22. race_ethnicity $35. local_health_juris $20. patient_city $25.
		account_name $40. account_address $80. account_city $22. account_zip_code 8.  occupation $25.;
	* reason_testing $110. risk_factors $250.;

* Identify data source;
	data_source = "SF eFTP";

* Recode multiple race and ethnicity variables down into one variable;
	if race_amind = '1' then race_ethnicity = 'Native American/Alaskan Native';  
	if race_asian = '1' then race_ethnicity = 'Asian';
	if race_pacisland = '1' then race_ethnicity = 'Pacific Islander';
	if race_black = '1' then race_ethnicity = 'Black/African-American';  
	if race_white = '1' then race_ethnicity = 'White';  
	if race_other = '1' then race_ethnicity = 'Other';  
	if ethnic_grp = '1' then race_ethnicity = 'Hispanic/Latino';
	if race_ethnicity = '' then race_ethnicity = 'Unknown';

	local_health_juris = "SAN FRANCISCO";
	if cnty_res = "San Francisco" then patient_city = "SAN FRANCISCO";
	
* Rename variables to standardize them with other datasets;
	rename
		birth_dt = date_of_birth
		local_id = patient_id 
		rep_dt = episode_date_1
		birth_dt = date_of_birth
		fname = first_name
		lname = last_name
		;

* Drop unneeded variables;
	drop diagnosis_dt race_amind race_asian race_black race_white race_other ethnic_grp race_pacisland 
		NETSS_ID NETSS_YR event birth_country reastest_acutehep specoth_birthcountry reastest_acutehep 
		reastest_livenzymes reastest_riskfact reastest_donor reastest_norisk reastest_followup reastest_prenatal 
		reastest_other reastest_unknown specoth_reastest HCVTRANSF HCVTRANSP HCVCLOT HCVDIAL HCVIVDRUGS MSM_hepC
		HCVINCAR HCVSTD HCVCONTACT sexcont_hepC hholdcont_hepC othercont_hepc HCVOTHCON HCVMEDEMP
		complete comment case_status antihcv_sigcut_quant specoth_race hcvnummalepart hcvnumfemalepart 
		care_hepc med_hepc Iview cnty_res; 

* Create result_name and result_value variables using laboratory information available in SF data;
format result_name $36. result_value $20.;
if strip(compress(HCV_genotype,,'a')) ne '' then  do;
	result_name='GENOTYPE';
	result_value=HCV_genotype;
end;
if antihcv_sigcut_qual=1 then do;
	result_name='ANTI-HCV HIGH S/CO';
	result_value='POS';
end;
if HCVRNA=1 then do;
	result_name='RNA';
	result_value='POS';
end;

* include ALT data later when ready to define probable case;
	drop ALT alt_dt ALT_ULN antihcv antihcv_sigcut_qual antiHCV_suppl HCV_genotype HCVRNA;

	run;



* New CalREDIE datasend;


* Sort, to get rid of duplicates;
proc sort data=calredie nodup; by ID CMRNumber descending HEPCLABCRDXTSTANTIHCVRSLT descending HEPCLABCRDXTSTANTIHCVCUTRATIO descending DXLVRENZLEVALTSGOTRSLT; 
run;
proc sort data=calredie nodupkey; by ID CMRNumber; run;


data set006;
	set calredie (rename = (ssn = ssn1));

* Create size and type of new variables that will be calculated;
	format episode_date_1 mmddyy10. episode_date_2 mmddyy10. episode_date_3 mmddyy10. episode_date_4 mmddyy10. date_of_onset mmddyy10.
		date_of_diagnosis mmddyy10. date_of_death mmddyy10. date_of_birth mmddyy10.;
	informat patient_id $20. race_ethnicity $35. data_source $22. ssn 9. 
		account_name $40. account_address $80. account_city $22. account_zip_code patient_zip_code 8. 
		middle_name $20. occupation2 $25. local_health_juris $20. ordering_doctor $30.
		episode_date_1 mmddyy10. episode_date_2 mmddyy10. episode_date_3 mmddyy10. episode_date_4 mmddyy10. date_of_onset mmddyy10.
		date_of_diagnosis mmddyy10. date_of_death mmddyy10. date_of_birth mmddyy10.;

* Include reporting type (CMR, Lab, both) in data source field;
	data_source = catx (' ',"CalREDIE",ReportedBy);

* Convert from numeric to character;
	patient_id = put(ID,8.);

* Calculate race_ethnicity variable from seperate CalREADIE race and ethnicity variables;
	race_ethnicity = race;
	if race = "American Indian/Alaska Native" then race_ethnicity = "Native American/Alaskan Native";
	if race = "Asian - Other/Unknown" then race_ethnicity = "Asian";
	if race = "Asian - Indian" then race_ethnicity = "Asian Indian";
	if index(race,"Pacific Islander") then race_ethnicity = "Pacific Islander";
	if race = "Multiple Races" then race_ethnicity = "Multirace";
	if ethnicity = "Hispanic/Latino" then race_ethnicity = "Hispanic/Latino";
	if (ethnicity = "Unknown" & race_ethnicity ='') then race_ethnicity = "Unknown";
	if index(race_ethnicity,"Asian - ") then race_ethnicity = compress(tranwrd (race_ethnicity,'Asian - ',''));
	else race_ethnicity = tranwrd (race_ethnicity,'Asian - ','');

* Some situations where zip code information ends up in state variable;
	if (notdigit(state) > 6 | notdigit(state) = 0) & length(state) = 5 
		& missing(ZipCode) then ZipCode = state;

* If middle name not missing and first name is, make middle name first name;
if missing (FIRSTNAME) & not missing (middlename) then do;
	firstname = middlename;
	middlename = '';
	end;
middle_name=middlename;

* Abreviate sex variable from full word down to one letter, so as to make 
		compatible with other datasets;
	sex = substr(sex,1,1);

* Occupation is calculated from a number of variables;
OccupationSettingTypeSpecify = put(propcase(OccupationSettingTypeSpecify),$occup.);
OccupationSettingType = put(OccupationSettingType,$occup.);

occupation2 = put(propcase(OccupationSettingTypeSpecify),$occup.);
if missing(strip(occupation2)) | OccupationSettingTypeSpecify = 'Inmate' then occupation2 = OccupationSettingTypeSpecify;
if missing(strip(occupation2)) | OccupationSettingType = 'Inmate' then occupation2 = OccupationSettingType;
if (missing(strip(occupation2)) & occupation ^= "Unknown") | occupation = 'Inmate' then occupation2 = occupation;
OccupationLocation = put(upcase(OccupationLocation),$prison.);
if OccupationLocation in ("CORRECTIONAL TRAINING FACILITY","SALINAS VALLEY STATE PRISON")
	then account_name = OccupationLocation;
if missing(strip(occupation2)) | OccupationLocation = 'Inmate' then occupation2 = OccupationLocation;
if occupation = "Unknown" or occupation = '' then occupation = occupation2;


* Standardize case;
local_health_juris = upcase(HealthJurisdiction);

* Ordering doctor and account name calculated from several variables;
ordering_doctor = upcase(RSName);
	if missing(strip(ordering_doctor)) then ordering_doctor = SubmitterName;
if anydigit(substr(rs_primarylocation,1,1)) = 0 & missing(account_name)
	then account_name = upcase(rs_primarylocation);
if missing (account_name) then account_name = ordering_doctor; 
account_address = upcase(LOC_address);
if missing(account_address) & anydigit(substr(rs_primarylocation,1,1)) = 1 
	then account_address = upcase(rs_primarylocation);
account_city = upcase(loc_CITY);
account_zip_code = loc_zip;

* Extract date part;
date_of_birth=datepart(dob); 
date_of_onset=datepart(DateOfOnset);
date_of_diagnosis=datepart(DateOfDiagnosis);
date_of_death=datepart(DateOfDeath);
episode_date_1=datepart(EpisodeDate);
episode_date_2=datepart(DateCreated);
episode_date_3=datepart(DateReceived);
episode_date_4=datepart(DateSubmitted);

drop dob DateOfOnset DateOfDiagnosis DateOfDeath EpisodeDate DateCreated DateReceived DateSubmitted;

* Clean ssn information - make unknown values blank, remove blanks and dashes, translate into numeric; 
if ssn1 in ("000-00-0000","UNK","000000001","999999999","000-00-0001","999-99-9999") then ssn1 = '';
if ssn1 notin ('','.') then ssn = put(compress (ssn1,"0123456789",'k'),9.);
	else ssn = .;		

* Translate from character to numeric - take only first five chars of zip, and only if all five are numbers;
if (notdigit(zipcode) > 5 | notdigit(strip(zipcode)) = 0) then 
	patient_zip_code = put (substr(zipcode,1,5),8.);

* Rename variables to standardize them with other datasets;
	rename
		LASTNAME = last_name 
		FIRSTNAME = first_name
		StreetAddress = patient_address
		CITY = patient_city	
		censustract = census_tract
		ResolutionStatus = diagnosis;

* Drop unnneeded variables;
drop age Apartment Cellular_Phone___Pager CENSUSBLOCK CLUSTERID CMRNUMBER CountyFIPS CountyOfResidence COUNTRY 
	CountryOfBirth DISEASE DiseaseGroups DisShortName DateAdmitted DateOfArrival DateClosed DateDischarged 
	DateofLabReport DateSent  ExpDeliveryDate ethnicity FinalDisposition HOMEPHONE 
	HOSPITAL IsIndexCase INPATIENT LATITUDE HealthJurisdiction LONGITUDE 
	MedicalRecordNumber namesuffix OccupationLocation OccupationSettingTypeSpecify OccupationSettingType OccupationSettingTypeSpecify occupation2 
	OutbreakNumber OUTBREAKTYPE OUTPATIENT pregnant ProcessStatus PatientDiedofthisIllness PatientHospitalized race  
	ReportedBy LOC_: RS_: RSNAME ssn1 STATE SubmitterName TransmissionStatus WORKPHONE ZipCode id;

* Create result_name and result_value variables using laboratory information available in CalREDIE;
cutoff=input(strip(compress(HEPCLABCRDXTSTANTIHCVCUTRATIO,'>=!;/:<`','a')),8.);
if cutoff>100 then cutoff=.;
format result_name $36. result_value $20. result_comment $200.;
if HEPCLABCRDXTSTHCVRNARSLT='POS' then do;
	result_name='HCV RNA';
	result_value='POS';
	result_comment=HEPCLABCRDXTSTGENOTYPE;
end;
else if HEPCLABCRDXTSTHCVRIBARSLT='POS' then do;
	result_name='RIBA';
	result_value='POS';
end;
else if HEPCLABCRDXTSTANTIHCVTRUPOS='Y' then do;
	result_name='ANTI-HCV HIGH S/CO';
	result_value='POS';
	result_comment='S/CO ='||cutoff;
end;
else if HEPCLABCRDXTSTANTIHCVRSLT='POS' and cutoff>=11 then do;
	result_name='ANTI-HCV HIGH S/CO';
	result_value='POS';
	result_comment='S/CO ='||cutoff;
end;

* include ALT data later when ready to define probable cases;
		drop HEPCLABCRDXTSTANTIHCVRSLT HEPCLABCRDXTSTANTIHCVCUTRATIO HEPCLABCRDXTSTANTIHCVTRUPOS 
HEPCLABCRDXTSTHCVRIBARSLT HEPCLABCRDXTSTHCVRNARSLT HEPCLABCRDXTSTGENOTYPE HEPCLABCRDXTSTOTHANTIHAVIGMRSLT 
HEPCLABCRDXTSTOTHHBSAGRSLT HEPCLABCRDXTSTOTHANTIHBCRSLT HEPCLABCRDXTSTOTHANTIHBCIGMRSLT 
HEPCLABCRDXTSTOTHANTIHBSRSLT DXLVRENZLEVALTSGOTRSLT DXLVRENZLEVALTSGOTUPPER DXLVRENZLEVALTSGPTRSLT 
DXLVRENZLEVALTSGPTUPPER;
run;


* New EpiInfo data;
data set007;
set epiinfo (rename=(ssn=ssn1 occupation=occupation1));

*rename existing variable;
rename	firstname=first_name
 		lastname=last_name
		gender=sex
		dob=date_of_birth
		dtonset=date_of_onset
		dtdiag=date_of_diagnosis
		dtdeath=date_of_death
		facility=account_name
		faddress=account_address
		fcity=account_city
		provider=ordering_doctor
		drec=episode_date_1
		dsubmit=episode_date_2
		lhj=local_health_juris
		address=patient_address
		city=patient_city;

* Create size and type of new variables that will be calculated;
format middle_name $20. ssn 9. race_ethnicity $35. occupation $25. mmwr_year 6. account_zip_code 8. patient_zip_code 8. laboratory $50. diagnosis $20.
	diagnosis2 8. episode_date_3 mmddyy10. episode_date_4 mmddyy10. collection_date mmddyy10. result_date mmddyy10. reporter_type $9. prison $1.
	test_name $45. result_name $36. order_name $41. result_value $20. result_comment $200. patient_id $22. data_source $30. census_tract $10.;
	
informat middle_name $20. ssn 9. race_ethnicity $35. occupation $25. mmwr_year 6. account_zip_code 8. patient_zip_code 8. laboratory $50. diagnosis $20.
	diagnosis2 8. episode_date_3 mmddyy10. episode_date_4 mmddyy10. collection_date mmddyy10. result_date mmddyy10. reporter_type $9. prison $1.
	test_name $45. result_name $36. order_name $41. result_value $20. result_comment $200. patient_id $22. data_source $30. census_tract $10.;

*Exclude non-chronic hep C cases;
if acutechron='A' then delete;

ssn=put(ssn1,9.);

if ethnicity='H' then race_ethnicity='Hispanic/Latino';
else if black='Y' then race_ethnicity='Black/African-American';
else if asian='Y' then race_ethnicity='Asian/Pacific Islander';
else if naan='Y' then race_ethnicity='Native American/Alaskan Native';
else if white='Y' then race_ethnicity='White';
else if orace='Y' then race_ethnicity='Other';
else race_ethnicity='Unknown';

*What do these codes mean?;
if occupation1='C' then occupation='CORRECTIONAL FACILITY';
else if occupation1='F' then occupation='FOOD SERVICE';
else if occupation1='H' then occupation='HEALTH CARE';
else if occupation1='O' then occupation='OTHER';
else if occupation1='S' then occupation='SCHOOL';
if occupation1='O' or occupation1='' and occspec ne '' then occupation=occspec;

patient_zip_code=put(substr(zip,1,5),8.);
patient_zip_code=put(substr(zip,1,5),8.);

if antihcv ne '' then do;
	result_name='ANTI-HCV';
	if antihcv='P' then result_value='POS';
	else if antihcv='N' then result_value='NEG';
end;

if pcrhcv ne '' then do;
	result_name='HCV PCR';
	if pcrhcv='P' then result_value='POS';
	else if pcrhcv='N' then result_value='NEG';
end;

data_source="EPIINFO";

drop fstate acutechron disease hepc ssn1 occupation1 occspec ethnicity black asian naan white orace fzip age antihcv pcrhcv dsource edd exposure expspec
	remarks remarks1 state zip;
run;

