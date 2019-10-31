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

drop table if exists RentalsNew;
create table RentalsNew (
    pid int references People(pid),
    hid int references H1(hid),
    s int not null,
    primary key (pid, hid)
);

drop table if exists People;
create table People (
    pid int primary key,
    pn varchar(50) not null
);

drop table if exists H1;
create table H1 (
    hid int primary key,
    hs varchar(50) not null,
    hz int references H2(hz)
);

drop table if exists H2;
create table H2 (
    hz int primary key,
    hc varchar(50) not null
);

--! The normal form for the new schema is BCNF

--? Boats
-- bl, bno -> z, t, bn, ssn
-- z -> bl
-- z -> t

--! Boats(bl, bno, z, bn, ssn)
--! Zipcodes(z, t)

drop table if exists BoatsNew;
create table BoatsNew (
    bl char(2),
    bno int,
    z int references Zipcodes(z),
    bn varchar(50),
    ssn char(10)
    primary key (bl, bno)
);

drop table if exists Zipcodes;
create table Zipcodes(
    z int primary key,
    t varchar(50)
);

--! The normal form for the new schema is 3NF