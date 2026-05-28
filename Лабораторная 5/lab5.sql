-- ALTER TABLE repair ADD late_status bool DEFAULT false
-- alter table repair rename column late_status to is_late
-- alter table repair alter column repair_end drop not null

-- select * from repair

-- При добавлении ремонта сразу прибавлять количество ремонтов у станка +
-- Если удалить незаконченный ремонт, то вычесть количество ремонтов
CREATE OR REPLACE FUNCTION add_repair_func()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE machinery 
    SET repair_ammount = repair_ammount + 1 
    WHERE id = NEW.id_machinery;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS add_repair_trigger ON repair;

CREATE TRIGGER add_repair_trigger
AFTER INSERT ON repair
FOR EACH ROW
EXECUTE FUNCTION add_repair_func();


CREATE OR REPLACE FUNCTION remove_repair_func()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.repair_end IS NULL THEN
        UPDATE machinery 
        SET repair_ammount = repair_ammount - 1 
        WHERE id = OLD.id_machinery;
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS remove_repair_trigger ON repair;

CREATE TRIGGER remove_repair_trigger
AFTER DELETE ON repair
FOR EACH ROW
EXECUTE FUNCTION remove_repair_func();


-- Статус просрочено, если (дата конца ремонта)-(дата начала ремонта) > длительность_ремонта
CREATE OR REPLACE FUNCTION is_late_func()
RETURNS TRIGGER AS $$
DECLARE
	dur smallint;
BEGIN
	SELECT t.duration INTO dur
	FROM repair_type t WHERE NEW.id_repair_type = t.id;

	IF (NEW.repair_end IS NOT NULL) THEN
		 IF (NEW.repair_end - NEW.repair_start)::smallint > dur THEN
		 NEW.is_late = true;
		 END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS is_late_trigger ON repair;

CREATE TRIGGER is_late_trigger
BEFORE INSERT OR UPDATE ON repair
FOR EACH ROW
EXECUTE FUNCTION is_late_func();

-- Год станка не позже, чем дата его начала ремонта
CREATE OR REPLACE FUNCTION machinery_year_func()
RETURNS TRIGGER AS $$
DECLARE 
	m_year int;
BEGIN
	SELECT year INTO m_year
	FROM machinery
	WHERE id = new.id_machinery;

	IF EXTRACT(YEAR FROM NEW.repair_start) < m_year THEN
		RAISE EXCEPTION 'Machinery year < repair year';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS machinery_year_trigger ON repair;

CREATE TRIGGER machinery_year_trigger
BEFORE INSERT OR UPDATE ON repair
FOR EACH ROW
EXECUTE FUNCTION machinery_year_func();