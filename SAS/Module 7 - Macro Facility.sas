
/*
Module 7 - Macro Facility.sas
Created: Oct 7, 2014
*/


** Example 1;

%let n = 5;
%let exname = Example 1; * Notice lack of quotes;

data new;
	do i=1 to &n;
		x = ranuni(0);
		output;
	end;
run;

proc print data=new;
	title "Generated Data for &exname";
run;

* macri variable within single quote;
proc print;
	title 'Generated Data for &exname';
run;

** Example 2a;
** Showing macro variable for debugging;
%let exname = Example 2;
%put &exname;

** Or something like this;
%put >>>> exname = &exname;


data _null_;
put 'Whatever';
run;


** Example 2b;
data _null_;
	do j=1 to 3;
		put j ' Placed by PUT';
		%put j ' Placed by macro PUT';
	end;
run;

* Testing types of put statement;
%put _all_;
%put _global_;
%put _user_;

* Emulating SAS log messages;
%put ERROR: This is a test error;
%put WARNING: This is not a warning;

******************
** Example  3a;
******************;
proc contents data=sashelp.class;
run;

** Print Variable Descriptives;
proc means data=sashelp.class mean median std skew kurt;
	var age height weight;
run;

** Item frequency table;
proc freq data=sashelp.class ;
	tables sex;
run;

*********************
* Example 3b;
*********************;
* Use a macro variable;
%let dsn = class;

** Print Variable Descriptives;
proc means data=sashelp.&dsn mean median std skew kurt;
	var age height weight;
run;

** Item frequency table;
proc freq data=sashelp.&dsn ;
	tables sex;
run;

*******************
Example 4
******************;

proc contents data=sashelp.iris;
run;

%let dsn = sashelp.iris;
%let DEBUG =;

&DEBUG title "Data set &dsn";
&DEBUG proc contents data=&dsn;
&DEBUG run;

&DEBUG proc print data=&dsn (obs=10);
&DEBUG run;


** Example of Prefixes;
%let dsn = sales;
data &dsncomb;
	set &dsn1 &dsn2;
run;


** Example 6 **;

%MACRO progtime;
	DATA _NULL_;
	   now=TODAY();
	   PUT "The program was executed on " now WORDDATE.;
	RUN;
%MEND;

%progtime;


** Example 6b **;

%MACRO progtime(progname);
DATA _NULL_;
   now=TODAY();
   PUT "The program &progname was executed on " now WORDDATE.;
RUN;
%MEND;

%progtime(Example 6b);

* Where parameter has prespecified value;
%MACRO progtime(progname=Example 7 and 8);
DATA _NULL_;
   now=TODAY();
   PUT "The program &progname was executed on " now WORDDATE.;
RUN;
%MEND;

%progtime;

** Example 7 ** ;

%macro gen_norm(dsn=dat, m=0, sd=1, n=100, seed=0);
	data &dsn;
		do i=1 to &n;
			x = rand('NORMAL', &m, &sd);
			output;
		end;
		*keep x;
	run;

	title "Generate &n deviates from normal distribution with";
	title3 "  mean = &m, stdev = &sd";
	proc univariate data=&dsn;
		histogram;
	run;
%mend gen_norm;


%macro gen_norm(dsn=dat, m=0, sd=1, n=100, seed=100);
	data &dsn;
	call streaminit (&seed);
		do i=1 to &n;
			x = rand('NORMAL', &m, &sd);
			output;
		end;
		keep x;
	run;

	title "Generate &n deviates from normal distribution with";
	title3 "  mean = &m, stdev = &sd";
	proc univariate data=&dsn;
		histogram;
	run;
%mend gen_norm;

%gen_norm(m=50, sd=8, n=150, dsn=m50s8, seed=1); 
%gen_norm

** Activity 1 **;

%gen_norm(n=50, m=5, sd=2, dsn=test, seed=1)

proc means data=test mean std;
var x;
run;


** Example 8 : Look Macro **;

%macro look(dsn, obs);		
	proc contents data=&dsn;
		title "DATA SET &dsn";
	run;

	proc print data=&dsn (OBS=&obs);
		title2 "First &obs Observations";
	run;
%mend look;

%look (sashelp.class, 10);


* Example 8b;

%macro look(dsn=&SYSLAST, obs=10);		
	proc contents data=&dsn;
		title "DATA SET &dsn";
	run;

	proc print data=&dsn (OBS=&obs);
		title2 "First &obs Observations";
	run;
%mend look;

%LOOK(dsn=sashelp.class, obs=5)


/*
Activity 2

Write a SAS macro to count the number of rows
of a data set. You should be able to enter the 
data set when invoking the macro 

*/

%macro count (dsn);
proc sql;
title "Row counts for &dsn Data";
 select count(*) as Count
 from &dsn
 ;
quit;
%mend count;

%count(sashelp.class)


** Example 9a;
%let city = Greeley;
%macro msg1;
	%let state = Colorado;
	%put >>IN: The city of &city is in &state;
%mend;

%msg1;
%put >>OUT: &city is in &state, right?;

%put _user_;

** Example 9b **;

%macro msg2;
	%global state;
	%let state = Colorado;
	%put >>IN: The city of &city is in &state;
%mend;

%msg2;
%put >>OUT: &city is in &state, right?;

%put _user_;

** Example 9c **;
%macro msg3;
	%local city; 		** Repeat without this command;
	%let city = Evans;
	%let state = Colorado;
	%put >>IN: The city of &city is in &state;
%mend;

%put _user_;
%put _global_;
%put _local_;

%msg3;
%put >>OUT: &city is in &state, right?;


* without the city as local variable;
%macro msg3;
	%let city = Windsor;
	%let state = Colorado;
	%put >>IN: The city of &city is in &state;
%mend;

%put _user_;

%msg3;

%put _user_;
%put >>OUT: &city is in &state, right?;


** Example 9d **;
%macro msg4;
	%local newcity; 
	%let newcity = Longmont;
	%let state = Colorado;
	%put >>IN: The city of &newcity is in &state;
%mend;

%put _user_;

%msg4

%put >>OUT: &city is in &state, right?;
%put >>OUT: &newcity is in &state, right?;

** Conditional Macro Statements;

** Example 10a **;
%macro classdays(class);
	%if &class=SRM 620 %then %let days=T R;
	%else %let days = M W F;
	%put >>>> days = &days;
%mend classdays;

%classdays(SRM 620);


** Example 10b ** ;
data dset1;
input id x y;
cards;
1 1 10
2 1 20
;
run;

data dset2;
input id x y;
cards;
2 2 30
3 2 40
;
run;



%let method = cat;
%macro new;
	data combined;
	%if  &method=cat %then set dset1 dset2;
	%else merge dset1 dset2;
	run;
%mend;

%new;

%let method = cat;
%macro new;
	data combined;
	%if  &method=cat %then %str(set dset1 dset2;);
	%else %str(merge dset1 dset2;);
	run;
%mend;

%new;

proc print data=combined;
run;


** Example 10c **;
%macro new;
	data combined;
	%if  &method=cat %then %do;
		set dset1 dset2;
	%end;
	%else %do;
		merge dset1 dset2;
		by ID;
	%end;
	run;
%mend;

%let method=none;
%new

proc print data=combined;
run;


** Example 11 **;

* Review PROC APPEND;
* base=destination data set (will create newdata);
* data= source data set;
proc append base=dset data=dset1;
run;

proc print data=dset;
run;

** Macro gen_norm;
* This macro will iteratively call gen_norm with 
increasing values of n;

%macro gen_norm(dsn=dat, m=0, sd=1, n=100, seed=0);
data &dsn;
	do i=1 to &n;
		x = rand('NORMAL', &m, &sd);
		output;
	end;
	keep x;
run;

title "Generate &n deviates from normal distribution with";
title3 "  mean = &m, stdev = &sd";

ods select basicmeasures;
proc univariate data=&dsn;
run;
%mend gen_norm;


%macro n_loop(start, stop, incr);
	%DO n=&start %TO &stop %BY &incr;
		%gen_norm(m=50, sd=8, n=&n, dsn=m50s8n&n);
	%END;
%mend;

%n_loop(10, 15, 1);

* printing the generated data sets;
proc print data=m50s8n10;
run;
