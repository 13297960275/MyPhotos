--数据检索--
语法:
--select 字段列表/* from 表列表 where 条件(not and or) 

--1.查询所有学员信息
select * from Student
--2.查询所有女学员信息
select * from Student where Sex='女'
--3.多条件查询
select * from Student where Sex='女' and ClassId='6'
--4.指定查询的列
select StudentName,Sex,Phone,Address from Student where Sex='女' and ClassId='6'
select Student.StudentName,Student.Sex,Student.Phone,Student.Address from Student where Sex='女' and ClassId='6'
--5.指定列标题 as可以指定列标题，但是它可以省略，这种操作纯粹是得到结果集之后，在视图中的另外一种显示方式，与查询无关
select StudentName as 姓名,Sex 性别,电话=Phone,Address from Student where Sex='女' and ClassId='6'
--6.添加常量列
select StudentName as 姓名,Sex 性别,电话=Phone,Address,'广州' as 城市 from Student where Sex='女' and ClassId='6'

--select有两种功能
1.查询
2.输出:以结果集的形式进行输出的
select 1

--
-使用top提取记录,top可以提取指定数量的记录，也可以使用百分比
--它不是四舍五入，而是Ceiling
--select CEILING(0.999)
select top 2 StudentName as 姓名,Sex 性别,电话=Phone,Address,'广州' as 城市 from Student where Sex='女' and ClassId='6'
select top 80 percent StudentName as 姓名,Sex 性别,电话=Phone,Address,'广州' as 城市 from Student where Sex='女' and ClassId='6'
--使用distinct来过滤重复记录.它所说的重复记录不是指表的原始记录,而是通过查询得到的结果集,只有查询的结果集的每一个字段值都一样,才认为是重复记录
select distinct   LoginPwd,Sex from Student