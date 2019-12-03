--! Q1
select count(*)
from gGarments
where g_price is null;

--! Q2
select count(distinct g.d_id)
from gMadeOf mo
	join gGarments g on g.g_id = mo.g_id
	join gElements e on e.f_id = mo.f_id
where mo_percentage > 25
  and e.e_element like '%Procrastinium%';

--! Q3
select count(distinct d_id)
from gGarments
where co_id is null
  and d_id not in (select co_id from gGarments);
-- TODO

--! Q4
select d_id
from gGarments
group by d_id
having avg(g_price) =
(
	select max(average)
	from (
		select avg(g_price) as average
		from gGarments
		group by d_id
	) x
);

--! Q5
select count(*)
from (
	select distinct e_element
	from gElements e
		join gFabrics f on f.f_id = e.f_id
	where e_element like 'C%'
	group by e_element
	having count(*) >= 5
) x;

--! Q6
select count(*)
from (
	select g_id
	from gMadeOf
	group by g_id
	having sum(mo_percentage) <> 100
) x;

--! Q7
select count(*)
from (
select d_id
from gTypes t
	join gHasType ht on ht.t_id = t.t_id
	join gGarments g on g.g_id = ht.g_id
where t_Category = 'Dress'
group by d_id
having count(distinct t.t_id) = (select count(distinct t_id) from gTypes where t_Category = 'Dress')
) x;

--! Q8
-- select g.d_id
-- from gGarments g
-- 	join gDesigners d1 on g.d_id = d1.d_id
-- 	join gDesigners d2 on g.co_id = d2.d_id
-- group by g.d_id;

-- select count(*) from gDesigners;

-- gDesigners(d_ID, d_Name, d_Country)
-- gGarments(g_ID, g_Price, d_ID, co_ID)

-- gTypes(t_ID, t_Name, t_Category)
-- gHasType(g_ID, t_ID, ht_Importance)

-- gFabrics(f_ID, f_Name)
-- gElements(f_ID, e_Element)
-- gMadeOf(g_ID, f_ID, mo_Percentage)
