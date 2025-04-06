CREATE TABLE t (porcento INT, dt DATETIME);

DROP TABLE IF EXISTS t;

DELIMITER $

CREATE TRIGGER bi_t BEFORE INSERT ON t
	FOR EACH ROW BEGIN
		SET NEW.dt = CURRENT_TIMESTAMP();
        IF NEW.porcento < 0 THEN
			SET NEW.porcento = 0;
		ELSEIF NEW.porcento > 100 THEN
			SET NEW.porcento = 100;
		END IF;
	END$
    
DELIMITER ;

DROP TRIGGER IF EXISTS bi_t;

INSERT INTO t (porcento) VALUES
(-10),
(110),
(120),
(-23),
(0),
(50);

SELECT * FROM t;