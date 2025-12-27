-- TO VIEW ENTIRE TABLE --
SELECT * FROM nexloom_analytics.fact_subscriptions;

-- CLEANING THE "USERS" TABLE TO ENSURE PROPER DATA QUALITY --
CREATE TABLE fact_subscriptions_cleaned AS 
SELECT	
-- SUBSCRIPTION ID --
    UPPER(TRIM(subscription_id)) AS subscription_id,
    
-- USER ID --
    TRIM(UPPER(
		CASE
		  WHEN TRIM(user_id) LIKE 'USR-%'
			THEN CONCAT('U0', SUBSTRING(TRIM(user_id), 6))
		  ELSE TRIM(user_id) END))  
	AS user_id,
    
-- PLAN NAME --
	CONCAT(
    UPPER(LEFT(plan_name, 1)),
    LOWER(SUBSTRING(plan_name, 2))) 
    AS plan_name,

-- BILLING CYCLE --
	CASE WHEN billing_cycle = '' THEN 'Not Identified' ELSE
    CONCAT(
    UPPER(LEFT(billing_cycle, 1)),
    LOWER(SUBSTRING(billing_cycle, 2))) 
    END AS billing_cycle,
    
-- PRICE AMOUNT --    
	price_amount,
    
-- CURRENCY -- 
	CASE WHEN currency = '' THEN 'Unknown'
    ELSE UPPER(currency)
    END AS currency,
    
-- STATUS -- 
	CONCAT(
    UPPER(LEFT(status, 1)),
    LOWER(SUBSTRING(status, 2))) AS status,
    
-- START DATE --
	CASE
    WHEN start_date IS NULL
      OR TRIM(start_date) = ''
      OR start_date = '0:00'
      OR start_date = '0000-00-00'
        THEN NULL

    -- DD-MM-YYYY
    WHEN start_date LIKE '__-__-____'
        THEN DATE_FORMAT(STR_TO_DATE(start_date, '%d-%m-%Y'), '%Y-%m-%d 00:00:00')

    -- MM/DD/YYYY
    WHEN start_date LIKE '__/__/____'
        THEN DATE_FORMAT(STR_TO_DATE(start_date, '%m/%d/%Y'), '%Y-%m-%d 00:00:00')

    -- YYYY-MM-DD H:MM  (single-digit hour)
    WHEN start_date LIKE '____-__-__ _:%'
        THEN DATE_FORMAT(STR_TO_DATE(start_date, '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i:00')

    -- YYYY-MM-DD HH:MM
    WHEN start_date LIKE '____-__-__ __:%'
        THEN DATE_FORMAT(STR_TO_DATE(start_date, '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i:00')

    -- YYYY-MM-DD (no time)
    WHEN start_date LIKE '____-__-__'
        THEN DATE_FORMAT(STR_TO_DATE(start_date, '%Y-%m-%d'), '%Y-%m-%d 00:00:00')

    ELSE NULL
END AS start_date,
 
 -- END DATE --
	CASE
    WHEN end_date IS NULL
      OR TRIM(end_date) = ''
      OR end_date = '0:00'
      OR end_date = '0000-00-00'
        THEN NULL

    -- DD-MM-YYYY
    WHEN end_date LIKE '__-__-____'
        THEN DATE_FORMAT(STR_TO_DATE(end_date, '%d-%m-%Y'), '%Y-%m-%d 00:00:00')

    -- MM/DD/YYYY
    WHEN end_date LIKE '__/__/____'
        THEN DATE_FORMAT(STR_TO_DATE(end_date, '%m/%d/%Y'), '%Y-%m-%d 00:00:00')

    -- YYYY-MM-DD H:MM (single-digit hour)
    WHEN end_date LIKE '____-__-__ _:%'
        THEN DATE_FORMAT(STR_TO_DATE(end_date, '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i:00')

    -- YYYY-MM-DD HH:MM
    WHEN end_date LIKE '____-__-__ __:%'
        THEN DATE_FORMAT(STR_TO_DATE(end_date, '%Y-%m-%d %H:%i'), '%Y-%m-%d %H:%i:00')

    -- YYYY-MM-DD (no time)
    WHEN end_date LIKE '____-__-__'
        THEN DATE_FORMAT(STR_TO_DATE(end_date, '%Y-%m-%d'), '%Y-%m-%d 00:00:00')

    ELSE NULL
END AS end_date, 
    
    -- PAYMENT METHOD --
	CASE WHEN payment_method = '' THEN 'Not Identified' ELSE
    CONCAT(
    UPPER(LEFT(payment_method, 1)),
    LOWER(SUBSTRING(payment_method, 2))) 
    END AS payment_method, 
    
    -- AUTO-RENEW --
	CASE WHEN auto_renew = TRUE THEN 1
		 WHEN auto_renew = '' THEN 2 
         WHEN auto_renew = FALSE THEN 0 
    ELSE auto_renew
    END AS auto_renew,
    
-- CANCEL REASON --
	CASE WHEN cancel_reason = '' THEN 'N/A'
    WHEN cancel_reason = 'Past_due' THEN 'Past due'
    ELSE cancel_reason
    END AS cancel_reason, 

-- UPDATED AT --
	CASE
    -- blank, null, invalid, or placeholder
    WHEN updated_at IS NULL
      OR TRIM(updated_at) = ''
      OR updated_at = '0:00'
      OR updated_at = '0000-00-00'
        THEN NULL

    -- format: DD-MM-YYYY
    WHEN updated_at LIKE '__-__-____'
        THEN DATE_FORMAT(
                STR_TO_DATE(updated_at, '%d-%m-%Y'),
                '%Y-%m-%d 00:00:00'
             )

    -- format: MM/DD/YYYY
    WHEN updated_at LIKE '__/__/____'
        THEN DATE_FORMAT(
                STR_TO_DATE(updated_at, '%m/%d/%Y'),
                '%Y-%m-%d 00:00:00'
             )

    -- format: YYYY-MM-DD H:MM  (single-digit hour)
    WHEN updated_at LIKE '____-__-__ _:%'
        THEN DATE_FORMAT(
                STR_TO_DATE(updated_at, '%Y-%m-%d %H:%i'),
                '%Y-%m-%d %H:%i:00'
             )

    -- format: YYYY-MM-DD HH:MM
    WHEN updated_at LIKE '____-__-__ __:%'
        THEN DATE_FORMAT(
                STR_TO_DATE(updated_at, '%Y-%m-%d %H:%i'),
                '%Y-%m-%d %H:%i:00'
             )

    -- format: YYYY-MM-DD (no time)
    WHEN updated_at LIKE '____-__-__'
        THEN DATE_FORMAT(
                STR_TO_DATE(updated_at, '%Y-%m-%d'),
                '%Y-%m-%d 00:00:00'
             )

    ELSE NULL
END AS updated_at


    
FROM nexloom_analytics.fact_subscriptions