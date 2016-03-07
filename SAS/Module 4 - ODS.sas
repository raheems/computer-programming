/*
SRM 620 - Module 4
File name: Module 4- ODS.sas
*/


data battery;
	input brand load minutes;
	cards;
1 1.7 101
1 1.7 109
2 1.8 100
2 2.0 101
4 5.1 542
;
run;


** Print the output of univariate procedure;
proc univariate data=battery;
	var minutes;
run;

** Selecting output "selectively";
ods select BasicMeasures;
proc univariate data=battery;
	var minutes;
run;


** Saving a section of the output
to a separate SAS data set;
ods output OverallANOVA = new_dataset;
proc glm data=battery;
	class brand;
	model minutes=brand;
run; quit;

** In addition to producing the GLM output
we've selectively saved the "OverallANOVA"
to a new data set called "new_dataset";
proc print data=new_dataset;
run;

** Ex 3a
**The following code routes the output 
from several PROCs to an HTML file;

ods html file='battery.html';

proc means data=battery;
run;

proc glm data=battery;
	class brand;
	model minutes=brand;
run;
quit;

ods html close;

** Ex 3b
** This code writes the same output to 
both an RTF file and an HTML file;

ods html file='battery.html';
ods rtf file='battery.rtf';
proc means data=battery;
run;
quit;

proc glm data=battery;
	class brand;
	model minutes=brand;
run;
quit;
ods html close;
ods rtf close;




** How do you know what select-option(s) are available;
** SOLUTION: Use the ODS TRACE ON|OFF statement;

ods trace on;
proc univariate data = battery;
var minutes;
run;
ods trace off;

** Ex 5 - Selecting only particular objects;
ods select basicmeasures quantiles;

* The ODS SHOW statement writes to the SAS log 
the overall list, which is set to SELECT ALL by default.;
ods show; 
proc univariate data=battery;
var minutes;
run;


** ODS SELECT NONE;
ods select none;
ods show;
proc univariate data=battery;
var minutes;
run;

** ODS SELECT ALL;
ods select all; * this is the default;
ods show;
proc univariate data=battery;
var minutes;
run;

** Slection of specific objects for
RTF destination;

** Ex 5b;
ods rtf; * you need this statement to set it ON;
ods rtf select basicmeasures quantiles;
proc univariate data=battery;
	var minutes;
run;
ods rtf close;


** Example 3c;
ods html 
	path='C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 620\Fall 2014\SAS Program Files\tmp\'	/** Path to a folder **/
	body='body.html'		
	contents='contents.html' 
	frame='frame.html';
proc means data=battery;
run;
quit;
ods html close;


** Ex 6;
filename myfile 'tmp\myfile.rtf';
ods rtf file=myfile;

title 'My Page Title - A title of your choice';

data classroom; 
   input id 1-4 name $ 6-24 @;
   do i=1 to 3;
      input score @;
      output;
   end;
   cards; 
1023 Robert Poulson     98 77 125
1049 Mike Anderson      52 86 156
1219 Chris Christensen  25 88 164
1246 Tyrone Schuur      86 99 .
1078 Chris Fisher       100 65 194
run; 

proc print data=classroom;
run;

proc means data=classroom;
run;

ods rtf close;


** ODS PDF example; **
** Example 7;

options sysprintfont="Courier"; * Run only if you have issues with PDF option;

ods pdf file="tmp\class.pdf" ;

proc gchart data=sashelp.class;
	title 'Student ages';
	hbar age;
run;
quit;

symbol v=circle c=blue i=r;
proc gplot data=sashelp.class ;
	title 'Weight by Height';
	plot weight*height;
run;
quit;

ods pdf close;

** *************************
** ODS RFT STARTPAGE option
** ************************;
ods rtf startpage=yes file='output.rtf'; ** default;
proc print data=classroom;
run;

proc means data=classroom;
run;
ods rtf close;

** *************************
** ODS RFT STARTPAGE= NO  option
** ************************;
ods rtf startpage=no file='output.rtf'; ** default;
proc print data=classroom;
run;

proc means data=classroom;
run;
ods rtf close;



** STARTPAGE=NO and use of NOW;
options date;
ods rtf startpage=no file='output.rtf'; 
proc print data=classroom;
run;

proc means data=classroom;
title1 'On the same page';
title;
run;

ods rtf startpage=now;
proc means data=classroom;
title1 'Should be on a new page';
run;
title;
ods rtf close;


/*
Styles and Templates;
*/
title;

proc template;
list styles;
run;
quit;

** Using command line to view a template;
proc template;
source styles.htmlblue;
run;


** Applying a style to the output;

ods rtf file='tmp\somefile.rtf' 
		style=Astronomy;
proc univariate data=sashelp.class;
	var weight;
run;
ods rtf close;

*Ex 8;
ods pdf file='somepdf.pdf';
proc print data=sashelp.class noobs
	style(header)=[background=orange]
	style(total)=[background=cyan];
	sum weight;
	by age;
run;
ods pdf close;


** Example - Class Activity;
ods html style=htmlblue; * default style;
title "Model Height By Weight";
proc sgplot data=sashelp.class;
  reg x=height y=weight / clm cli;
run;
title;

ods html style=journal;
title "Model Height By Weight";
proc sgplot data=sashelp.class;
  reg x=height y=weight / clm cli;
run;
title;

** Example of journal style;
ods html style=journal;
title "Model Height By Weight";
proc sgplot data=sashelp.class;
  reg x=height y=weight / clm cli;
run;
title;

** Example of Gears style;
ods html style=gears;
title "Model Height By Weight";
proc sgplot data=sashelp.class;
  reg x=height y=weight / clm cli;
run;
title;


** Example 9;
** ODS Graphics;
ods graphics on;

proc reg data=sashelp.class;
	model weight=height;
run;
quit;

ods graphics off;


** Example 10;
** Create an image to be used in LaTeX
having a specific width and format;

ods graphics on / 
     width=5.0in
     imagefmt=ps
     imagename='test'
	 border=off;

ods latex gpath="C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 620\Fall 2014\SAS Program Files";
proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution by Weight Class";
  hbox cholesterol / category=weight_status;
run;

ods latex close;

