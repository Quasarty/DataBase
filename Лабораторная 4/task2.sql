-- 2) Получить прибыль предприятия за каждый 
-- месяц заданного года.

DROP FUNCTION task2(integer);

CREATE OR REPLACE FUNCTION task2(target_year integer)
RETURNS TABLE(month integer, profit money) as $$
BEGIN
    RETURN QUERY
    SELECT
        EXTRACT(MONTH FROM r.repair_end)::integer,
        SUM(t.cost)::money
    FROM repair r
    JOIN repair_type t ON r.id_repair_type = t.id 
    WHERE EXTRACT(YEAR FROM r.repair_end) = target_year 
	GROUP BY EXTRACT(MONTH FROM r.repair_end); 

END;
$$
LANGUAGE plpgsql;

SELECT * FROM task2(2026);
