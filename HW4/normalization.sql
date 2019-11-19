--id, pid, sid -> all
--id -> mid
--id -> mn
--pid -> pn
--sid -> sn
--sn -> sid
--mid -> mn
--mn -> mid

--r1(id, pid, sid)
--r2(id, mid)
--r3(mid, mn)
--r4(pid, pn)
--r5(sid, sn)

drop table if exists managers cascade;
create table managers (
	mid int primary key,
	mn varchar(50) not null
);

insert into managers
select distinct mid, mn
from projects;

drop table if exists people cascade;
create table people (
	pid int primary key,
	pn varchar(50) not null
);

insert into people
select distinct pid, pn
from projects;

drop table if exists students cascade;
create table students (
	sid int primary key,
	sn varchar(50) not null
);

insert into students
select distinct sid, sn
from projects;

drop table if exists projectmanagers cascade;
create table projectmanagers (
	id int primary key,
	mid int references managers(mid)
);

insert into projectmanagers
select distinct id, mid
from projects;

drop table if exists projectsnew cascade;
create table projectsnew (
	id int references projectmanagers(id),
	pid int references people(pid),
	sid int references students(sid),
	primary key (id, pid, sid)
);

insert into projectsnew
select distinct id, pid, sid
from projects;

-- All relations are in BCNF and therefore the schema is in BCNF.
