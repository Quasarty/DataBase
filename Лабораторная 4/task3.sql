-- 3) Получить список из 3 самых «ненадежных» (часто ремонтируемых) станков.
-- Для каждого их них указать дату самого первого и самого последнего ремонта.

DROP FUNCTION task3();

-- todo правильно заполнить инсерт
CREATE OR REPLACE FUNCTION task3()
RETURNS TABLE(country text, brand text, year smallint, repair_ammount smallint, oldest date, newest date) as $$
BEGIN
    RETURN QUERY
    SELECT 
        m.country,
        m.brand,
        m.year,
		m.repair_ammount,
		MIN(r.repair_end),
		MAX(r.repair_end)
    FROM machinery m
	JOIN repair r ON m.id = r.id_machinery 
	GROUP BY m.country, m.brand, m.year, m.repair_ammount
    ORDER BY repair_ammount DESC
    LIMIT 3;

END;
$$
LANGUAGE plpgsql;

SELECT * FROM task3();
