create table food2(
id int primary key identity(1,1),
[name] varchar (50) not null,
quantity decimal(3,2) check (quantity>0), --smallest value:0.01
size char(1) not null, --s/m/l
category varchar(50),
price decimal(6,2) check (price>=20), --smallest value
isveg bit, --1,0,null
date datetime default getdate()
)

insert into food2([name],quantity,size,category,price,isveg,date)
values('momo',2,'m','snacks',200,1,default),
	  ('rice',2,'m','snacks',250,1,default),
      ('meat',2,'m','snacks',230,0,default),
      ('cauliflower',2,'m','snacks',210,0,default),
	  ('momo',2,'l','snacks',400,1,default),
	  ('momo',2,'l','snacks',400,1,default),
	  ('momo',2,'l','snacks',400,1,default),
	  ('momo',2,'s','snacks',100,1,default),
	  ('momo',2,'s','snacks',100,1,default),
	  ('momo',2,'s','snacks',100,1,default)
drop table food2

select* from food2

--listing only veg
select distinct [name] from food2 where isveg=0

--listing non-veg
--select distinct [name] from food2 where isveg=1
/*select name 
from food
	where isnull(isveg,0)=0 group by [name]*/

-- list the veg food only
select distinct [name] from food2 where isveg=1

--list only the non-veg food.
select distinct [name] from food2 where isveg=0

--list the snacks order today.
SELECT * FROM food2 where category='snacks' and convert(date,date)=CONVERT(date,getdate())

--LIST THE FOOD THAT STARTS WITH 'C'
SELECT * FROM food2 WHERE [name] LIKE 'C%'

--list the food items that were ordered before december 7, 2022
select [name] from food2 where convert(date,[date])<'2022/12/7'

--list the food available and sort them alphabetically
select  [name] from food2 order by name

--what are the non-veg food that are pricier than 150
select [name] from  food2 where isveg=0 and price>150

--list food that were ordered yesterday and today
select [name] from food2 where convert(date,date)=CONVERT(date,getdate()) and convert(date,date)<CONVERT(date,date()


--list the total number of large, medium, and small pizza served. show the result as
--	pizza	total
--	l		10
--	m		8
--	s		5

select 
	case size when 1 then 'veg'		
		when  'm' then 'medium' 
		when 's' then 'small'
		end 
	momo, 
	sum(quantity) total 
	from food2 
	where [name] like '%momo%' 
	group by size 

/*
--single condition
	case condition then truepart else false part

--multiple condition
	case condition1 then truepart
	case condition2 then truepart 
	else falsepart
	end
*/

--write a query to show the name of food and its type
--show the result as
/*	name			type of food
	pizza			veg
	chicken momo	non-veg
	momo			non-veg
*/

select distinct [name] ,
	case isveg when '0' then 'non-veg'		
		when '1' then 'veg' 
		end as [type of food]
	from food2 

/*
13. how many unis of momos were sold on december 2022?
14. how many units of momos are sold on last staurday?
15. list the category and the cheapest food.
16. list the category and the total price of food sold in each category. sort by total sales descending.
17. list the category of food and their total sales whose total sales is more than 500 and sort them by total price in descending order.

Assignment 

18. create table ingredients to store the ingredients of each food.
		table:ingredients
		columns:id(pk)
		foodid(fk)
		ingredient
		unit>0
		isliquid default 0 */



--1)what are the ingredients of momo?

/*create table ingredients to store the ingredients of each food.
table: ingredients
columns : Id
		foodid(fk)
		unit
		isliquid
	*/
		 

create table ingredients(
id int primary key identity(1,1),
foodid int foreign key references food2 (id),
ingredients varchar (100),
units decimal(7,2) check (units>0),
Isliquid bit
)

insert into ingredients(foodid,ingredients,units,Isliquid)
	values(1,'flour',500,0),
	(1,'chicken',200,0),
	(1,'water',100,1),
	(1,'vegitables',300,0)

	drop table ingredients
	select * from food2
	select * from ingredients

select i.ingredients
	 from food2 f
		inner join ingredients i
		on f.id = i.foodid 
		where f.name like '%momo%'

--1-what are the solid ingredients of momos?

select i.ingredients
	 from food2 f
		inner join ingredients i
		on f.id = i.foodid 
		where f.name like '%momo%' and isliquid = 0

--2-how many kilos of flour has been used till date?

select  sum (i.units) flour
	 from food2 f
		inner join ingredients i
		on f.id = i.foodid 
		where i.ingredients = 'flour' 

--3-how many kilos of flour has been used till date?

/* select  sum (i.units)/1000 flour
	 from food2 f
		inner join ingredients i
		on f.id = i.foodid 
		where i.ingredients = 'flour'
		*/

		select sum(units)/1000  
			flour FROM ingredients
			where ingredients = 'flour'

--4-list the ingredients and their total weight.

select ingredients , sum(units)/1000  
			[total weight] FROM ingredients
			group by ingredients
		
--5-list the food and total weight of only solid items.

select f.[name],[totalweight]=sum(i.units)
from food2 f
inner join ingredients i
on f.id=i.foodid
where i.isliquid=0
group by name

--6-list the food in which liquid has not been used.
select distinct f.[name]
from food2 f
inner join ingredients i
on f.id=i.foodid
where isliquid=0

--7-List the food and total weight of ingredients used to prepare the food . if there are no ingredients then show 0
--show the result as
/*
food             solid		liquid
cauliflower		800			200
momo			500			300
meat			1000		0
rice			0			0
*/


--CASE WHEN COLUMN = VALUE THEN DO THIS ELLSE DO THIS 
-- CASE WHEN CONDITION TRUE ELSE FALSE




select f.name food2,
SUM(case when i.isliquid =0 THEN i.units ELSE 0 END ) SOLID,
SUM(case when i.isliquid =1 THEN i.units ELSE 0 END ) LIQUID 
from food2 f
left outer join ingredients i
on f.id=i.foodid
GROUP BY NAME

--list the food that do not have any ingredients 
select f.name from food f 
inner join ingredients i
on f.id=i,foodid
where ingredients=null

/*table variables and temporary tables
------
1.create table variable to store only the food that start with c.*/


declare @foodstartwithC table(
	foodname varchar(100)
)
--select * from @foodstartwithC

insert into @foodstartwithC(foodname)
select distinct name
	from food2
	where name like 'c%'

	select * from @foodstartwithC




---table variable




select distinct name
	from food2
	where name like 'c%'


/*2) create a table variable to store the food that contain chicken*/
declare @foodwithingredientschicken table(
foodname  varchar(100)
)

insert into @foodwithingredientschicken(foodname)
select distinct f.name
	from food2 f  inner join ingredients i on f.id=i.foodid where i.ingredients='chicken'

select * from @foodwithingredientschicken

--creat a temporary table to sstore the number of veg and non veg item sold in year.
create table students(
	 roll int identity(1,1),
	 name varchar(100)
	 )

	 insert into students(name)
	 values ('ram'),('rajendra'),('rabi'),('shaya')
	 
create table #students2(
	 name varchar(100)
)

insert into #students2 (name)
select name from students where name like 'r%'

select * from students
