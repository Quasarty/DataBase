-- ** Database generated with pgModeler (PostgreSQL Database Modeler).
-- ** pgModeler version: 1.2.3
-- ** PostgreSQL version: 18.0
-- ** Project Site: pgmodeler.io
-- ** Model Author: ---

-- ** Database creation must be performed outside a multi lined SQL file. 
-- ** These commands were put in this file only as a convenience.

-- object: course_db | type: DATABASE --
-- DROP DATABASE IF EXISTS course_db;
-- CREATE DATABASE course_db;
-- ddl-end --


SET search_path TO pg_catalog,public;
-- ddl-end --

-- object: public.machinery | type: TABLE --
DROP TABLE IF EXISTS public.machinery CASCADE;
CREATE TABLE public.machinery (
	id integer NOT NULL,
	country text NOT NULL,
	year smallint NOT NULL,
	brand text NOT NULL,
	-- Значение по умолчанию = 0 (не было ремонтов)
	repair_ammount smallint NOT NULL DEFAULT 0,
	id_client integer NOT NULL,
	id_machinery_category integer NOT NULL,
	CONSTRAINT machinery_pk PRIMARY KEY (id),
	-- Столетние и более старые станки сомнительны
	CHECK (year >= 1900)
);
-- ddl-end --
ALTER TABLE public.machinery OWNER TO postgres;
-- ddl-end --

-- object: public.repair | type: TABLE --
DROP TABLE IF EXISTS public.repair CASCADE;
CREATE TABLE public.repair (
	id integer NOT NULL,
	repair_start date NOT NULL,
	repair_end date NOT NULL,
	id_machinery integer NOT NULL,
	id_repair_type integer NOT NULL,
	CONSTRAINT repair_pk PRIMARY KEY (id),
	-- Дата начала всегда меньше даты конца
	CHECK (repair_start < repair_end)
);
-- ddl-end --
ALTER TABLE public.repair OWNER TO postgres;
-- ddl-end --

-- object: public.client | type: TABLE --
DROP TABLE IF EXISTS public.client CASCADE;
CREATE TABLE public.client (
	id integer NOT NULL,
	-- Клиент заносится в базу только один раз
	company_name text UNIQUE NOT NULL,
	CONSTRAINT client_pk PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.client OWNER TO postgres;
-- ddl-end --

-- object: client_fk | type: CONSTRAINT --
ALTER TABLE public.machinery DROP CONSTRAINT IF EXISTS client_fk CASCADE;
ALTER TABLE public.machinery ADD CONSTRAINT client_fk FOREIGN KEY (id_client)
REFERENCES public.client (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.machinery_category | type: TABLE --
DROP TABLE IF EXISTS public.machinery_category CASCADE;
CREATE TABLE public.machinery_category (
	-- Категория заносится в базу только один раз
	name text UNIQUE NOT NULL,
	id integer NOT NULL,
	CONSTRAINT machinery_category_pk PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.machinery_category OWNER TO postgres;
-- ddl-end --

-- object: public.repair_type | type: TABLE --
DROP TABLE IF EXISTS public.repair_type CASCADE;
CREATE TABLE public.repair_type (
	id integer NOT NULL,
	name text NOT NULL,
	duration smallint NOT NULL,
	cost money NOT NULL,
	CONSTRAINT repair_type_pk PRIMARY KEY (id),
	CHECK (duration > 0)
);
-- ddl-end --
ALTER TABLE public.repair_type OWNER TO postgres;
-- ddl-end --

-- object: machinery_fk | type: CONSTRAINT --
ALTER TABLE public.repair DROP CONSTRAINT IF EXISTS machinery_fk CASCADE;
ALTER TABLE public.repair ADD CONSTRAINT machinery_fk FOREIGN KEY (id_machinery)
REFERENCES public.machinery (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: machinery_category_fk | type: CONSTRAINT --
ALTER TABLE public.machinery DROP CONSTRAINT IF EXISTS machinery_category_fk CASCADE;
ALTER TABLE public.machinery ADD CONSTRAINT machinery_category_fk FOREIGN KEY (id_machinery_category)
REFERENCES public.machinery_category (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: repair_type_fk | type: CONSTRAINT --
ALTER TABLE public.repair DROP CONSTRAINT IF EXISTS repair_type_fk CASCADE;
ALTER TABLE public.repair ADD CONSTRAINT repair_type_fk FOREIGN KEY (id_repair_type)
REFERENCES public.repair_type (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


