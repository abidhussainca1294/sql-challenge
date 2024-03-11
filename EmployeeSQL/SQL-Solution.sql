-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "department" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_department" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(10)   NOT NULL,
    "emp_no" integer   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" varchar(10)   NOT NULL,
    "title" varchar(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" integer   NOT NULL,
    "emp_title_id" varchar(10)   NOT NULL,
    "birth_date" varchar(20)   NOT NULL,
    "first_name" varchar(50),
    "last_name" varchar(50),
    "sex" char(1),
    "hire_date" varchar(20)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" integer   NOT NULL,
    "salary" integer   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" integer   NOT NULL,
    "dept_no" varchar(10)   NOT NULL
);

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "department" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "department" ("dept_no");

--data check after importing csv
select * from department;  --9 records
select * from titles;      --7 records
select * from employees;   --300024 records
select * from salaries;    --300024 records
select * from dept_emp;	   --331603 records
select * from dept_manager;--24 records

----Analysis----
--Q1.
select emp.emp_no as "Employee Number", 
emp.first_name as "First Name", 
emp.last_name as "Last Name", 
emp.sex as "Sex",
sal.salary as "Salary"
from employees emp
inner join salaries sal
on emp.emp_no= sal.emp_no;

--Q2.
select first_name as "First Name",
last_name as "Last Name",
hire_date as "Hire Date"
from employees
where substring(hire_date,length(hire_date)-3,4)='1986';

--Q3.
select dept_mgr.dept_no as "Department Number", 
dept.dept_name as "Department Name",
dept_mgr.emp_no as "Employee Number",
emp.first_name as "First Name",
emp.last_name as "Last Name"
from dept_manager dept_mgr 
inner join department dept
on dept_mgr.dept_no=dept.dept_no
inner join employees emp
on dept_mgr.emp_no=emp.emp_no;

--Q4.
select first_name as "First Name",
last_name as "Last Name",
sex as "Sex"
from employees
where first_name = 'Hercules'
and last_name like 'B%';

--Q5.
select emp_no as "Employee Number",
last_name as "Last Name",
first_name as "First Name"
from employees
where emp_no in (
	select emp_no 
	from dept_emp
	where dept_no in (select dept_no from department where dept_name ='Sales'))
order by emp_no; 

--alternate solution	
select emp.emp_no as "Employee Number",
emp.last_name as "Last Name",
emp.first_name as "First Name"
from department dept 
inner join dept_emp dept_emp
on dept.dept_no= dept_emp.dept_no
inner join employees emp
on dept_emp.emp_no=emp.emp_no
where dept.dept_name='Sales'
order by emp.emp_no;

--Q7.
select emp.emp_no as "Employee Number",
emp.last_name as "Last Name",
emp.first_name as "First Name",
dept.dept_name as "Department Name"
from department dept 
inner join dept_emp dept_emp
on dept.dept_no= dept_emp.dept_no
inner join employees emp
on dept_emp.emp_no=emp.emp_no
where dept.dept_name in ('Sales','Development')
order by emp.emp_no;

--Q8.
select last_name as "Last Name",
count(*) as "Frequency"
from employees
group by last_name
order by count(*);
