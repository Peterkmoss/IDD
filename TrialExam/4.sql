create table projects (
	pid serial primary key,
	name varchar(50) not null
);

create table researchers (
	rid int primary key,
	name varchar(50) not null
);

create table articles (
	aid int primary key,
	year int not null
);

create table journals (
	aid int primary key references articles(aid),
	journal varchar(500) not null,
	volume int not null,
	sid int not null references staff(sid)
);

create table conferences (
	aid int primary key references articles(aid),
	conference varchar(500) not null
);

create table staff (
	sid int primary key,
	name varchar(50) not null
);

create table workson (
	pid int references projects(pid),
	rid int references researchers(rid),
	primary key (pid, rid)
);

create table writes (
	rid int references researchers(rid),
	aid int references articles(aid),
	primary key (rid, aid)
);

create table evaluates (
	pid int references workson(pid),
	rid int references workson(rid),
	sid int references staff(sid),
	rating int not null,
	primary key (sid, pid, rid)
);