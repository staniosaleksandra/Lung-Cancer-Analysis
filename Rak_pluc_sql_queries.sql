-- =======================================================================================================================================
-- PROJEKT RAK PLUC
-- =======================================================================================================================================

--Tworzenie pustej tabeli do zaimportowania pliku CSV

CREATE TABLE Lung_raw (
Patient_ID TEXT,
Diagnosis_Year TEXT,
Diagnosis_Date TEXT,
WHO_Region TEXT,
Country TEXT,
Age TEXT,
Age_Group TEXT,
Gender TEXT,
Smoking_Status TEXT,
Cigarettes_Per_Day TEXT
);

-- Analiza czy więcej mężczyzn czy kobiet zachorowało na raka płuc z podziałem na przedziały wiekowe.

SELECT gender, 
	age_group,
	smoking_status,
	COUNT (*) AS total_patient,
	SUM (CASE WHEN gender='Male' THEN 1 ELSE 0 END),
	SUM (CASE WHEN gender='Female' THEN 1 ELSE 0 END)
FROM lung_raw
GROUP BY gender, age_group, smoking_status
ORDER BY gender, age_group

-- Ranking państw z podziałem na płeć.

WITH Agregacja AS (
	SELECT
		gender,
		smoking_status,
		country,
		COUNT (*) AS total_patient,
		SUM (CASE WHEN gender='Male' THEN 1 ELSE 0 END),
		SUM (CASE WHEN gender='Female' THEN 1 ELSE 0 END)
	FROM lung_raw
	GROUP BY gender, country, smoking_status
),
Ranking AS (
SELECT
	gender,
	smoking_status,
	country,
	total_patient,
	ROW_NUMBER () OVER (PARTITION BY gender ORDER BY total_patient DESC) AS pozycja_w_rankingu
FROM Agregacja
)
SELECT *
FROM Ranking
ORDER BY gender, pozycja_w_rankingu

-- Analiza zdiagnozowanych pacjętów pod względem statusu palacza z podziałem na płeć i przedziały wiekowe.

WITH Agregacja AS (
	SELECT 
		gender, 
		age_group,
		COUNT (*) AS total_patient,
		SUM (CASE WHEN gender='Male' THEN 1 ELSE 0 END),
		SUM (CASE WHEN gender='Female' THEN 1 ELSE 0 END),
		smoking_status
	FROM lung_raw
GROUP BY gender, age_group, smoking_status
)
	SELECT
		gender, 
		age_group,
		total_patient,
		smoking_status
	FROM Agregacja
ORDER BY gender, age_group

-- Rozkład zachorowalności w poszczególnych latach.

SELECT 
    gender, 
    diagnosis_year, 
    smoking_status,
    COUNT(*) AS liczba_osob,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY gender, diagnosis_year), 1) AS procent_w_grupie
FROM lung_raw
GROUP BY gender, diagnosis_year, smoking_status
ORDER BY diagnosis_year, gender, smoking_status;

-- Mediana wieku diagnozy pacjenta dla obu grup.

WITH Agregacja AS (
SELECT 
	age,
	smoking_status,
	gender
FROM lung_raw
)
SELECT
	smoking_status,
	gender,
	--ZMIANA AGE Z TEXT NA INTEGER
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age::integer) AS mediana_age
FROM Agregacja
GROUP BY smoking_status, gender
ORDER BY gender, smoking_status