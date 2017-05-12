---带条件的查询---
--语法:select 字段列表/* from 表列表 where 条件
select * from Student where ClassId=1 or ClassId=2 or ClassId=3
--使用in代表一个具体的值范围,in要求指定的范围的数据类型一致
select * from Student where ClassId in(1,2,3)
select * from Student where ClassId not in(1,2,3)
--所谓类型一致是指：系统会为你做强制类型转换，如果可以转换OK，否则报错
--在使用in的时候，指定的范围值需要与字段的值做相应的匹配：强制转换
select * from Student where ClassId in('1','2','3')

--查询考试成绩在80`90之间的学员信息
select * from Result where StudentResult>=80 and StudentResult<=90
--如果是数值的范围判断可以使用between...and
select * from Result where StudentResult between 80 and 90


--带条件的查询-模糊查询:是对字符串而言
--必须明确：=就是严格的完全匹配
--%:代表任意个任意字符
--_:代表任意的单个字符
--[]:代表一个具体的值范围中的一个字符
--[^]:代表不在指定的范围之内,放在[]里面才有这个意义
--通配符有意义必须在模糊查询中：模糊查询的关键字是：like
select * from Student where StudentName like '张%' and Sex='女'
select * from Student where StudentName like '张__' and Sex='女'
--查询学号在11~18之间的学员信息
select * from Student where StudentNo not like '[1-2]'
--如果放在范围值的中间没有意义了，只能放在开头
select * from Student where StudentNo  like '[345^672]'

---isnull函数的使用：可以使用一个自定义的字符串替换null值
select StudentNo,StudentName,ISNULL(email,'没有电子邮箱') from Student where ClassId=6

--模糊查询练习：
--1.查询六期班所有姓 王 的学员
select classid from grade where classname='六期班'
select * from Student where StudentName like '王%' and ClassId=(select classid from grade where classname='六期班')
--2.查询所有科目中包含c 字符的科目信息--不区分大小写
select * from Subject where SubjectName like '%[Cc]%'
--3.查询office最近一次考试时间
select subjectid from Subject where SubjectName='office'
select max(ExamDate) from Result where SubjectId=(select subjectid from Subject where SubjectName='office')
--select 字段列表 from 表列表 where  条件 order by  排序字段列表
--排序对查询得到的结果集做记录重排，并不是修改原始的查询结果集
--desc:降序排序
--asc:升序排序、默认就是升序排序
--top是 order by 之后再取值
select top 1 ExamDate 考试日期,StudentNo from Result where SubjectId=(select subjectid from Subject where SubjectName='office') order by 考试日期 desc,StudentNo asc

