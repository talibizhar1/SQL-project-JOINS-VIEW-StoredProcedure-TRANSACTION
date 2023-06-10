/*********************************************MySQL script of Final Project*******************************************/
/*************** Task A: Create a database ***************/ 
I downloaded the  datasets available in ‘.sql ‘ format and imported all the tables one by one in MySQL database ‘practicedb’ by 
running the SQL script. We can see tables available in the database by querying  show tables; 
*  Meta Data
* I wrote a query ‘desc <table name>’ to find the data type and dimension of each table.
1. Chicago Public School- Table has 566 rows & 78 columns.
2. Chicago Crime data-  This table has 21 columns and 533 row
3. Socioeconomic table named Census Data- 6 Census data has only 9 columns and 77 rows 

/**********Task B: Answer the questions**************/
-- Question 1
-- Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
/*Census data and school data has common column community area number*/
SELECT cps.NAME_OF_SCHOOL, cps.COMMUNITY_AREA_NAME, cps.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools cps 
JOIN census_data cs
USING(COMMUNITY_AREA_NUMBER)
WHERE cs.HARDSHIP_INDEX =98;

/*Question 2
Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.*/
SELECT ccd.CASE_NUMBER, ccd.PRIMARY_TYPE, cd.COMMUNITY_AREA_NAME
FROM chicago_crime_data ccd 
JOIN census_data cd
USING(COMMUNITY_AREA_NUMBER)
WHERE ccd.LOCATION_DESCRIPTION LIKE '%School%';

/*Exercise 2: Creating a View
Question 1
Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in
 the second column. */
 /*Query to create View*/
CREATE VIEW chicago_school_info(School_Name,Safety_Rating,Family_Rating,Environment_Rating,Instruction_Rating,Leaders_Rating,Teachers_Rating)
AS SELECT NAME_OF_SCHOOL,Safety_Icon, Family_Involvement_Icon, Environment_Icon,Instruction_Icon, Leaders_Icon, Teachers_Icon
FROM CHICAGO_PUBLIC_SCHOOLS;
-- Write and execute a SQL statement that returns all of the columns from the view.
SELECT * FROM chicago_school_info;
-- Write and execute a SQL statement that returns just the school name and leaders rating from the view.
SELECT school_name, leaders_rating FROM chicago_school_info;

/*Exercise 3: Creating a Stored Procedure
Question 1
Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as
 an integer and a in_Leader_Score parameter as an integer. */
 /*Structure of Stored procedure in MySQL*/
DELIMITER //
CREATE   PROCEDURE `UPDATE_LEADERS_SCORE`(in_School_ID int, in_Leader_Score int)
BEGIN

END //

/* Question 2
Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for 
the school identified by in_School_ID to the value in the in_Leader_Score parameter*/
DELIMITER //
CREATE   PROCEDURE `UPDATE_LEADERS_SCORE` (in_School_ID  int, in_Leader_Score int)
BEGIN
/********Update statement begins********/
 UPDATE CHICAGO_PUBLIC_SCHOOLS
 SET Leaders_Score = in_Leader_Score
 WHERE School_ID = in_School_ID ;
/******Update statement ends******/
END //
/* Question 3
Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the 
school identified by in_School_ID using the following information.*/
/*Complete query of stored procedure*/
DELIMITER //
CREATE   PROCEDURE `UPDATE_LEADERS_SCORE` (IN in_School_ID  int,IN in_Leader_Score  int)
BEGIN
 UPDATE CHICAGO_PUBLIC_SCHOOLS
 SET Leaders_Score = in_Leader_Score
 WHERE School_ID = in_School_ID ;
/****If statement begins****/
  IF in_Leader_Score >0 AND in_Leader_Score <20
  THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
  SET Leaders_Icon ='Very Weak'
  WHERE School_ID = in_School_ID;
  ELSEIF in_Leader_Score < 40
  THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
  SET Leaders_Icon ='Weak'
  WHERE School_ID = in_School_ID;
  ELSEIF in_Leader_Score < 60
  THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
  SET Leaders_Icon ='Average'
  WHERE School_ID = in_School_ID;
  ELSEIF in_Leader_Score < 80
  THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
  SET Leaders_Icon ='Strong'
  WHERE School_ID = in_School_ID;
  ELSEIF in_Leader_Score < 100
  THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
  SET Leaders_Icon ='Very Strong'
  WHERE School_ID = in_School_ID;
  
  END IF;
  /****If statement ends****/
END //

/* Question 4

Run your code to create the stored procedure.
Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected.*/
call UPDATE_LEADERS_SCORE(610084,50);
/*To check the result*/
select School_ID, leaders_icon, Leaders_Score from CHICAGO_PUBLIC_SCHOOLS where School_ID=610084;
/*Exercise 4: Using Transactions
Question 1
Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories. */
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_LEADERS_SCORE`(in_School_ID  int,in_Leader_Score  int)
BEGIN
/*TRANSACTION STATEMENT BEGINS*/ 
START TRANSACTION;
/*Here is the update code*/
   /*ELSE STATEMENT IF ABOVE 100 THEN ROLL BACK*/
   ELSE  
   ROLLBACK;
END IF;
END
/*Question 2
Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure. */
/*Here is complete query, commit added after if statement ends*/
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_LEADERS_SCORE`(in_School_ID  int,in_Leader_Score  int)
BEGIN
 START TRANSACTION;
  UPDATE CHICAGO_PUBLIC_SCHOOLS
  SET Leaders_Score = in_Leader_Score
  WHERE School_ID = in_School_ID ;

  IF in_Leader_Score >0 AND in_Leader_Score <20
   THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
   SET Leaders_Icon ='Very Weak'
   WHERE School_ID = in_School_ID;
   ELSEIF in_Leader_Score < 40
   THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
   SET Leaders_Icon ='Weak'
   WHERE School_ID = in_School_ID;
   ELSEIF in_Leader_Score < 60
   THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
   SET Leaders_Icon ='Average'
   WHERE School_ID = in_School_ID;
   ELSEIF in_Leader_Score < 80
   THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
   SET Leaders_Icon ='Strong'
   WHERE School_ID = in_School_ID;
   ELSEIF in_Leader_Score < 100
   THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
   SET Leaders_Icon ='Very Strong'
   WHERE School_ID = in_School_ID;
   ELSE  
   ROLLBACK;
END IF;
  COMMIT;
  
END
/* End of code*/
