drop schema public cascade;
create schema public;

grant all on schema public to postgres;
grant all on schema public to public;

create table person (
    id int primary key,
    name varchar not null,
    dod date not null,
    dob date null,
    address varchar not null,
    phone varchar not null
);

create table member (
    id int primary key
        references person(id),
    startDate date not null
);

create table enemy (
    id int primary key
        references person(id)
);

create table linking (
    id int primary key,
    name varchar not null,
    type varchar not null,
    description varchar not null
);

create table role (
    id int primary key,
    title varchar not null,
    unique(title)
);

create table asset (
    name varchar,
    memberid int
        references person(id),
    description varchar,
    use varchar,
    primary key (name, memberid)
);

create table party (
    id int primary key,
    name varchar not null,
    country varchar not null,
    unique (name, country)
);

create table monitors (
    partyid int 
        references party(id),
    memberid int 
        references member(id),
    primary key (partyid, memberid)
);

create table sponsor (
    id int primary key,
    industry varchar not null,
    address varchar not null,
    name varchar not null
);

create table grants (
    sponsorid int 
        references sponsor(id),
    memberid int 
        references member(id),
    payback varchar not null,
    date date,
    amount float not null,
    primary key (sponsorid, memberid, date)
);

create table reviews (
    memberid int not null
        references member(id),
    sponsorid int not null,
    grantsmember int not null,
    gdate date not null,
    rdate date not null,
    grade int not null
        check (grade >= 1 and grade <= 10),
    foreign key (sponsorid, grantsmember, gdate) 
        references grants(sponsorid, memberid, date),
    primary key (memberid, sponsorid, grantsmember, gdate)
);

create table fills (
    memberid int 
        references member(id),
    roleid int 
        references role(id),
    salary float not null,
    enddate date not null,
    startdate date not null,
    primary key (memberid, roleid)
);

create table opponent (
    memberid int 
        references member(id),
    enemyid int 
        references enemy(id),
    startdate date not null,
    enddate date null,
    primary key (memberid, enemyid)
);