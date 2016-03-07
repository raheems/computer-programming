
/*
File name: Module 1 - Sources of Info and Programming Organization.sas

Author: Enayetur Raheem
Created: Aug 23, 2014
Last Modified: Aug 25, 2014

This file is to be given to the class to complete a class activity
to demonstrate the topics covered in Module 1 of SRM 620 Fall 2014.

The following codes have been taken from 
http://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_reg_sect056.htm

Example 73.3 Predicting Weight by Height and Age

In this example, the weights of schoolchildren are modeled as a 
function of their heights and ages. The example shows the use of 
a BY statement with PROC REG, multiple MODEL statements, 
and the OUTEST= and OUTSSCP= options, which create data sets. 

Here are the data:
   *------------Data on Age, Weight, and Height of Children-------*
   | Age (months), height (inches), and weight (pounds) were      |
   | recorded for a group of school children.                     |
   | From Lewis and Taylor (1967).                                |
   *--------------------------------------------------------------*;
*/   

** To Do:
** 1. Create a program file and give it an appropriate name.
** 2. Comment appropriately 
** 3. Use indents and spaces to make the program easy to read; 

data htwt;
input sex $ age :3.1 height weight @@;
datalines;
f 143 56.3  85.0 f 155 62.3 105.0 f 153 63.3 108.0 f 161 59.0  92.0
f 191 62.5 112.5 f 171 62.5 112.0 f 185 59.0 104.0 f 142 56.5  69.0
f 160 62.0  94.5 f 140 53.8  68.5 f 139 61.5 104.0 f 178 61.5 103.5
f 157 64.5 123.5 f 149 58.3  93.0 f 143 51.3  50.5 f 145 58.8  89.0
m 164 66.5 112.0 m 189 65.0 114.0 m 164 61.5 140.0 m 167 62.0 107.5
m 151 59.3  87.0
;

proc reg outest=est1 outsscp=sscp1 rsquare;
by sex;
eq1: model  weight=height;
eq2: model  weight=height age;

proc print data=sscp1;
title2 'SSCP type data set';

** Print the est1 data set;
proc print data=est1;
title2 'EST type data set';
run;

