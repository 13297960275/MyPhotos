--联合结果集union(集合运算符--
select StudentNo as nonono,SUM(StudentResult) from Result where StudentNo=1 group by StudentNo
union
select StudentNo as no,aa='22' from Result where StudentNo=2 

---union可以合并多个结果集
--它有两个前提和一个注意:
--1.合并的结果集的列数必须完全一致
--2.合并的多个结果集的对应列的类型需要一致(可以相互转换)
--3.结果集的列名只与第一个结果集有关

--
select top 3 * from Student
union --做了distinct操作
select top 3 * from Student

select top 3 * from Student
union all --不做distinct操作，它的合并效率更高，因为没有必须去判断结果记录是否重复
select top 3 * from Student

--要求在一个表格中查询出学生的英语最高成绩、最低成绩、平均成绩
select MAX(StudentResult) from Result
select MIN(StudentResult) from Result
select AVG(StudentResult) from Result

--
select MAX(StudentResult), MIN(StudentResult), AVG(StudentResult) from Result

--
select (select MAX(StudentResult) from Result),(select MIN(StudentResult) from Result),(select AVG(StudentResult) from Result)

select MAX(StudentResult) from Result
union
select MIN(StudentResult) from Result
union
select AVG(StudentResult) from Result

--查询每一个学员的成绩，同时在最下面显示平均分
union语句中不能添加order by排序，如果加只能加在最后，最后一句的order by只能去选择第一个结果集中的列
select cast(StudentNo as CHAR(2)) as id,StudentResult from Result
union
select '平均分',AVG(StudentResult) from Result  order by id Desc

select ' '+cast(StudentNo as CHAR(2)) as id,StudentResult from Result
union
select '  平均分',AVG(StudentResult) from Result 
