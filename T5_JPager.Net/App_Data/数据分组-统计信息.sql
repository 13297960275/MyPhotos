---数据分组-统计信息-----
--select 字段列表 from 表列表  where 对数据源进行数据筛选 group by 分组字段列表 Order by 排序字段列表
--1.得到所有学员总人数
select COUNT(*) from Student
--2.得到男女生的人数
select COUNT(*) from Student where Sex='男'
select COUNT(*) from Student where Sex='女'
--使用分组统计
select COUNT(*),sex from Student group by sex

select COUNT(*),sex from Student
select COUNT(*) from Student
select distinct sex from Student

--查询每个班级的人数
--分组统计有一个规则:与聚合函数一起出现在查询中的列，要么被聚合，要么被分组
--1.聚合不应出现在 WHERE 子句中,语法规则
--2.where 的执行在分组之前，先对源数据做筛选之后再对筛选得到的结果集做分组
--3.having是对分组统计得到的结果集做筛选的。
--select 字段列表 from  表列表  where 源数据筛选条件  group by 分组统计字段列表 having  对分组统计结果集做筛选 order by 得到最终结果集之后的数据重排
select classid ,COUNT(*)  from Student   group by ClassId  having ClassId=6
select classid 班级,COUNT(*) 人数,StudentNo from Student   group by ClassId  having StudentNo>10
--  5 显示                                        1获取数据源    2  筛选原                    3 对数据源进行分组  4 对分组统计的结果集做筛选    6对最终结果集做数据重排                      
select classid 班级,COUNT(*) 人数 from Student where Email is not null   group by ClassId  having COUNT(*) between 2 and 3      order by  人数 desc

select StudentNo no,StudentName name from Student where StudentName like '%'


select COUNT(*) 人数 from Student where Email is not null  having COUNT(*)>=3       order by  人数 desc

select classid, sex,COUNT(*) from Student group by ClassId,Sex order by ClassId,sex

--分组统计练习:
--1.查询每个班级的总学时数，并按照升序排列
select classid, SUM(ClassHour) from Subject where ClassId is not null group by ClassId order by SUM(ClassHour)
--2.查询每个参加考试的学员的平均分
select studentNo, AVG(StudentResult) from Result where StudentResult is not null group by StudentNo --having StudentResult is not null
--3.查询每门课程的平均分，并按照降序排列
select SubjectId, AVG(StudentResult) as score from Result where StudentResult is not null group by SubjectId order by  score desc
--4.查询每个班级男女生的人数
select ClassId,Sex, COUNT(*) from Student group by ClassId,Sex
