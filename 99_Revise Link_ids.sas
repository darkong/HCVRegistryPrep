*One-time code run to reset link_ids of registry to lowest ids.  Does not need to be run again.


* Main directory;
%let directory=\\cdphdcdc_01\Groups\STD\Office of Adult Viral Hepatitis Prevention\State Surveillance\;
libname mainfldr "&directory.Adam Coutts Code Folder\Datasets";
libname archive "&directory.Adam Coutts Code Folder\Datasets\Archived Data";


* Back up previous datasets to archive folder prior to creating new file (at bottom of this program);
data archive.setx14_&sysdate9;
set mainfldr.setx14;
run;

data archive.main01_&sysdate9;
set mainfldr.main01;
run;

data archive.main02_&sysdate9;
set mainfldr.main02;
run;

data archive.main01_forfuturededup&sysdate9;
set mainfldr.main01_forfuturededup;
run;

data archive.main02_formatching&sysdate9;
set mainfldr.main02_formatching;
run;


data setx14;
set mainfldr.setx14;
run;

data main01;
set mainfldr.main01;
run;

data main02;
set mainfldr.main02;
run;

data main01_forfuturededup;
set mainfldr.main01_forfuturededup;
run;

data main02_formatching;
set mainfldr.main02_formatching;
run;


data ids;
set main02;
keep link_id id;
run;

proc sort data = ids;
by link_id id;
run;

data idsnew;
set ids;
by link_id id;
if first.link_id;
rename id = link_id2;
run;


proc sort data = idsnew; by link_id; run;
proc sort data = setx14; by link_id; run;
proc sort data = main02; by link_id; run;
proc sort data = main01; by link_id; run;
proc sort data = main01_forfuturededup; by link_id; run;
proc sort data = main02_formatching; by link_id; run;


%macro redoid (dataset);

data &dataset.;
merge &dataset.
      idsnew;
by link_id;
drop link_id;
run;

data &dataset.;
set &dataset.;
rename link_id2 = link_id;
run;

data mainfldr.&dataset.;
set &dataset.;
run;

%mend;


%redoid(main01);
%redoid(main01_forfuturededup);
%redoid(main02);
%redoid(main02_formatching);
%redoid(setx14);




