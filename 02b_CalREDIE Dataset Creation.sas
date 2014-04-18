*Assign year to macro variable for easy changing from year to year;
%let y1=2012; *year for July-December data files;
%let m1=Jul;*months for July-December data files;
%let y2=2013; *year for January-June data files;
%let m2=Jun; *months for January-June data files;

filename in  "&directory.CalREDIE\&y1-&y2 Hep C Data\HCVCalREDIE&m1&y1&m2&y2..tsv";

data WORK.calredie    ;
infile IN delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2 ;
		 informat IncidentID best32. ;
		 informat CMRNumber best32. ;
         informat Disease $20. ;
         informat DisShort $8. ;
         informat DiseaseGrp $99. ;
         informat PersonId best32. ;
         informat LastName $10. ;
         informat FirstName $8. ;
         informat MiddleName $1. ;
         informat NameSuffix $1. ;
         informat SSN $11. ;
         informat DOB mmddyy10. ;
         informat Age best32. ;
         informat Ethnicity $23. ;
         informat Race $7. ;
         informat RaceAIAN $1. ;
         informat RaceASIAN $5. ;
         informat RaceBLACK $1. ;
         informat RaceNHPI $1. ;
         informat RaceOTHER $1. ;
         informat RaceWHITE $5. ;
         informat RaceUNK $3. ;
         informat Language $13. ;
         informat Address $20. ;
         informat AptNo $20. ;
         informat City $13. ;
         informat State $2. ;
         informat Zip $5. ;
         informat CTract $6. ;
         informat CensusBlock $4. ;
         informat Latitude $9. ;
         informat Longitude $11. ;
         informat CntyOfResid $15. ;
         informat CntyFIPS $5. ;
         informat CntyGEO $15. ;
         informat Country $13. ;
         informat CountryBirth $13. ;
         informat DtArrival $1. ;
         informat HomePhone $12. ;
         informat CellPhone $12. ;
         informat WorkPhone $12. ;
         informat Email $1. ;
         informat OtherElectronicID $1. ;
         informat Sex $1. ;
         informat GenderSpM $1. ;
         informat GenderSpF $1. ;
         informat GenderSpMTF $1. ;
         informat GenderSpFTM $1. ;
         informat GenderSpREF $1. ;
         informat GenderSpUNK $1. ;
         informat Pregnant $1. ;
         informat EDD $1. ;
         informat Marital $1. ;
         informat MRN $10. ;
         informat Guardian $1. ;
         informat OccSettingType $1. ;
         informat OccSettingSpec $7. ;
         informat Occupation $18. ;
         informat OccSpecify $7. ;
         informat OccLocation $7. ;
         informat LHJ $15. ;
         informat LHJNumber best32. ;
         informat Region $8. ;
         informat SecondLHJ $7. ;
         informat Investigator $21. ;
         informat RSName $53. ;
         informat RSLocation $41. ;
         informat RSLocType $46. ;
         informat RSClass $11. ;
         informat RSAddress $28. ;
         informat RSCity $13. ;
         informat RSState $2. ;
         informat RSZipCode best32. ;
         informat RSPhone $12. ;
         informat Submitter $16. ;
         informat Laboratory $50. ;
         informat LabCity $14. ;
         informat LabState $2. ;
         informat ClusterID $1. ;
         informat OutbreakNum $1. ;
         informat OutbreakType $1. ;
         informat IndexCase $1. ;
         informat PtDiedIllness $1. ;
         informat PtHospitalized $1. ;
         informat InPatient $1. ;
         informat OutPatient $1. ;
         informat Hospital $1. ;
         informat Symptomatic $1. ;
         informat DtOnset mmddyy10. ;
         informat DtLabCollect mmddyy10. ;
         informat DtLabResult mmddyy10. ;
         informat DtDiagnosis mmddyy10. ;
         informat DtDeath mmddyy10. ;
         informat DtReceived mmddyy10. ;
         informat DtCreate mmddyy10. ;
         informat DtEpisode mmddyy10. ;
         informat DtClosed mmddyy10. ;
         informat DtSent mmddyy10. ;
         informat DtAdmit mmddyy10. ;
         informat DtDischarge mmddyy10. ;
         informat PStatus $13. ;
         informat RPTBy $11. ;
         informat IStatus $7. ;
         informat RStatus $19. ;
         informat FinalDispo $19. ;
         informat TStatus $1. ;
         informat DtSubmit mmddyy10. ;
         informat DtRptBy mmddyy10. ;
         informat DtLabRpt mmddyy10. ;
         informat Exposure $1. ;
         informat NOTES $824. ;
         informat DtLastEdit mmddyy10. ;
         informat HEPCLABCRDXTSTANTIHCVDT mmddyy10. ;
         informat HEPCLABCRDXTSTANTIHCVRSLT $3. ;
         informat HEPCLABCRDXTSTANTIHCVCUTRATIO $6. ;
         informat HEPCLABCRDXTSTANTIHCVTRUPOS $1. ;
         informat HEPCLABCRDXTSTHCVRNADT mmddyy10. ;
         informat HEPCLABCRDXTSTHCVRNARSLT $3. ;
         informat HEPCLABCRDXTSTHCVRIBADT mmddyy10. ;
         informat HEPCLABCRDXTSTHCVRIBARSLT $3. ;
         informat HEPCLABCRDXTSTGENOTYPE $8. ;
         informat HEPCLABCRDXTSTOTHANTIHAVIGMDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHAVIGMRSLT $3. ;
         informat HEPCLABCRDXTSTOTHANTIHAVDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHAVRSLT $3. ;
         informat HEPCLABCRDXTSTOTHHBVDNADate mmddyy10. ;
         informat HEPCLABCRDXTSTOTHHBVDNAQUALRES $7. ;
         informat HEPCLABCRDXTSTOTHHBVDNAQUALDATE mmddyy10. ;
         informat HEPCLABCRDXTSTOTHHBVDNARes $8. ;
         informat HEPCLABCRDXTSTOTHHBeAgDate mmddyy10. ;
         informat HEPCLABCRDXTSTOTHHBeAgRes $4. ;
         informat HEPCLABCRDXTSTOTHHBSAGDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHHBSAGRSLT $3. ;
         informat HEPCLABCRDXTSTOTHANTIHBCIGMDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHBCIGMRSLT $3. ;
         informat HEPCLABCRDXTSTOTHANTIHBSDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHBSRSLT $3. ;
         informat HEPCLABCRDXTSTOTHANTIHBCDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHBCRSLT $3. ;
         informat HEPCLABCRDXTSTOTHANTIHDVDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHDVRSLT $3. ;
         informat HEPCLABCRDXTSTOTHANTIHEVDT mmddyy10. ;
         informat HEPCLABCRDXTSTOTHANTIHEVRSLT $3. ;
         informat DXLVRENZLEVALTSGPTDT mmddyy10. ;
         informat DXLVRENZLEVALTSGPTRSLT $8. ;
         informat DXLVRENZLEVALTSGPTUPPER $8. ;
         informat DXLVRENZLEVALTSGOTDT mmddyy10. ;
         informat DXLVRENZLEVALTSGOTRSLT $8. ;
         informat DXLVRENZLEVALTSGOTUPPER $8. ;
         informat DXLVRENZLEVBILIRUBINDT mmddyy10. ;
         informat DXLVRENZLEVBILIRUBINRSLT $8. ;
         format IncidentID best12. ;
         format CMRNumber best12. ;
         format Disease $20. ;
         format DisShort $8. ;
         format DiseaseGrp $99. ;
         format PersonId best12. ;
         format LastName $10. ;
         format FirstName $8. ;
         format MiddleName $1. ;
         format NameSuffix $1. ;
         format SSN $11. ;
         format DOB mmddyy10. ;
         format Age best12. ;
         format Ethnicity $23. ;
         format Race $7. ;
         format RaceAIAN $1. ;
         format RaceASIAN $5. ;
         format RaceBLACK $1. ;
         format RaceNHPI $1. ;
         format RaceOTHER $1. ;
         format RaceWHITE $5. ;
         format RaceUNK $3. ;
         format Language $13. ;
         format Address $20. ;
         format AptNo $20. ;
         format City $13. ;
         format State $2. ;
         format Zip $5. ;
         format CTract $6. ;
         format CensusBlock $4. ;
         format Latitude $9. ;
         format Longitude $11. ;
         format CntyOfResid $15. ;
         format CntyFIPS $5. ;
         format CntyGEO $15. ;
         format Country $13. ;
         format CountryBirth $13. ;
         format DtArrival $1. ;
         format HomePhone $12. ;
         format CellPhone $12. ;
         format WorkPhone $12. ;
         format Email $1. ;
         format OtherElectronicID $1. ;
         format Sex $1. ;
         format GenderSpM $1. ;
         format GenderSpF $1. ;
         format GenderSpMTF $1. ;
         format GenderSpFTM $1. ;
         format GenderSpREF $1. ;
         format GenderSpUNK $1. ;
         format Pregnant $1. ;
         format EDD $1. ;
         format Marital $1. ;
         format MRN $10. ;
         format Guardian $1. ;
         format OccSettingType $1. ;
         format OccSettingSpec $7. ;
         format Occupation $18. ;
         format OccSpecify $7. ;
         format OccLocation $7. ;
         format LHJ $15. ;
         format LHJNumber best12. ;
         format Region $8. ;
         format SecondLHJ $7. ;
         format Investigator $21. ;
         format RSName $53. ;
         format RSLocation $41. ;
         format RSLocType $46. ;
         format RSClass $11. ;
         format RSAddress $28. ;
         format RSCity $13. ;
         format RSState $2. ;
         format RSZipCode best12. ;
         format RSPhone $12. ;
         format Submitter $16. ;
         format Laboratory $50. ;
         format LabCity $14. ;
         format LabState $2. ;
         format ClusterID $1. ;
         format OutbreakNum $1. ;
         format OutbreakType $1. ;
         format IndexCase $1. ;
         format PtDiedIllness $1. ;
         format PtHospitalized $1. ;
         format InPatient $1. ;
         format OutPatient $1. ;
         format Hospital $1. ;
         format Symptomatic $1. ;
         format DtOnset mmddyy10. ;
         format DtLabCollect mmddyy10. ;
         format DtLabResult mmddyy10. ;
         format DtDiagnosis mmddyy10. ;
         format DtDeath mmddyy10. ;
         format DtReceived mmddyy10. ;
         format DtCreate mmddyy10. ;
         format DtEpisode mmddyy10. ;
         format DtClosed mmddyy10. ;
         format DtSent mmddyy10. ;
         format DtAdmit mmddyy10. ;
         format DtDischarge mmddyy10. ;
         format PStatus $13. ;
         format RPTBy $11. ;
         format IStatus $7. ;
         format RStatus $19. ;
         format FinalDispo $19. ;
         format TStatus $1. ;
         format DtSubmit mmddyy10. ;
         format DtRptBy mmddyy10. ;
         format DtLabRpt mmddyy10. ;
         format Exposure $1. ;
         format NOTES $824. ;
         format DtLastEdit mmddyy10. ;
         format HEPCLABCRDXTSTANTIHCVDT mmddyy10. ;
         format HEPCLABCRDXTSTANTIHCVRSLT $3. ;
         format HEPCLABCRDXTSTANTIHCVCUTRATIO $6. ;
         format HEPCLABCRDXTSTANTIHCVTRUPOS $1. ;
         format HEPCLABCRDXTSTHCVRNADT mmddyy10. ;
         format HEPCLABCRDXTSTHCVRNARSLT $3. ;
         format HEPCLABCRDXTSTHCVRIBADT mmddyy10. ;
         format HEPCLABCRDXTSTHCVRIBARSLT $3. ;
         format HEPCLABCRDXTSTGENOTYPE $8. ;
         format HEPCLABCRDXTSTOTHANTIHAVIGMDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHAVIGMRSLT $3. ;
         format HEPCLABCRDXTSTOTHANTIHAVDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHAVRSLT $3. ;
         format HEPCLABCRDXTSTOTHHBVDNADate mmddyy10. ;
         format HEPCLABCRDXTSTOTHHBVDNAQUALRES $7. ;
         format HEPCLABCRDXTSTOTHHBVDNAQUALDATE mmddyy10. ;
         format HEPCLABCRDXTSTOTHHBVDNARes $8. ;
         format HEPCLABCRDXTSTOTHHBeAgDate mmddyy10. ;
         format HEPCLABCRDXTSTOTHHBeAgRes $4. ;
         format HEPCLABCRDXTSTOTHHBSAGDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHHBSAGRSLT $3. ;
         format HEPCLABCRDXTSTOTHANTIHBCIGMDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHBCIGMRSLT $3. ;
         format HEPCLABCRDXTSTOTHANTIHBSDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHBSRSLT $3. ;
         format HEPCLABCRDXTSTOTHANTIHBCDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHBCRSLT $3. ;
         format HEPCLABCRDXTSTOTHANTIHDVDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHDVRSLT $3. ;
         format HEPCLABCRDXTSTOTHANTIHEVDT mmddyy10. ;
         format HEPCLABCRDXTSTOTHANTIHEVRSLT $3. ;
         format DXLVRENZLEVALTSGPTDT mmddyy10. ;
         format DXLVRENZLEVALTSGPTRSLT $12. ;
         format DXLVRENZLEVALTSGPTUPPER $12. ;
         format DXLVRENZLEVALTSGOTDT mmddyy10. ;
         format DXLVRENZLEVALTSGOTRSLT $12. ;
         format DXLVRENZLEVALTSGOTUPPER $12. ;
         format DXLVRENZLEVBILIRUBINDT mmddyy10. ;
         format DXLVRENZLEVBILIRUBINRSLT $12. ;
      input
                  IncidentID
                  CMRNumber
                  Disease $
                  DisShort $
                  DiseaseGrp $
                  PersonId
                  LastName $
                  FirstName $
                  MiddleName $
                  NameSuffix $
                  SSN $
                  DOB
                  Age
                  Ethnicity $
                  Race $
                  RaceAIAN $
                  RaceASIAN $
                  RaceBLACK $
                  RaceNHPI $
                  RaceOTHER $
                  RaceWHITE $
                  RaceUNK $
                  Language $
                  Address $
                  AptNo $
                  City $
                  State $
                  Zip $
                  CTract $
                  CensusBlock $
                  Latitude $
                  Longitude $
                  CntyOfResid $
                  CntyFIPS $
                  CntyGEO $
                  Country $
                  CountryBirth $
                  DtArrival $
                  HomePhone $
                  CellPhone $
                  WorkPhone $
                  Email $
                  OtherElectronicID $
                  Sex $
                  GenderSpM $
                  GenderSpF $
                  GenderSpMTF $
                  GenderSpFTM $
                  GenderSpREF $
                  GenderSpUNK $
                  Pregnant $
                  EDD $
                  Marital $
                  MRN $
                  Guardian $
                  OccSettingType $
                  OccSettingSpec $
                  Occupation $
                  OccSpecify $
                  OccLocation $
                  LHJ $
                  LHJNumber
                  Region $
                  SecondLHJ $
                  Investigator $
                  RSName $
                  RSLocation $
                  RSLocType $
                  RSClass $
                  RSAddress $
                  RSCity $
                  RSState $
                  RSZipCode
                  RSPhone $
                  Submitter $
                  Laboratory $
                  LabCity $
                  LabState $
                  ClusterID $
                  OutbreakNum $
                  OutbreakType $
                  IndexCase $
                  PtDiedIllness $
                  PtHospitalized $
                  InPatient $
                  OutPatient $
                  Hospital $
                  Symptomatic $
                  DtOnset
                  DtLabCollect
                  DtLabResult
                  DtDiagnosis
                  DtDeath 
                  DtReceived
                  DtCreate
                  DtEpisode
                  DtClosed
                  DtSent 
                  DtAdmit 
                  DtDischarge 
                  PStatus $
                  RPTBy $
                  IStatus $
                  RStatus $
                  FinalDispo $
                  TStatus $
                  DtSubmit
                  DtRptBy
                  DtLabRpt
                  Exposure $
                  NOTES $
                  DtLastEdit
                  HEPCLABCRDXTSTANTIHCVDT
                  HEPCLABCRDXTSTANTIHCVRSLT $
                  HEPCLABCRDXTSTANTIHCVCUTRATIO $
                  HEPCLABCRDXTSTANTIHCVTRUPOS $
                  HEPCLABCRDXTSTHCVRNADT
                  HEPCLABCRDXTSTHCVRNARSLT $
                  HEPCLABCRDXTSTHCVRIBADT
                  HEPCLABCRDXTSTHCVRIBARSLT $
                  HEPCLABCRDXTSTGENOTYPE $
                  HEPCLABCRDXTSTOTHANTIHAVIGMDT
                  HEPCLABCRDXTSTOTHANTIHAVIGMRSLT $
                  HEPCLABCRDXTSTOTHANTIHAVDT 
                  HEPCLABCRDXTSTOTHANTIHAVRSLT $
                  HEPCLABCRDXTSTOTHHBVDNADate 
                  HEPCLABCRDXTSTOTHHBVDNAQUALRES $
                  HEPCLABCRDXTSTOTHHBVDNAQUALDATE 
                  HEPCLABCRDXTSTOTHHBVDNARes $
                  HEPCLABCRDXTSTOTHHBeAgDate 
                  HEPCLABCRDXTSTOTHHBeAgRes $
                  HEPCLABCRDXTSTOTHHBSAGDT
                  HEPCLABCRDXTSTOTHHBSAGRSLT $
                  HEPCLABCRDXTSTOTHANTIHBCIGMDT
                  HEPCLABCRDXTSTOTHANTIHBCIGMRSLT $
                  HEPCLABCRDXTSTOTHANTIHBSDT
                  HEPCLABCRDXTSTOTHANTIHBSRSLT $
                  HEPCLABCRDXTSTOTHANTIHBCDT 
                  HEPCLABCRDXTSTOTHANTIHBCRSLT $
                  HEPCLABCRDXTSTOTHANTIHDVDT 
                  HEPCLABCRDXTSTOTHANTIHDVRSLT $
                  HEPCLABCRDXTSTOTHANTIHEVDT 
                  HEPCLABCRDXTSTOTHANTIHEVRSLT $
                  DXLVRENZLEVALTSGPTDT
                  DXLVRENZLEVALTSGPTRSLT $
                  DXLVRENZLEVALTSGPTUPPER $
                  DXLVRENZLEVALTSGOTDT 
                  DXLVRENZLEVALTSGOTRSLT $
                  DXLVRENZLEVALTSGOTUPPER $
                  DXLVRENZLEVBILIRUBINDT 
                  DXLVRENZLEVBILIRUBINRSLT $;
run;


data calredie;
set calredie;
rename 	aptno = Apartment
		CellPhone = Cellular_Phone___Pager
		CTract = CensusTract
		CountryBirth = CountryofBirth
		CntyFIPS = CountyFIPS
     	CntyOfResid = CountyOfResidence
		DtAdmit = DateAdmitted
		DtClosed = DateClosed
		DtCreate = DateCreated
		DtDischarge = DateDischarged
		DtArrival = DateofArrival
		DtDeath = DateOfDeath
		DtDiagnosis = DateOfDiagnosis
		DtOnset = DateOfOnset
		DtReceived = DateReceived
		DtSent = DateSent
		DtSubmit = DateSubmitted
	    DtLabResult = DateofLabReport
		DisShort = DisShortName
		DiseaseGrp = DiseaseGroups
		DtEpisode = EpisodeDate
		FinalDispo = FinalDisposition
		LHJ = Healthjurisdiction
		IncidentID = ID
		IndexCase = IsIndexCase
		MRN = MedicalRecordNumber
		OccLocation = OccupationLocation
		OccSettingType = OccupationSettingType
		OccSettingSpec = OccupationSettingTypeSpecify
		OutbreakNum = OutbreakNumber
		PtDiedIllness = PatientDiedofthisIllness
		PtHospitalized = PatientHospitalized
		PStatus = ProcessStatus
		RStatus = ResolutionStatus
		RPTBy = ReportedBy
		Address = StreetAddress
		Submitter = SubmitterName
		Tstatus = TransmissionStatus
		Zip = ZipCode
		rslocation=rs_primarylocation
		rsaddress=loc_address
		rscity=loc_city
		rszipcode=loc_zip;
run;


data calredie;
set calredie;
keep Age Apartment CMRNumber Cellular_Phone___Pager CensusBlock CensusTract City ClusterId Country
CountryOfBirth CountyFIPS CountyOfResidence DOB DXLVRENZLEVALTSGOTRSLT DXLVRENZLEVALTSGOTUPPER DXLVRENZLEVALTSGPTRSLT
DXLVRENZLEVALTSGPTUPPER DateAdmitted DateClosed DateCreated DateDischarged DateOfArrival DateOfDeath DateOfDiagnosis
DateOfOnset DateReceived DateSent DateSubmitted DateofLabReport DisShortName Disease DiseaseGroups EpisodeDate
Ethnicity FinalDisposition FirstName HEPCLABCRDXTSTANTIHCVCUTRATIO HEPCLABCRDXTSTANTIHCVRSLT
HEPCLABCRDXTSTANTIHCVTRUPOS HEPCLABCRDXTSTGENOTYPE HEPCLABCRDXTSTHCVRIBARSLT HEPCLABCRDXTSTHCVRNARSLT
HEPCLABCRDXTSTOTHANTIHAVIGMRSLT HEPCLABCRDXTSTOTHANTIHBCIGMRSLT HEPCLABCRDXTSTOTHANTIHBCRSLT HEPCLABCRDXTSTOTHANTIHBSRSLT
HEPCLABCRDXTSTOTHHBSAGRSLT HealthJurisdiction HomePhone Hospital ID InPatient IsIndexCase Laboratory
LastName Latitude Longitude MedicalRecordNumber MiddleName NameSuffix Occupation OccupationLocation
OccupationSettingType OccupationSettingTypeSpecify OutPatient OutbreakNumber OutbreakType
PatientDiedofthisIllness PatientHospitalized Pregnant ProcessStatus RSName Race ReportedBy
ResolutionStatus SSN Sex State StreetAddress SubmitterName TransmissionStatus WorkPhone
ZipCode rs_primarylocation loc_address loc_city loc_zip;
run;

proc sort data=calredie nodup;
by id;
run;
