--日期函数--
--GETDATE():获取当前系统日期
select GETDATE()
--DATEADD：能够在指定日期上增加指定的时间 
select DATEADD(MM,2,GETDATE())
---查询出生已经20年有学员信息-
select * from Student where BornDate<DATEADD(yyyy,-20,getdate())
--查询年龄超过20岁的学员信息
--DATEDIFF():找出两个日期的差异
select studentname, DATEDIFF(yyyy,borndate,getdate()) as age from Student order by  age desc

--DATENAME:日期中指定日期部分的字符串形式
select DATENAME(dw,GETDATE())
--DATEPART:可以得到指定的日期部分 2014-4-11 10:47
select cast(DATEPART(yyyy,getdate()) as CHAR(4))+'-'+ cast(DATEPART(mm,getdate()) as CHAR(2))
select DATEPART(dd,getdate())
select DATEPART(hh,getdate())
select DATEPART(mi,getdate())

--查询年龄超过20周岁的6期班的学生信息。
select * from Student where ClassId=6 and DATEDIFF(yyyy,borndate,getdate())>20
select * from Student where ClassId=6 and BornDate<DATEADD(yyyy,-20,getdate())
--查询1月份过生日的学生信息
select * from Student where DATEPART(mm,borndate) =1
--查询今天过生日的学生姓名及所在班级
select * from Student where DATEPART(mm,borndate) =DATEPART(mm,getdate()) and DATEPART(dd,borndate) =DATEPART(dd,getdate()) 
--查询学号为“10”的学生Email的域名。
--新生入学，为其分配一个Email地址，规则如下：GZ+当前日期+4位随机数+@itcast.com





