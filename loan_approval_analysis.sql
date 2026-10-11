CREATE DATABASE bank_loan;
USE bank_loan;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT loan_id) AS unique_loan_ids
FROM l_approved;

SELECT *
FROM loan_approved_clean;
SELECT COUNT(*) FROM loan_approved_clean;

ALTER TABLE loan_approved_clean 
RENAME TO l_approved;

SELECT * FROM l_approved;

ALTER TABLE l_approved
DROP COLUMN MyUnknownColumn;

/*
Business Queries — Loan Approval Analysis 
1. Overall Performance (Dashboard Overview) 
• What is the total number of loan applications?  
• How many applications were approved vs rejected?  
• What is the overall loan approval rate?  
• What is the average loan amount issued?  
• What is the average applicant income? 
*/

SELECT dependents, COUNT(*) AS count
FROM l_approved
GROUP BY dependents;

/*
• What is the total number of loan applications? 
*/

SELECT COUNT(*)
FROM l_approved;

SELECT COUNT(loan_status) 
FROM l_approved
WHERE loan_status = "Y";
# 3
-- The dataset contains 614 loan applications in total.
-- A total of 614 loan applications were analyzed in this loan approval dataset.
-- “I used COUNT(*) on the loan table to determine the total number of applications.”

/*
• How many applications were approved vs rejected?
*/
SELECT 
	SUM(
		CASE 
			WHEN loan_status = "Y" THEN 1        
		END) AS app_app,
	SUM(
		CASE WHEN loan_status = "N" THEN 1
        END) AS app_rej
FROM l_approved; 

SELECT
	loan_status, COUNT(loan_status)
FROM l_approved
GROUP BY loan_status;

-- Out of 614 loan applications, 422 were approved and 192 were rejected. Therefore, approved applications were more numerous than rejected applications in the dataset.
-- Approximately 69% of applications were approved, while 31% were rejected. This indicates that approval was more common than rejection in the analyzed dataset.

/*
What is the average loan amount issued? 
*/

SELECT ROUND(AVG(loanamount),2) AS average_loan_amount
FROM l_approved;

-- The average loan amount requested by applicants was 145.75 units in the dataset.
-- Across all 614 applications, the mean requested loan amount was 145.75. This represents the typical loan amount based on the arithmetic average, although the distribution is right-skewed because some applications have much larger loan amounts.

/*
 What is the average applicant income? 
*/

SELECT ROUND(AVG(applicantincome+coapplicantincome),2) AS average_applicant_coapplicant_income
FROM l_approved;

SELECT
    ROUND(AVG(applicantincome), 2) AS average_applicant_income
FROM l_approved;

-- The average applicant income in the dataset is 5,403.46.
-- The average applicant income is 5,403.46, but the mean should be interpreted carefully because the income distribution is right-skewed. We previously found that the median income is 3,812.50, which is considerably lower than the mean.

/*
What is the overall loan approval rate?  
*/

SELECT 
	COUNT(CASE WHEN loan_status = "Y" THEN 1 END ) AS loan_approved,
    COUNT(*) AS total_applicants,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END ) * 100.0 / COUNT(*),2) AS loan_approval_rate
FROM l_approved;

SELECT
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved;

-- The overall loan approval rate is 68.73%, meaning approximately 69 out of every 100 loan applications were approved.
-- The dataset shows that 68.73% of applications were approved, while the remaining 31.27% were not approved.


-- 2. Applicant Demographics 
/*
• Which gender has a higher loan approval rate?  
• Does marital status impact loan approval?  
• Do graduates have a higher approval rate than non-graduates?  
• How does self-employment affect loan approval chances?  
• Which applicant profile (combination of gender, education, etc.) has the highest 
approval rate?  
*/

--  Which gender has a higher loan approval rate?  
SELECT 
	COUNT(CASE WHEN gender = "Male" AND loan_status = "Y" THEN 1 END) AS male_approved_counts,
    COUNT(CASE WHEN gender = "Female" AND loan_status = "Y" THEN 1 END) AS female_approved_counts,
    COUNT(CASE WHEN gender = "Male" AND loan_status = "Y" THEN 1 END) * 100.0 / COUNT(CASE WHEN gender = "Male" THEN 1 END) AS male_loan_approved_rate,
    COUNT(CASE WHEN gender = "Female" AND loan_status = "Y" THEN 1 END) * 100.0 / COUNT(CASE WHEN gender = "Female" THEN 1 END) AS female_loan_approved_rate
FROM l_approved;

SELECT 
	gender,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approval_counts,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*) AS approval_percentage
FROM l_approved
GROUP BY gender;

SELECT
    gender,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY gender;

-- Male applicants had a higher observed loan approval rate of 69.12%, compared with 66.96% for female applicants. The difference is approximately 2.16 percentage points.


-- Q.7.Does marital status impact loan approval?
SELECT 
	married AS martial_status,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS total_approved_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*) AS approval_rate_percentage
FROM l_approved
GROUP BY martial_status;

SELECT 
	married,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) AS approval_counts,
    ROUND(SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY married;

SELECT
    education,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY education;

-- Q.8.Do graduates have a higher approval rate than non-graduates? 
SELECT 
	education,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approval_counts,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*) AS approval_percentage
FROM l_approved
GROUP BY education;

-- Q.9.How does self-employment affect loan approval chances?  
SELECT
	self_employed,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approval_counts,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*) AS approval_percentage
FROM l_approved
GROUP BY self_employed;

SELECT
    self_employed,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY self_employed;

-- Q.10.Which applicant profile (combination of gender, education, etc.) has the highest approval rate?
SELECT 
    gender, 
    married, 
    dependents, 
    education, 
    self_employed, 
    loan_amount_term, 
    credit_history, 
    property_area, 
    COUNT(*) AS total_applicants, 
    COUNT(CASE WHEN loan_status = 'Y' THEN 1 END) AS approved_applicants, 
    COUNT(CASE WHEN loan_status = 'Y' THEN 1 END) * 100.0 / COUNT(*) AS approval_rate 
FROM 
    l_approved 
GROUP BY 
    gender, 
    married, 
    dependents, 
    education, 
    self_employed, 
    loan_amount_term, 
    credit_history, 
    property_area
ORDER BY 
    approval_rate DESC;

SELECT 
    credit_history, education, property_area, -- 🌟 Reduced to just the heavy hitters
    COUNT(*) AS total_applicants, 
    COUNT(CASE WHEN loan_status = 'Y' THEN 1 END) * 100.0 / COUNT(*) AS approval_rate 
FROM l_approved 
GROUP BY credit_history, education, property_area
ORDER BY approval_rate DESC;


SELECT
    gender,
    married,
    education,
    self_employed,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY
    gender,
    married,
    education,
    self_employed
HAVING COUNT(*) >= 20
ORDER BY approval_rate DESC;


-- 3. Financial Insights 
/*
• How does applicant income affect loan approval?  
• Is there a relationship between loan amount and approval status?  
• What is the average loan amount across different income groups?  
• Do higher-income applicants get higher loan approvals?  
*/

SELECT 
	MAX(applicantincome),
    MIN(applicantincome),
    AVG(applicantincome)
FROM l_approved
ORDER BY applicantincome DESC;

-- Q.10.How does applicant income affect loan approval?  
SELECT
    CASE
        WHEN applicantincome <= 2877.5 THEN 'Low Income'
        WHEN applicantincome <= 3812.5 THEN 'Lower-Middle Income'
        WHEN applicantincome <= 5795 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY
    CASE
        WHEN applicantincome <= 2877.5 THEN 'Low Income'
        WHEN applicantincome <= 3812.5 THEN 'Lower-Middle Income'
        WHEN applicantincome <= 5795 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END;
    
--  Q.12.Is there a relationship between loan amount and approval status?
SELECT 
	loan_status,
    COUNT(*) AS total_applicants,
    ROUND(AVG(loanamount), 2) AS average_loan
FROM l_approved
GROUP BY loan_status;

SELECT
    COUNT(loanamount) AS count,
    ROUND(MIN(loanamount), 2) AS min_loan,
    ROUND(AVG(loanamount), 2) AS avg_loan,
    ROUND(MAX(loanamount), 2) AS max_loan
FROM l_approved;

SELECT
    loan_status,
    COUNT(*) AS applications,
    ROUND(AVG(loanamount), 2) AS avg_loan_amount,
    ROUND(MIN(loanamount), 2) AS min_loan_amount,
    ROUND(MAX(loanamount), 2) AS max_loan_amount
FROM l_approved
GROUP BY loan_status;

SELECT
    CASE
        WHEN loanamount <= 100.25 THEN 'Low Loan'
        WHEN loanamount <= 128 THEN 'Lower-Middle Loan'
        WHEN loanamount <= 164.75 THEN 'Upper-Middle Loan'
        ELSE 'High Loan'
    END AS loan_group,
    COUNT(*) AS applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    SUM(CASE WHEN loan_status = 'N' THEN 1 ELSE 0 END) AS rejected,
	ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY
    CASE
        WHEN loanamount <= 100.25 THEN 'Low Loan'
        WHEN loanamount <= 128 THEN 'Lower-Middle Loan'
        WHEN loanamount <= 164.75 THEN 'Upper-Middle Loan'
        ELSE 'High Loan'
    END;

-- Q.13.What is the average loan amount across different income groups? 
SELECT
    CASE
        WHEN applicantincome <= 2877.5 THEN 'Low Income'
        WHEN applicantincome <= 3812.5 THEN 'Lower-Middle Income'
        WHEN applicantincome <= 5795 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS applications,
    ROUND(AVG(loanamount), 2) AS avg_loan_amount
FROM l_approved
GROUP BY
    CASE
        WHEN applicantincome <= 2877.5 THEN 'Low Income'
        WHEN applicantincome <= 3812.5 THEN 'Lower-Middle Income'
        WHEN applicantincome <= 5795 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END;
    
-- Q.14.Do higher-income applicants get higher loan approvals?  
SELECT
    CASE
        WHEN applicantincome <= 2877.5 THEN 'Low Income'
        WHEN applicantincome <= 3812.5 THEN 'Lower-Middle Income'
        WHEN applicantincome <= 5795 THEN 'Upper-Middle Income'
        ELSE 'High Income' 
	END AS income_group,
    COUNT(*) AS applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    SUM(CASE WHEN loan_status = 'N' THEN 1 ELSE 0 END) AS rejected,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY
    CASE
        WHEN applicantincome <= 2877.5 THEN 'Low Income'
        WHEN applicantincome <= 3812.5 THEN 'Lower-Middle Income'
        WHEN applicantincome <= 5795 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END;

-- 4. Property & Location Analysis 
/*
• Which property area (Urban, Rural, Semiurban) has the highest approval rate?  
• Where are most loan applications coming from?  
• Do urban applicants receive higher loan amounts than rural applicants?  
*/

-- Q.15.Which property area (Urban, Rural, Semiurban) has the highest approval rate? 

SELECT
	property_area,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY property_area;

-- Q.16.Where are most loan applications coming from?  
SELECT 
	property_area,
    COUNT(*) AS no_of_applicants
FROM l_approved
GROUP BY property_area
ORDER BY no_of_applicants DESC;

-- Q.17.Do urban applicants receive higher loan amounts than rural applicants?  
SELECT 
	property_area,
    ROUND(AVG(loanamount),2) AS average_loan_amount
FROM l_approved
WHERE property_area IN("Urban","Rural")
GROUP BY property_area;

-- 5. Credit Risk Analysis (Most Important Section) 
/*
• How does credit history affect loan approval?  
• What percentage of applicants with good credit history are approved?  
• Are there any approvals for applicants with poor credit history?  
• How strong is the relationship between credit history and approval? 
*/

-- Q.18.How does credit history affect loan approval?  
SELECT 
	credit_history,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY credit_history;

-- Q.19.What percentage of applicants with good credit history are approved?  
SELECT 
	credit_history,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approved,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*),2) AS good_credit_approval_rate 
FROM l_approved
WHERE credit_history = 1;

-- Q.20.Are there any approvals for applicants with poor credit history?  
SELECT 
	credit_history,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approved,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*),2) AS poor_credit_approval_rate
FROM l_approved
WHERE credit_history = 0;

SELECT
    COUNT(*) AS approved_with_poor_credit
FROM l_approved
WHERE credit_history = 0
  AND loan_status = 'Y';

SELECT *
FROM l_approved
WHERE credit_history = 0
  AND loan_status = 'Y';
  
-- Q.21.How strong is the relationship between credit history and approval? 
SELECT 
	credit_history,
    loan_status,
    COUNT(*) AS applications
FROM l_approved
GROUP BY credit_history,loan_status
ORDER BY credit_history,loan_status;

SELECT
    credit_history,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY credit_history;

-- 6. Combined / Advanced Insights 
/*
• Which combination of factors leads to the highest approval rate? 
(e.g., Graduate + Urban + Credit History = 1)  
• What characteristics are common among rejected applicants?  
• Which group should the bank target to increase approval rates?  
• What are the key drivers of loan rejection? 
*/

-- Q.22.Which combination of factors leads to the highest approval rate? 

SELECT 
	education,
    property_area,
    credit_history,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN loan_status = "Y" THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = "Y"THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY 
	education,
    property_area,
    credit_history
HAVING COUNT(*) >= 10
ORDER BY approval_rate DESC;

-- Q.22.What characteristics are common among rejected applicants?  

SELECT
    COUNT(*) AS total_rejected,

    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_rejected,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_rejected,

    SUM(CASE WHEN married = 'Yes' THEN 1 ELSE 0 END) AS married_rejected,
    SUM(CASE WHEN married = 'No' THEN 1 ELSE 0 END) AS unmarried_rejected,

    SUM(CASE WHEN education = 'Graduate' THEN 1 ELSE 0 END) AS graduate_rejected,
    SUM(CASE WHEN education = 'Not Graduate' THEN 1 ELSE 0 END) AS not_graduate_rejected,

    SUM(CASE WHEN self_employed = 'Yes' THEN 1 ELSE 0 END) AS self_employed_rejected,
    SUM(CASE WHEN self_employed = 'No' THEN 1 ELSE 0 END) AS non_self_employed_rejected,

    SUM(CASE WHEN credit_history = 1 THEN 1 ELSE 0 END) AS good_credit_rejected,
    SUM(CASE WHEN credit_history = 0 THEN 1 ELSE 0 END) AS poor_credit_rejected,

    SUM(CASE WHEN property_area = 'Urban' THEN 1 ELSE 0 END) AS urban_rejected,
    SUM(CASE WHEN property_area = 'Semiurban' THEN 1 ELSE 0 END) AS semiurban_rejected,
    SUM(CASE WHEN property_area = 'Rural' THEN 1 ELSE 0 END) AS rural_rejected,

    ROUND(AVG(applicantincome), 2) AS avg_applicant_income,
    ROUND(AVG(loanamount), 2) AS avg_loan_amount

FROM l_approved
WHERE loan_status = 'N';



-- q.23.Which group should the bank target to increase approval rates?   
SELECT
    education,
    property_area,
    credit_history,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    SUM(CASE WHEN loan_status = 'N' THEN 1 ELSE 0 END) AS rejected,
    ROUND(
        SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS approval_rate
FROM l_approved
GROUP BY
    education,
    property_area,
    credit_history
HAVING COUNT(*) >= 20
ORDER BY approval_rate DESC;

-- Q.24.



-- SECTION 1 — Basic SQL Queries 
/* 1. View the first 10 records from the table. 
2. Count the total number of loan applications. 
3. List all unique property areas. 
4. Show all applicants who are self-employed and have an income above 5000. 
5. Find the total number of approved loans.
*/

-- Q.1.View the first 10 records from the table.  
SELECT * FROM l_approved 
LIMIT 10;

-- Q.2.Count the total number of loan applications. 
SELECT COUNT(*) total_applicants
FROM l_approved;

-- Q.3.List all unique property areas. 
SELECT DISTINCT
	property_area
FROM l_approved;

-- Q.4.Show all applicants who are self-employed and have an income above 5000.
SELECT COUNT(*)
FROM l_approved
WHERE self_employed = "Yes"
AND applicantincome > 5000;

SELECT COUNT(*) AS total_self_employed_above_5000
FROM l_approved
WHERE self_employed = 'Yes'
  AND applicantincome > 5000;
  
SELECT
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    SUM(CASE WHEN loan_status = 'N' THEN 1 ELSE 0 END) AS rejected,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
WHERE self_employed = 'Yes'
AND applicantincome > 5000;

-- Q.5.Find the total number of approved loans. 
SELECT COUNT(*) AS approved
FROM l_approved
WHERE loan_status = "Y";

-- SECTION 2 — Aggregation & Grouping 
/*
6. Find average loan amount by education level. 
7. Find average total income (Applicant + Coapplicant) by marital status. 
8. Show average loan amount by credit history. 
9. Find total applications and approval rate by gender. 
10. Show approval rate by property area.
*/

-- Q.6. Find average loan amount by education level.
SELECT 
	education,
	round(AVG(loanamount),2) AS average_loan_amt 
FROM l_approved
GROUP BY education;

-- Q.7.Find average total income (Applicant + Coapplicant) by marital status.
SELECT 
	married, 
	ROUND(AVG(applicantincome+coapplicantincome),2) AS avg_total_income
FROM l_approved
GROUP BY married;

-- Q.8.Show average loan amount by credit history. 
SELECT 
	credit_history, 
	ROUND(AVG(loanamount),2) AS average_loan_amt
FROM l_approved
GROUP BY credit_history;

-- Q.9.Find total applications and approval rate by gender. 
SELECT gender, COUNT(*) AS total_applications,
	COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approved,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY gender;

-- Q.10.Show approval rate by property area.
SELECT
	property_area,
    COUNT(*) AS total_applicants,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approved,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY property_area;

-- SECTION 3 — Filtering & Conditions 
/*
11. Show applicants who are graduates, not self-employed, and have loan amount greater 
than 150. 
12. Display approved loans from urban area with good credit history. 
13. List top 5 applicants with highest total income. 
*/

SELECT *
FROM l_approved
WHERE education = "Graduate"
AND self_employed = "No"
AND loanamount > 150
ORDER BY loanamount ASC;

SELECT COUNT(*) AS total_applicants
FROM l_approved
WHERE education = 'Graduate'
  AND self_employed = 'No'
  AND loanamount > 150;

-- Display approved loans from urban area with good credit history. 
SELECT *
FROM l_approved
WHERE property_area = "Urban"
AND credit_history = 1;

SELECT COUNT(*) AS total_applicants
FROM l_approved
WHERE property_area = "Urban"
AND credit_history = 1;

-- List top 5 applicants with highest total income.

SELECT *,
	(applicantincome+coapplicantincome) AS total_income
FROM l_approved
ORDER BY total_income DESC
LIMIT 5;

-- SECTION 4 — Derived Columns & CASE WHEN 
/*
14. Create derived columns for total income for each applicant. 
15. Classify applicants into income groups (Low, Medium, High) based on applicant income. 
16. Find average loan amount for each income group. 
*/

-- 14. Create derived columns for total income for each applicant. 
SELECT *, (applicantincome+coapplicantincome) AS total_income
FROM l_approved;

-- 15. Classify applicants into income groups (Low, Medium, High) based on applicant income.
SELECT COUNT(*) AS applicants,
	CASE 
		WHEN applicantincome <= 2877.5 THEN "Low Income"
        WHEN applicantincome <= 3812.5 THEN "Lower-Middle Income"
        WHEN applicantincome <= 5795 THEN "Upper-Middle Income"
        ELSE "High Income"
	END AS income_group
FROM l_approved
GROUP BY 	
	CASE 
		WHEN applicantincome <= 2877.5 THEN "Low Income"
        WHEN applicantincome <= 3812.5 THEN "Lower-Middle Income"
        WHEN applicantincome <= 5795 THEN "Upper-Middle Income"
        ELSE "High Income"
	END;


-- 16. Find average loan amount for each income group. 
SELECT
	CASE 
		WHEN applicantincome <= 2877.5 THEN "Low Income"
        WHEN applicantincome <= 3812.5 THEN "Lower-Middle Income"
        WHEN applicantincome <= 5795 THEN "Upper-Middle Income"
        ELSE "High Income"
	END AS income_group,
    ROUND(AVG(loanamount),2) AS avg_loan_amt
FROM l_approved
GROUP BY 	
	CASE 
		WHEN applicantincome <= 2877.5 THEN "Low Income"
        WHEN applicantincome <= 3812.5 THEN "Lower-Middle Income"
        WHEN applicantincome <= 5795 THEN "Upper-Middle Income"
        ELSE "High Income"
	END;
    
-- SECTION 5 — Subqueries & Nested Analysis 
/*
17. Find applicants whose loan amount is greater than the overall average loan amount. 
18. Identify the property area with the highest average total income. 
19. List all applicants whose income is above the average income of their education category. 
*/

SELECT COUNT(*) AS applicants 
FROM l_approved
WHERE loanamount > (
	SELECT AVG(loanamount)
    FROM l_approved
);

-- 18. Identify the property area with the highest average total income. 
SELECT property_area 
FROM l_approved
WHERE property_area = (
	SELECT 
		property_area
    FROM l_approved
    GROUP BY property_area
    ORDER BY (AVG(applicantincome+coapplicantincome)) DESC
    LIMIT 1
)
GROUP BY property_area;

SELECT 
	property_area,
    ROUND(AVG(applicantincome+coapplicantincome),2) AS avg_total_income
FROM l_approved
GROUP BY property_area
HAVING AVG(applicantincome+coapplicantincome) = (
	SELECT MAX(avg_income)
    FROM (SELECT AVG(applicantincome + coapplicantincome) AS avg_income
		  FROM l_approved
          GROUP BY property_area
	) AS area_income
);

WITH cte AS(
	SELECT
		property_area,
		ROUND(AVG(applicantincome+coapplicantincome),2) AS total_income
	FROM l_approved
    GROUP BY property_area
    ORDER BY total_income DESC
    LIMIT 1
)
SELECT *
FROM cte;

-- 19. List all applicants whose income is above the average income of their education category. 

SELECT *
FROM l_approved AS l1
WHERE applicantincome > (
	SELECT AVG(l2.applicantincome)
    FROM l_approved AS l2 
    WHERE l2.education = l1.education
);

WITH CTE AS(
	SELECT 
		education,
		AVG(applicantincome) AS avg_income 
    FROM l_approved
    GROUP BY education
)
SELECT COUNT(*) AS total_applicants
FROM l_approved AS l1
JOIN cte AS l2
ON l1.education = l2.education
WHERE applicantincome > avg_income;

-- SECTION 6 — Window Functions 
/*
20. Rank applicants based on total income (highest income rank = 1). 
21. Show average loan amount per property area using a window function. 
22. Calculate approval rate by education using grouping or window function.
*/
-- 20. Rank applicants based on total income (highest income rank = 1).
SELECT *,
	applicantincome+coapplicantincome AS total_income,
    RANK() OVER(ORDER BY applicantincome+coapplicantincome DESC) AS rnk
FROM l_approved;

-- 21. Show average loan amount per property area using a window function. 
SELECT 
	*,
    ROUND(AVG(loanamount) OVER(PARTITION BY property_area),2) AS average_loan_amt
FROM l_approved;

-- 22. Calculate approval rate by education using grouping or window function.
SELECT 
	education,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100.0 / COUNT(*) AS approval_rate
FROM l_approved
GROUP BY education;

SELECT
    education,
    loan_status,
    COUNT(*) OVER (PARTITION BY education) AS total_education_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) OVER (PARTITION BY education) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) OVER (PARTITION BY education)* 100.0/ COUNT(*) OVER (PARTITION BY education),2) AS approval_rate
FROM l_approved;

-- SECTION 7 — Business Insights & Combined Analysis 
/*
23. Compare approval rate by credit history and education level to find which combination 
performs best. 
24. Find the combination of property area and education with the highest approval rate. 
25. Compare approval rate for self-employed vs non-self-employed applicants by credit 
history.
*/

-- 23. Compare approval rate by credit history and education level to find which combination performs best. 
SELECT 
	education,
    credit_history,
    COUNT(*) AS total_applications,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100 / COUNT(*),2) AS approval_rate 
FROM l_approved
GROUP BY education,credit_history
ORDER BY approval_rate DESC;

SELECT
    education,
    credit_history,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END) AS approved,
    ROUND(SUM(CASE WHEN loan_status = 'Y' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY education, credit_history
ORDER BY approval_rate DESC;

-- 24. Find the combination of property area and education with the highest approval rate. 
SELECT 
	property_area,
    education,
    COUNT(*) AS total_applications,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approved,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100 / COUNT(*),2) AS approval_rate 
FROM l_approved
GROUP BY property_area, education
ORDER BY approval_rate DESC;



-- 25. Compare approval rate for self-employed vs non-self-employed applicants by credit history.
SELECT 
	self_employed,
    credit_history,
    COUNT(*) AS total_applications,
    COUNT(CASE WHEN loan_status = "Y" THEN 1 END) AS approved,
    ROUND(COUNT(CASE WHEN loan_status = "Y" THEN 1 END) * 100 / COUNT(*),2) AS approval_rate
FROM l_approved
GROUP BY self_employed,credit_history
ORDER BY approval_rate DESC;

