-- data info

-- Get our movies, and our ratings, and if it won an oscar
SELECT	T.TITLE_CONSTANT,
		T.PRIMARY_TITLE,
		T.RUNTIME_MINUTES,
		T.GENRES,
		O.CATEGORY,
		O.YEAR_FILM,
		O.NAME,
		O.WIN,
		R.AVERAGE_RATING,
		R.NUMBER_VOTES
FROM	TITLES T
LEFT JOIN
		OSCARS O
ON		LOWER(REGEXP_REPLACE(T.PRIMARY_TITLE,'[[:punct:][:space:]]', '','g')) = LOWER(REGEXP_REPLACE(O.FILM,'[[:punct:][:space:]]', '','g'))
AND		T.START_YEAR = O.YEAR_FILM
INNER JOIN
		RATINGS R
ON		T.TITLE_CONSTANT = R.TITLE_CONSTANT
WHERE	T.IS_ADULT = 0
AND		T.TITLE_TYPE IN ('movie','short')
AND		R.NUMBER_VOTES > 100;


SELECT	MI.TITLE_CONSTANT,
		MI.PRIMARY_TITLE,
		MI.START_YEAR,
		MI.RUNTIME_MINUTES,
		MI.GENRES,
		O.CATEGORY,
		O.NAME,
		CASE
			WHEN O.WIN IS NULL OR O.WIN = 'False'
			THEN 0
			ELSE 1
		END AS WIN,
		MI.AVERAGE_RATING,
		MI.NUMBER_VOTES
FROM	(	SELECT	T.TITLE_CONSTANT,
					T.PRIMARY_TITLE,
		 			T.START_YEAR,
					T.RUNTIME_MINUTES,
					T.GENRES,
					R.AVERAGE_RATING,
					R.NUMBER_VOTES
			FROM	TITLES T
			INNER JOIN
					RATINGS R
			ON		T.TITLE_CONSTANT = R.TITLE_CONSTANT
			AND		T.IS_ADULT = 0
			AND		T.TITLE_TYPE IN ('movie','short')
		 	AND		T.START_YEAR >= 1927
			AND		R.NUMBER_VOTES > 100
		) MI
LEFT JOIN
		OSCARS O
ON		LOWER(REGEXP_REPLACE(MI.PRIMARY_TITLE,'[[:punct:][:space:]]', '','g')) = LOWER(REGEXP_REPLACE(O.FILM,'[[:punct:][:space:]]', '','g'))
AND		MI.START_YEAR = O.YEAR_FILM
ORDER BY MI.TITLE_CONSTANT;


-- TAKING TOO LONG
WITH	OSCAR_CLEAN
AS		(	SELECT	O.NAME,
					O.CATEGORY,
					O.YEAR_FILM,
		 			LOWER(REGEXP_REPLACE(O.NAME,'[[:punct:][:space:]]', '','g')) CLEAN_NAME
			FROM	OSCARS O
		)
SELECT	NI.PRIMARY_NAME,
		NI.CATEGORY,
		NI.JOB,
		OC.NAME,
		OC.CATEGORY,
		OC.YEAR_FILM
FROM	(	SELECT	DISTINCT
					N.PRIMARY_NAME,
					P.CATEGORY,
					P.JOB,
		 			LOWER(REGEXP_REPLACE(N.PRIMARY_NAME,'[[:punct:][:space:]]', '','g')) CLEAN_NAME
			FROM	TITLES T
			INNER JOIN
					RATINGS R
			ON		T.TITLE_CONSTANT = R.TITLE_CONSTANT
			AND		T.IS_ADULT = 0
			AND		T.TITLE_TYPE IN ('movie','short')
			AND		T.START_YEAR >= 1927
			AND		R.NUMBER_VOTES > 100
			INNER JOIN
					PRINCIPALS P
			ON		T.TITLE_CONSTANT = P.TITLE_CONSTANT
			INNER JOIN
					NAMES N
			ON		P.NAME_CONSTANT = N.NAME_CONSTANT
		 ) NI
LEFT JOIN
		OSCAR_CLEAN OC
ON		OC.CLEAN_NAME ~ NI.CLEAN_NAME
ORDER BY	NI.PRIMARY_NAME;

SELECT	O.NAME,
		O.CATEGORY,
		O.YEAR_FILM,
		LOWER(REGEXP_REPLACE(O.NAME,'[[:punct:][:space:]]', '','g')) CLEAN_NAME
FROM	OSCARS O
LEFT JOIN
		(	SELECT	DISTINCT
					N.PRIMARY_NAME,
					P.CATEGORY,
					P.JOB,
		 			LOWER(REGEXP_REPLACE(N.PRIMARY_NAME,'[[:punct:][:space:]]', '','g')) CLEAN_NAME
			FROM	TITLES T
			INNER JOIN
					RATINGS R
			ON		T.TITLE_CONSTANT = R.TITLE_CONSTANT
			AND		T.IS_ADULT = 0
			AND		T.TITLE_TYPE IN ('movie','short')
			AND		T.START_YEAR >= 1927
			AND		R.NUMBER_VOTES > 100
			INNER JOIN
					PRINCIPALS P
			ON		T.TITLE_CONSTANT = P.TITLE_CONSTANT
			INNER JOIN
					NAMES N
			ON		P.NAME_CONSTANT = N.NAME_CONSTANT
		) NI
ON		LOWER(REGEXP_REPLACE(O.NAME,'[[:punct:][:space:]]', '','g')) 
