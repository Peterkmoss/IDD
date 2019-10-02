-- Drop all tables and create the ones in this schema
drop schema public cascade;
create schema public;
grant all on schema public to postgres;
grant all on schema public to public;

create table party (
    id serial primary key,
    name varchar not null,
    country varchar not null,
    unique (name, country)
);

create table person (
    id serial primary key,
    name varchar not null,
    dod date null,
    dob date not null,
    address varchar not null,
    phone int not null
);

create table member (
    id int primary key
        references person(id),
    startdate date not null,
    partyid int null 
        references party(id)
);

create table enemy (
    id int primary key
        references person(id)
);

-- Look at
create table linking (
    id serial primary key,
    name varchar not null,
    type varchar not null,
    description varchar not null
);

create table participates (
    linkingid int 
        references linking(id),
    personid int
        references person(id),
    primary key (linkingid, personid)
);

create table role (
    id serial primary key,
    title varchar not null,
    unique(title)
);

create table asset (
    memberid int
        references member(id),
    name varchar,
    description varchar not null,
    use varchar not null,
    primary key (memberid, name)
);

create table sponsor (
    id serial primary key,
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
    date date not null,
    amount float not null,
    primary key (sponsorid, memberid),
    unique (sponsorid, memberid, date)
);

create table reviews (
    memberid int
        references member(id),
    sponsorid int,
    grantsmember int,
    date date not null,
    grade int not null
        check (grade >= 1 and grade <= 10),
    foreign key (sponsorid, grantsmember) 
        references grants(sponsorid, memberid),
    primary key (memberid, sponsorid, grantsmember)
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

-- Can't leave the party - even in death!
create function CantLeave()
returns trigger
as $$
begin
    raise exception 'Cant_leave: You can''t leave the WASP party!';
end;
$$ language plpgsql;

create trigger CantLeave
    before delete on member 
    for each row 
execute procedure CantLeave();

-- 
create function CheckPeople()
returns trigger
as $$
begin
return new;
end; $$ language plpgsql;

-- Trigger to enforce people are either a member or an enemy
create function CheckPerson() 
returns trigger 
as
$$
declare

begin
	if  ((select id from member where id = new.id) is null
          and
         (select id from enemy where id = new.id) is null) 
        then raise exception 'CheckPeople: You have to be either a member or an enemy';
    end if;
	return new;
end;
$$ 
language plpgsql;

create constraint trigger CheckPerson
after insert or update
on person 
-- The next line makes the trigger run at the end of the transaction!
deferrable initially deferred
for each row execute procedure CheckPerson();

-- Linkings check
create function CheckLinking()
returns trigger
as $$
begin
    if ((select linkingid from participates where linkingid = new.id) is null)
        then raise exception 'CheckLinking: A linking has to have at least one person participating';
    end if;
    return new;
end; $$ language plpgsql;

create constraint trigger CheckLinking
after insert or update
on linking 
-- The next line makes the trigger run at the end of the transaction!
deferrable initially deferred
for each row execute procedure CheckLinking();