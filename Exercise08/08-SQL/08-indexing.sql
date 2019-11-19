SELECT COUNT(*) 
FROM movie 
WHERE year=1948;

SELECT COUNT(*) 
FROM movie 
WHERE year=1920 OR year=1924 OR year=1928 OR year=1932 
   OR year=1936 OR year=1940 OR year=1944 OR year=1948;


CREATE INDEX movieyear ON movie (year);
DROP INDEX IF EXISTS movieyear;

EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM movie 
WHERE year=1948;

EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM movie 
WHERE year=1920 OR year=1924 OR year=1928 OR year=1932 
   OR year=1936 OR year=1940 OR year=1944 OR year=1948;
