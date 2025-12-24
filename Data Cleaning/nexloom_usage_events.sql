-- TO VIEW ENTIRE TABLE --
SELECT * FROM nexloom_analytics.nexloom_usage_events;

-- CLEANING THE "USAGE EVENTS" TABLE TO ENSURE PROPER DATA QUALITY --
SELECT
-- EVENT ID --	
	UPPER(TRIM(event_id)) as event_id,
    
-- USER ID --
	TRIM(UPPER(
		CASE
		  WHEN TRIM(user_id) LIKE 'USR-%'
			THEN CONCAT('U1', SUBSTRING(TRIM(user_id), 7))
		  ELSE TRIM(user_id) END))  
	AS user_id,

-- EVENT TYPE --
	LOWER(event_type) as event_type,
    
-- PAGE URLs --
	page_url, 
    
-- EVENT TIMESTAMP --  
	CASE
    WHEN event_timestamp IS NULL OR TRIM(event_timestamp) = '' THEN NULL
    WHEN TRIM(event_timestamp) = '0000-00-00 00:00:00' THEN NULL

    -- YYYY-MM-DD HH:MM:SS
    WHEN STR_TO_DATE(TRIM(event_timestamp), '%Y-%m-%d %H:%i:%s') IS NOT NULL
      THEN STR_TO_DATE(TRIM(event_timestamp), '%Y-%m-%d %H:%i:%s')

    -- YYYY-MM-DD H:MM (like 2025-06-19 3:45)
    WHEN STR_TO_DATE(TRIM(event_timestamp), '%Y-%m-%d %k:%i') IS NOT NULL
      THEN STR_TO_DATE(TRIM(event_timestamp), '%Y-%m-%d %k:%i')

    -- YYYY-MM-DD (date only)
    WHEN STR_TO_DATE(TRIM(event_timestamp), '%Y-%m-%d') IS NOT NULL
      THEN STR_TO_DATE(CONCAT(TRIM(event_timestamp), ' 00:00:00'), '%Y-%m-%d %H:%i:%s')

    -- MM/DD/YYYY HH:MM (from your dataset)
    WHEN STR_TO_DATE(TRIM(event_timestamp), '%m/%d/%Y %H:%i') IS NOT NULL
      THEN STR_TO_DATE(TRIM(event_timestamp), '%m/%d/%Y %H:%i')

    ELSE NULL
  END AS event_timestamp, 
    
-- DEVICE TYPE --
	CASE 
		WHEN TRIM(device_type) = '' THEN 'unknown'
		ELSE LOWER(device_type)
    END AS device_type, 
    
--  BROWSER --
	CASE 
		WHEN TRIM(browser) = '' THEN 'unknown'
		ELSE LOWER(browser) 
    END AS browser, 
    
 --  OPERATING SYSTEM --   
	CASE 
		WHEN TRIM(os) = '' THEN 'unknown'
		ELSE os
	END AS os,  
	CASE 
		WHEN session_duration_seconds = 'unknown' THEN ''
        ELSE session_duration_seconds
	END AS session_duration_seconds,  
	CASE 
		WHEN error_flag = 'TRUE' THEN 1
        WHEN error_flag = 'FALSE' THEN 0
        WHEN error_flag = '' THEN 2
		ELSE error_flag
	END AS error_flag, 
	created_at

FROM nexloom_analytics.nexloom_usage_events;
