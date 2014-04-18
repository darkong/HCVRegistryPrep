* Enter the dataset that was used during the previous run;
%let ds1=sfeftp.Cdhs_sf_chronic_c_dl06072012; *updated 2/20/2014, new data not in registry yet;
* Enter the new dataset;
%let ds2=sfeftp.cdhs_sf_chronic_c_dl11122013; *updated 2/20/2014, new data not in registry yet;

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
