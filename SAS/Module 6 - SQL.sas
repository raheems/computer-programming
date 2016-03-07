
/*
Module 6: SAS SQL 
File name: Module 6 - SQL.sas
Created by Enayetur Raheem
Crated on Sep 9, 2014
Last modified: Sep 9, 2014
*/


** SQL is unique
** See the example below;
proc sql;
 select empid, jobcode, salary,
  salary*.06 as bonus
 from sasuser.payrollmaster
 where salary<32000
 order by jobcode;
quit;

proc contents data=sasuser.payrollmaster;
run;

** SELECTing columns;
proc sql;
	select 	empid, jobcode, salary,
			salary*.06 as bonus label="Bonus"
		from sasuser.payrollmaster
		where salary<32000
		order by jobcode;
quit;

** Activity 1
** Use the salay example and select 
rows for which salary is between 20,000 and 40,000;
proc sql;
select empid, jobcode, salary,
	salary*.06 as bonus
	from sasuser.payrollmaster
	where 20000<salary<40000;
quit;

* useing between-and option;
proc sql;
 select empid, jobcode, salary,
  salary*.06 as bonus
  from sasuser.payrollmaster
  where salary between 20000 and 40000
  ;
quit;

* Sort by salary (Descending);
proc sql;
select empid, jobcode, salary,
	salary*.06 as bonus
	from sasuser.payrollmaster
	where 20000<salary<40000
	order by salary desc;
quit;

** Inner Join: Joining tables horizontally;

* Verify that the salcomps data exists;
proc print data=sasuser.salcomps (obs=5);
run;

* Verify that the newsals data exists;
proc print data=sasuser.newsals (obs=5);
run;

* join the two tables by empID;
proc sql;
	select salcomps.empid, lastname,
	newsals.salary, newsalary
	from sasuser.salcomps, sasuser.newsals
	where salcomps.empid=newsals.empid
	order by empid;
quit;


** Summarizing groups of data;
proc contents data=sasuser.frequentflyers;
run;

proc sql;
select membertype, 
 sum(milestraveled) as TotMiles
 from sasuser.frequentflyers
 group by membertype
;
quit;

** HAVING clause with GROUP BY;
proc sql;
 select jobcode, avg(salary) as AvgSal
  from sasuser.payrollmaster
  group by jobcode
  having avg(salary)>40000
  order by jobcode
  ;
quit;

** displaying number of rows;
proc sql;
 select count(*) as Count
 from sasuser.heart
 ;
quit;

proc sql;
 select count(Shock) as Count
 from sasuser.heart
 ;
quit;


** INOBS=n;
proc sql inobs=10;
 select *
 from sasuser.heart
 ;
quit;

** OUTOBS=n;
proc sql outobs=5;
 select *
 from sasuser.heart
 ;
quit;

** INOBS=n;
proc sql inobs=10;
 select *
 from sasuser.heart
 where sex=1
 order by Heart
 ;
quit;

** OUTOBS=n;
proc sql outobs=5;
 select *
 from sasuser.heart
 where sex=1
 order by Heart
 ;
quit;


** Selecting all the columns;
proc sql;
 select *
 from sasuser.heart
 where sex=1
 ;
quit;


** Eliminating duplicate rows from output;
proc sql (outobs=10);
 select flightnumber, destination
 from sasuser.internationalflights
 ;
quit;

** Displaying unique rows;
proc sql;
 select distinct flightnumber, destination
 from sasuser.internationalflights
 ;
quit;

** sort the data by second column;
proc sql;
 select distinct flightnumber, destination
 from sasuser.internationalflights
 order by 2 desc
 ;
quit;


** Activity 2:
* Calculate average miles traveled by gold members
and present them by state;

proc sql;
 select membertype, avg(milestraveled) as AveMiles
 from sasuser.frequentflyers
 group by membertype
 having membertype='GOLD'
 ;
quit;

proc sql;
 select state,
  avg(milestraveled) as AveMiles
  from sasuser.frequentflyers
  where membertype='GOLD'
  group by state
  ;
quit;

proc sql;
 select state,
  avg(milestraveled) as AveMiles
  from sasuser.frequentflyers
  where membertype='GOLD'
  group by state
  order by state desc
  order by state
  ;
quit;


** Subsetting rows by calculated values;
proc sql;
 select flightnumber, date, destination,
  boarded+transferred+nonrevenue as Total
   from sasuser.marchflights
   ;
quit;

* You cannot use a where clause with this
calculated column;
proc sql;
 select flightnumber, date, destination,
  boarded+transferred+nonrevenue as Total
   from sasuser.marchflights
   where total <100
   ;
quit;

** USE KEYWORD CALCULATED;
proc sql outobs=5;
 select flightnumber, date, destination,
  boarded+transferred+nonrevenue as Total
   from sasuser.marchflights
   where CALCULATED total <100
   ;
quit;

** Operation on the calculated column;
** generates error;
proc sql outobs=10;
 select flightnumber, date, destination,
  boarded+transferred+nonrevenue as Total,
  calculated total/2 as Half
   from sasuser.marchflights
   where half <50
   ;
quit;

** Summary function with a single argument;
proc sql;
 select avg(salary) as AvgSalry
  from sasuser.payrollmaster
  ;
quit;

proc contents data=sasuser.payrollmaster;
run;

** Summary function with multiple arguments (cols);
proc sql outobs=5;
 select sum(boarded, transferred, nonrevenue) as total
  from sasuser.marchflights
  ;
quit;


* Using summary function with columns outside of 
the function;

proc sql;
 select avg(salary) as AvgSalary
 from sasuser.payrollmaster;
quit;

proc sql;
 select jobcode, avg(salary) as AvgSalary
 from sasuser.payrollmaster;
quit;


* Remerging Example;
proc contents data=sasuser.payrollmaster;
run;
proc sql;
 select jobcode
 from sasuser.payrollmaster
 where jobcode contains 'NA';
quit;

* Navigator's salary as percentage of
all navigator's salary;
proc sql;
 select empid, salary, (salary/sum(salary)) as Percent
  format=percent8.2
 from sasuser.payrollmaster
 where jobcode contains 'NA'
 ;
quit;



proc contents data=sasuser.marchflights;
run;


** Subquery;
** noncorrelated subquery;
proc sql;
 select jobcode, avg(salary) as AvgSalary format=dollar11.2
  from sasuser.payrollmaster
  group by jobcode
  having avg(salary) >
   (select avg(salary)
    from sasuser.payrollmaster)
	;
quit;


** Activity 3;
** SAS Advanced Prep Guide: p. 63
** Use sasuser.payrollmaster and see what variables 
are there.
 
Suppose you want to identify any flight attendants 
at level 1 or level 2 who are older than any of the 
flight attendants at level 3. 

Job type and level are identified in JobCode. 
each flight attendant has the job code 
FA1, FA2, or FA3;

proc sql;
 select empid, jobcode, dateofbirth
  from sasuser.payrollmaster
  where jobcode in ('FA1', 'FA2')
  	and dateofbirth <  
	(select dateofbirth 
	 from sasuser.payrollmaster
	 where jobcode='FA3')
  ;
quit;


* Testing;
proc sql outobs=5;
select min(dateofbirth)
from sasuser.payrollmaster;
quit;

proc sql;
 select empid, jobcode, dateofbirth
 from sasuser.payrollmaster
 where jobcode='FA1' or jobcode='FA2'
 and dateofbirth < min	(select dateofbirth 
	 from sasuser.payrollmaster
	 where jobcode='FA3');
 quit;


**************************;
** Correlated subquery;
**************************;

* contents of staffmaster databse;
proc contents data=sasuser.staffmaster;
run;

* what's in the EmpID variable?
* print the staffmaster data;
proc sql outobs=5;
 select lastname, firstname, empid
 from sasuser.staffmaster
 ;
quit;

* contents of supervisor database;
proc contents data=sasuser.supervisors;
run;

* What's in the jobcategory variable?
* prints the supervisor data;
proc sql outobs=10;
 select jobcategory
  from sasuser.supervisors
  ;
quit;

* Running the correlated subquery;
proc sql;
 select lastname, firstname
  from sasuser.staffmaster
  where 'NA'=
   (select jobcategory
   from sasuser.supervisors
   where staffmaster.empid = 
     supervisors.empid)
   ;
quit;

** Dry running a query;
proc sql noexec;
 select empid, jobcode
  from sasuser.payrollmaster
  ;
quit;

* Uses of validate option;
proc sql;
 validate
 select empid, jobcode
  from sasuser.payrollmaster
  ;
quit;



** Listing the missing values in a column;
proc sql;
	select boarded, transferred, nonrevenue, deplaned
	from sasuser.marchflights
	where boarded is missing;
quit;


****************
SQL Join
****************;
data one;
input X A $;
cards;
1 a
2 b
4 d
;
run;

data two;
input X B $;
cards;
2 x
3 y
5 v
;
run;

proc sql;
title 'Table one';
select * from one;

title 'Table two';
select * from two;

title 'Cartesian Product of One & Two';
select * from one,two;
quit;


* Innter join;
data one;
input X A $;
cards;
1 a
2 b
4 d
;
run;

data two;
input X B $;
cards;
2 x
3 y
5 v
;
run;

data three;
input X C $;
cards;
5 a
6 c
7 d
;
run;


* Cartesian join;
proc sql;
title 'Cartesian Join';
 select *
 from one, two, three;
quit;

* Innter join;
proc sql;
 title 'Inner Join';
 select *
 from one, two
 where one.x = two.x
 ;
quit;

title;

* Column alias;
proc sql;
 select one.x as ID, two.x, a, b
 from one, two
 where one.x=two.x;
quit;

* Table alias;
* why do you need it? - to avoid repeatedly typing
long table names;
proc sql outobs=5;
 select staffmaster.empid, lastname, firstname, jobcode
 from sasuser.staffmaster, sasuser.payrollmaster
 where staffmaster.empid=payrollmaster.empid;
quit;

* Table alias;
proc sql outobs=5;
 select s.empid, lastname, firstname, jobcode
 from sasuser.staffmaster as s, 
  sasuser.payrollmaster as p
 where s.empid=p.empid;
quit;

/** Example Inner Join;
You want to display the fistname and last name, 
job codes, and ages of all employees who live 
in New York. 

You want to sort the results by job code and age.
They are stored in two different tables

sasuser.staffmaster
sasuser.payrollmaster
*/

proc sql outobs=5;
 select * 
 from sasuser.staffmaster;
quit;

proc sql outobs=5;
 select * 
 from sasuser.payrollmaster;
quit;

* Joining these two tables;
proc sql outobs=10;
 select (firstname || lastname) as Name,
  jobcode, dateofbirth
  from sasuser.payrollmaster as p,
   sasuser.staffmaster as s
  where p.empid=s.empid and state='NY';
quit;


* Joining these two tables and showing
age, sorting by jobcode and then age;
proc sql outobs=10;
 select (firstname || lastname) as Name,
  jobcode, 
  int(today()-dateofbirth) as Age
 from 
  sasuser.payrollmaster as p,
  sasuser.staffmaster as s
 where 
  p.empid=s.empid 
  and state='NY'
 order by 2, 3;
quit;

* converting the ages to years;
proc sql outobs=10;
 select (firstname || lastname) as Name,
  jobcode, 
  int((today()-dateofbirth)/365.25) as Age
 from 
  sasuser.payrollmaster as p,
  sasuser.staffmaster as s
 where 
  p.empid=s.empid 
  and state='NY'
 order by 2, 3;
quit;
   

** Activity 4:
Modify the previous example to display the following summarized column for NY employees
- Number of employees in each job category
- Average age in each job category;

proc sql outobs=10;
title 'Average Age of NY Employees';
 select jobcode, count(p.empid) as Employees,
  avg (int((today()-dateofbirth)/365.25)) as AvgAge
  format=4.1
 from 
  sasuser.payrollmaster as p,
  sasuser.staffmaster as s
 where 
  p.empid=s.empid 
  and state='NY'
 group by jobcode
 order by jobcode;
quit;


** Outer Join;

* Left join;
title;

proc sql;
title 'Table One';
 select *
 from one;
quit;
proc sql;
title 'Table Two';
 select *
 from two;
quit;

* Left outer join;
proc sql;
 select * 
 from one 
  left join
  two
  on one.x=two.x;
quit;

* right outer join;
proc sql;
 select * 
 from one 
  right join
  two
  on one.x=two.x;
quit;

* Full outer join;
proc sql;
 select * 
 from one 
  full join
  two
  on one.x=two.x;
quit;

** Example of outer join;
/*
Suppose you want to list all of an airline’s 
flights that were scheduled for March, along with 
corresponding delay information (if exists). 

Each flight is identified by both a flight date 
and a flight number. Display the following:
Flight date, flight number, destination, and 
length of delay in minutes

Sasuser.marchflights
Sasuser.Flightdelays
*/

proc contents data=sasuser.marchflights;
run;

proc contents data=sasuser.flightdelays;
run;

proc sql outobs=15;
 select 
  mf.date, 
  mf.flightnumber, 
  mf.destination,
  fd.delay
 from sasuser.marchflights as mf
 left join sasuser.flightdelays as fd
  on mf.date=fd.date 
 and mf.flightnumber=fd.flightnumber
  order by fd.delay;
quit;


** Comparing SQL join and data step match-merge;



data one;
input X A $;
cards;
1 a
2 b
3 c
;
run;

data two;
input X B $;
cards;
1 x
2 y
3 z
;
run;

proc print data=one;
title 'One';
run;

proc print data=two;
title 'Two';
run;

* Compare when all of the values match;
* DATA step match-merge;
data merged;
 merge one two;
 by x;
run;

proc print data=merged noobs;
title 'Merged Table';
run;

* Compare when all of the values match;
* SQL inner join;
proc sql;
 title 'SQL Inner Join';
 select one.x, a, b
 from one, two
 where one.x=two.x;
quit;


** Compare when some of the values match;

* Data three;
data three;
input X A $;
cards;
1 a
2 b
4 d
;
run;

* data four;
data four;
input X B $;
cards;
2 x
3 y
5 v
;
run;

* Compare when some of the values match;
* DATA step match-merge;
data merged;
 merge three four;
 by x;
run;
proc print data=merged noobs;
title 'Merged Table';
run;

* Compare when some of the values match;
* PROC SQL full outer join;
proc sql;
title 'SQL Full Outer Join';
select three.x, a, b
from three
full join four
on three.x=four.x;
quit;


* PROC SQL full outer join
with COALESCE function;
proc sql;
title 'SQL Full Outer Join';
select coalesce(three.x, four.x) as X, a, b
from three

full join four
on three.x=four.x;
quit;


