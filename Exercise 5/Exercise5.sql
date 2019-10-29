drop table if exists person cascade;
create table person (
    id      integer primary key,
    name    varchar(100)
);


drop table if exists dane cascade;
create table dane (
    id          integer primary key references person(id),
    nationality varchar(50),
    gender      varchar(1)
);

drop table if exists degree cascade;
create table degree (
    id          integer references dane(id),
    level       varchar(50),
    subject     varchar(50),
    institute   varchar(50),
    year        integer,
    primary key (id, level, subject)
);

drop table if exists employee cascade;
create table employee (
    id integer primary key references person(id)
);

drop table if exists club cascade;
create table club (
    id          integer primary key,
    name        varchar(50),
    nationality varchar(50),
    unique (name, nationality)
);

drop table if exists heldat cascade;
create table heldat (
    tournamentid    integer references tournament(id),
    clubid          integer references club(id),
    venue           varchar(50),
    date            date,
    primary key (tournamentid, clubid, venue, date)
);

drop table if exists memberof cascade;
create table memberof (
    daneid      integer references dane(id),
    clubid      integer references club(id),
    startdate   date not null,
    enddate     date null,
    primary key (daneid, clubid, startdate, enddate)
);

drop table if exists tournament cascade;
create table tournament (
    id      integer primary key,
    name    varchar(50)
);

drop table if exists league cascade;
create table league (
    id              integer,
    tournamentid    integer references tournament(id),
    gender          varchar(1),
    number          integer,
    duration        timestamp,
    time            timestamp,
    primary key (id, tournamentid),
    unique (gender, number)
);

drop table if exists problem cascade;
create table problem (
    id          integer primary key,
    programming varchar,
    dance       varchar,
    name        varchar(50),
    unique (name)
);

drop table if exists writtenby cascade;
create table writtenby (
    employeeid  integer references employee(id),
    problemid   integer references problem(id),
    primary key (employeeid, problemid)
);

drop table if exists monitors cascade;
create table monitors (
    employeeid      integer references employee(id),
    tournamentid    integer references tournament(id) primary key
);

drop table if exists participatesin cascade;
create table participatesin (
    leagueid    integer references league(id),
    daneid      integer references dane(id),
    rank        integer,
    primary key (leagueid, daneid)
);

drop table if exists paysfor cascade;
create table paysfor (
    leagueid    integer references participatesin(leagueid) not null,
    daneid      integer references participatesin(daneid) not null,
    clubid      integer references club(id) not null,
    fee         integer,
    primary key (leagueid, daneid, clubid)
);