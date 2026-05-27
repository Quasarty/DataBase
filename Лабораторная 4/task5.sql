-- 5) Получить кросс-таблицу из итоговой таблицы R(«Станок», «год», «количество ремонтов»).
-- Значения атрибута «год» представить в виде колонок кросс-таблицы.

CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT 
m.id,
EXTRACT(year FROM r.repair_end),
COUNT(m.id)
FROM machinery m
JOIN repair r ON r.id_machinery = m.id
GROUP BY m.id, EXTRACT(year FROM r.repair_end);

CREATE OR REPLACE FUNCTION task5()
RETURNS TABLE(machinery_id int, "2023" smallint, "2024" smallint, "2025" smallint, "2026" smallint)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM crosstab(
		-- Таблица состоит из 3 столбцев
		-- 1) то, что останется в левом вертикальном столбце. По нему данные группируются.
	    -- 2) значения из этой колонки распределятся по горизонтали и станут именами новых столбцов.
		-- 3) данные, которые запишутся в ячейки на пересечении строки и столбца.
		'SELECT 
		m.id,
		EXTRACT(year FROM r.repair_end),
		COUNT(m.id)
		FROM machinery m
		JOIN repair r ON r.id_machinery = m.id
		GROUP BY m.id, EXTRACT(year FROM r.repair_end);',
		-- Т.к. могут быть пропуски, нужен второй параметр
		'SELECT DISTINCT EXTRACT(year FROM repair_end) FROM repair ORDER BY 1'
	) AS result_table(
		machinery_id int,
		"2023" smallint,
		"2024" smallint,
		"2025" smallint,
		"2026" smallint);
END;
$$
LANGUAGE plpgsql

select * from task5();

