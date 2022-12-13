use wasimdb;
-- Query 1:Write a SQL query to fetch all the duplicate records from a table.
/*create table users(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50)
);*/
/*insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');*/

-- Query 1:Write a SQL query to fetch all the duplicate records from a table.
select * from users;

select user_name from (
	select * ,
	row_number() over(partition by user_name order by user_id) as rn
	from users 
) as x
where x.rn > 1

select * from employee
-- Query 2: Write a SQL query to fetch the second last record from a employee table.
select emp_id,emp_name,dept_name,salary from (
	select * ,row_number() over(order by emp_id desc) as rnn
	from employee
) as xyz
where xyz.rnn = 2

/* Write a SQL query to display only the details of employees 
who either earn the highest salary or the lowest salary in each department from the employee table
	*/
select * from employee
select x.* from employee e join 
(
	select *,max(salary) over(partition by dept_name) as max_salary,
	min(salary) over(partition by dept_name ) as min_salary 
	from employee) as x
on x.emp_id = e.emp_id
where x.emp_id = e.emp_id and (x.max_salary = e.salary or x.min_salary = e.salary)
    
    
select x.* from employee e join(

	select e.* ,
	max(salary) over (partition by dept_name  ) as max_salary,
	min(salary) over (partition by dept_name  ) as min_salaty
	 from employee e ) as x
on e.emp_id = x.emp_id 
where e.emp_id = x.emp_id and ( e.salary = x.max_salary or e.salary=x.min_salaty)


select x.*
from employee e 
join 
(select *,
max(salary) over (partition by dept_name) as max_salary,
min(salary) 
over (partition by dept_name) as min_salary
from employee) x
 
on e.emp_id = x.emp_id 
and (e.salary = x.max_salary or e.salary = x.min_salary)

order by x.dept_name, x.salary;

-- Query 4:From the doctors table, 
-- fetch the details of doctors who work in the same hospital but in different speciality.
/*create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);*/

/*insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);*/

select * from doctors;

select d1.* 
from doctors d1 join doctors d2
where d1.id <> d2.id and d1.hospital = d2.hospital and d1.speciality <> d2.speciality

-- Query 5: From the login_details table, fetch the users who logged in consecutively 3 or more times.
select * from login_details;
-- Table Structure:

use wasimdb
drop table login_details ;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date + interval 1 day),
(104, 'Stewart', current_date + interval 1 day),
(105, 'Stewart', current_date+ interval 1 day),
(106, 'Michael', current_date+ interval 2 day),
(107, 'Michael', current_date+ interval 2 day),
(108, 'Stewart', current_date + interval 3 day),
(109, 'Stewart', current_date + interval 3 day),
(110, 'James', current_date + interval 4 day),
(111, 'James', current_date + interval 4 day),
(112, 'James', current_date + interval 5 day),
(113, 'James', current_date + interval 6 day);

select * from login_details;



select xyzz.user_name from (
		select *,
				case
					when user_name = lead(user_name) over(order by login_id) and user_name = lead(user_name,2) over(order by login_id)
					then user_name
					else null
					end as userrr
					
		from login_details
) as xyzz
where xyzz.userrr is not null

create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

-- write a SQL query to interchange the adjacent student names.
-- lead syntax
/*LEAD(expr, N, default) 
          OVER (Window_specification | Window_name)*/
          
select * from students;

select id,student_name,
	case
		when id% 2 <> 0 then lead(student_name,1,student_name) over()
        when id % 2 = 0 then lag(student_name,1,student_name) over() 
	end as new_student 
from students

-- Query 7:From the weather table, 
-- fetch all the records when London had extremely cold temperature for 3 consecutive days or more .
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
use wasimdb
drop table weather;

insert into weather values
(1, 'London', -1, str_to_date('2021 01 01','%Y %c %d')),
(2, 'London', -2, str_to_date('2021 01 02','%Y %c %d')),
(3, 'London', 4, str_to_date('2021 01 03','%Y %c %d')),
(4, 'London', 1, str_to_date('2021 01 04','%Y %c %d')),
(5, 'London', -2, str_to_date('2021 01 05','%Y %c %d')),
(6, 'London', -5, str_to_date('2021 01 06','%Y %c %d')),
(7, 'London', -7, str_to_date('2021 01 07','%Y %c %d')),
(8, 'London', 5, str_to_date('2021 01 08','%Y %c %d'));

select * from weather;
select  xyz.id,xyz.city,xyz.temperature,xyz.day
from(
	select *,
		case
			when temperature < 0 and lead(temperature,1) over(order by id )<0 and lead(temperature,2) over(order by id ) < 0 then "Y"
			when temperature < 0 and lag(temperature,1) over(order by id ) < 0 and lead(temperature,1) over(order by id ) <0 then "Y"
			when temperature <0 and lag(temperature,1) over(order by id ) < 0 and lag(temperature,2) over(order by id ) <0 then "Y"
			end as Flag
	from weather w
) as xyz
 where xyz.Flag ="Y"

-- write a SQL query to get the histogram of specialities of the unique physicians
-- who have done the procedures but never did prescribe anything.
select * from physician_speciality;
select * from patient_treatment;
select * from event_category;

create table event_category
(
  event_name varchar(50),
  category varchar(100)
);

create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);

insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');

insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');

insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);


select * from patient_treatment;
select * from physician_speciality;
select * from event_category;

use wasimdb

select ps.speciality, count(1) as speciality_count
from patient_treatment pt
join event_category ec on ec.event_name = pt.event_name
join physician_speciality ps on ps.physician_id = pt.physician_id
where ec.category = 'Procedure'
and pt.physician_id not in (select pt2.physician_id
							from patient_treatment pt2
							join event_category ec on ec.event_name = pt2.event_name
							where ec.category in ('Prescription'))
group by ps.speciality;

-- Query 9:Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);
-- to_date ki jagah hum str_to_date use karte hai
insert into patient_logs values (1, str_to_date('02-01-2020','%d-%m-%Y'), 100);
insert into patient_logs values (1, str_to_date('27-01-2020','%d-%m-%Y'), 200);
insert into patient_logs values (2, str_to_date('01-01-2020','%d-%m-%Y'), 300);
insert into patient_logs values (2, str_to_date('21-01-2020','%d-%m-%Y'), 400);
insert into patient_logs values (2, str_to_date('21-01-2020','%d-%m-%Y'), 300);
insert into patient_logs values (2, str_to_date('01-01-2020','%d-%m-%Y'), 500);
insert into patient_logs values (3, str_to_date('20-01-2020','%d-%m-%Y'), 400);
insert into patient_logs values (1, str_to_date('04-03-2020','%d-%m-%Y'), 500);
insert into patient_logs values (3, str_to_date('20-01-2020','%d-%m-%Y'), 450);

select * from patient_logs;

select * from (
	select * ,row_number() over(partition by month order by no_of_patient desc) as rn from(
			select month,account_id,count(distinct(patient_id))as no_of_patient from (
					select date_format(date,'%M') as month,account_id,patient_id 
					from patient_logs) as xyz
			group by 1,2
	) uvw
) abc
where abc.rn<3

-- Query 10
-- Finding n consecutive records where temperature is below zero. And table has a primary key.
