* Enter the dataset that was used during the previous run;
%let ds1=sfeftp.Cdhs_sf_chronic_c_dl04022012;
* Enter the new dataset;
%let ds2=sfeftp.Cdhs_sf_chronic_c_dl06072012;

proc sort data=&ds1;
by local_id;
run;

proc sort data=&ds2;
by local_id;
run;

data SFeFTPData;
merge &ds1 (in=a) &ds2 (in=b);
by local_id;
if b and not a;
run;
