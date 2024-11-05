-- expolatory data analysis

select * from layoff_copy2;

select max(total_laid_off), max(percentage_laid_off) from layoff_copy2;

select * from layoff_copy2 where percentage_laid_off = 1 order by funds_raised_millions desc; 

select * from layoff_copy2 where percentage_laid_off = 1 order by total_laid_off desc;

select company,sum(total_laid_off) from layoff_copy2 group by company order by 2 desc ;

select min(`date`),max(`date`) from layoff_copy2;

select year(`date`),sum(total_laid_off) from layoff_copy2 group by year(`date`) order by 1 desc ;

select stage,sum(total_laid_off) from layoff_copy2 group by stage order by 2 desc ;

select * from layoff_copy2;

select stage,sum(percentage_laid_off) from layoff_copy2 group by stage order by 2 desc ;

SELECT 
    SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM
    layoff_copy2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;


WITH rolling_total AS
( 
select substring(`date`,1,7) as `MONTH` , sum(total_laid_off) as total_off
from layoff_copy2
where substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc
)
select `MONTH`,total_off
,sum(total_off) over (order by `MONTH`) AS ROLLING_TOTAL from rolling_total;

select company,YEAR(`date`),sum(total_laid_off)
 from layoff_copy2 
 group by company ,YEAR (`date`)
 order by 3 desc  ;

with company_year (company,years,total_laid_off)as -- naming the columns
(
select company,YEAR(`date`),sum(total_laid_off)
from layoff_copy2 
group by company ,YEAR (`date`)
),
comapny_year_rank as(
select *,dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * from comapny_year_rank where ranking <= 5;
select * from comapny_year_rank where ranking <= 5 and years = 2020;






































































































