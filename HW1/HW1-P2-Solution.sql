/*
Copyright Peter Konnerup Moss, Sep. 2019
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
\echo 'Exercise. 11'
select count(*)
from person
where height is null;

-- 12
\echo 'Exercise. 12'
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
 \echo 'Exercise. 13'
select count(*)
from (
  select count(*)
  from movie_genre mg
  group by mg.movieid, mg.genre
  having count(*) > 1
) tmp;

-- 14
\echo 'Exercise. 14'
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
\echo 'Exercise. 15'
select count(*)
from movie m
  left join involved i on m.id = i.movieid
where i.movieid is null
  and m.year = 1999;

-- 16
\echo 'Exercise. 16'
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
\echo 'Exercise. 17'
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
\echo 'Exercise. 18'
select count(*)
from (
select count(*)
from involved i 
  join movie_genre mg on i.movieid = mg.movieid
where mg.genre in (select genre from genre where category = 'Lame')
group by i.personid
  having count(distinct mg.genre) = (select count(*) from genre where category = 'Lame')
) tmp;