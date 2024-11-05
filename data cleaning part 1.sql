-- data cleaning

select * from layoffs;
-- 1. Remove duplicate
-- 2. standardize 
-- 3. null or blank values
-- 4. remove any columns 



create table layoff_copy
like layoffs;

select * from layoff_copy ;
INSERT layoff_copy select * from layoffs;

select *, row_number() over( partition by company,industry,total_laid_off,percentage_laid_off ,`date`) as row_num 
from layoff_copy ; 

with duplicate_cte as
( 
select *, row_number() over( partition by company, location
,industry,total_laid_off,percentage_laid_off ,`date`, stage,country,funds_raised_millions) 
as row_num 
from layoff_copy 
)
select *from duplicate_cte
where row_num >1;

select* from layoff_copy where company = 'casper';
 
-- we cant use delete  or any update statement directly in my sql so we will copy the layoff_copy create statemnet and then create a new  blank table if we want to delete a row or a table with row_num


select *, row_number() over( partition by company, location
,industry,total_laid_off,percentage_laid_off ,`date`, stage,country,funds_raised_millions) 
as row_num 
from layoff_copy ;
 
DROP TABLE IF EXISTS layoff_copy2;

CREATE TABLE `layoff_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `row_num` INT,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



select * from layoff_copy2 ; -- empty table

insert into layoff_copy2 -- insert into empty table
select * , row_number() over( partition by company, location
,industry,total_laid_off,percentage_laid_off ,`date`, stage,country,funds_raised_millions) 
as row_num 
from layoff_copy;

select * from layoff_copy2 ;

delete from layoff_copy2 where row_num>1;
 
select * from layoff_copy2 where row_num>1;
select * from layoff_copy2 ;
-- standardizing data

select company, trim(company) from layoff_copy2;

update layoff_copy2
set company = trim(company);

select distinct(company) from layoff_copy2;

select distinct(industry) from layoff_copy2 order by 1;

select * from layoff_copy2 where industry like 'crypto%';

update layoff_copy2 set industry = 'Crypto' where industry like 'crypto%';

select distinct country ,trim(TRAILING '.' from country )from layoff_copy2 order by 1;

update layoff_copy2
set country = trim(TRAILING '.' from country ) 
where country like 'United States% ';


-- change date as text as data data type

select `date`,
str_to_date(`date`,'%m/%d/%Y') 
from layoff_copy2;

update layoff_copy2 set `date`= str_to_date(`date`,'%m/%d/%Y') ;

select `date` from layoff_copy2;

alter table  layoff_copy2 modify column `date` date ; -- only do it in a copy 


select * from layoff_copy2
where total_laid_off is null
and percentage_laid_off is null;

select distinct industry 
from layoff_copy2 
where industry is null or industry = ' ';

select distinct *
from layoff_copy2 
where company ='E Inc.';                               

select * from layoff_copy2 AS t1
join layoff_copy2 AS t2
	on t1.company= t2.company
    and t1.location= t2.location
where (t1.industry is null or t1.industry = ' ')
and t2.industry is not null;

update layoff_copy2 
set industry = null
where industry = ' ';

 update layoff_copy2  as t1
 join layoff_copy2 as t2
	on t1.company= t2.company
	set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;


select * from layoff_copy2;


select * from layoff_copy2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoff_copy2
where total_laid_off is null
and percentage_laid_off is null;

select * from layoff_copy2;

alter table layoff_copy2 drop column row_num;

select * from layoff_copy2;









































