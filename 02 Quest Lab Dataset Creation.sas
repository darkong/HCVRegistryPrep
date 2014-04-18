*=====================================================================;
* Analyst     : Adam Coutts
* Created     : March 8, 2011
* Last Updated:	February 24, 2014 by Erin Murray
* Purpose     : Create a cleaned and ordered dataset of Quest lab data 
                for use in data amalgamation and analysis;
*=====================================================================;

* Create empty template dataset, so as to standardize length of variables - this template dataset will 
		set the standard for the merged dataset for all of those attributes because it will 
		be the first one merged in;

**** Current registry contains Quest data through May 2012;

*set value of year for easy changeing in the future;
%let n=2012; *year for July-December data files;
%let m=2013; *year for January-June data files;

data setquest00;
	attrib PATIENT_FIRST_NAME length = $20. format = $20. informat = $20.;
	attrib PATIENT_LAST_NAME length = $22. format = $22. informat = $22.;
	attrib PATIENT_GENDER length = $12. format = $12. informat = $12.;
	attrib PATIENT_DOB length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib occupation length = $15. format = $15. informat = $15.;
	attrib patient_address1 length = $50. format = $50. informat = $50.;
	attrib patient_address2 length = $50. format = $50. informat = $50.;
	attrib patient_city length = $25. format = $25. informat = $25.;
	attrib patient_zip_code length = 8. format = 8. informat = 8.;
	attrib ACCOUNT_NAME length = $40. format = $40. informat = $40.;
	attrib ACCOUNT_ADDRESS1 length = $40. format = $40. informat = $40.;
	attrib ACCOUNT_ADDRESS2 length = $40. format = $40. informat = $40.;
	attrib ACCOUNT_CITY length = $24. format = $24. informat = $24.;
	attrib ACCOUNT_STATE length = $9. format = $9. informat = $9.;
	attrib ACCOUNT_PHONE length = $20. format = $20. informat = $20.;
	attrib ACCOUNT_ZIP length = $14. format = $14. informat = $14.;
	attrib ACCESSION_NUMBER length = $22. format = $22. informat = $22.;
	attrib DATE_OF_SERVICE length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib COLLECTION_DATE length = 8. format = MMDDYY10. informat = MMDDYY10.;
	attrib ORIGINATING_LAB length = $13. format = $13. informat = $13.;
	attrib ORDER_NAME length = $41. format = $41. informat = $41.;
	attrib RESULT_NAME length = $36. format = $36. informat = $36.;
	attrib RESULT_VALUE length = $20. format = $20. informat = $20.;
	attrib UNITS length = $12. format = $12. informat = $12.;
	attrib RESULT_COMMENT length = $200. format = $200. informat = $200.;
	attrib ORDERING_MD length = $33. format = $33. informat = $33.;
	run;

* Import spreadsheets into SAS datasets - use macro to loop over all nine names of spreadsheets;

%macro repeatedcode;
		accession_number=accession;
		account_name=acctname;
		account_address1=acctaddr1;
		account_address2=acctaddr2;
		account_city=acctcity;
		account_state=acctst;
		account_zip=put(acctzip,$14.);
		account_phone=acctphone;
		patient_first_name=firstname;
		patient_middle_name=middlename;
		patient_last_name=lastname;
		patient_dob=DateOfBirth;
		patient_gender=gender;
		patient_address1=pataddr1;
		patient_address2=pataddr2;
		patient_city=city;
		patient_zip_code=input(compress(zip,'-'),8.);
		date_of_service=dos;
		collection_date=collectiondate;
		originating_lab=labcode;
		ordering_md=refphy;
		order_name=ordername;
		result_name=resultname;
		result_value=resultvaluelit;
		result_comment=resultcomment;
	drop accession acctaddr1 acctaddr2 acctcity acctname acctphone acctst acctzip collectiondate dos dateofbirth firstname gender labcode lastname middlename
		pataddr1 pataddr2 city zip labcode ordername refphy resultcomment resultname resultvaluelit;
	if a then delete;
%mend;

*Bring in new data;
%Macro JulDecData;
	proc import datafile = 
	  "&directory.Quest and Foundation Lab Reports\Lab Data\Quest Data, 2010 - Present\&n.\Final_CADOH_HCV&mth&n..xls" 
	   dbms = xls out = setquest&mth.test&n replace;
	   run;

	proc import datafile = 
	  "&directory.Quest and Foundation Lab Reports\Lab Data\Quest Data, 2010 - Present\&n.\Final_CADOH_HCV_Signal&mth&n..xls" 
	   dbms = xls out = setquest&mth.sco&n replace;
	   run;

	data setquest&mth&n;
	set setquest00 (in=a) setquest&mth.test&n (drop=abnflg acctno age loinc localordercode localprofilecode npi perflab phone profilename refrangealpha refrangehigh 
			refrangelow resultcode st stdordercode stdprofilecode upin)
		setquest&mth.sco&n (drop=abnflg acctno age loinc localordercode localprofilecode npi perflab phone profilename refrangealpha refrangehigh 
			refrangelow resultcode st stdordercode stdprofilecode upin);
	%repeatedcode;
	run;
%Mend;

%Macro JanJunData;
	proc import datafile = 
	  "&directory.Quest and Foundation Lab Reports\Lab Data\Quest Data, 2010 - Present\&m.\Final_CADOH_HCV&mth&m..xls" 
	   dbms = xls out = setquest&mth.test&m replace;
	   run;

	proc import datafile = 
	  "&directory.Quest and Foundation Lab Reports\Lab Data\Quest Data, 2010 - Present\&m.\Final_CADOH_HCV_Signal&mth&m..xls" 
	   dbms = xls out = setquest&mth.sco&m replace;
	   run;

	data setquest&mth&m;
	set setquest00 (in=a) setquest&mth.test&m (drop=abnflg acctno age loinc localordercode localprofilecode npi perflab phone profilename refrangealpha refrangehigh 
			refrangelow resultcode st stdordercode stdprofilecode upin)
		setquest&mth.sco&m (drop=abnflg acctno age loinc localordercode localprofilecode npi perflab phone profilename refrangealpha refrangehigh 
			refrangelow resultcode st stdordercode stdprofilecode upin);
	%repeatedcode;
	run;
%Mend;

%let mth=Jul;
%JulDecData;
%let mth=Aug;
%JulDecData;
%let mth=Sep;
%JulDecData;
%let mth=Oct;
%JulDecData;
%let mth=Nov;
%JulDecData;
%let mth=Dec;
%JulDecData;
%let mth=Jan;
%JanJunData;
%let mth=Feb;
%JanJunData;
%let mth=Mar;
%JanJunData;
%let mth=Apr;
%JanJunData;
%let mth=May;
%JanJunData;
%let mth=Jun;
%JanJunData;


* Combine all datasets into one;

data setquest10;
	set setquest00 (in=a) setquestJan&m setquestFeb&m setquestMar&m setquestApr&m setquestMay&m setquestJun&m 
		setquestJul&n setquestAug&n setquestSep&n setquestOct&n setquestNov&n setquestDec&n;

* Drop cases that have missing values for all variables - use an array to loop through all numeric and character
	variables, and count how many are not missing - if all are missing, then delete the case;

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



data questset;
	set setquest10;

* New variables;
	attrib account_zip_full length = $10. format = $10. informat = $10.;
	informat account_zip_code 8. account_address $80. patient_address $80. TEST_NAME $45. ssn 8.;
 
* Clean up, standardize, group together Order and Record data values;

	ORDER_NAME = put(ORDER_NAME,$testname.); 
	RESULT_NAME = put(RESULT_NAME,$testname.);
	ORDER_NAME = translate (ORDER_NAME,'',',');
	ORDER_NAME = tranwrd (ORDER_NAME,'Hepatitis','HEP');
	ORDER_NAME = tranwrd (ORDER_NAME,'HEPATITIS','HEP');
	ORDER_NAME = tranwrd (ORDER_NAME,'HEP C','HCV');
	ORDER_NAME = tranwrd (ORDER_NAME,'HCV VIRUS','HCV');
	ORDER_NAME = tranwrd (ORDER_NAME,'HCV VIRAL','HCV');
	ORDER_NAME = tranwrd (ORDER_NAME,'HEPTIMAX(','HEPTIMAX (');
	ORDER_NAME = tranwrd (ORDER_NAME,'QUALITATIVE','QUAL');
	ORDER_NAME = tranwrd (ORDER_NAME,'QUANTITATIVE','QUANT');
	ORDER_NAME = tranwrd (ORDER_NAME,'QUANTITAT','QUANT');
	ORDER_NAME = tranwrd (ORDER_NAME,'QUANTITA','QUANT'); 
	ORDER_NAME = tranwrd (ORDER_NAME,' QN ',' QUANT ');
	ORDER_NAME = tranwrd (ORDER_NAME,' QT ',' QUANT ');
	ORDER_NAME = tranwrd (ORDER_NAME,' QNT ',' QUANT ');
	ORDER_NAME = tranwrd (ORDER_NAME,' QL ',' QUAL ');
	ORDER_NAME = tranwrd (ORDER_NAME,' pnl ',' PANEL ');
	ORDER_NAME = tranwrd (ORDER_NAME,'Panel','PANEL');
	ORDER_NAME = tranwrd (ORDER_NAME,'ANTIBODY','AB');
	ORDER_NAME = tranwrd (ORDER_NAME,' Ab',' AB');
	ORDER_NAME = tranwrd (ORDER_NAME,'RFLEX','RFLX');
	ORDER_NAME = tranwrd (ORDER_NAME,'REFLEX','RFLX');
	ORDER_NAME = tranwrd (ORDER_NAME,'RFX','RFLX');
	ORDER_NAME = tranwrd (ORDER_NAME,'Rfx','RFLX');
	ORDER_NAME = tranwrd (ORDER_NAME,'Rfl ','RFLX ');
	ORDER_NAME = tranwrd (ORDER_NAME,'Rflx','RFLX');
	ORDER_NAME = tranwrd (ORDER_NAME,'rfl ','RFLX ');
	ORDER_NAME = tranwrd (ORDER_NAME,'RFL ','RFLX ');
	ORDER_NAME = tranwrd (ORDER_NAME,'REFLX','RFLX ');
	ORDER_NAME = tranwrd (ORDER_NAME,'REFL','RFLX ');
	ORDER_NAME = tranwrd (ORDER_NAME,'BDNA','bDNA');
	ORDER_NAME = tranwrd (ORDER_NAME,'LiPA','LIPA');
	ORDER_NAME = tranwrd (ORDER_NAME,'  ',' ');
	ORDER_NAME = tranwrd (ORDER_NAME,' )',')');
	if ORDER_NAME = 'CMP/GGT/FE+IBC/PT/PTT/FERR/ANA' then
		ORDER_NAME = RESULT_NAME;

	if RESULT_NAME in ('c22p','c33c') then RESULT_NAME = upcase (RESULT_NAME);
	if RESULT_NAME = "HCV RNA" & ORDER_NAME = "HEPTIMAX (TM) HCV RNA" then 
		RESULT_NAME = "HEPTIMAX (TM) HCV RNA";
	if (ORDER_NAME = "HEP C GENO/HCV RNA/ANTI HCV RI" & RESULT_NAME = "HCV RNA QUANT REAL-TIME PCR")
		then ORDER_NAME = "HCV RNA QUANT REAL-TIME PCR";
		else if ORDER_NAME = "HEP C GENO/HCV RNA/ANTI HCV RI" then 
			ORDER_NAME = "HCV AB w/RFLX to RIBA";

* Drop cases where we were sent information for non-HCV tests;

if ORDER_NAME in ('HIV 1/2 EIA AB SCREEN W/RFLX','HIV 1/HIV 2 WESTERN BLOT/IMMUN','HTLV I/II AB W/RFLX TO WB',
	'HCV FIBROSURE - LABCORP','DONOR RPR','CBC W/DIFF BSAG HCV','COMP MET/LIPID/HEP B AB/HEP B','DONOR HIV 1/HBV/HCV/NAT PROCLEIX(R) W/R',
	'HEPATIC/CBC W/MANUAL DIFF','HEPATIC/LIPID/CBC W/MANUAL DIF') | RESULT_NAME in 
	('WESTERN BLOT','P24','VIRAL BANDS OBSERVED','DONOR, RPR','P19','P26','P28','P32','P36','DONOR, HIV 1/HBV/HCV/NAT PROCLEIX(R)')
	then delete; 

IF index(order_name,'HCV')=0 and index(order_name,'HEP')=0 and index(result_name,'HCV')=0 and index(result_name,'HEP')=0 
	and result_name ne 'Signal to Cutoff Ratio' then delete;

* Create TEST_NAME variable - for merging into single variable with Foundation TEST_NAME variable;

if (ORDER_NAME = RESULT_NAME) | (ORDER_NAME in ('HCV AB', 'HCV AB w/RFLX to RIBA', 'HCV RNA QUANT REAL-TIME PCR', 
'HCV RNA QUANT TMA', 'HCV RNA QUANT bDNA', 'HCV QUANT REAL-TIME PCR w/RFLX QUAL TMA', 'HCV RNA QUANT bDNA w/RFLX TMA', 
'HCV RNA QUANT PCR w/RFLX GENOTYPE LIPA', 'HCV RNA QUAL PCR', 'HCV RNA QUAL TMA', 
'HCV RNA QUAL PCR w/RFLX REAL-TIME PCR', 'HCV GENOTYPE LIPA', 'HEPTIMAX (R) HCV RNA'))
		then TEST_NAME = ORDER_NAME;

* Result name takes precidence over test name - result correlates more closely with a single test value,
		while order name (when reflex is present) can correlate with more than one result;

if (RESULT_NAME in ('HCV RNA QUANT REAL-TIME PCR', 'HCV RNA QUANT bDNA', 'HEPTIMAX (TM) HCV RNA',
	'HCV RNA QUANT TMA', 'HCV GENOTYPE LIPA', 'HCV RNA QUAL PCR', 'HCV RNA QUAL TMA'))
	then TEST_NAME = RESULT_NAME;

* Stanardize values for units variables;
units = put(units,$units.); 


* Create one variable with nine digit zip code (if full nine digits are available, just five if not - and with 
	dash inserted between first five digits and last four of the nine, if it's not already) and another 
	variable with just five digit zip;

	account_zip = strip (account_zip);
	if (length (account_zip) = 9 & index (account_zip,'-') = 0) then
		account_zip_full = cats (substr(account_zip,1,5),'-',substr(account_zip,6,4));
		else account_zip_full = account_zip;

	account_zip_code = input (substr(account_zip_full,1,5),5.);

* Combine account_address1 and account_address2 variables into one;

	account_address = catx (' ',account_address1,account_address2);

* Clean up and standardize MD names for client name;

	account_name = tranwrd (account_name,'M. D.','MD');
	account_name = tranwrd (account_name,'M.D.','MD');
	account_name = tranwrd (account_name,', MD',' MD');
	account_name = tranwrd (account_name,',MD',' MD');

* Change [Last Name, First Name] to [First Name Last Name] for MDs;

	if find (account_name,' MD') > 0 & findc (account_name,',') > 0 then do;
		account_name = tranwrd (account_name,' MD','');
		name_1 = substr(account_name,1,(findc (account_name,',') - 1));
		name_2 = substr(account_name,(findc (account_name,',') + 1 ));
		account_name = catx (' ',name_2,name_1,'MD');
		end;

* Strip out 'attn' from account_address; 

	if substr (account_address,1,5) = "ATTN:" then 
		account_address = strip(substr(account_address,6));
	if substr (account_address,1,4) = "ATTN" then 
		account_address = strip(substr(account_address,5));

* Standardize case in result name comment variable;
	RESULT_COMMENT = upcase (RESULT_COMMENT);

* The Quest lab in San Jose seems at times to have given itself as account address - if so, then delete this data;
	if (account_name = "REFERRING PHYS" and account_address = "SAN JOSE, CA 95133" & account_city = "" &
		account_zip_code = .) then do; 
		account_name = ordering_md; 
		account_address = "";
		end;

* Delete empty 'TEST' cases;
	if upcase(PATIENT_FIRST_NAME) = "TEST" & upcase(PATIENT_last_name) = "TEST" then delete;

* Combine patient_address1 and patient_address2 variables into one;

	patient_address = catx (' ',patient_address1,patient_address2);

* Drop unneeded variables;
	drop account_zip account_address1 account_address2 name_1 name_2 patient_address1 patient_address2; 
run;
