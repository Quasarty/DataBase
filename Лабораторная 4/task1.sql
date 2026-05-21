CREATE TABLE price_range(
	min money NOT NULL,
	max money NOT NULL,
	CHECK (min <= max)
);

-- todo: rename
CREATE OR REPLACE FUNCTION task1(table_name text)
RETURNS text as $$
DECLARE
	res text;
BEGIN
	
	
	return res;
END;
$$
LANGUAGE plpgsql;