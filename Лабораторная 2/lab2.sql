-- Полный вывод отдельной таблицы 
SELECT * FROM client;


-- Вывод нужных столбцев с новым вычисленным столбцем 
SELECT
name, 
duration, 
cost,
-- Стоимость ремонта в день
(cost/duration) AS cost_per_day
FROM repair_type;


-- Вывод станков, где количество починок равно 0 или 2
SELECT * from machinery
WHERE repair_ammount = 0 OR repair_ammount = 2;


-- Вывод клиентов, у которых в названии имеется слово "Мастерская"
SELECT * from client
WHERE company_name LIKE '%Мастерска%';


-- Вывод всех станков, с присоединным
-- к ним столбцем с временем окончания работы
SELECT
	m.*,
	r.repair_end
FROM machinery m
-- Присоединяем таблицу repair, так, чтобы строки соотносились по id станка
JOIN repair r ON r.id_machinery = m.id;


-- Вывод компаний и информации об их станка
-- Если у компании несколько станков, у неё будет несколько строк
SELECT
	c.company_name,
	m.country,
	m.year,
	m.brand
FROM machinery m
-- Соотносим айди
JOIN client c ON m.id_client = c.id;


-- Отличие RIGHT JOIN от JOIN(INNER JOIN) в том, что
-- даже если у клиента нет станка, то он все равно выведется, 
-- но информация о станке будет null
-- (LEFT JOIN сделал бы так же, но для станков, т.е. вывел бы и станки без хозяина)
SELECT
	c.company_name,
	m.country,
	m.year,
	m.brand
FROM machinery m
RIGHT JOIN client c ON m.id_client = c.id;


-- UNION(ИЛИ) объединяет две таблицы (нужное одинаковое кол-во столбцев)
-- Сначала фильтруем станки из Германии, затем объединяем с таблицей,
-- где станки из Японии 
SELECT brand, country, year FROM machinery WHERE country = 'Германия'
UNION
SELECT brand, country, year FROM machinery WHERE country = 'Япония';


-- Выводит список всех стран, и компаний с "Мастерская" в названии
-- При этом создает новый столбец type,
-- где указывается страна это или клиент 
SELECT country AS name, 'Страна' as type FROM machinery
UNION
-- название столбца не надо указывать, он всегда берется как у верхнего
SELECT company_name AS client, 'Клиент' FROM client WHERE company_name LIKE '%Мастерска%';


-- INTERSECT(И) выводит только то, что есть в первой таблице И во второй
-- Выводит айди клиентов, со станками из Германии
SELECT id FROM client
INTERSECT
SELECT id_client FROM machinery WHERE country = 'Германия';


-- EXCEPT(минус) выводит все из первой таблице, КРОМЕ того, что есть во второй
-- Выводит айди клиентов, со станками НЕ из Германии
SELECT id FROM client
EXCEPT
SELECT id_client FROM machinery WHERE country = 'Германия';