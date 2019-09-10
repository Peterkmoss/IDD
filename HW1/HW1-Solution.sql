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
/*
\echo 'Ex. 1';
select count(distinct R.peopleid)
from results R
where R.result is null;

-- 2
\echo 'Ex. 2';
select P.id, P.name
from people P
  left join results R on P.id = R.peopleid
where R.competitionid is null;

-- 3
\echo 'Ex. 3';
select distinct P.id, P.name
from people P
  join results R on P.id = R.peopleid
  join competitions C on C.id = R.competitionid
  join sports S on S.id = R.sportid
where (S.name = 'High Jump' and S.record = R.result) 
   or (extract(month from C.held) = 6 and extract(year from C.held) = 2002);

-- 4
\echo 'Ex. 4';
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
\echo 'Ex. 5';
select S.id, S.name, to_char(MAX(R.result), '90.99') as maxres
from sports S
  join results R on S.id = R.sportid
group by S.id
order by S.id;

-- 6
\echo 'Ex. 6';
select P.id, P.name, count(R.result) as total
from people P
  join results R on P.id = R.peopleid
  join sports S on R.sportid = S.id
where R.result = S.record
group by P.id
  having count(distinct R.sportid) >= 2;

-- 7
\echo 'Ex. 7';
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
\echo 'Ex. 8';
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
\echo 'Ex. 9';
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

-- 10
\echo 'Ex. 10';
select S.id, S.name, S.record, MIN(R.result)
from sports S
  join results R on S.id = R.sportid
  join competitions C on R.competitionid = C.id
where R.result is not null
group by S.id, S.name, S.record
  having count(distinct C.place) = (select count(distinct place) from competitions);
*/
-- Part 2
/*

Schema:
person(id, name, gender, birthdate, deathdate, height)
movie(id, title, year, color, country, language, distrvotes, imdbvotes, imdbrank, releasedate)
genre(genre, category)
movie_genre(movieid, genre)
role(role)
involved(personid, movieid, role)

*/

-- 11
\echo 'Ex. 11';
select count(*)
from person
where height is null;

-- 12
\echo 'Ex. 12';
select count(*)
from (
  select i.movieid
  from involved i
    join person p on i.personid = p.id
  where p.height is not null
  group by i.movieid
    having avg(p.height) > 190
) tmp;

-- 13
 \echo 'Ex. 13';
select count(*)
from (
  select count(*)
  from movie_genre mg
  group by mg.movieid, mg.genre
  having count(*) > 1
) tmp;

-- 14
\echo 'Ex. 14';
select count(distinct p.id)
from person p
  join involved i on p.id = i.personid
  join (select distinct i.movieid
        from involved i
          join person p on i.personid = p.id
        where p.name = 'Steven Spielberg'
          and i.role = 'director') d on d.movieid = i.movieid
where i.role = 'actor';

-- 15
\echo 'Ex. 15';
select count(*)
from movie m
  left join involved i on m.id = i.movieid
where i.movieid is null
  and m.year = 1999;

-- 16
\echo 'Ex. 16';
select count(*)
from (
select i_actor.personid
from involved i_actor
  join involved i_director on i_actor.personid = i_director.personid 
                          and i_actor.movieid = i_director.movieid
where i_actor.role  = 'actor' 
  and i_director.role = 'director'
group by i_actor.personid
having count(*) >= 2
) tmp;

-- 17
\echo 'Ex. 17';
select count(*)
from (select count(*)
from involved i
  join role r on i.role = r.role
  join movie m on i.movieid = m.id
where m.year = 1999
group by i.movieid
  having count(distinct i.role) = (select count(*) from role)
) tmp;

-- 18
\echo 'Ex. 18';
select count(*)
from (
select count(*)
from person p
  join involved i on p.id = i.personid
  join movie_genre mg on i.movieid = mg.movieid
  join genre g on mg.genre = g.genre
where g.genre in (select genre from genre where category = 'Newsworthy')
group by p.id
  having count(distinct g.genre) = (select count(*) from genre where category = 'Newsworthy')
) tmp;