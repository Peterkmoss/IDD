-- Query 7 (+ counting results)

drop index if exists test;
create index test on Results(sportID, result);

SELECT NOW();

EXPLAIN ANALYZE
select COUNT(*)
from (
select R.peopleID, R.sportID, R.result
from Results R
where (R.sportID, R.result) in (
    select R1.sportID, max(R1.result)
    from Results R1
    group by R1.sportID)
) X;

SELECT NOW();
