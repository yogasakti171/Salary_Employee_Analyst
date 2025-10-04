/* CREATE NEW TABLE */
create table salary(
	age_emp int,
	gender text,
	edu_level text,
	job_title text,
	year_exp decimal,
	salary_emp int
)

/* IMPORT DATASET */
COPY salary(age_emp, gender, edu_level, job_title, year_exp, salary_emp)
FROM 'D:\Salary Data\Salary_Data.csv'
DELIMITER ','
CSV HEADER;

select * from salary;

/* DATA CLEANING */
/* 1. delete null values */
select * from salary 
	where job_title is null
	or age_emp is null
	or gender is null
	or edu_level is null
	or year_exp is null
	or salary_emp is null;
	
delete from salary 
	where job_title is null
	or age_emp is null
	or gender is null
	or edu_level is null
	or year_exp is null
	or salary_emp is null;

/* FIX INCONSISTENT DATA */
update salary_clean set edu_level = 'Bachelor' where edu_level ilike 'bachelor%'
update salary_clean set edu_level = 'Master' where edu_level ilike 'master%'
update salary_clean set edu_level = 'Phd' where edu_level ilike 'phd%'

select distinct job_title from salary_clean order by job_title asc;
select distinct edu_level from salary_clean

/* check duplicate values/rows */
select age_emp, gender, edu_level, job_title, year_exp, salary_emp, count(*) from salary 
group by age_emp, gender, edu_level, job_title, year_exp, salary_emp
having count(*)>1;	

/* Create NEW TABLE WITHOUT DUPLICATE VALUES/ROWS */
create table salary_clean as select distinct * from salary;
select count(*) from salary_clean;
select * from salary_clean;

/* CLEAN OUTLINER VALUES */
delete from salary_clean
where salary_emp <1000 or salary_emp >300000;

delete from salary_clean
where age_emp < 30 and year_exp >= 12;

select * from salary_clean where salary_emp < 1000;
/* AGE */
select * from salary_clean
select max(age_emp) as maximum_age, min(age_emp) as minimum_age from salary_clean

alter table salary_clean
add column age_category text;

update salary_clean set age_category =
case
	when age_emp between 21 and 26 then 'Gen Z'
	when age_emp between 27 and 42 then 'Millenial'
	when age_emp between 43 and 54 then 'Genn X'
	when age_emp between 55 and 62 then 'Baby Boomer'
	else 'Other'
end;

select job_title,age_category, count(age_category) as total_age from salary_clean group by job_title, age_category order by total_age desc;

/* ADD COLUMN EXP_CATEGORY */
select max(year_exp) as maximum_exp, min(year_exp) as minimum_exp from salary_clean

/* 1. add new column */
alter table salary_clean 
add column exp_category text;

/* 2. rename new column */
alter table salary_clean
rename exp_category to exp_level;

/* update column velues */
update salary_clean set exp_level =
case
	when year_exp between 0 and 2 then 'Entry'
	when year_exp between 3 and 7 then 'Mid'
	when year_exp>=8 then 'Senior'
	else 'Other'
end;

/* EDA */
/* JOB TITLE HAS A HIGHEST SALARY  */
select job_title, max(salary_emp) as highest_salary from salary_clean 
group by job_title order by highest_salary desc limit 10;

/* AVERAGE SALARY BY EXPERIENCE LEVEL */
select exp_level, avg(salary_emp) as average_salary from salary_clean
group by exp_level order by average_salary desc;

/* AVERAGE SALARY BY EDUCATION LEVEL */
select edu_level, avg(salary_emp) as average_edu_salary from salary_clean
group by edu_level order by average_edu_salary desc;

select gender, count(gender) from salary_clean group by gender order by count(gender) desc;





