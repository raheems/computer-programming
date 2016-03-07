
/*
File name: Module 2 - SAS Libraries.sas

Author: Enayetur Raheem
Created: Aug 25, 2014
Last Modified: Aug 27, 2014

*/   

** Defining a SAS library;
libname clinic 'C:\Users\Raheem\Documents\My SAS Files\9.3';

data clinic.admit2; * defining a new data set;
set clinic.admit; * reading from an existing data set;
run;

** Printing the data by referencing with two-level name;
proc print data = clinic.admit2; * printing the data set;
run;

** This also works;
proc print; * printing the data set;
run;

** Another Example of a temporary SAS data set;
data classroom; 
   input id 1-4 name $ 6-24 ssn hw1 hw2 exam; 
   Total_Points=hw1+hw2; 
   Total_Points_Possible=200;
   Total_Percentage=Total_Points/total_points_possible;
   cards; 
1023 Robert Poulson     123456789 98 77 125
1049 Mike Anderson      234567891 52 86 156
1219 Chris Christensen  345678912 25 88 164
1246 Tyrone Schuur      456789012 86 99 .
1078 Chris Fisher       987654321 100 65 194
run;

** Printing the classroom data set;
proc print data = classroom;
run;

** Also works;
proc print data=work.classroom; 
run;

** Portions in a SAS data set;
proc contents data=clinic.admit2;
run;

** Viewing all the contents in the Clinic library;
proc contents data = clinic._all_ nods;
run;


** The following portion of codes are to be executed on
** SAS Studio on the web;
** Students please use this path to define library;
libname mydata "~/my_courses/enayetur.raheem" access=readonly;

data mydata.admit2;
set mydata.admit;
run;

proc print data=mydata.admit2;
run;
