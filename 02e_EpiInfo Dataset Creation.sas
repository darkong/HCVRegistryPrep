PROC IMPORT OUT= WORK.epiinfo 
            DATAFILE= "\\intra.dhs.ca.gov\CDPH\DCDC\STD\Groups\Office of Adult Viral Hepatitis Prevention\Surveillance\State Surveillance\CMRs\HEP_C.DBF" 
            DBMS=DBF REPLACE;
     GETDELETED=NO;
RUN;

