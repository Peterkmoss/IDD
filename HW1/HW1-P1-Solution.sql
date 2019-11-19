/*
Copyright Peter Konnerup Moss, Sep. 2019
*/

-- Part 1
/*

Schema:
Competitions(id, place, held)
Gender(gender, description)
People(id, name, gender, height)
Results(peopleid, competitionid, sportid, result)
Sports(id, name, record)

*/

-- 1
\echo 'Exercise. 1'
select count(distinct R.peopleid)
from results R
where R.result is null;

-- 2
\echo 'Exercise. 2'
select P.id, P.name
from people P
  left join results R on P.id = R.peopleid
where R.competitionid is null;

-- 3
\echo 'Exercise. 3'
select distinct P.id, P.name
from people P
  join results R on P.id = R.peopleid
  join competitions C on C.id = R.competitionid
  join sports S on S.id = R.sportid
where (S.name = 'High Jump' and S.record = R.result) 
   or (extract(month from C.held) = 6 and extract(year from C.held) = 2002);

-- 4
\echo 'Exercise. 4'
select P.id, P.name
from people P
  join results R on P.id = R.peopleid
  join sports S on R.sportid = S.id
where R.result = S.record
INTERSECT
select P.id, P.name
from people P
  join results R on R.peopleid = P.id
group by P.id, P.name
having count(R.sportid) = 1;

-- 5
\echo 'Exercise. 5'
select S.id, S.name, to_char(MAX(R.result), '90.99') as maxres
from sports S
  join results R on S.id = R.sportid
group by S.id
order by S.id;

-- 6
\echo 'Exercise. 6'
select P.id, P.name, count(R.result) as total
from people P
  join results R on P.id = R.peopleid
  join sports S on R.sportid = S.id
where R.result = S.record
group by P.id
  having count(distinct R.sportid) >= 2;

-- 7
\echo 'Exercise. 7'
select distinct P.id, P.name, P.height, R.result, S.name, case 
                                                            when R.result = S.record then 'Yes' 
                                                            else 'No' end as "record?"
from people P
  join results R on P.id = R.peopleid
  join sports S on R.sportid = S.id
  join (select R.sportid, MAX(R.result) as maxres
        from results R
        group by R.sportid) best on best.sportid = R.sportid and best.maxres = R.result;

-- 8
\echo 'Exercise. 8'
select count(*)
from (
    select count(*)
    from people P
    join results R on P.id = R.peopleid
    join competitions C on R.competitionid = C.id
    group by P.id
    having count(distinct C.place) >= 10
) tmp;

-- 9
\echo 'Exercise. 9'
insert into people values (6969, 'Peter Moss', 'M', 1.84); 
insert into results values (6969, 50, 0, 2.11);
insert into results values (6969, 50, 1, 6.78);
insert into results values (6969, 50, 2, 13.15);
insert into results values (6969, 50, 3, 16.66);
insert into results values (6969, 50, 4, 5.52);
insert into results values (6969, 50, 5, 60.46);
insert into results values (6969, 50, 6, 50.41);

select P.id, P.name
from people P
  join results R on P.id = R.peopleid
  join sports S on R.sportid = S.id
where R.result = S.record
group by P.id
  having count(distinct R.sportid) = (select count(*) from sports);

delete from results where peopleid = 6969;
delete from people where id = 6969;
\echo ''

-- 10
\echo 'Exercise. 10'
select S.id, S.name, S.record, MIN(R.result)
from sports S
  join results R on S.id = R.sportid
  join competitions C on R.competitionid = C.id
where R.result is not null
group by S.id, S.name, S.record
  having count(distinct C.place) = (select count(distinct place) from competitions);