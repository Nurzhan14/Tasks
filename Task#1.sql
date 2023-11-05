
create table public.workers(
id integer primary key,
full_name varchar(30),
job_start date,
job_position varchar(30),
dpmt_id integer references departments(id)
)

drop table employers

create table public.employers(

id integer primary key,
max_employee_num integer

)


create table public.departments(
id integer primary key,
title text
)



create table public.employees(
id integer primary key,
employer_id integer references employers(id)
)

create table public.salaries(
worker_id integer primary key,
salary integer)


insert into workers 
Values(1, 'Давид Манукян', '2015-10-20', 'PM', 10),
	(2, 'Давид Микеланджело', '2019-01-05', 'HR', 30),
	(3, 'Давид Вилья', '2023-10-05', 'HR', 30),
	(4, 'Джон Сноу', '2021-01-05', 'Cyber sec', 20),
	(5, 'Майкл Стоунбрейкер', '1986-01-01', 'PM', 10)
	
select * from workers

insert into employers 
Values(1, 3), (5, 4)

insert into employees 
values (2, 1),
	(3, 5),
	(4, 5)
	
insert into departments 
values (10, 'Management and Planning'),
	(20, 'Security and Maintenance'),
	(30, 'Human resources')
	
insert into salaries 
values(1, 60000), 
		(2, 110000),
		(3, 300000),
		(4, 120000),
		(5, 500000)
		
--1
		
select full_name, slrs.salary, job_position from workers wrks
join departments dps on wrks.dpmt_id=dps.id
join salaries slrs on wrks.id=slrs.worker_id
where full_name like 'Давид%' and dps.title='Management and Planning' 

--2
select dps.title, AVG(slrs.salary) from workers wrks
join salaries slrs on wrks.id=slrs.worker_id
join departments dps on dps.id=wrks.dpmt_id 
group by dps.title

--3
select 
distinct job_position, 
AVG(slrs.salary) over (partition by job_position), 
case 
	when AVG(slrs.salary) over (partition by job_position)> AVG(slrs.salary) over() then 'YES' 
	else 'NO' 
end as "bigger"
from workers wrks
join salaries slrs on wrks.id=slrs.worker_id



--4 
CREATE or replace VIEW jobs_v AS
SELECT
  wrks.job_position AS "Должность",
  dps.title AS "Отделы",
  JSON_AGG(
    JSON_BUILD_OBJECT(
      'Сотрудник', wrks.full_name,
      'Дата_приема', wrks.job_start
    ) ORDER BY wrks.full_name
  ) FILTER (WHERE wrks.job_start >= '2021-01-01') AS "Список сотрудников с начала 2021 года",
  AVG(slrs.salary) AS "Средняя ЗП"
FROM
  workers wrks
  JOIN departments dps ON wrks.dpmt_id = dps.id
  LEFT JOIN salaries slrs ON wrks.id = slrs.worker_id
  where wrks.job_start>='2018-01-01'
GROUP BY wrks.job_position, dps.title
ORDER BY wrks.job_position, dps.title

select * from jobs_v


	
