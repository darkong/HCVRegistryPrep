*Assign year to macro variable for easy changing from year to year;
%let n=2011; *year for July-December data files;
%let m=2012; *year for January-June data files;

*Import Case Data;
%Macro JulDecimportcases;
PROC IMPORT OUT= WORK.CALREDIECASES&mth&n 
            DATATABLE= "Disease Incident Export" 
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&n Hep C Data\CalREDIE &mth&n..mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;
%Mend;

%Macro JanJunimportcases;
PROC IMPORT OUT= WORK.CALREDIECASES&mth&m 
            DATATABLE= "Disease Incident Export" 
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&m Hep C Data\CalREDIE &mth&m..mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;
%Mend;


*Import Lab Data; *** NEED to change table names in Access to match those marked below because some of them are too long as exported from CalREDIE ***;
%Macro JulDecimportlabdata;
PROC IMPORT OUT= WORK.CALREDIELabLiv&mth&n 
            DATATABLE= "LIVER ENZYME LEVELS AT DIAGNOSIS" 
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&n Hep C Data\CalREDIE &mth&n._Lab.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= WORK.CALREDIELabOth&mth&n 
            DATATABLE= "OTHER VIRAL HEPATITIS DIAGNOST" /*Changed from original table name because it was too long*/
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&n Hep C Data\CalREDIE &mth&n._Lab.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= WORK.CALREDIELabDiag&mth&n 
            DATATABLE= "VIRAL HEPATITIS C DIAGNOST" /*Changed from original table name because it was too long*/
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&n Hep C Data\CalREDIE &mth&n._Lab.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

proc sort data=CALREDIELabLiv&mth&n;
by DiseaseIncidentID;
run;

proc sort data=CALREDIELabOth&mth&n;
by DiseaseIncidentID;
run;

proc sort data=CALREDIELabDiag&mth&n;
by DiseaseIncidentID;
run;

data CALREDIELab&mth&n;
merge CALREDIELabLiv&mth&n CALREDIELabOth&mth&n CALREDIELabDiag&mth&n;
by DiseaseIncidentID;
run;
%Mend;

%Macro JanJunimportlabdata;
PROC IMPORT OUT= WORK.CALREDIELabLiv&mth&m 
            DATATABLE= "LIVER ENZYME LEVELS AT DIAGNOSIS" 
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&m Hep C Data\CalREDIE &mth&m._Lab.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= WORK.CALREDIELabOth&mth&m 
            DATATABLE= "OTHER VIRAL HEPATITIS DIAGNOST" /*Changed from original table name because it was too long*/
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&m Hep C Data\CalREDIE &mth&m._Lab.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= WORK.CALREDIELabDiag&mth&m 
            DATATABLE= "VIRAL HEPATITIS C DIAGNOST" /*Changed from original table name because it was too long*/
            DBMS=ACCESS REPLACE;
     DATABASE="&directory.CalREDIE\&m Hep C Data\CalREDIE &mth&m._Lab.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;

proc sort data=CALREDIELabLiv&mth&m;
by DiseaseIncidentID;
run;

proc sort data=CALREDIELabOth&mth&m;
by DiseaseIncidentID;
run;

proc sort data=CALREDIELabDiag&mth&m;
by DiseaseIncidentID;
run;

data CALREDIELab&mth&m;
merge CALREDIELabLiv&mth&m CALREDIELabOth&mth&m CALREDIELabDiag&mth&m;
by DiseaseIncidentID;
run;
%Mend;

%let mth=Jan;
%JanJunimportcases;
%JanJunimportlabdata;
%let mth=Feb;
%JanJunimportcases;
%JanJunimportlabdata;
%let mth=Mar;
%JanJunimportcases;
%JanJunimportlabdata;
%let mth=Apr;
%JanJunimportcases;
%JanJunimportlabdata;
%let mth=May;
%JanJunimportcases;
%JanJunimportlabdata;
%let mth=Jun;
%JanJunimportcases;
%JanJunimportlabdata;
%let mth=Jul;
%JulDecimportcases;
%JulDecimportlabdata;
%let mth=Aug;
%JulDecimportcases;
%JulDecimportlabdata;
%let mth=Sep;
%JulDecimportcases;
%JulDecimportlabdata;
%let mth=Oct;
%JulDecimportcases;
%JulDecimportlabdata;
%let mth=Nov;
%JulDecimportcases;
%JulDecimportlabdata;
%let mth=Dec;
%JulDecimportcases;
%JulDecimportlabdata;

data calrediecases;
set CALREDIECASESJan&m CALREDIECASESFeb&m CALREDIECASESMar&m CALREDIECASESApr&m CALREDIECASESMay&m CALREDIECASESJun&m
	CALREDIECASESJul&n CALREDIECASESAug&n CALREDIECASESSep&n CALREDIECASESOct&n CALREDIECASESNov&n CALREDIECASESDec&n;
run;

proc sort data=CALREDIECASES;
by id;
run;

data calredielab;
set CALREDIELabJan&m CALREDIELabFeb&m CALREDIELabMar&m CALREDIELabApr&m CALREDIELabMay&m CALREDIELabJun&m
	CALREDIELabJul&n CALREDIELabAug&n CALREDIELabSep&n CALREDIELabOct&n CALREDIELabNov&n CALREDIELabDec&n;
id=input(DiseaseIncidentID,8.);
drop DiseaseIncidentID;
run;

proc sort data=calredielab;
by id;
run;

*Import provider information - needs updated each time this program is run to incorporate any new providers added to CalREDIE;
PROC IMPORT OUT= WORK.ProvData 
            DATAFILE= "&directory.CalREDIE\&m Hep C Data\HepC-IZB.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="IZB_Export$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data provdata1;
set provdata;
where mdy(4,2,2012)<=dtcreate<=mdy(6,30,2012);
run;

proc sort data=provdata1 (keep=incidentid rsname rslocation rslocation rsaddress rscity rszipcode);
by incidentid;
run;

*Merge lab data with case data;
data calredie1;
merge CalREDIECases (in=a) CalREDIELab;
by id;
if a;
run;

proc sort data=calredie1;
by ID;
run;

*Merge case and lab data with provider information;
data calredie;
merge calredie1 (in=a) provdata1 (rename=(incidentid=id));
by id;
if a;
rename	rslocation=rs_primarylocation
		rsaddress=loc_address
		rscity=loc_city
		rszipcode=loc_zip;
drop AdditionalLaboratory AdditionalProvider AddressStandardized AgeInYears Asymptomatic CensusTractFromDI Closed_by_LHDDate Closed_by_StateDate CompleteAddress
	Contact_Investigation_CompletedD Contact_Lab_Specimen_ClearedDate Contact_Lost_to_Follow_upDate Contact_Moved__out_of_jurisdicti 
	Contact_Not_Investigated_No_Foll Contact_Pending_ClearanceDate Contact_Turned_to_IncidentDate Contact_Under_InvestigationDate Count County CreatedBy
	DateLastEdited Doctor DoctorAddress DoctorPhone DXLVRENZLEVALTSGOTDT DXLVRENZLEVALTSGPTDT DXLVRENZLEVBILIRUBINDT DXLVRENZLEVBILIRUBINRSLT EnteredDate
	Field_Record_CompleteDate Field_Record_OpenDate HealthJurisdictionNumber HepatitisStatus HEPCLABCRDXTSTANTIHCVDT HEPCLABCRDXTSTHCVRIBADT
	HEPCLABCRDXTSTHCVRNADT HEPCLABCRDXTSTOTHANTIHAVDT HEPCLABCRDXTSTOTHANTIHAVIGMDT HEPCLABCRDXTSTOTHANTIHAVRSLT HEPCLABCRDXTSTOTHANTIHBCDT
	HEPCLABCRDXTSTOTHANTIHBCIGMDT HEPCLABCRDXTSTOTHANTIHBSDT HEPCLABCRDXTSTOTHANTIHDVDT HEPCLABCRDXTSTOTHANTIHDVRSLT /*HEPCLABCRDXTSTOTHANTIHEVDT*/ 
	HEPCLABCRDXTSTOTHANTIHEVRSLT HEPCLABCRDXTSTOTHHBSAGDT HospitalDR ImportedStatus In_LHD_Review__2Date In_LHD_ReviewDate In_State_ReviewDate LabReportNotes
	LabReportTestName LastCDCUpdate MaritalStatus MostRecentLabResult MostRecentLabResultValue Need_Additional_Info_Re_Intervie Notes NurseInvestigator
	OccupationSpecify Other__Specify ParentPerson Pending_Release_ClearanceDate PrimaryLanguage Result Returned_to_LHDDate SecondaryJurisdiction 
	SpecimenCollectedDate SpecimenNotes SpecimenReceivedDate Status_Date Status_Repeated TimeSubmitted TransStatus Under_InvestigationDate ZIPPlus4;
run;

proc sort data=calredie nodup;
by id;
run;
