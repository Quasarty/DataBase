-- 1) Получить классификацию видов ремонта по заданным диапазонам цен.
-- Диапазоны цен задаются в отдельной таблице. Совокупность видов ремонта представить
-- в виде массива строк.

-- CREATE TABLE price_range(
-- 	min money NOT NULL,
-- 	max money NOT NULL,
-- 	CHECK (min <= max)
-- );

insert into price_range
values
(5001, 15000),
(15001, 30000);

select * from price_range;
-- update price_range
-- set
-- min = 0,
-- max = 5000
-- where TRUE;

-- подсказка: join range_price + repair_type с проверкой входа цены в диапозон
-- todo в результате таблица с разными диапозонами цен - столбцы: (диапозон, массив строк)
-- CREATE OR REPLACE FUNCTION task1()
-- RETURNS text[] as $$
-- DECLARE
-- 	res text[];
-- 	min money;
-- 	max money;
-- BEGIN

-- 	SELECT r.min INTO min FROM price_range r; 
-- 	SELECT r.max INTO max FROM price_range r; 

-- 	SELECT ARRAY_AGG(name) INTO res FROM repair_type WHERE (min <= cost  AND cost <= max ); 
	
	
-- 	return res;
-- END;
-- $$
-- LANGUAGE plpgsql;
-- DROP FUNCTION task1();

CREATE OR REPLACE FUNCTION task1()
RETURNS TABLE(cost_range text, repairs text[]) as $$
BEGIN 
	RETURN QUERY
	SELECT
		r.min::text || ' - ' || r.max::text AS cost_range,
		ARRAY_AGG(t.name) 
	FROM price_range r
	JOIN repair_type t ON (r.min <= t.cost AND t.cost <= max)
	GROUP BY r.min::text || ' - ' || r.max::text;
	
END;
$$
LANGUAGE plpgsql;


select * from task1();