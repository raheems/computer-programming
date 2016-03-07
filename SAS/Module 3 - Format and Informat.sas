/*
SRM 620 - Module 3
File name: Module 3- Format and Informats.sas
*/

libname datalib "/courses/d77053e5ba27fe300";

** Frequency Distribution and Bar Graphs: Categorical Data;

** Loading Salmon Data set;
** The data contains growth ring size (freshwater or marine) and gender of 
** Salmon fish caught in American and Canadian water near Alaska. ;

proc import datafile="/courses/d77053e5ba27fe300/salmon.csv" out=salmon_main dbms=csv replace;
   getnames=yes;
run;

/** For running on the Instructor's PC -- begins;
proc import datafile="salmon.csv" out=salmon_main dbms=csv replace;
   getnames=yes;
run;
** For running on the Instructor's PC -- ends;
*/

** printing the salmon data set;
title 'Salmon Data';
proc print data = salmon_main;
run;
title; * clears the title statement;

** Frequency distribution of Region (American or Canadian);
title 'Freq. Distribution of Regions';
proc freq data = salmon_main;
table region;
run;
title; * clearing the title statement;


** Frequency distribution of Gender of Salmon (1 or 2);
** 1 to indicate male
** 2 to indicate female;
title 'Freq. Distribution of Gender';
proc freq data = salmon_main;
table gender;
run;
title; * clearing the title statement;

** Drawing bar diagram of region;
title 'Bar chart of Region';
proc gchart data = salmon_main;
      vbar region;
run; 


** Load a SAS Data set called cars;
data cars2;
set sashelp.cars;
run;

proc print data = cars2 (obs =10);
run;

** Drawing bar diagram of Make of cars;
title 'Bar chart of Make of Vehicles';
proc gchart data = cars2;
      vbar make;
run; 
quit;




********************************************
Quantitative Data: 
Frequency Distribution and Histogram
********************************************;

** Example 3.2, p. 33
** We first import crime data set ;
proc import datafile="/courses/d77053e5ba27fe300/crime2005.csv" out=crime_main dbms=csv replace;
   getnames=yes;
run;

/** For Instructor's PC - DO NOT RUN;
proc import datafile="crime2005.csv" out=crime_main dbms=csv replace;
   getnames=yes;
run;
*/

** Printing the crime data set;
proc print data = crime_main;
run; * Column 2 of the data shows the violent crime rates;


** Creating a new variable that will be needed
** to construct a relative frequency distribution
** of violent crime rates;

data crime;
set crime_main;
where state ne "DC";
vcr = .;
if (vi2 <= 11) then vcr = 0;
*if (vi2 >= 12) and (vi2 <= 23) then vcr = 1;
if (12 <= vi2 <= 23) then vcr = 1;
if (vi2 >= 24) and (vi2 <= 35) then vcr = 2;
if (vi2 >= 36) and (vi2 <= 47) then vcr = 3;
if (vi2 >= 48) and (vi2 <= 59) then vcr = 4;
if (vi2 >= 60) and (vi2 <= 71) then vcr = 5;
if (vi2 >= 72) then vcr = 6;
run;

proc print data = crime (obs=10); 
run;

proc format;
value vcrlab  
	0='0 - 11'
	1 = '12 - 23'
	2 = '24 - 35'
	3 = '36 - 47'
	4 = '48 - 59'
	5 = '60 - 71'
	6 = '>= 72'
;
run;

proc print data=crime;
format vcr vcrlab.;
run;


** Frequency Table for violent crime rates;
title 'Frequency Distribution for Violent Crime Rates';
proc freq data = crime;
format vcr vcrlab.;
table vcr;
run;



** Another way to create a format (vcrlabb) and apply it to 
** an existing variable without creating a new variable;
proc format;
	value vcrlabb
		low-<12 = '<= 11'
		12-23 = "12-23"
		24-35 = '24-35'
		36-47 = '36-47'
		48-59 = '48-59'
		60-71 = '60-71'
		72 - high = '>= 72'
		;
run;

** Printing the data to display vi2 variable
** according to our format; 
proc print data=crime_main (obs=5);
format vi2 vcrlabb.;
run;

** Example of character format (statef);
proc format;
	value $statef
		'AK'-'AZ' = 'Starts with A'
		'CA'-'CT' = 'Starts with C'
		'DE', 'fl', 'GA' = 'DFG'
		; 
run;


proc print data=crime_main (obs=10);
title 'Testing Character Format';
format state $statef.; *Note the dollar sign;
run;


** User-defined format vs system format;
data cars;
set sashelp.cars;
run;

proc print data=cars;
run;


proc print data=cars (obs=10);
title 'Testing system vs user-defined format';
format weight comma.;
run;

** Example 3-1
** Another example of a system format;
** Output is printed in the log;
data _null_;
   cost=10.95;
   put cost dollar6.2;
   put cost dollar5.2;
   put cost dollar.; * rounds up to 11;
run;

** Example 3-2;
data classdata;
input name $ score @@;
cards;
Barb .656 Bill .767 Betty .878 Bob .989 Ben .990 
;
run;

proc print data=classdata;
	format score percent4.2;
run;



** Example 3-3;
data a;
   cost = 10.95;
   price = 15.00;
   format price dollar6.2;

   *put cost dollar6.2;
   *put price;
run;

proc print;run;

proc print; 
format price dollar5.;
run;




data b;
   set a;
   put cost ; * it was not formatted permanently;
   put price; * it was formatted permanently;
run;


data c;
   cost = 10.95;
   price = 15.00;
   *format price dollar6.2;

   *put cost dollar6.2;
   *put price;
run;

proc print; run;

proc print;
format price dollar6.2;
format cost dollar5.;
run;


** Class Activity:
** Use the SASHELP.CARS data set to define two formats
** for variables horsepower and Weight;
** Save them in a permanent SAS data library as a 
** format catalog.
** Practice listing then and applying them on these
** two variables;

** Printing first 10 obs as-is from cars data;
proc print data=cars (obs=10);
run;

** More examples;
** Example 3.4;
data classdata;
   input name $ score @@;
   cards;
Barb .656 Bill .767 Betty .878 Bob .989 Ben .990 
;

proc format;
   value grade
   	0 - .599 = 'F'
   .60 - .699 = 'D'
   .70 - .799 = 'C'
   .80 - .899 = 'B'
   .90 - 1.00 = 'A';
run;

proc print data = classdata;
format score grade.;
run;


** Example 3.5;
data people;
   input name $ age;
   cards;
Amy 12
Ann 15
Alan 25
Arthur 3
Andrew 10
Alice 13
Antonio 45
Albert 65
Antwon 44
Austin 32
Agnes 88
;
run;

** Exclude lower bound;
proc format;
   value age  
      0  -  2 = "Infant"
      2 <-  5 = "Toddler"
      5 <- 12 = "Child"
      12 <- 18 = "Youth"
      18 <- 65 = "Adult"
      65 <- HIGH = "Senior";
run;

proc freq data = people;
format age age.;
tables age;
run;

/*
title 'Histogram Example';
proc univariate data=people noprint;
   	histogram age / midpoints= 0 to 50 by 10
	vscale= proportion; ** default is percent;
	format age age.;
run;
*/

** Example 3.6;
** Use of informat in an INPUT statement;
data ex6;
	input gender $1.;
	cards;
m
M
1
f
;
run;

proc print; 
run;

** Example 3.7
** Use of INFORMAT in an INFORMAT STATEMENT;
data ex37;
	informat startdate  date9.;
	input startdate @@;
	cards;
31MAR1999 11FEB2001
;
run;

proc print data=ex37;
title 'Unformatted date';
run;

proc print data = ex37;
title 'Formatted Date';
*format startdate MMDDYY10.;
format startdate date9.;
run;

** What happens if you do not use the 
** informat? ;
data ex37;
	informat startdate ;
	input startdate @@;
	cards;
31MAR1999 11FEB2001
;
run;

proc print; run;


** Example 3.8a;
** Use of INPUT function;
data _null_;
	cost = '$4,999.95';
	costnum = input(cost, comma9.2);
	tax = costnum*.075;
	put cost=; 
	put costnum= ;
	put tax= dollar9.2;
run;


** Example 3.8b;
data _null_;
	date = '11FEB2001';
	sasdate=INPUT(date,date9.);
	put date=;
	put sasdate=;
	put sasdate= worddate. ;
put;

** Class Activity Example;
** Read the following data;
data classroom;
input name $20. ssn tot_pts tot_poss;
cards;
Robert Poulson       123456789      175         200 
Mike Anderson        234567891      138         200 
Chris Christensen    345678912      113         200 
Tyrone Schuur        456789012      185         200 
Chris Fisher         987654321      165         200 
;
run;

proc print data = classroom;
run;

** Calculate percentage of scores;
** Calculate letter grade based on perc scores;
** Display data with the appropriate formats including
**	percentage, xxx-xxx-xxx for SSN and letter grade
**	in A - F;








