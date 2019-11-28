--------------------
-- Clear database --
--------------------

drop table if exists gods cascade;
drop table if exists priests cascade;
drop table if exists humans cascade;
drop table if exists sacrifices cascade;
drop table if exists promises cascade;
drop table if exists presides cascade;
drop table if exists valuables cascade;
drop table if exists flesh cascade;
drop table if exists wine cascade;
drop table if exists sacrificed cascade;

drop trigger if exists sacrificeCategory on sacrifices;
drop function if exists CheckSacrifice();
drop trigger if exists sacrificeHasHuman on sacrifices;
drop function if exists CheckHuman();

---------
-- DDL --
---------

create table gods (
	name varchar(50) primary key
);

create table priests (
	id int primary key
);

create table humans (
	id int primary key
);

create table sacrifices (
	id serial primary key,
	value int not null
);

create table valuables (
	id int references sacrifices(id),
	primary key (id)
	-- More attributes
);

create table flesh (
	id int references sacrifices(id),
	primary key (id)
	-- More attributes
);

create table wine (
	id int references sacrifices(id),
	primary key (id)
	-- More attributes
);

create table sacrificed (
	humanId int references humans(id),
	sacrificeId int references sacrifices(id),
	time timestamp not null,
	place varchar(50) not null,
	god varchar(50) references gods(name),
	primary key (humanId, sacrificeId)
);

create table promises (
	humanId int references humans(id),
	god varchar(50) references gods(name),
	promise varchar(100) not null,
	primary key (humanId, god, promise)
);

create table presides (
	humanId int,
	sacrificeId int,
	priestId int references priests(id),
	foreign key (sacrificeId, humanId) references sacrificed(sacrificeId, humanId),
	primary key (sacrificeId, humanId)
);

--------------
-- TRIGGERS --
--------------

CREATE FUNCTION CheckSacrifice() 
RETURNS TRIGGER 
AS 
$$
DECLARE
	cnt int;
	tot int;
	dis int;
BEGIN
	select count(*) from sacrifices into cnt;
	select count(*) from (
		select id from valuables UNION select id from flesh UNION select id from wine
	) x into tot;
	
	select count(*) from (
		select id from valuables UNION ALL select id from flesh UNION ALL select id from wine
	) x into dis;

	if (cnt <> tot) then
		raise exception 'Function CheckSacrifice: Not total!';
	end if;

	if (cnt <> dis) then
		raise exception 'Function CheckSacrifice: Not disjoint!';
	end if;
	-- After trigger, so return value is ignored
	RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER sacrificeCategory 
AFTER INSERT OR UPDATE
ON sacrifices
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE PROCEDURE CheckSacrifice();

CREATE FUNCTION CheckHuman() 
RETURNS TRIGGER 
AS 
$$
DECLARE
BEGIN
	if ((select count(*) from sacrificed where sacrificeId = new.id) == 0) then
		raise exception 'Function CheckHuman: sacrifice not sacrificed!';
	end if;
	-- After trigger, so return value is ignored
	RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER sacrificeHasHuman 
AFTER INSERT OR UPDATE
ON sacrifices
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE PROCEDURE CheckHuman();