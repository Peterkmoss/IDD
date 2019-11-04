--? Rentals
-- pid, hid -> pn, s, hs, hz, hc
-- pid -> pn
-- hid -> hs
-- hid -> hz
-- hid -> hc
-- hz -> hc

--! Rentals(pid, hid, s)
--! People(pid, pn)
--! H1(hid, hs, hz)
--! H2(hz, hc)

drop table if exists People cascade;
drop table if exists H2 cascade;
drop table if exists H1 cascade;
drop table if exists RentalsNew cascade;

create table People (
    pid int primary key,
    pn varchar(50) not null
);

insert into People(pid, pn)
select distinct pid, pn
from Rentals;

create table H2 (
    hz int primary key,
    hc varchar(50) not null
);

insert into H2(hz, hc)
select distinct hz, hc
from Rentals;

create table H1 (
    hid int primary key,
    hs varchar(50) not null,
    hz int not null references H2(hz)
);

insert into H1(hid, hs, hz)
select distinct hid, hs, hz
from Rentals;

create table RentalsNew (
    pid int references People(pid),
    hid int references H1(hid),
    s int not null,
    primary key (pid, hid)
);

insert into RentalsNew(pid, hid, s)
select distinct pid, hid, s
from Rentals;

--! The normal form for the new schema is BCNF

--? Boats
-- bl, bno -> z, t, bn, ssn
-- z -> bl
-- z -> t

--! Boats(bl, bno, z, bn, ssn)
--! Zipcodes(z, t)

drop table if exists Zipcodes cascade;
drop table if exists BoatsNew cascade;

create table Zipcodes(
    z int primary key,
    t varchar(50)
);

insert into Zipcodes(z, t)
select distinct z, t
from Boats;

create table BoatsNew (
    bl char(2),
    bno int,
    z int references Zipcodes(z),
    bn varchar(50),
    ssn char(10),
    primary key (bl, bno)
);

insert into BoatsNew(bl, bno, z, bn, ssn)
select distinct bl, bno, z, bn, ssn
from Boats;

--! The normal form for the new schema is 3NF

--* Testing to see if all the entries are in the new relations
select count(*) from Rentals;
select count(*) from RentalsNew;

select count(*) from Boats;
select count(*) from BoatsNew;