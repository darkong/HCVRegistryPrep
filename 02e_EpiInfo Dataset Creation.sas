PROC IMPORT OUT= WORK.epiinfo 
            DATAFILE= "\\dhs-dcdc-rdm-04\Office of Adult Viral Hepatitis Prevention\Surveillance\State Surveillance\CMRs\HEP_C.DBF" 
            DBMS=DBF REPLACE;
     GETDELETED=NO;
RUN;

