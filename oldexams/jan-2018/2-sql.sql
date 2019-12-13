-- @conn jan2018

--? Question a
\echo 'A'
select count(*)
from songs
where duration >= '1:00:00';

--? Question b
\echo 'B'
select extract(epoch from sum) as sum
from (
select sum(duration)
from songs
) x;

--? Question c
\echo 'C'
select max(count)
from (
select count(*)
from songs
group by extract(year from releasedate)
) x;

--? Question d
\echo 'D'
select count(*)
from albumartists aa
	join artists a on a.artistid = aa.artistid
where a.artist = 'Tom Waits';

--? Question e
\echo 'E'
select count(distinct albumid)
from albumgenres ag
	join genres g on g.genreid = ag.genreid
where genre like 'Alt%';

--? Question f
\echo 'F'
select count(distinct s1.songid)
from songs s1
	join songs s2 on s1.title = s2.title
where s1.songid <> s2.songid;

--? Question g
\echo 'G'
select avg(count)
from (
	select count(*)
	from albumgenres
	group by albumid
) x;

--? Question h
\echo 'H'
select count(*)
from albums
where albumid not in (
	select albumid
	from albumgenres ag
		join genres g on g.genreid = ag.genreid
	where g.genre = 'HipHop');