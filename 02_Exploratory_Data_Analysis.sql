
-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoff_stagings2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_stagings2;


SELECT *
FROM layoff_stagings2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off desc;


SELECT company, SUM(total_laid_off)
FROM layoff_stagings2
GROUP BY company
ORDER BY 2 DESC;


SELECT industry,
       SUM(total_laid_off) AS total_layoffs
FROM layoff_stagings2
GROUP BY industry
ORDER BY total_layoffs DESC;


SELECT country,
       SUM(total_laid_off) AS total_layoffs
FROM layoff_stagings2
GROUP BY country
ORDER BY total_layoffs DESC;


SELECT YEAR(`date`) AS layoff_year,
       SUM(total_laid_off) AS total_layoffs
FROM layoff_stagings2
GROUP BY layoff_year
ORDER BY layoff_year;


SELECT YEAR(`date`),
       SUM(total_laid_off)
FROM layoff_stagings2
GROUP BY YEAR(`date`)
ORDER BY 1;


SELECT stage,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`,
       SUM(total_laid_off)
FROM layoff_stagings2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_Total AS
(
    SELECT SUBSTRING(`date`,1,7) AS `MONTH`,
           SUM(total_laid_off) AS total_off
    FROM layoff_stagings2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC
)

SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total;	


WITH Company_Year AS
(
    SELECT company,
           YEAR(`date`) AS years,
           SUM(total_laid_off) AS total_laid_off
    FROM layoff_stagings2
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(
    SELECT *,
           DENSE_RANK() OVER
           (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)

SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;