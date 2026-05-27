-- 4) Получить суммарная продолжительность ремонта всех станков. 
-- Выявить, продолжительность ремонта каких станков больше средней продолжительности
-- ремонта всех станков.


-- DROP FUNCTION task4();

CREATE OR REPLACE FUNCTION duration_sum()
RETURNS integer AS $$
DECLARE
	dur_sum integer; 
BEGIN
    SELECT 
        SUM(duration)
	INTO dur_sum
    FROM repair r 
    JOIN repair_type t ON r.id_repair_type = t.id;

	RETURN dur_sum;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION repair_count()
RETURNS integer AS $$
DECLARE
	rep_count integer; 
BEGIN
    SELECT 
        COUNT(*)
	INTO rep_count
    FROM repair r;
	RETURN rep_count;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION task4()
RETURNS TABLE(country text, brand text, year smallint, repair_sum integer) as $$
BEGIN
    RETURN QUERY
	SELECT
		sum.country,
		sum.brand, 
		sum.year, 
		sum.repair_sum
	FROM 
	    (SELECT 
	        m.country,
	        m.brand,
	        m.year,
			SUM(t.duration)::integer as repair_sum
	    FROM machinery m
		JOIN repair r ON m.id = r.id_machinery 
		JOIN repair_type t ON r.id_repair_type = t.id
		GROUP BY m.country, m.brand, m.year) sum
	WHERE sum.repair_sum > duration_sum()/repair_count();

END;
$$
LANGUAGE plpgsql;

SELECT * FROM task4();

SELECT * FROM duration_sum();

select m.country, m.brand, m.year, SUM(t.duration)::integer as repair_sum 
from machinery m JOIN repair r ON m.id = r.id_machinery 
		JOIN repair_type t ON r.id_repair_type = t.id
		GROUP BY m.country, m.brand, m.year;


SELECT * 
FROM repair_type t
JOIN repair r ON r.id_repair_type = t.id;