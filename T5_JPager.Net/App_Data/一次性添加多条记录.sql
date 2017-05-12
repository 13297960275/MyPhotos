use MySchool
--一次性插入多条记录--
insert into grade values(4,'工具')

insert into Grade (GradeName)
select 'aaa' union all --只有全部写了union all才不会去除重复记录
select 'aaa' union all
select 'aaa' union all
select 'aaa' union all
select 'bb' union all
select 'bb' --union 最后一句不需要加union all,在union里面不能写Default

select * from Grade

---一次性插入多条记录
--1。select 字段列表/*  into 目的表  from  源表 会生成一个与查询字段相同结构的新表，也就意味着新表不能先存在，它是系统生成的
select classname into newGrade from Grade
truncate table grade
--2. insert into 目的表名 select * from 源表：目的表必须先存在,如果没有存在 ,就报错了
--select classname  into Grade from newGrade
insert into Grade select * from newgrade


select * into newGrade from Grade
--使用select into from 生成的新表字段的属性都会消失，除了标识列属性之外
select * from newGrade
