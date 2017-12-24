DROP TABLE IF EXISTS dates;
CREATE TABLE dates (
    idDate INTEGER PRIMARY KEY,
    fulldate DATE NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    week INTEGER NOT NULL,
    dayOfWeek INTEGER NOT NULL,
    weekend INTEGER NOT NULL,
    UNIQUE td_ymd_idx (year , month , day),
    UNIQUE td_dbdate_idx (fulldate)
)  ENGINE=INNODB;

DROP PROCEDURE IF EXISTS fill_date_dimension;
DELIMITER //
CREATE PROCEDURE fill_date_dimension(IN startdate DATE,IN stopdate DATE)
BEGIN
	DECLARE currentdate DATE;
	SET currentdate = startdate;
	WHILE currentdate < stopdate DO
		INSERT INTO dates VALUES (
		YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
		currentdate,
		YEAR(currentdate),
		MONTH(currentdate),
		DAY(currentdate),
		QUARTER(currentdate),
		WEEKOFYEAR(currentdate),

		CASE DAYOFWEEK(currentdate)-1 WHEN 0 THEN 7 ELSE DAYOFWEEK(currentdate)-1 END ,
		CASE DAYOFWEEK(currentdate)-1 WHEN 0 THEN 1 WHEN 6 then 1 ELSE 0 END);
		SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
	END WHILE;
END
//
DELIMITER ;

TRUNCATE TABLE dates;
CALL fill_date_dimension('2016-01-01','2050-01-01');
OPTIMIZE TABLE dates;
