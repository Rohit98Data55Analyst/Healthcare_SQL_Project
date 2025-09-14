-- **** Project Starts ****

-- ** Q.1. Find the total revenue per hospital (JOIN admissions + hospitals). **
SELECT h.hospital_name,
       sum(a.treatment_cost)Total_revenue
FROM  hospitals h inner join admissions a
on h.hospital_id = a.hospital_id
GROUP BY h.hospital_name;

-- ** Q.2. List patients with multiple admissions.**
SELECT p.name AS patient_name,
       COUNT(a.patient_id)Total_times_of_admission
FROM admissions a inner join patients p
on p.patient_id = a.patient_id
GROUP BY p.name
HAVING COUNT(a.patient_id) > 1
ORDER BY p.name ASC;

-- ** Q.3. Find the most common disease per hospital. **
SELECT hospital_name,
       disease  AS most_common_disease
FROM
        (SELECT h.hospital_name AS hospital_name,
                a.disease AS disease,
	            COUNT(a.disease)AS count_of_disease,
	            RANK() OVER(PARTITION BY h.hospital_name ORDER BY COUNT(a.disease) DESC)AS rank
        FROM hospitals h inner join admissions a
        ON h.hospital_id = a.hospital_id
        GROUP BY h.hospital_name, a.disease
       ) AS T
WHERE rank = 1 ;

-- ** Q.4. Get the average treatment cost by hospital. **
SELECT h.hospital_name,
       AVG(a.treatment_cost) AS avg_treatment_cost
FROM hospitals h
INNER JOIN admissions a
    ON h.hospital_id = a.hospital_id
GROUP BY h.hospital_name;

--** Q.5. Show patients admitted in a hospital outside their city (JOIN patients + hospitals). **
SELECT p.name ,
       h.hospital_name,
       p.city AS patient_city,
	   h.city AS Hospital_city
FROM hospitals h INNER JOIN admissions a
     ON h.hospital_id = a.hospital_id
	 INNER JOIN patients p
	 ON a.patient_id = p.patient_id
WHERE p.city != h.city;

-- ** Q.6. Find the oldest patient admitted in each hospital. **
 SELECT  patient_name,hospital_name,age 
 FROM (
      SELECT p.name AS patient_name,
           h.hospital_name,
	       p.age ,
	       RANK() OVER(PARTITION BY  h.hospital_name ORDER BY p.age DESC)AS rank
      FROM hospitals h INNER JOIN admissions a
      ON h.hospital_id = a.hospital_id
      INNER JOIN patients p
      ON p.patient_id = a.patient_id
    ) AS T
WHERE rank = 1 ;
       
-- ** Q.7. Show the top 5 hospitals by total patients treated. **
SELECT TOP 5 
       h.hospital_name,
	   COUNT(a.patient_id)AS Total_no_of_treated_patient
FROM hospitals h INNER JOIN admissions a
ON h.hospital_id = a.hospital_id 
GROUP BY h.hospital_name
ORDER BY  Total_no_of_treated_patient DESC;

--** Q.8. Find the average length of stay per disease. (DATEDIFF on admission/discharge) **
SELECT disease ,
       AVG(DATEDIFF(DAY,admission_date,discharge_date))average_stay_time_in_days
FROM admissions
GROUP BY disease;

-- ** Q.9. List all patients who spent more than 50,000 in total across all admissions. **
SELECT p.name AS patient_name,
       SUM(a.treatment_cost)Total_expenditure
FROM patients p INNER JOIN admissions a
ON p.patient_id = a.patient_id 
GROUP BY  p.name
HAVING SUM(a.treatment_cost) > 50000 ;

-- ** Q.10. Show the gender-wise count of patients per hospital. **
SELECT h.hospital_name,
       p.gender ,
	   COUNT(a.patient_id)AS Total_patient
FROM hospitals h INNER JOIN admissions a
ON h.hospital_id = a.hospital_id
INNER JOIN patients p
ON p.patient_id = a.patient_id 
GROUP BY h.hospital_name, p.gender ;

-- **** Project Ends ****


SELECT * FROM hospitals;
SELECT * FROM admissions;
SELECT * FROM patients;











