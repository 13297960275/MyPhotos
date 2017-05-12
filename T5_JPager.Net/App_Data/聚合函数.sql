--聚合函数--
--max():求指定数据范围中的最大值:可以对任意类型进行聚合，如果是非数值么就按值的拼音进行排序
--min():求指定数据范围中的最小值:可以对任意类型进行聚合，如果是非数值么就按值的拼音进行排序
--avg:求指定数据范围中的平均值,它只能对数值进行聚合,不能对日期进行聚合
--sum:求指定数据范围中的和,它只能对数值进行聚合,不能对日期进行聚合
--count:求满足条件的记录数,与字段没有任何关系

select COUNT(*) from Student where ClassId=6
--查询年龄最大的学员  年龄值越大就越小
select min(BornDate) from Student
select max(BornDate) from Student
select SUM(StudentName) from Student
select min(StudentName) from Student
select max(StudentName) from Student
select max(BornDate) from Student
select avg(BornDate) from Student
--查询科目ID是1的学员的总分
select SUM(StudentResult) from Result where SubjectId=1
--平均分
--在sql server中，null是指不知道是什么值。聚合函数会过滤掉null值
select avg(StudentResult*1.0) from Result where SubjectId=1 and StudentResult is not null

select * from Student order by StudentName