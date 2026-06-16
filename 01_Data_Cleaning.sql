-- DATA CLEANING PROJECT

-- DELETING DUPLICATE DATA

CREATE TABLE layoff_stagings
LIKE layoffs;

SELECT *
FROM layoff_stagings; 

INSERT layoff_stagings
SELECT *
FROM layoffs;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,'date') AS row_num
FROM layoff_stagings
)
DELETE
FROM duplicate_cte
WHERE row_num>1;

CREATE TABLE `layoff_stagings2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_stagings2;

INSERT INTO layoff_stagings2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,'date') AS row_num
FROM layoff_stagings;
DELETE
FROM layoff_stagings2
WHERE row_num>1;


-- STANDARDIZING DATA

SELECT company, trim(company)
FROM layoff_stagings2;

UPDATE layoff_stagings2
SET company=trim(company);

SELECT *
FROM layoff_stagings2
WHERE industry LIKE 'CRYPTO%';

UPDATE layoff_stagings2
SET industry='CRYPTO'
WHERE industry like 'CRYPTO%';


SELECT DISTINCT country,trim(trailing '.' from country)
FROM layoff_stagings2
ORDER BY 1;

UPDATE layoff_stagings2
SET country=trim(trailing '.' from country)
WHERE country like 'UNITED STATES%';

SELECT `date`
FROM layoff_stagings2;

UPDATE layoff_stagings2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoff_stagings2
modify column `date` DATE;

SELECT `date`
FROM layoff_stagings2;


SELECT *
FROM layoff_stagings2 t1
JOIN layoff_stagings2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;
  
  
  UPDATE layoff_stagings2 t1
JOIN layoff_stagings2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;
  
  
SELECT *
FROM layoff_stagings2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoff_stagings2 t1
JOIN layoff_stagings2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoff_stagings2 t1
JOIN layoff_stagings2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


SELECT *
FROM layoff_stagings2
WHERE industry IS NULL
OR industry = '';

SELECT COUNT(*)
FROM layoff_stagings2
WHERE industry IS NULL
OR industry = '';


SELECT company, industry
FROM layoff_stagings2
WHERE company IN ('Airbnb', 'Bally''s Interactive', 'Carvana', 'Juul');


UPDATE layoff_stagings2 t1
JOIN layoff_stagings2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoff_stagings2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoff_stagings2
WHERE company = 'Airbnb';


UPDATE layoff_stagings2
SET industry = CASE
    WHEN company = 'Airbnb' THEN 'Travel'
    WHEN company = 'Carvana' THEN 'Transportation'
    WHEN company = 'Juul' THEN 'Consumer'
    ELSE industry
END
WHERE company IN ('Airbnb', 'Carvana', 'Juul')
  AND (industry IS NULL OR industry = '');
  
  SELECT *
FROM layoff_stagings2
WHERE industry IS NULL
   OR industry = '';
   
   
   -- Check remaining NULLs
SELECT *
FROM layoff_stagings2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete rows with no layoff information
DELETE
FROM layoff_stagings2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE layoff_stagings2
DROP COLUMN row_num;