/*
SRM 620 - Module 5 - Sas Graph
File name: Module5 - Graph.sas

Created by Enayetur Raheem
Created: Sep 10, 2014
Last modified: Sep 15, 2014
*/

** setup graph size to 4in;
** Applies to ODS graphs only (SG - plots);

* Setting the ODS graph size;
ods graphics on / width=6.0in;


proc plot data=sashelp.class;
	plot height*weight=sex;
run;quit;

goptions hsize=6 vsize=4;
proc gplot data=sashelp.class;
	plot height*weight=sex ;
run;quit;

proc sgplot data=sashelp.class;
	scatter y=height x=weight / group=sex;
run;quit;


** automatic graphs in SAS;

*ods select 'Analysis of Variance';
ods select 'Fit Plot';

proc reg data=sashelp.class;
	model weight = height;
run;
quit;


********************
** SG Procedures **
********************

** Single-Cell Graphs (SGPLOT Procedure);

proc sgplot data=sashelp.cars;
	histogram horsepower;
	density horsepower;
	density horsepower/type=kernel;
	keylegend / location=inside position=topright across=2;
	xaxis display=(nolabel);
run;

** 2. SGPANEL procedure Example;
proc sgpanel data=sashelp.cars;
	where 	origin='USA' or
			origin='Asia';
panelby origin type /novarname;
histogram mpg_city;
density mpg_city;
run;
	

** SGSCATTER procedure;
proc sgscatter data=sashelp.cars;
plot (mpg_city mpg_highway) * horsepower /
	markerattrs=(symbol=circlefilled)
				transparancy=0.85;
run;


** Ex 1. SGPLOT;
proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution";
  histogram cholesterol;
  density cholesterol;
  density cholesterol / type=kernel;
  keylegend / location=inside position=topright;
run;

proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution";
  histogram cholesterol;
  density cholesterol;
  density cholesterol / type=kernel;
  keylegend / location=inside position=topright;
  xaxis display=(nolabel);
run;



** Ex 2;
** SGPANEL procedure Example;
proc sgpanel data=sashelp.cars;
	where 	origin='USA' or
			origin='Asia';
panelby origin type;
histogram mpg_city;
density mpg_city;
rowaxis display=none grid;
colaxis display=(nolabel) GRID;
title 'Mileage';
run;

proc print data=sashelp.cars (obs=10);
run;


** Ex 3;
proc sgscatter data=sashelp.cars;
matrix mpg_city weight horsepower msrp/
	markerattrs=(symbol=circlefilled)
	transparency=.9;
title 'Association between variables';
run;


** Ex 4a;
proc sgscatter data=sashelp.cars;
compare x=(mpg_city mpg_highway) y=(horsepower) /
	markerattrs=(symbol=circlefilled)
	transparency=.7;
title 'Comparison between Variables (common y-xaix)';
run;

** Ex 4b;
proc sgscatter data=sashelp.cars;
compare x=(mpg_city mpg_highway) y=(horsepower cylinders) /
	markerattrs=(symbol=circlefilled)
	transparency=.7;
title 'Comparison between Variables (two var on y-axis)';
run;


***********************************
** Developing Single-Cell Graph;
***********************************;
ods graphics on / width=6.0in;

** 5. Basic scatterplot;
proc sgplot data=sashelp.cars;
where type='Sedan' or type='Sports';
scatter x=horsepower y=mpg_highway;
title 'MPG(Highway) by Horsepower';
run;

** 6. Basic scatterplot with grid line;
proc sgplot data=sashelp.cars;
where type='Sedan' or type='Sports';
scatter x=horsepower y=mpg_highway;
xaxis grid; yaxis grid;
keylegend / location=inside position=topright;
title 'MPG(Highway) by Horsepower';
run;

** 7. Basic scatterplot with fitted line;
proc sgplot data=sashelp.cars;
where type='Sedan' or type='Sports';
reg x=horsepower y=mpg_highway /lineattrs=(thickness=2.5);
scatter x=horsepower y=mpg_highway;
xaxis grid; yaxis grid;
keylegend / location=inside position=topright;
title 'MPG (Highway) by Horsepower';
run;


** 8. Basic scatterplot with fitted line
and 95% confidence bands;
proc sgplot data=sashelp.cars;
where type='Sedan' or type='Sports';
reg x=horsepower y=mpg_highway /nomarkers lineattrs=(thickness=2.5)
	cli clm;
scatter x=horsepower y=mpg_highway;
xaxis grid; yaxis grid;
keylegend / location=inside position=topright;
title 'MPG (Highway) by Horsepower';
run;

** 9. Basic scatterplot with second-order fitted line
and 98% confidence bands;
proc sgplot data=sashelp.cars;
where type='Sedan' or type='Sports';
reg x=horsepower y=mpg_highway /nomarkers lineattrs=(thickness=2.5)
	cli clm alpha=.02 degree=2;
scatter x=horsepower y=mpg_highway;
xaxis grid; yaxis grid;
keylegend / location=inside position=topright;
title 'MPG (Highway) by Horsepower';
run;


** 10. Scatterplot Matrix with Histogram in the Diagonals;
proc sgscatter data=sashelp.heart (where=(ageatstart > 58));
matrix cholesterol diastolic systolic weight /
	diagonal=(histogram kernel)
	transparency=.7 ;
title 'Scatterplot Matrix';
run;

**From 
http://support.sas.com/documentation/cdl/en/grstatproc/62603/HTML/default/viewer.htm#sgscatter-ov.htm
;

** 11; 
proc sgscatter data=sashelp.iris
               (where=(species eq "Virginica"));
matrix petallength petalwidth sepallength
       / ellipse=(type=mean)
         diagonal=(histogram kernel);
run;


** Basic Linear Fit Plot with Confidence Limits;

** 12. Basic Linear Fit plot;
proc sgplot data=sashelp.cars;
where type ='Sedan' and origin='USA';
reg x=horsepower y=mpg_city;
title 'Basic Fit Plot';
run;


** 13. Basic Linear Fit plot with CLM-
confidence limits for the mean;
proc sgplot data=sashelp.cars noautolegend;
where type ='Sedan' and origin='USA';
reg x=horsepower y=mpg_city / clm;
title 'Fit plot with CLM';
run;


** 14. Basic Linear Fit plot with CLM and CLI;
proc sgplot data=sashelp.cars;
where type ='Sedan' and origin='USA';
reg x=horsepower y=mpg_city / clm cli;
title 'Fit plot with CLM and CLI';
run;

** 15;
** Basic Linear Fit plot with CLM and CLI;
** Change the attribute of the markers;
proc sgplot data=sashelp.cars;
where type ='Sedan' and origin='USA';
reg x=horsepower y=mpg_city / clm cli markerattrs=(symbol=plus);
title 'Fit plot with CLM and CLI';
run;

** 16. 
** Basic Linear Fit plot with CLM and CLI;
** Change the attribute of the markers;
proc sgplot data=sashelp.cars;
where type ='Sedan' and origin='USA';
reg x=horsepower y=mpg_city / clm cli markerattrs=(symbol=plus);
title 'Fit plot with CLM and CLI';
run;


** 17. 
** Basic Linear Fit plot with CLM and CLI;
** Change the attribute of the markers;
** Change the prediction band attribute;
proc sgplot data=sashelp.cars;
where type ='Sedan' and origin='USA';
reg x=horsepower y=mpg_city / clm cli markerattrs=(symbol=plus)
	cliattrs=(clilineattrs=(pattern=solid))
	clmattrs=(clmfillattrs=(color=orange));
title 'Fit plot with CLM and CLI';
run;

** 18
** Grouped fit: Scatterplot + Regression line;
proc sgplot data=sashelp.cars;
where type ='Sedan';
scatter x=horsepower y=mpg_highway / group=origin name='scatter';
reg x=horsepower y=mpg_highway /group=origin nomarkers name='reg';
keylegend 'scatter' / title='Origin';
keylegend 'reg' / location=inside;
title 'Grouped Plot';
run;


** 19
** Grouped fit: Scatterplot with different symbols 
	+ Smoothed line;
proc sgplot data=sashelp.cars;
where type ='Sedan';
scatter x=horsepower y=mpg_highway 
	/ group=origin transparency=0.7 name='scatter';
reg x=horsepower y=mpg_highway /nomarkers degree=2 name='reg';
keylegend 'scatter' / title='Origin';
keylegend 'reg' / location=inside;
title 'Grouped Plot';
run;

** 20 Class Activity;
** Use Ex 19, and overlay a polynomial of degree 2 and degree 3 
on the scatterplot;
proc sgplot data=sashelp.cars;
where type ='Sedan';
scatter x=horsepower y=mpg_highway 
	/ group=origin transparency=0.7 name='scatter';
reg x=horsepower y=mpg_highway /nomarkers degree=2 name='reg1';
reg x=horsepower y=mpg_highway /nomarkers degree=3 name='reg2';
*keylegend 'scatter' / title='Origin';
keylegend 'reg1' 'reg2' / location=inside across=1;
title 'Grouped Plot';
run;

** 21;
** Use Ex 19, and overlay a polynomial of degree 2 and degree 3 
on the scatterplot;
proc sgplot data=sashelp.cars;
where type ='Sedan';
scatter x=horsepower y=mpg_highway 
	/ group=origin transparency=0.5 name='scat_highway';
scatter x=horsepower y=mpg_city
	/ group=origin transparency=0.8 name='scat_city';
reg x=horsepower y=mpg_city /nomarkers degree=2 curvelabel= 'mpg (city)';
reg x=horsepower y=mpg_highway /nomarkers degree=2 curvelabel='mpg (highway)';
title 'Plots for MPG (City Vs Highway)';
yaxis display=(nolabel);
run;


** 22. Basic Ellipse;
** Draw an ellipse of the weight variable
in the cars data set;

proc sgplot data=sashelp.cars;
scatter x=horsepower y=mpg_city;
ellipse x=horsepower y=mpg_city;
title '95% Prediction Ellipse';
run;

** 23. 90% prediction ellipse;
proc sgplot data=sashelp.cars;
scatter x=mpg_city y=horsepower;
ellipse x=mpg_city y=horsepower / alpha=.10;
title '90% Prediction Ellipse';
run;

** 24. 90% prediction ellipse with orange shade;
proc sgplot data=sashelp.cars;
ellipse x=mpg_city y=horsepower 
	/ alpha=.10
	fill fillattrs=(color=orange);
scatter x=mpg_city y=horsepower;
title '90% Prediction Ellipse';
run;

**Class Activities;
/*
Draw a 95% prediction ellipse of horsepower against mpg_highway
Superimpose (overlay) the 95% ellipse for mpg_city

Do you think the default legend is used for this graph?

If not, suppress the default legend and give them customized names

Use legendlabel=“Custom label” in the ellipse statement
Place the legend on toright corner insider the graph.
*/

proc sgplot data=sashelp.cars;
ellipse y=mpg_city x=horsepower 
	/ name="el_city" legendlabel="95% Pred (City)";
ellipse y=mpg_highway x=horsepower
	/ name="el_highway" legendlabel="95% Pred (Highway)";
scatter y=mpg_city x=horsepower / transparency=.8;
scatter y=mpg_highway x=horsepower / transparency=.6;
keylegend "el_city" "el_highway" 
	/ location=inside position=topright across=1;
title 'Two Prediction Ellipse';
yaxis label="MPG";
xaxis label='Horsepower';
run;


** 25;
** Superimposed shaded ellipses;
** Draw three shaded ellipses for 
50% prediction ellipse
75% prediction ellipse
90% prediction ellipse
for mpg_city vs horsepower;

proc sgplot data=sashelp.cars;
ellipse x=mpg_city y=horsepower
	/ fill alpha=.05 name="e95" legendlabel="95% Prediction";
ellipse x=mpg_city y=horsepower
	/ fill alpha=.25 name="e75" legendlabel="75% Prediction";
ellipse x=mpg_city y=horsepower 
	/ fill alpha=.5 name="e50" legendlabel="50% Prediction";
scatter x=mpg_city y=horsepower;
keylegend "e50" "e75" "e95" 
	/ location=inside position=topright across=1;
title 'Three Prediction Ellipses';
run;


** 26;
** Histogram of  horsepower;
proc sgplot data=sashelp.cars;
histogram horsepower ;
title 'Histogram of Horsepower';
run;

proc sgplot data=sashelp.cars;
histogram horsepower 
	/ scale=count;
title 'Histogram of Horsepower';
run;

** 27;
** Histogram with NBINS;
proc sgplot data=sashelp.cars;
histogram horsepower 
	/ nbins=20 scale=count;
title 'Histogram of Horsepower';
run;

** 28;
** Histogram with NBINS and BINSTART;
proc sgplot data=sashelp.cars;
histogram horsepower 
	/ nbins=20 binstart=0 scale=count;
title 'Histogram of Horsepower';
run;

** 29;
** Use heart data and draw
two histograms side by side;
proc sgplot data=sashelp.heart;
histogram systolic ;
histogram diastolic / nofill;
run;

** 30;
** Use heart data and draw
two histograms side by side;
proc sgplot data=sashelp.heart;
histogram systolic /binstart=30 binwidth=10;
histogram diastolic /binstart=30 binwidth=10 nofill;
run;

proc sgplot data=sashelp.heart;
histogram systolic /binwidth=10;
histogram diastolic /binwidth=10 nofill;
run;

** 31;
title;
proc sgplot data=sashelp.cars;
vbox mpg_city / 
	category=type;
run;

proc sgplot data=sashelp.cars;
vbox mpg_city / 
	category=type group=drivetrain;
run;

