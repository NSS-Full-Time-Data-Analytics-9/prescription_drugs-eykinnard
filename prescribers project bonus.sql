--1. How many npi numbers appear in the prescriber table but not in the prescription table?
SELECT COUNT(prescriber.npi)- COUNT(prescription.npi) AS diff_prescriber
FROM prescriber
	FULL JOIN prescription
	USING (npi);
	
--2a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
SELECT generic_name,
	SUM(total_claim_count) AS total_count,
	specialty_description
FROM drug
	INNER JOIN prescription
	USING(drug_name)
		INNER JOIN prescriber
		USING (npi)
WHERE specialty_description = 'Family Practice'
GROUP BY generic_name, specialty_description
ORDER BY total_count DESC;

--2b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
SELECT generic_name,
	SUM(total_claim_count) AS total_count,
	specialty_description
FROM drug
	INNER JOIN prescription
	USING(drug_name)
		INNER JOIN prescriber
		USING (npi)
WHERE specialty_description = 'Cardiology'
GROUP BY generic_name, specialty_description
ORDER BY total_count DESC;

--2c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.
SELECT generic_name,
	SUM(total_claim_count) AS total_count,
	specialty_description
FROM drug
	INNER JOIN prescription
	USING(drug_name)
		INNER JOIN prescriber
		USING (npi)
WHERE specialty_description IN ('Cardiology','Family Practice')
GROUP BY generic_name, specialty_description
ORDER BY total_count DESC;

--3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
 
--3a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.
SELECT SUM(total_claim_count) AS total_count,
	prescriber.npi,
	nppes_provider_city
FROM prescription
	INNER JOIN prescriber
	USING (npi)
WHERE nppes_provider_city ILIKE '%Nash%'
GROUP BY prescriber.npi, nppes_provider_city
ORDER BY total_count DESC;

--3b. Now, report the same for Memphis.
SELECT SUM(total_claim_count) AS total_count,
	prescriber.npi,
	nppes_provider_city
FROM prescription
	INNER JOIN prescriber
	USING (npi)
WHERE nppes_provider_city ILIKE '%MEM%'
GROUP BY prescriber.npi, nppes_provider_city
ORDER BY total_count DESC;

--3c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.
SELECT SUM(total_claim_count) AS total_count,
	prescriber.npi,
	nppes_provider_city
FROM prescription
	INNER JOIN prescriber
	USING (npi)
WHERE nppes_provider_city ILIKE '%Nash%'
	OR nppes_provider_city ILIKE '%Mem%'
	OR nppes_provider_city ILIKE '%Knox%'
	OR nppes_provider_city ILIKE '%Chat%'
GROUP BY prescriber.npi, nppes_provider_city
ORDER BY total_count DESC;

--4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.
SELECT *
FROM overdoses
WHERE deaths > (SELECT AVG(deaths) 
			   FROM overdoses);
			   
--5a. Write a query that finds the total population of Tennessee.
SELECT SUM(population) AS total_pop,
	state
FROM population
	INNER JOIN fips_county
	USING(fipscounty)
WHERE state ILIKE '%tn%'
GROUP BY state;

--Need Help--5b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.
SELECT state,
	county,
	population,
	(COUNT(population)*100/(SELECT COUNT (*)
				 FROM population))AS percent
FROM population
	INNER JOIN fips_county
	USING(fipscounty)
WHERE state ILIKE '%tn%'
GROUP BY state, county,population;
