-- Test that you cannot leave the WASP party
begin transaction;

insert into person(name, dob, address, phone)
    values ('Name', current_date, 'Address', 12345678);

insert into member(id, startdate)
    values ( (select id from person where name = 'Name') , current_date);

delete from member where id = (select id from person where name = 'Name');

rollback;

-- Test total inheritance on people relation
-- Test 1: Insert person, no sub-class
--         This test should fail!
insert
into person(Name, Address, Phone, DOB) 
values ('Bjorn', 'Home', 1, CURRENT_DATE);

-- Test 2: Insert person, no sub-class, but as a transaction
--         This test should fail!
BEGIN;
insert
into person(Name, Address, Phone, DOB) 
values ('Bjorn', 'Home', 1, CURRENT_DATE);
COMMIT;

-- Test 3: Insert person, with sub-class, as a transaction
--         This test should succeed!
BEGIN;
insert
into person(Name, Address, Phone, DOB) 
values ('Bjorn', 'Home', 1, CURRENT_DATE);
insert
into member(ID, Startdate) 
values (lastval(), CURRENT_DATE);
COMMIT;

-- Check the values
select * 
from person P join Member M on P.ID = M.ID;

-- Test that you have to have a person linked to a linking
-- Test 1, linking with no person attached
-- This test should fail!
begin;
insert 
    into linking(name, type, description)
    values ('Link', 'Sometype', 'Description');
commit;

-- Test 2, linking with a person attached
-- This test should work!
begin;
insert 
    into person(name, dob, address, phone)
    values ('Name', current_date, 'Address', 12345678);
insert 
    into member(id, startdate)
    values ( (select id from person where name = 'Name') , current_date);
insert 
    into linking(name, type, description)
    values ('Link2', 'Type', 'Desription');
insert
    into participates(linkingid, personid)
        values ((select id from linking where name = 'Link2'), (select id from person where name = 'Name'));
commit;

-- Check values
select *
from participates;