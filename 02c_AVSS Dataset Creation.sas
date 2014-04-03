%let morbfiledate=20120702;

data archive.avss_old_&sysdate;
set avss.avss_old;
run;

PROC IMPORT OUT= WORK.AVSS_010199_042012 
            DATAFILE= "&directory.Chronic HCV Data Analysis\Chronic HCV SAS Files\AVSS HEP-C-CR 1-1-1999 to 4-20-2012.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="HEP_C_CR_Only$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data temp1 temp3;
set AVSS_010199_042012;
rename	xid=id
		xdis=dis
		xlhd=lhd
		xdat=dat
		xtyp=typ
		xdob=dob
		xage=age
		xre=re
		xsex=sex
		xlna=lna
		xfna=fna
		xmna=mna
		xssn=ssn
		xctr=ctr
		xaddr=addr
		xcity=city
		xctry=ctry
		xocc=occ
		xout=out_spp
		xrtyp=rtyp
		fdob=dobf
		pdup=dup;
year=put(xyear,$2.);
format don ddx dth date9.;
don=mdy(substr(xdon,1,2),substr(xdon,4,2),substr(xdon,7,2));
ddx=mdy(substr(xddx,1,2),substr(xddx,4,2),substr(xddx,7,2));
dth=mdy(substr(xdth,1,2),substr(xdth,4,2),substr(xdth,7,2));
zip=input(xzip,8.);
donf=input(fdon,8.);
ddxf=input(fddx,8.);
dthf=input(fdth,8.);
darf=input(fdar,8.);
drop year xdon xddx xdth xzip xdar xgc fdon fddx fdth fdar pxind prace psero pdfl;
run;

proc sort data=temp1 (keep=id hcv pcrhcv);
by id;
run;

proc sort data=avss.avss_old;
by id;
run;

data morb;
set avss.Morb_hcv_&morbfiledate;
zip1=input(zip,8.);
drop zip;
rename zip1=zip;
run;

proc sort data=morb;
by id;
run;

data avss_data;
merge avss.avss_old (in=a) morb (in=b);
by id;
if b and not a;
run;

proc sort data=avss_data;
by id;
run;

data avss_combined look;
merge avss_data (in=a) temp1 (in=b);
by id;
if b and not a then output look;
else output avss_combined;
run;

proc sort data=look (keep=id);
by id;
run;

proc sort data=temp3;
by id;
run;

data look_data;
merge temp3 look (in=a);
by id;
if a;
run;

data avss_final;
set avss_combined look_data;
if strip(year) ='9' then year='09';
if strip(year) ='.' then year='';
run;

/* This code has not yet been tested - please see Erin Murray if you get an error message for trouble shooting assistance - DELETE this comment after 
	the first time this code is run successfully*/
proc append base=avss.avss_old data=avss_final;
run;
