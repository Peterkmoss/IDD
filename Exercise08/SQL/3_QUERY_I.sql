-- Query 1

SELECT NOW();

EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Results R 
INNER JOIN Sports S 
        ON R.sportID = S.ID
WHERE S.name = 'Long Jump';

SELECT NOW();
