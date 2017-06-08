-- 创建数据库时,设置数据库的编码方式 
-- CHARACTER SET:指定数据库采用的字符集,utf8不能写成utf-8
-- COLLATE:指定数据库字符集的排序规则,utf8的默认排序规则为utf8_general_ci（通过show character set查看）
--drop database if EXISTS dbtest;
--create database dbtest CHARACTER SET utf8 COLLATE utf8_general_ci;

---- 修改数据库编码
--alter database dbtest CHARACTER SET GBK COLLATE gbk_chinese_ci;
--alter database dbtest CHARACTER SET utf8 COLLATE utf8_general_ci;

---- 创建表时，设置表、字段编码
--use dbtest;
--drop table if exists tbtest;
--create table tbtest(
--id int(10) auto_increment,
--user_name varchar(60) CHARACTER SET GBK COLLATE gbk_chinese_ci,
--email varchar(60),
--PRIMARY key(id)
--)CHARACTER SET utf8 COLLATE utf8_general_ci;

---- 修改表编码
--alter table tbtest character set utf8 COLLATE utf8_general_ci;
---- 修改字段编码
--ALTER TABLE tbtest MODIFY email VARCHAR(60) CHARACTER SET utf8 COLLATE utf8_general_ci;

---- 查看所有的字符编码
--  SHOW CHARACTER SET;
---- 查看创建数据库的指令并查看数据库使用的编码
--    show create database dbtest;

---- 查看数据库编码：
--   show variables like '%char%';

---- 设置character_set_server、set character_set_client和set character_set_resultsset character_set_server = utf8; -- 服务器的默认字符集。使用这个语句可以修改成功，但重启服务后会失效。根本的办法是修改配置MYSQL文件MY.INI，
alter database MySchool collate utf8_general_ci --gbk_chinese_ci
alter database MySchool collate gbk_chinese_ci


-- ################################ --


---Len(参数)--得到指定的字段或者字符串的长度---存储的字符个数--不区分中英文
select LEN('中华') --2
--DataLength(参数)--得到指定的字段或者字符串值占据的字节数
select DATALENGTH('中华') --2

--char:空间一旦分配就不会再根据存储的内容进行回收,但是如果存储的字符数走出了空间大小,就会报一个  截断二进制数据的错误--
select LEN(Char) from CharTest --2
select DATALENGTH(Char) from CharTest --10

--Varchar：会根据存储的内容做相应的处理：如果存储的内容小于指定的大小，那么多余的空间会自动回收，但是如果超出范围还是报错
select LEN(Varchar) from CharTest --2
select DATALENGTH(Varchar) from CharTest --2

--当你的数据的长度可以大概限制一个波动不是很的范围空间值之内的,那么就可以使用char,如身份证号 ，但是如果值的空间范围波动很大，那么就应该考虑使用varchar

--nchar:不管什么类型的字符都是占据两个字节 它就是传说中的unicode字符，它的目标就是消除乱码
select LEN(Nchar) from CharTest --2
select DATALENGTH(Nchar) from CharTest --20

--Nvarchar  n代表unicode字符，var代表自动收缩。
select LEN(Nvarchar) from CharTest --2
select DATALENGTH(Nvarchar) from CharTest --4

---如果全部是英文字符的时候就应该考虑使用非unicode,如果包含中文就可以考虑使用unicode字符


-- ################################ --


--SQL语句入门--
--1.sql语言是解释语言
--2.它不区分大小写
--3.没有“”，所有字符或者字符串都使用''包含
--4.sql里面也有类似于c#的运算符
--	算术运算符：+ - * / %
--	关系运算符：>  <   >= <=    =(赋值与逻辑相等都是=)，  <>   !=
--	逻辑运算符：！（not） &&(and) || (or)
--5.在sql中没有BOOL值的概念，也就意味着条件中不能写true/false  但是对于bit类型的值，在视图里面只能输入true/false,但是在代码中只能输入1/0
--6.在sql中也有if..else   还有while循环
--7.它也有一些保留关键字：object address user var
--8.sql对类型要求不是很严格，所以类型都可以转换为字符串进行处理


---创建数据库：--
--数据库名称--
--逻辑名称--name
--初始大小--size
--文件增长---filegrowth
--文件路径--filename
--语法:
--create database 数据库名称
--on 文件组
--（
----数据库名称--
----逻辑名称--name
----初始大小--size
----文件增长---filegrowth
----文件路径--filename
--）
--log on
--(
----数据库名称--
----逻辑名称--name
----初始大小--size
----文件增长---filegrowth
----文件路径--filename
--)
--自动创建文件夹   execute 执行  xp--extends procedure
exec sp_configure 'show advanced options',1
go
reconfigure
go
exec sp_configure 'xp_cmdshell' ,1
go
reconfigure
go
execute xp_cmdshell 'mkdir d:\project'
--判断数据库是否已经存在，如果存在就先删除再创建
use master --因为数据库的记录都存储这个master库的sysdatabases里面
if exists( select * from sysdatabases where name='MyBase')--exists是一个函数，用来判断（）中的结果集是否为null,如果为null.就返回false,否则返回true
 drop database MyBase --drop是用来注销结构的
go
create database MyBase --指定数据库名称
on primary --默认就是主文件组
(
name='MyBase_data',--逻辑名称 当语句不是一句可以独立执行的语句的时候就需要添加，它往往是一个语句块中的一句
size=3mb, --初始大小
fileGrowth=10%,--文件增长，每一次比前一次增长10%的容量
maxsize=1000mb,--限制文件的最大容量
filename='d:\project\MyBase_data.mdf' --文件全路径，必须指定文件的扩展名，最后一句不需要添加，
),
filegroup mygroup --创建文件组，那么接下来的一个数据库就会创建在这个文件组上
(
name='MyBase_data1',--逻辑名称 当语句不是一句可以独立执行的语句的时候就需要添加，它往往是一个语句块中的一句
size=3mb, --初始大小
fileGrowth=10%,--文件增长，每一次比前一次增长10%的容量
maxsize=1000mb,--限制文件的最大容量
filename='e:\aa\MyBase_data1.ndf' --文件全路径，必须指定文件的扩展名，最后一句不需要添加，
)
log on
(
name='MyBase_log',--逻辑名称 当语句不是一句可以独立执行的语句的时候就需要添加，它往往是一个语句块中的一句
size=3mb, --初始大小
fileGrowth=10%,--文件增长，每一次比前一次增长10%的容量,日志文件一般不会限制文件大小
filename='d:\project\MyBase_log.ldf' --文件全路径，必须指定文件的扩展名，最后一句不需要添加，
),
(
name='MyBase_log1',--逻辑名称 当语句不是一句可以独立执行的语句的时候就需要添加，它往往是一个语句块中的一句
size=3mb, --初始大小
fileGrowth=10%,--文件增长，每一次比前一次增长10%的容量,日志文件一般不会限制文件大小
filename='d:\project\MyBase_log1.ldf' --文件全路径，必须指定文件的扩展名，最后一句不需要添加，
)


--创建数据表
--语法：
--create table 表名
--(
-- 字段名称   类型   字段的特征（标识列 是否可以为null 主键 唯一键 外键 check约束）,--排名不分先后
-- 字段名称   类型   字段的特征（标识列 是否可以为null 主键 唯一键 外键 check约束）
--)
--Student：Id（学生编号，自动编号，主键）、Name（学生姓名）、Gender（性别）、Address（家庭地址）、Phone（电话）、Age（年龄）、Birthday（出生日期）CardId（身份证号）、CId（班级Id）
use MyBase
if exists(select * from sysobjects where name='Student')
--在sql中的if必须做处理
begin
	--print '数据表存在' --默认只包含一句
	drop table Student
end
go--批处理结束的标记
create table  Student
(
Id int primary key identity(1,1) ,--第一个参数是标识种子，第二个参数是标识增量
Name nvarchar(50) not null, --一定要记得为字符类型的字段设置长度，不然长度默认就是1  not null 就是说明这个字符非空--必须给值
Gender char(2) not null,
[Address] nvarchar(100) null,--如果为空可以设置为null,或者干脆不写，不定就说明这个字段的值呆以为null
Phone char(13),
Age int check(age>0 and age<100),
CardId char(18) not null,
Birthday datetime not null,
CId int not null
)


-- ################################ --


--约束-保证数据完整性--
--什么叫数据完整性：保证数据的真实，安全和准确

--一共有四种数据完整性：
--1.实体完整性：实体就是指一行记录，这个完整性就是为了保证这一行记录是唯一的
--	主键：非空，唯一
--	标识列：系统自动生成的，永远不会重复，也是唯一
--	唯一键：唯一，但是可以为null,只能null一次

--2.域完整性：域就是指单个字段，也就说明域完整性是为了保证字段的值是准确的有安全的
--	check约束
--	是否为null
--	数据类型
--	主外键约束--关系
--	默认值约束

--自定义完整性：check约束
--关系是一种多对一的关系 
--引用完整性：主外键约束：一个表（外键表）某个字段的值必须引用自另外一个表（主表）的某个字段,一个的字段的值必须是另外一个表的字段中已经存在的值
--外键表：引用的表，后存在的表
--主键表：被引用表，先存在的表
--建立主外键关系的细节：
--1.必须选择外键表去创建主外键关系
--2.建立主外键关系的字段的类型必须一致
--3.建立主外键关系的字段的意义必须完全一致
--4.建立了主外键关系的表在添加数据的时候需要先添加主键表的记录，再添加外键表的记录
--5.建立了主外键关系的表在删除数据的时候先删除外键表的记录再删除主键表的记录
--6.建立主外键关系的字段在主表中必须是主键或者唯一键

--有没有可能性：主表中没有任何记录，但是从表中有多条记录？为什么？
--有：因为建立关系的字段在主表中可以是唯一键，而唯一可以为NULL

--使用代码创建约束--
--主键(primary key PK)  唯一键(unique UQ) 默认值(default  DF) ckeck约束(check  CK) 主外键(foreign key  FK)
--语法：
--alter table 表名
--add constraint 约束名称(缩写_用户自定义名称) 约束类型  约束说明(表达式  字段名称  值)

--添加主键
if exists(select * from sysobjects where name='PK_id')
	alter table student drop constraint PK_id
alter table student add constraint PK_id primary key(id)
--为name字段添加唯一键
alter table student add constraint UQ_Name unique(name)
--为性别添加check约束
alter table student add constraint CK_gender check(gender='男' or gender='女')
--为年龄添加check约束，同时为地址添加默认约束
alter table student
add constraint DF_Address default(N'我在广wg州') for address, --为某个字段添加约束
constraint CK_Age check(age>0 and age<=100)
---为cid添加主外键
alter table student
add constraint FK_Student_Class_Cid foreign key(cid) references class(classId)


-- ################################ --


use master --切换数据库
if exists(select * from sysdatabases where name='MySchool')
  drop database MySchool --删除数据库
go
exec sp_configure 'show advanced options',1
go
reconfigure
go
exec sp_configure  'xp_cmdshell',1
go
reconfigure
go
exec xp_cmdshell 'mkdir d:\project'
go
create database MySchool
on --在那一个文件组上创建，默认就是主文件组
(
 name='MySchool_data',--逻辑名称
 size=3mb,--初始大小
 filegrowth=10%,--文件增长
 maxsize=1000mb,--文件最大容量
 filename='d:\project\MySchool_data.mdf'    --文件全路径，包含目录和文件名 
)
log on
(
 name='MySchool_log',--逻辑名称
 size=3mb,--初始大小
 filegrowth=10%,--文件增长
 --maxsize=1000mb,--文件最大容量,日志文件一般不会限制最大文件
 filename='d:\project\MySchool_log.ldf' 
)
use MySchool --先切换数据库
if exists(select * from sysobjects where name='Grade')
  drop table Grade
  go 
create table Grade
(
--字段名称  字段类型 字段的特征(主键 唯一键 外键 check约束 是否为null,默认值)
GradeId int identity(1,1),
GradeName nvarchar(50) not null
)
--为grade表添加约束
--alter table 表名 add constraint 约束名称 约束类型 约束说明(字段，表达式，值)
alter table grade add constraint PK_GradeId primary key(GradeId),
constraint UQ_GradeName unique(GradeName)

if exists(select * from sysobjects where name='Student')
  drop table Student
  go 
create table Student
(
StudentNo int primary key identity(1,1),
LoginPwd varchar(50)  not null,
StudentName nvarchar(50) not null,
Gender char(1) not null,
GradeId int not null,
Phone varchar(14) ,
Address nvarchar(200),
Birthday datetime not null,
Email varchar(50)
)
--为student表添加约束
--	密码loginPwd的长度大于等于6位
alter table student add constraint CK_LoginPwd check(len(loginPwd)>=6)
--	studentNo学号是标识列--不能通过约束添加
--	Gender性别只能取1和0，1代表男，0代表女
alter table student add constraint CK_Gender check(gender=0 or gender=1)
--	GradeId是grade表的外键
alter table student add constraint FK_Grade_Student_GradeId foreign key(gradeid) references grade(GradeId)
--	Address有默认值：“未填写”--	Email:默认值 匿名@未知.com
alter table student
add constraint DF_Address default(N'未填写') for address,
constraint DF_Email default('aa@bb.com') for email

alter table student add TestId int


-- ################################ --


--- 创建关系时的级联操作
alter table student
with nocheck --不检查现有数据
add constraint FK_Grade_Student_GradeId foreign key(gradeid) references grade(gradeid)
on delete set null


--[ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
--on--在做何种操作的时候做相应的处理
--NO ACTION--不做任何操作：该报错就报错，可以删除就删除
--CASCADE：级联：删除主表，对应的从表数据也会删除，更新也一样
--SET NULL：如果删除主表的记录，那么对应的从表记录的字段值会被设置为null,前提是从表的这个字段的值可以是null
--SET DEFAULT :删除主表记录，从表的记录的对应字段值设置为默认值，前提是你之前为这个字段设置了默认值



-- ################################ --


--数据插入--
--语法：方法参数有三个对应：类型对应   数量对应   顺序对应
--insert [into] 表名[(字段列表)] values(值列表)
use MySchool
--1.如果表名后没有指定具体的字段列表，那么就默认需要为所有列添加值,但是不管什么时候都不能为标识列人为添加值
insert into Student values('dsfasdfas','fasdfas',1,3,'23432','fadsfas','2012-2-2','fasfasd')
--2.不能为标识列插入值：仅当使用了列列表并且 IDENTITY_INSERT 为 ON 时，才能为表'Student'中的标识列指定显式值。
--3.如果没有指定具体的列名,就必须为所有列添加值,也就意味着值的数量不能多也不能少:列名或所提供值的数目与表定义不匹配。
insert into Student values('dsfasdfas','fasdfas',1,3,'23432','fadsfas','2012-2-2')
--4.如何为可以为NULL的字段指定null值，或者有默认值的字段指定默认值
insert into Student values('dsfasdfas','fasdfas',1,3,'23432',default,'2012-2-2',null)
--5.如果字段可以为NULL,那么就可以不指定这个字段
insert into Student(LoginPwd,StudentName,Gender,GradeId,Phone,Address,Birthday) values('dsfasdfas','fasdfas',1,3,'23432',default,'2012-2-2')
--6.如果是非空字段，就必须插入值
insert into Student(LoginPwd,StudentName,Gender,GradeId,Phone,Address) values('dsfasdfas','fasdfas',1,3,'23432',default)
--插入的值必须满足表的完整性约束
insert into Student(LoginPwd,StudentName,Gender,GradeId,Phone,Address,Birthday) values('aaa','fasdfas',1,3,'23432',default,'2012-2-2')

--类型在插入数据时的地位：
--7.任何类型的值都可以包含在‘’以内：系统会做隐式的强制转换，将实参的值强制转换为字段的类型，如果可以转换就执行相应的操作，如果不可以转换就报错
insert into Student values('dsfasdfas','fasdfas','0','3','23432','fadsfas','2012-2-2','fasfasd')
--8.如果是字符串类型却没有添加‘’就会：1.如果是数值组成的字符串就OK 2.如果是非数值组成的字符串就报错
insert into Student values('dsfasdfas',fasdfas,'0','3','23432','fadsfas','2012-2-2','fasfasd')
insert into Student values('dsfasdfas',123123,'0','3','23432','fadsfas','2012-2-2','fasfasd')
--9.日期类型的值一定需要包含在‘’以内，否则就是系统的默认值  1905-7-2   1906-6-22
insert into Student values('dsfasdfas',121,'0','3','23432','fadsfas',2012-2-2,'fasfasd')


-- ################################ --


--数据更新-- 做修改和删除对于程序员而言一定需要看有没有条件
--语法：
--update 表名 set 字段=新值,字段=新值 where 条件(主键一般就可以做为条件)

update Student set GradeId=1
--修改学号为9的学员班级是3班
update Student set GradeId=3 where StudentNo=9
update Student set Gender=0,GradeId=3 where StudentNo=4
--多条件修改
update Student set Address='广州传智' where GradeId=1 and Gender=0


-- ################################ --


--数据删除--
--语法:
--delete [from] 表名 where 条件
delete from Student where StudentNo=4 or StudentNo=5 or StudentNo=6
--使用delete进行删除的特点：
--1.它是一条一条进行删除的，每一次的删除都会写入到日志文件，效率不高
--2.标识列值不会重新从标识种子计算

--使用truncate进行删除
--语法：
--truncate table 表名  --没有条件，
--1.它不是一条篥进行删除的，它是一次性整体删除，与删除的记录数无关
--2.它的日志文件的写入是按最小化折方式进行写入--一次
--3.标识列会重新从标识种子计算

truncate table student


-- ################################ --


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
--1.查询
--2.输出:以结果集的形式进行输出的
select 1

--
---使用top提取记录,top可以提取指定数量的记录，也可以使用百分比
--它不是四舍五入，而是Ceiling
--select CEILING(0.999)
select top 2 StudentName as 姓名,Sex 性别,电话=Phone,Address,'广州' as 城市 from Student where Sex='女' and ClassId='6'
select top 80 percent StudentName as 姓名,Sex 性别,电话=Phone,Address,'广州' as 城市 from Student where Sex='女' and ClassId='6'
--使用distinct来过滤重复记录.它所说的重复记录不是指表的原始记录,而是通过查询得到的结果集,只有查询的结果集的每一个字段值都一样,才认为是重复记录
select distinct   LoginPwd,Sex from Student


-- ################################ --


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


-- ################################ --


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


-- ################################ --


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


-- ################################ --


--类型转换函数
--+在使用时首先是运算符，系统会做隐藏的类型转换，如果可以转换那就OK，否则报错
select 1+'1'   --2
select '1'+1   --2
--除非两边都是字符串类型，那么+号就是字符串连接符
select '1'+'1'  --11
--cast(源数据 as 目标类型)
print '我的总成绩是：'+cast(200 as varchar(30))
--Convert(目标类型，源数据,格式)
print '我的总成绩是：'+convert(char(3),200)
--为日期值添加格式
select CONVERT(char(30),GETDATE(),102)


-- ################################ --


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
--union语句中不能添加order by排序，如果加只能加在最后，最后一句的order by只能去选择第一个结果集中的列
select cast(StudentNo as CHAR(2)) as id,StudentResult from Result
union
select '平均分',AVG(StudentResult) from Result  order by id Desc

select ' '+cast(StudentNo as CHAR(2)) as id,StudentResult from Result
union
select '  平均分',AVG(StudentResult) from Result 


-- ################################ --


--所以数据操作只有四种可能：
--1.新增：
--	insert into 表名(字段列表) values(值列表)  --一次只能增加一条记录
--	1.如果没有确定字段列表，那么需要对所有列添加值
--	2.标识列不能人为插入值，它是系统自动生成的
--	3.如果字段有默认值或者可以为null,那么在值列表中可以写null/default
--	4.如果不想为有默认值的字段或者可以为null的字段赋值，也可以在字段列表中不指定这些字段
--	5.非空字段必须赋值
--	6.类型需要一致：
--		1.所有类型的值都可以包含在‘’以内
--		2.如果没有包含在‘’以内，那么：	
--			1.如果是数值组成的字符串--OK
--			2.如果是非数值组成的字符串没有包含在‘’以内，就会报错
--	7.日期值必须包含在‘’以内，否则就得到默认值--1905-7-2

--2.修改：
--	update 表 set 字段=新值，字段=新值 where 条件
--	1.修改的值不能违反表的完整性约束
	
--3.删除
--	delete from 表名 where 条件
--	1.一条一条记录进行删除，每一条的删除会记录到日志文件中，效率低
--	2.标识列的值不会重新从种子值计算
--	3.会触发 delete触发器
--	truncate table 表名 --不能添加条件
--	1.一次性删除整个表的数据，日志文件的写入是最小化的
--	2.标识列会从种子重新计算
--	3.不会触发delete触发器
	
--聚合函数：
--	max():必须有参数，但是参数的类型可以是任意的，如果对于数值凡比较大小，如果对于日期，也是比较大小，如果是字符串，就比较A-Z，如果是中文就比较它的拼音A-Z
--	min()：与max一样
--	sum()：必须有参数但是参数的类型必须是数值，不能是字符串或者日期
--	avg()：与sum一样
--	count()：与字段无关，与记录有关，所以参数可以是任意的
	
--查询：
--select(5) 字段列表 from(1)表列表 where(2) 源数据的筛选条件  group by(3) 分组字段列表 having(4) 分组结果集的筛选条件 order by(6)最终结果集的数据重排字段列表
--1.between...and:对数值进行区间判断，相当于大于等于  小于等于，它的效率比关系运算符要高
--2.in:指定一个具体的值的范围，要求值的类型需要一致
--3.模糊查询：对字符串而言
--	通配符
--		1.%：代表任意个任意字符
--		2._:代表一个任意字符
--		3.[]:它代表具体的值或者范围,范围指定只能是a-z  A-Z  0-9
--		3.[^]:不在指定的范围内，必须在[]中才有这个意义
--	模糊查询关键字：如果使用了通配符做模糊查询，就必须使用关键字：like /not like
	
--类型转换：
--	cast(源数据  as 目标类型)
--	convert(目标类型，源数据，日期格式)-- 0-15  100-115

--union:合并多个结果集：
--	1.列有数量一定一致
--	2.列的类型需要一致
--	3.union会去除重复记录，union all就不会去除，所有效率更高


-- ################################ --


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


-- ################################ --


---字符串函数--
--1.CHARINDEX:第一个参数是需要查询的字符串，第二个是源字符串，第三个是开始查询的位置，从1开始计算
select CHARINDEX('人民','中华人民共和国',4)
--2.LEN：得到指定字符的个数,与中英文无关
select LEN('中华人民aa')
--3.UPPER():将英文小写转换为大写 LOWER()将大写转换为小写
select lower(UPPER('fgasdfasf'))
--4.LTRIM   RTRIM,没有trim函数   Trim() TrimStart()  TrimEnd();
SELECT  ltrim(Rtrim('                      dfg      hjkl                         '))+'柘城s'
--5.REPLACE 替换,如果没有找到对应需要替换的,就返回原始字符串值
select REPLACE('中华人民共和国','人d民','公仆')
--6.RIGHT()  LEFT():参数可以大于字符串的长度,但是不能是负值
select right('中华人民共和国',-10)
--7.
select SUBSTRING('中华sdsfdsf人民共和国',CHARINDEX('人民','中华sdsfdsf人民共和国'),2)

--STUFF
select STUFF('中华人民共和国',3,2,'dfasfasdfasd')

--wuhu0723@126.com
select CHARINDEX('@','wuhu0723@126.com')
select  LEFT('wuhu0723@126.com',CHARINDEX('@','wuhu0723@126.com')-1)

select  right('wuhu0723@126.com',len('wuhu0723@126.com')-CHARINDEX('@','wuhu0723@126.com'))


-- ################################ --


--数学函数--
--rand:随机数
select RAND()
--ABS
select ABS(-123242)
--CEILING:得到比当前数据大的最小整数
select CEILING(16*1.0/5)
--FLOOR:得到比当前数据小的最大整数
select FLOOR(1.99999)
--ROUND:四舍五入:只关注指定的小数位后一位
select ROUND(1.558,1)
--POWER():返回指定表达式的指定幂的值
select POWER(2,3)
--SQRT():返回指定浮点值的平方根
select SQRT(9)


-- ################################ --


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


-- ################################ --


--数学函数--
--rand:随机数
select RAND()
--ABS
select ABS(-123242)
--CEILING:得到比当前数据大的最小整数
select CEILING(16*1.0/5)
--FLOOR:得到比当前数据小的最大整数
select FLOOR(1.99999)
--ROUND:四舍五入:只关注指定的小数位后一位
select ROUND(1.558,1)
--POWER():返回指定表达式的指定幂的值
select POWER(2,3)
--SQRT():返回指定浮点值的平方根
select SQRT(9)


-- ################################ --


USE [MySchoolMoreData]
GO
/****** Object:  Table [dbo].[CharTest]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CharTest](
	[Char] [char](10) NULL,
	[Varchar] [varchar](10) NULL,
	[Nchar] [nchar](10) NULL,
	[Nvarchar] [nvarchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[CharTest] ([Char], [Varchar], [Nchar], [Nvarchar]) VALUES (N'aa        ', N'aa', N'aaaaaaaaaa', N'aa')
/****** Object:  Table [dbo].[Category]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[tId] [int] IDENTITY(1,1) NOT NULL,
	[tName] [nvarchar](100) NOT NULL,
	[tParentId] [int] NOT NULL,
	[tNote] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[tId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Category] ON
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (1, N'软件开发', -1, N'关于代码的那些鸟事儿')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (2, N'休闲娱乐', -1, N'累了吧，来休息会')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (3, N'C#', 1, N'C Sharp')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (4, N'Java', 1, N'java 学习')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (5, N'Php', 1, N'php 学习')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (6, N'笑话', 2, N'笑话')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (7, N'糗百', 2, N'糗事百科')
INSERT [dbo].[Category] ([tId], [tName], [tParentId], [tNote]) VALUES (8, N'cnbeta', 2, N'it资讯')
SET IDENTITY_INSERT [dbo].[Category] OFF
/****** Object:  Table [dbo].[books]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[books](
	[bookid] [int] NOT NULL,
	[bookname] [char](50) NOT NULL,
	[price] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1001, N'人生若只如初见                                    ', 25.5200)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1002, N'SQl Server 2005                                   ', NULL)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1003, N'东莞不相信眼泪                                    ', 15.0000)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1004, N'感谢折磨你的人                                    ', 18.0000)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1005, N'我的人生刚刚开始                                  ', 0.0000)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1006, N'下午三点的女人                                    ', 39.5000)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1007, N'法律基础                                          ', 8.5000)
INSERT [dbo].[books] ([bookid], [bookname], [price]) VALUES (1008, N'标准韩国语                                        ', 55.8500)
/****** Object:  Table [dbo].[bank]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bank](
	[name] [char](10) NULL,
	[cmoney] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[bank] ([name], [cmoney]) VALUES (N'aa        ', 1000.0000)
INSERT [dbo].[bank] ([name], [cmoney]) VALUES (N'bb        ', 1.0000)
/****** Object:  Table [dbo].[Areas]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Areas](
	[AID] [int] IDENTITY(1,1) NOT NULL,
	[AName] [varchar](50) NOT NULL,
	[APid] [int] NOT NULL,
	[ASort] [int] NOT NULL,
	[AAddTime] [datetime] NOT NULL,
	[ADelFlag] [bit] NOT NULL,
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[AID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'父级节点ID(-1为顶级节点)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Areas', @level2type=N'COLUMN',@level2name=N'APid'
GO
SET IDENTITY_INSERT [dbo].[Areas] ON
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (1, N'湖南', 0, 5, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (2, N'北京', 0, 1, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (3, N'天津', 0, 2, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (4, N'河南', 0, 6, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (5, N'河北', 0, 7, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (6, N'江苏', 0, 9, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (7, N'江西', 0, 8, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (8, N'云南', 0, 11, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (9, N'上海', 0, 3, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (10, N'湖北', 0, 10, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (11, N'广东', 0, 12, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (12, N'山西', 0, 13, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (13, N'辽宁', 0, 14, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (14, N'吉林', 0, 15, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (15, N'浙江', 0, 16, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (16, N'安徽', 0, 17, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (17, N'福建', 0, 18, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (18, N'山东', 0, 19, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (19, N'内蒙古', 0, 29, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (20, N'黑龙江', 0, 20, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (21, N'广西', 0, 21, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (22, N'海南', 0, 22, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (23, N'四川', 0, 23, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (24, N'重庆', 0, 4, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (26, N'贵州', 0, 24, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (27, N'西藏', 0, 25, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (28, N'陕西', 0, 26, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (29, N'甘肃', 0, 27, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (30, N'青海', 0, 28, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (31, N'宁夏', 0, 30, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (32, N'新疆', 0, 31, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (37, N'常德市', 1, 5, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (38, N'长沙市', 1, 1, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (39, N'洛阳市', 4, 39, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (40, N'焦作市', 4, 40, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (41, N'邵阳市', 1, 9, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (42, N'永州市', 1, 10, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (43, N'怀化市', 1, 12, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (44, N'益阳市', 1, 8, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (45, N'岳阳市', 1, 7, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (46, N'张家界', 1, 11, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (47, N'和平区', 3, 47, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (48, N'昆明市', 8, 48, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (49, N'三门峡', 4, 49, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (50, N'郑州市', 4, 50, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (51, N'株洲市', 1, 2, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (52, N'湘潭市', 1, 3, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (53, N'衡阳市', 1, 4, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (54, N'郴州市', 1, 6, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (55, N'武汉市', 10, 55, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (56, N'南昌市', 7, 56, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (57, N'黄浦区', 9, 57, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (58, N'南京市', 6, 58, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (59, N'石家庄', 5, 59, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (60, N'广州市', 11, 60, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (61, N'深圳市', 11, 61, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (62, N'东莞市', 11, 62, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (63, N'汕头市', 11, 63, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (64, N'珠海市', 11, 64, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (65, N'娄底地区', 1, 13, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (66, N'湘西自治州', 1, 14, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (68, N'清远市', 11, 68, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (69, N'韶关市', 11, 69, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (70, N'河源市', 11, 70, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (71, N'梅州市', 11, 71, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (72, N'潮州市', 11, 72, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (73, N'揭阳市', 11, 73, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (74, N'汕尾市', 11, 74, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (75, N'惠州市', 11, 75, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (76, N'中山市', 11, 76, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (77, N'江门市', 11, 77, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (78, N'佛山市', 11, 78, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (79, N'肇庆市', 11, 79, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (80, N'云浮市', 11, 80, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (81, N'阳江市', 11, 81, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (82, N'茂名市', 11, 82, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (83, N'湛江市', 11, 83, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (85, N'十堰市', 10, 85, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (86, N'襄樊市', 10, 86, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (87, N'荆门市', 10, 87, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (88, N'孝感市', 10, 88, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (89, N'黄冈市', 10, 89, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (90, N'鄂州市', 10, 90, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (91, N'黄石市', 10, 91, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (92, N'咸宁市', 10, 92, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (93, N'荆州市', 10, 93, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (94, N'宜昌市', 10, 94, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (95, N'随州市', 10, 95, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (96, N'仙桃市', 10, 96, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (97, N'天门市', 10, 97, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (98, N'潜江市', 10, 98, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (99, N'神农架林区', 10, 99, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (100, N'恩施自治州', 10, 100, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (102, N'九江市', 7, 102, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (103, N'景德镇', 7, 103, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (104, N'鹰潭市', 7, 104, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (105, N'新余市', 7, 105, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (106, N'萍乡市', 7, 106, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (107, N'赣州市', 7, 107, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (108, N'上饶市', 7, 108, CAST(0x0000998F008E7394 AS DateTime), 0)
GO
print 'Processed 100 total records'
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (109, N'抚州市', 7, 109, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (110, N'宜春市', 7, 110, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (111, N'吉安市', 7, 111, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (119, N'乌鲁木齐市', 32, 119, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (120, N'克拉玛依市', 32, 120, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (121, N'石河子市', 32, 121, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (122, N'喀什地区', 32, 122, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (123, N'阿克苏地区', 32, 123, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (124, N'和田地区', 32, 124, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (125, N'吐鲁番地区', 32, 125, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (126, N'哈密地区', 32, 126, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (132, N'伊犁地区', 32, 132, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (133, N'塔城地区', 32, 133, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (134, N'阿勒泰地区', 32, 134, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (136, N'银川市', 31, 136, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (137, N'石嘴山市', 31, 137, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (138, N'吴忠市', 31, 138, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (139, N'固原地区', 31, 139, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (141, N'西宁市', 30, 141, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (142, N'海东地区', 30, 142, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (150, N'兰州市', 29, 150, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (151, N'嘉峪关市', 29, 151, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (152, N'金昌市', 29, 152, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (153, N'白银市', 29, 153, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (154, N'天水市', 29, 154, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (155, N'酒泉地区', 29, 155, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (156, N'张掖地区', 29, 156, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (157, N'武威地区', 29, 157, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (158, N'庆阳地区', 29, 158, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (159, N'平凉地区', 29, 159, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (160, N'定西地区', 29, 160, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (161, N'陇南地区', 29, 161, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (163, N'甘南自治州', 29, 163, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (165, N'西安市', 28, 165, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (166, N'延安市', 28, 166, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (167, N'铜川市', 28, 167, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (168, N'咸阳市', 28, 168, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (169, N'渭南市', 28, 169, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (170, N'宝鸡市', 28, 170, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (171, N'汉中市', 28, 171, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (172, N'榆林地区', 28, 172, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (173, N'商洛地区', 28, 173, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (174, N'安康地区', 28, 174, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (176, N'拉萨市', 27, 176, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (177, N'那曲地区', 27, 177, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (178, N'昌都地区', 27, 178, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (179, N'林芝地区', 27, 179, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (180, N'山南地区', 27, 180, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (181, N'日喀则', 27, 181, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (182, N'阿里地区', 27, 182, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (184, N'贵阳市', 26, 184, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (185, N'六盘水市', 26, 185, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (186, N'遵义市', 26, 186, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (187, N'毕节地区', 26, 187, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (188, N'铜仁地区', 26, 188, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (189, N'安顺地区', 26, 189, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (199, N'渝中区', 24, 199, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (200, N'大渡口', 24, 200, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (201, N'江北区', 24, 201, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (202, N'沙坪坝', 24, 202, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (203, N'九龙坡', 24, 203, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (204, N'南岸区', 24, 204, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (205, N'北碚区', 24, 205, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (206, N'万盛区', 24, 206, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (207, N'双桥区', 24, 207, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (208, N'渝北区', 24, 208, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (209, N'巴南区', 24, 209, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (210, N'万州区', 24, 210, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (211, N'涪陵区', 24, 211, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (212, N'合川市', 24, 212, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (213, N'永川市', 24, 213, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (214, N'江津市', 24, 214, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (215, N'南川市', 24, 215, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (216, N'长寿县', 24, 216, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (217, N'綦江县', 24, 217, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (218, N'潼南县', 24, 218, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (219, N'铜梁县', 24, 219, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (220, N'大足县', 24, 220, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (221, N'荣昌县', 24, 221, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (222, N'璧山县', 24, 222, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (223, N'垫江县', 24, 223, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (224, N'武隆县', 24, 224, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (225, N'丰都县', 24, 225, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (226, N'城口县', 24, 226, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (227, N'梁平县', 24, 227, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (228, N'万州开发区', 24, 228, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (229, N'黔江开发区', 24, 229, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (231, N'成都市', 23, 231, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (232, N'广元市', 23, 232, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (233, N'绵阳市', 23, 233, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (234, N'德阳市', 23, 234, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (235, N'南充市', 23, 235, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (236, N'广安市', 23, 236, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (237, N'遂宁市', 23, 237, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (238, N'内江市', 23, 238, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (239, N'乐山市', 23, 239, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (240, N'自贡市', 23, 240, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (241, N'泸州市', 23, 241, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (242, N'宜宾市', 23, 242, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (243, N'攀枝花市', 23, 243, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (244, N'巴中地区', 23, 244, CAST(0x0000998F008E7394 AS DateTime), 0)
GO
print 'Processed 200 total records'
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (245, N'达川地区', 23, 245, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (246, N'资阳地区', 23, 246, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (247, N'眉山地区', 23, 247, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (248, N'雅安地区', 23, 248, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (250, N'甘孜自治州', 23, 250, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (253, N'海口市', 22, 253, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (254, N'三亚市', 22, 254, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (255, N'琼山市', 22, 255, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (256, N'文昌市', 22, 256, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (257, N'琼海市', 22, 257, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (258, N'万宁市', 22, 258, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (259, N'通什市', 22, 259, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (260, N'东方市', 22, 260, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (261, N'儋州市', 22, 261, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (262, N'临高县', 22, 262, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (263, N'澄迈县', 22, 263, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (264, N'定安县', 22, 264, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (265, N'屯昌县', 22, 265, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (266, N'昌江自治县', 22, 266, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (267, N'白沙自治县', 22, 267, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (269, N'陵水自治县', 22, 269, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (271, N'乐东自治县', 22, 271, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (274, N'南宁市', 21, 274, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (275, N'桂林市', 21, 275, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (276, N'柳州市', 21, 276, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (277, N'梧州市', 21, 277, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (278, N'贵港市', 21, 278, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (279, N'玉林市', 21, 279, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (280, N'钦州市', 21, 280, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (281, N'北海市', 21, 281, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (282, N'防城港市', 21, 282, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (283, N'南宁地区', 21, 283, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (284, N'百色地区', 21, 284, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (285, N'河池地区', 21, 285, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (286, N'柳州地区', 21, 286, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (287, N'贺州地区', 21, 287, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (289, N'哈尔滨市', 20, 289, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (290, N'齐齐哈尔', 20, 290, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (291, N'黑河市', 20, 291, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (292, N'大庆市', 20, 292, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (293, N'伊春市', 20, 293, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (294, N'鹤岗市', 20, 294, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (295, N'佳木斯市', 20, 295, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (296, N'双鸭山市', 20, 296, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (297, N'七台河市', 20, 297, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (298, N'鸡西市', 20, 298, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (299, N'牡丹江市', 20, 299, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (300, N'绥化地区', 20, 300, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (301, N'大兴安岭', 20, 301, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (303, N'呼和浩特', 19, 303, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (304, N'包头市', 19, 304, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (305, N'乌海市', 19, 305, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (306, N'赤峰市', 19, 306, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (307, N'呼伦贝尔', 19, 307, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (308, N'兴安盟', 19, 308, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (309, N'哲里木盟', 19, 309, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (310, N'锡林郭勒', 19, 310, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (311, N'乌兰察布', 19, 311, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (312, N'伊克昭盟', 19, 312, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (313, N'巴彦淖尔', 19, 313, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (314, N'阿拉善盟', 19, 314, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (316, N'济南市', 18, 316, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (317, N'聊城市', 18, 317, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (318, N'德州市', 18, 318, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (319, N'东营市', 18, 319, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (320, N'淄博市', 18, 320, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (321, N'潍坊市', 18, 321, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (322, N'烟台市', 18, 322, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (323, N'威海市', 18, 323, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (324, N'青岛市', 18, 324, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (325, N'日照市', 18, 325, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (326, N'临沂市', 18, 326, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (327, N'枣庄市', 18, 327, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (328, N'济宁市', 18, 328, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (329, N'泰安市', 18, 329, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (330, N'莱芜市', 18, 330, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (331, N'滨州市', 18, 331, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (332, N'菏泽市', 18, 332, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (334, N'福州市', 17, 334, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (335, N'南平市', 17, 335, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (336, N'三明市', 17, 336, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (337, N'莆田市', 17, 337, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (338, N'泉州市', 17, 338, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (339, N'厦门市', 17, 339, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (340, N'漳州市', 17, 340, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (341, N'龙岩市', 17, 341, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (342, N'宁德市', 17, 342, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (344, N'合肥市', 16, 344, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (345, N'宿州市', 16, 345, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (346, N'淮北市', 16, 346, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (347, N'阜阳市', 16, 347, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (348, N'蚌埠市', 16, 348, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (349, N'淮南市', 16, 349, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (350, N'滁州市', 16, 350, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (351, N'马鞍山', 16, 351, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (352, N'芜湖市', 16, 352, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (353, N'铜陵市', 16, 353, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (354, N'安庆市', 16, 354, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (355, N'黄山市', 16, 355, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (356, N'六安', 16, 356, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (357, N'巢湖', 16, 357, CAST(0x0000998F008E7394 AS DateTime), 0)
GO
print 'Processed 300 total records'
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (358, N'池州', 16, 358, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (359, N'宣城', 16, 359, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (361, N'杭州市', 15, 361, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (362, N'湖州市', 15, 362, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (363, N'嘉兴市', 15, 363, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (364, N'舟山市', 15, 364, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (365, N'宁波市', 15, 365, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (366, N'绍兴市', 15, 366, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (367, N'金华市', 15, 367, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (368, N'台州市', 15, 368, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (369, N'温州市', 15, 369, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (370, N'丽水地区', 15, 370, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (372, N'长春市', 14, 372, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (373, N'白城市', 14, 373, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (374, N'松原市', 14, 374, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (375, N'吉林市', 14, 375, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (376, N'四平市', 14, 376, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (377, N'辽源市', 14, 377, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (378, N'通化市', 14, 378, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (379, N'白山市', 14, 379, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (382, N'沈阳市', 13, 382, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (383, N'朝阳市', 13, 383, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (384, N'阜新市', 13, 384, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (385, N'铁岭市', 13, 385, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (386, N'抚顺市', 13, 386, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (387, N'本溪市', 13, 387, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (388, N'辽阳市', 13, 388, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (389, N'鞍山市', 13, 389, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (390, N'丹东市', 13, 390, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (391, N'大连市', 13, 391, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (392, N'营口市', 13, 392, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (393, N'盘锦市', 13, 393, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (394, N'锦州市', 13, 394, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (395, N'葫芦岛市', 13, 395, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (397, N'大同市', 12, 397, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (398, N'太原市', 12, 398, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (399, N'朔州市', 12, 399, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (400, N'阳泉市', 12, 400, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (401, N'长治市', 12, 401, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (402, N'晋城市', 12, 402, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (403, N'忻州地区', 12, 403, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (404, N'吕梁地区', 12, 404, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (405, N'晋中地区', 12, 405, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (406, N'临汾地区', 12, 406, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (407, N'运城地区', 12, 407, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (409, N'南市区', 9, 409, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (410, N'卢湾区', 9, 410, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (411, N'徐汇区', 9, 411, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (412, N'长宁区', 9, 412, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (413, N'静安区', 9, 413, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (414, N'普陀区', 9, 414, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (415, N'闸北区', 9, 415, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (416, N'虹口区', 9, 416, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (417, N'杨浦区', 9, 417, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (418, N'闵行区', 9, 418, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (419, N'宝山区', 9, 419, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (420, N'嘉定区', 9, 420, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (421, N'浦东新区', 9, 421, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (422, N'金山区', 9, 422, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (423, N'松江区', 9, 423, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (424, N'崇明县', 9, 424, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (425, N'青浦县', 9, 425, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (426, N'南汇县', 9, 426, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (427, N'奉贤县', 9, 427, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (429, N'门头沟', 2, 429, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (430, N'房山区', 2, 430, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (431, N'顺义区', 2, 431, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (432, N'延庆县', 2, 432, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (433, N'昌平县', 2, 433, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (434, N'怀柔县', 2, 434, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (435, N'徐州市', 6, 435, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (436, N'连云港市', 6, 436, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (437, N'宿迁市', 6, 437, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (438, N'淮阴市', 6, 438, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (439, N'盐城市', 6, 439, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (440, N'扬州市', 6, 440, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (441, N'泰州市', 6, 441, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (442, N'南通市', 6, 442, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (443, N'镇江市', 6, 443, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (444, N'常州市', 6, 444, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (445, N'无锡市', 6, 445, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (446, N'苏州市', 6, 446, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (448, N'河东区', 3, 448, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (449, N'河西区', 3, 449, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (450, N'南开区', 3, 450, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (451, N'河北区', 3, 451, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (452, N'红桥区', 3, 452, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (453, N'塘沽区', 3, 453, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (454, N'大港区', 3, 454, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (455, N'东丽区', 3, 455, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (456, N'西青区', 3, 456, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (457, N'津南区', 3, 457, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (458, N'北辰区', 3, 458, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (459, N'蓟县', 3, 459, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (460, N'宝坻县', 3, 460, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (461, N'武清县', 3, 461, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (462, N'宁河县', 3, 462, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (463, N'静海县', 3, 463, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (465, N'新乡市', 4, 465, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (466, N'鹤壁市', 4, 466, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (467, N'安阳市', 4, 467, CAST(0x0000998F008E7394 AS DateTime), 0)
GO
print 'Processed 400 total records'
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (468, N'濮阳市', 4, 468, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (469, N'开封市', 4, 469, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (470, N'商丘市', 4, 470, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (471, N'许昌市', 4, 471, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (472, N'漯河市', 4, 472, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (473, N'平顶山', 4, 473, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (474, N'南阳市', 4, 474, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (475, N'信阳市', 4, 475, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (476, N'济源市', 4, 476, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (477, N'周口', 4, 477, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (478, N'驻马店', 4, 478, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (480, N'曲靖市', 8, 480, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (481, N'玉溪市', 8, 481, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (482, N'丽江地区', 8, 482, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (483, N'昭通地区', 8, 483, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (484, N'思茅地区', 8, 484, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (485, N'临沧地区', 8, 485, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (486, N'保山地区', 8, 486, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (487, N'德宏自治州', 8, 487, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (488, N'怒江自治州', 8, 488, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (489, N'迪庆自治州', 8, 489, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (490, N'大理自治州', 8, 490, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (491, N'楚雄自治州', 8, 491, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (492, N'红河自治州', 8, 492, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (493, N'文山自治州', 8, 493, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (494, N'西双自治州', 8, 494, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (496, N'张家口', 5, 496, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (497, N'秦皇岛', 5, 497, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (498, N'承德市', 5, 498, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (499, N'唐山市', 5, 499, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (500, N'廊坊市', 5, 500, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (501, N'保定市', 5, 501, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (502, N'沧州市', 5, 502, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (503, N'衡水市', 5, 503, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (504, N'邢台市', 5, 504, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (505, N'邯郸市', 5, 505, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (507, N'密云县', 2, 507, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (508, N'北京城区', 2, 508, CAST(0x0000998F008E7394 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (510, N'岳麓区', 38, 1, CAST(0x0000998F00AD8E78 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (511, N'芙蓉区', 38, 2, CAST(0x0000998F00AE7A04 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (512, N'天心区 ', 38, 3, CAST(0x0000998F00AE85BC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (513, N'开福区', 38, 4, CAST(0x0000998F00AE9048 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (514, N'雨花区', 38, 5, CAST(0x0000998F00AEA434 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (515, N'开发区', 38, 6, CAST(0x0000998F00AEB118 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (517, N'望月湖', 510, 1, CAST(0x000099B800F44A48 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (518, N'银盆岭', 510, 2, CAST(0x000099B800F454D4 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (519, N'荣湾', 510, 3, CAST(0x000099B800F45E34 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (520, N'大学城', 510, 4, CAST(0x000099B800F46668 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (521, N'桐梓坡', 510, 5, CAST(0x000099B800F470F4 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (522, N'汽车西站附', 510, 6, CAST(0x000099B800F47928 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (523, N'观沙岭', 510, 8, CAST(0x000099B800F483B4 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (524, N'五一广场', 511, 1, CAST(0x000099B800F49C50 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (525, N'火车站', 511, 3, CAST(0x000099B800F4A5B0 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (526, N'马王堆', 511, 4, CAST(0x000099B800F4ACB8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (527, N'司门口', 511, 2, CAST(0x000099B800F4BE4C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (528, N'火星镇', 511, 5, CAST(0x000099B800F4F308 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (529, N'万家丽', 511, 6, CAST(0x000099B800F4FD94 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (530, N'杨家山', 511, 7, CAST(0x000099B800F50820 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (531, N'定王台', 511, 8, CAST(0x000099B800F512AC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (532, N'德政园', 511, 9, CAST(0x000099B800F51D38 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (533, N'荷花园', 511, 10, CAST(0x000099B800F52698 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (534, N'袁家岭', 511, 11, CAST(0x000099B800F52FF8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (535, N'识字岭', 511, 12, CAST(0x000099B800F53958 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (536, N'高桥', 511, 13, CAST(0x000099B800F5418C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (537, N'韭菜园', 511, 14, CAST(0x000099B800F54C18 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (538, N'人民新村', 511, 15, CAST(0x000099B800F56BBC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (539, N'浏城桥', 511, 16, CAST(0x000099B800F5751C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (540, N'天心阁', 511, 17, CAST(0x000099B800F57E7C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (541, N'南门口', 511, 18, CAST(0x000099B800F59394 AS DateTime), 1)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (542, N'侯家塘', 512, 1, CAST(0x000099B800F5C148 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (543, N'南门口', 512, 2, CAST(0x000099B800F5CAA8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (544, N'步行街', 512, 3, CAST(0x000099B800F5D2DC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (545, N'新开铺', 512, 4, CAST(0x000099B800F5DC3C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (546, N'劳动广场', 512, 5, CAST(0x000099B800F5E470 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (547, N'涂家冲', 512, 6, CAST(0x000099B800F5EDD0 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (548, N'四方平', 512, 7, CAST(0x000099B800F5F85C AS DateTime), 1)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (549, N'南郊公园', 512, 8, CAST(0x000099B800F60090 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (550, N'贺龙体育馆', 512, 9, CAST(0x000099B800F60B1C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (551, N'金盆岭', 512, 10, CAST(0x000099B800F6147C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (552, N'仰天湖', 512, 11, CAST(0x000099B800F61DDC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (553, N'五一广场', 512, 12, CAST(0x000099B800F6273C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (554, N'火车南站', 512, 13, CAST(0x000099B800F6354C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (555, N'黄土岭', 512, 14, CAST(0x000099B800F63FD8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (556, N'伍家岭', 513, 1, CAST(0x000099B800F6561C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (557, N'四方坪', 513, 2, CAST(0x000099B800F65E50 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (558, N'井湾子', 513, 3, CAST(0x000099B800F66684 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (559, N'烈士公园', 513, 4, CAST(0x000099B800F66EB8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (560, N'兴汉门', 513, 5, CAST(0x000099B800F676EC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (561, N'松桂园', 6, 100001, CAST(0x000099B800F6804C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (562, N'东塘', 514, 1, CAST(0x000099B800F6ABA8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (563, N'左家塘', 514, 2, CAST(0x000099B800F6B2B0 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (564, N'雨花亭', 514, 3, CAST(0x000099B800F6BAE4 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (565, N'窑岭', 514, 4, CAST(0x000099B800F6C1EC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (566, N'树木岭', 514, 5, CAST(0x000099B800F6CB4C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (567, N'长岭', 514, 6, CAST(0x000099B800F6D830 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (568, N'井湾子', 514, 7, CAST(0x000099B800F6E064 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (569, N'侯家塘', 514, 8, CAST(0x000099B800F6E898 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (570, N'赤岗冲', 514, 9, CAST(0x000099B800F6F1F8 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (571, N'砂子塘', 514, 10, CAST(0x000099B800F6FB58 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (572, N'桂花村', 514, 11, CAST(0x000099B800F7038C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (573, N'红星', 514, 12, CAST(0x000099B800F70BC0 AS DateTime), 0)
GO
print 'Processed 500 total records'
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (574, N'红旗', 514, 13, CAST(0x000099B800F7164C AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (575, N'体育新城', 514, 14, CAST(0x000099B800F749DC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (576, N'狮子山', 514, 15, CAST(0x000099B800F75210 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (577, N'高桥', 514, 16, CAST(0x000099B800F75B70 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (578, N'沙子塘', 514, 16, CAST(0x000099B800F765FC AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (579, N'茶园坡', 514, 17, CAST(0x000099B800F771B4 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (580, N'汽车南站', 514, 18, CAST(0x000099B800F77C40 AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (581, N'曾都区', 95, 100001, CAST(0x00009B140087909E AS DateTime), 0)
INSERT [dbo].[Areas] ([AID], [AName], [APid], [ASort], [AAddTime], [ADelFlag]) VALUES (582, N'北京市', 2, 1, CAST(0x00009BD400000000 AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Areas] OFF
/****** Object:  Table [dbo].[Admin]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Admin](
	[name] [nvarchar](50) NOT NULL,
	[pwd] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'a')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'a')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'f', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'f', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'g', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'f', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'g', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'f', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'g', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'f', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'g', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'a', N'c')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'f', N'g')
INSERT [dbo].[Admin] ([name], [pwd]) VALUES (N'g', N'g')
/****** Object:  Table [dbo].[Order]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[IIdd] [int] IDENTITY(1,1) NOT NULL,
	[id] [nchar](10) NULL,
	[money] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Order] ON
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (1, N'pk1       ', 10)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (2, N'pk2       ', 20)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (3, N'pk3       ', -30)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (4, N'pk4       ', -10)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (5, N'pk1       ', 10)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (6, N'pk2       ', 20)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (7, N'pk3       ', -30)
INSERT [dbo].[Order] ([IIdd], [id], [money]) VALUES (8, N'pk4       ', -10)
SET IDENTITY_INSERT [dbo].[Order] OFF
/****** Object:  Table [dbo].[grade]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[grade](
	[ClassId] [int] IDENTITY(1,1) NOT NULL,
	[classname] [varchar](50) NOT NULL,
 CONSTRAINT [PK_grade] PRIMARY KEY CLUSTERED 
(
	[ClassId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[grade] ON
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (2, N'二期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (3, N'三期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (4, N'四期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (5, N'五期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (6, N'六期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (7, N'七期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (8, N'八期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (9, N'九期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (10, N'十期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (11, N'十一期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (12, N'十二期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (13, N'一期班')
INSERT [dbo].[grade] ([ClassId], [classname]) VALUES (14, N'二期班1')
SET IDENTITY_INSERT [dbo].[grade] OFF
/****** Object:  Table [dbo].[employee]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[employee](
	[eId] [int] IDENTITY(1,1) NOT NULL,
	[eName] [varchar](10) NOT NULL,
	[eSex] [char](2) NOT NULL,
	[eAge] [int] NOT NULL,
	[eSalary] [int] NOT NULL,
	[eDepId] [int] NOT NULL,
	[eInTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[employee] ON
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (1, N'苍老师', N'0 ', 28, 10000, 1, CAST(0x0000981700000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (2, N'导演', N'1 ', 45, 9000, 2, CAST(0x0000953D00000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (3, N'武兰老师', N'0 ', 35, 6000, 1, CAST(0x0000946800000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (4, N'新人一号', N'0 ', 19, 1800, 1, CAST(0x0000A15F00000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (5, N'灯光师', N'1 ', 24, 1600, 3, CAST(0x00009DCC00000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (6, N'音响师', N'1 ', 25, 1800, 3, CAST(0x00009C5F00000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (7, N'路人甲', N'1 ', 24, 1550, 4, CAST(0x00009D7000000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (8, N'男一号', N'1 ', 30, 5000, 1, CAST(0x0000981700000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (9, N'副导演', N'1 ', 35, 7000, 2, CAST(0x00009BC300000000 AS DateTime))
INSERT [dbo].[employee] ([eId], [eName], [eSex], [eAge], [eSalary], [eDepId], [eInTime]) VALUES (10, N'资深路人', N'1 ', 35, 2500, 5, CAST(0x0000969700000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[employee] OFF
/****** Object:  Table [dbo].[department]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[department](
	[dId] [int] IDENTITY(1,1) NOT NULL,
	[dName] [varchar](10) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[department] ON
INSERT [dbo].[department] ([dId], [dName]) VALUES (1, N'主演')
INSERT [dbo].[department] ([dId], [dName]) VALUES (2, N'导演')
INSERT [dbo].[department] ([dId], [dName]) VALUES (3, N'幕后')
INSERT [dbo].[department] ([dId], [dName]) VALUES (4, N'跑龙套')
INSERT [dbo].[department] ([dId], [dName]) VALUES (5, N'音响')
INSERT [dbo].[department] ([dId], [dName]) VALUES (6, N'灯光')
INSERT [dbo].[department] ([dId], [dName]) VALUES (7, N'摄像')
SET IDENTITY_INSERT [dbo].[department] OFF
/****** Object:  Table [dbo].[User]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[UserPwd] [varchar](16) NOT NULL,
	[Email] [varchar](50) NULL,
	[Phone] [char](13) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON
INSERT [dbo].[User] ([Id], [UserName], [UserPwd], [Email], [Phone]) VALUES (9, N'aa', N'123456', N'aa@bb.com', N'             ')
INSERT [dbo].[User] ([Id], [UserName], [UserPwd], [Email], [Phone]) VALUES (10, N'aaa', N'123456', N'aa@bb.com', N'             ')
INSERT [dbo].[User] ([Id], [UserName], [UserPwd], [Email], [Phone]) VALUES (11, N'aabb', N'123456', N'aa@bb.com', N'             ')
INSERT [dbo].[User] ([Id], [UserName], [UserPwd], [Email], [Phone]) VALUES (12, N'aa', N'123456', N'aa@bb.com', N'             ')
SET IDENTITY_INSERT [dbo].[User] OFF
/****** Object:  Table [dbo].[Subject]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject](
	[SubjectId] [int] IDENTITY(1,1) NOT NULL,
	[SubjectName] [nvarchar](50) NOT NULL,
	[ClassHour] [int] NOT NULL,
	[ClassId] [int] NULL,
 CONSTRAINT [PK_Subject] PRIMARY KEY CLUSTERED 
(
	[SubjectId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Subject] ON
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (1, N'office', 6, 6)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (2, N'HTML', 10, 3)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (3, N'C#', 8, 1)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (4, N'SQL SERVER', 20, 3)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (5, N'.NET面向对象', 12, 2)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (6, N'数据库进阶', 14, 1)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (7, N'三层开发', 18, NULL)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (8, N'面向对象程序设计', 12, 1)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (9, N'JavaScript', 30, 5)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (10, N'英文', 120, 6)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (11, N'ASP.NET技术', 50, 2)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (12, N'Ajax', 20, 2)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (13, N'MVC', 52, NULL)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (14, N'UNIT 3D', 8, 4)
INSERT [dbo].[Subject] ([SubjectId], [SubjectName], [ClassHour], [ClassId]) VALUES (28, N'三层架构的使用', 30, 14)
SET IDENTITY_INSERT [dbo].[Subject] OFF
/****** Object:  Table [dbo].[Student]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[StudentNo] [int] IDENTITY(1,1) NOT NULL,
	[LoginPwd] [nvarchar](20) NOT NULL,
	[StudentName] [nvarchar](50) NOT NULL,
	[Sex] [nchar](2) NOT NULL,
	[ClassId] [int] NULL,
	[Phone] [nvarchar](255) NULL,
	[Address] [nvarchar](255) NULL,
	[BornDate] [datetime] NULL,
	[Email] [nvarchar](50) NULL,
	[isDel] [bit] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY NONCLUSTERED 
(
	[StudentNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Student] ON
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (3, N'123456', N'冯晨旭123', N'男', 4, N'110', N'广州传智播客', CAST(0x00008A6400000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (6, N'123456', N'郭林清', N'女', 1, N'999', N'广州传智播客', CAST(0x00008BE700000000 AS DateTime), N'aa@bb.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (18, N'123456', N'郭林清', N'女', 7, N'120', N'广州传智播客', CAST(0x00008A6400000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (17, N'123456', N'李聪', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (28, N'123456789', N'李四', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00006F4800000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (15, N'123456', N'李新伟', N'女', 1, N'110', N'广州', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (5, N'123456', N'廖杨', N'男', 2, N'110', N'广州传智播客', CAST(0x00008A6400000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (8, N'123456', N'林思', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (1, N'123456', N'刘健', N'男', 1, N'110', N'广州传智播客1', CAST(0x00006CAC00000000 AS DateTime), N'qq@qq.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (21, N'123456', N'刘文华', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (20, N'123456', N'卢欣', N'男', 6, N'110', N'广州传智播客', CAST(0x00008A6400000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (7, N'123456', N'罗浩123', N'男', 7, N'110', N'广州传智播客', CAST(0x00008A6400000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (9, N'123456', N'麦福权', N'男', 2, N'110', N'广州传智播客', CAST(0x00008BCC00000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (2, N'123456789', N'蒙方林', N'女', 6, N'1999', N'广州传智播客(1)', CAST(0x00006F4800000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (19, N'123456', N'欧旋科', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (14, N'123456', N'王洪波', N'男', 6, N'110', N'广州传智播客', CAST(0x0000901900000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (13, N'123456', N'王君军', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (23, N'123456', N'王男的q', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (29, N'123456', N'王女', N'女', 3, N'110', N'广州传智播客', CAST(0x0000834200000000 AS DateTime), N'a@b.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (22, N'123456', N'徐伟', N'男', 6, N'110', N'广州传智播客', CAST(0x00007C2000000000 AS DateTime), NULL, 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (10, N'aaaaaa', N'杨培钊', N'男', 3, N'140', N'广州传智播客', CAST(0x00008A6400000000 AS DateTime), N'a@bffdsf.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (27, N'123456', N'张莉', N'男', 4, N'110', N'广州传智播客1', CAST(0x00006C6F00000000 AS DateTime), N'qq@qq.com', 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (11, N'123456', N'周余波', N'女', 6, N'110', N'广州传智播客(1)', CAST(0x00008BD100000000 AS DateTime), NULL, 0)
INSERT [dbo].[Student] ([StudentNo], [LoginPwd], [StudentName], [Sex], [ClassId], [Phone], [Address], [BornDate], [Email], [isDel]) VALUES (12, N'123456789', N'周治明', N'男', 6, N'110', N'广州传智播客', CAST(0x00008EAC00000000 AS DateTime), N'a@b.com', 0)
SET IDENTITY_INSERT [dbo].[Student] OFF
/****** Object:  Table [dbo].[PhoneNum]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhoneNum](
	[pId] [int] IDENTITY(1,1) NOT NULL,
	[pTypeId] [int] NOT NULL,
	[pName] [nvarchar](50) NULL,
	[pCellPhone] [varchar](50) NULL,
	[pHomePhone] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[pId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[PhoneNum] ON
INSERT [dbo].[PhoneNum] ([pId], [pTypeId], [pName], [pCellPhone], [pHomePhone]) VALUES (1, 2, N'刘备', N'13000000000', N'7000000')
INSERT [dbo].[PhoneNum] ([pId], [pTypeId], [pName], [pCellPhone], [pHomePhone]) VALUES (6, 3, N'孙权', N'13400000003', N'9000003')
INSERT [dbo].[PhoneNum] ([pId], [pTypeId], [pName], [pCellPhone], [pHomePhone]) VALUES (7, 22, N'小乔', N'13400000004', N'9000004')
INSERT [dbo].[PhoneNum] ([pId], [pTypeId], [pName], [pCellPhone], [pHomePhone]) VALUES (15, 5, N'qq', N'111', N'222')
SET IDENTITY_INSERT [dbo].[PhoneNum] OFF
/****** Object:  Table [dbo].[Result]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Result](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentNo] [int] NOT NULL,
	[SubjectId] [int] NOT NULL,
	[StudentResult] [int] NULL,
	[ExamDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_Result] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Result] ON
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (3, 3, 2, 100, CAST(0xA97D0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (4, 2, 2, 87, CAST(0xA0EE0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (5, 6, 1, 100, CAST(0xA2BB0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (6, 20, 1, NULL, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (7, 7, 1, NULL, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (8, 8, 1, 74, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (9, 9, 1, 85, CAST(0xA27E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (10, 10, 1, 99, CAST(0xA27E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (11, 10, 1, 99, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (12, 12, 1, 44, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (13, 13, 1, 73, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (14, 14, 1, 51, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (15, 15, 1, 62, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (16, 16, 1, 84, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (17, 17, 1, 95, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (18, 18, 1, 100, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (19, 19, 1, 84, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (20, 20, 1, 62, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (21, 21, 1, 73, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (22, 22, 1, 61, CAST(0xA2BB0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (23, 23, 1, 100, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (24, 24, 1, 100, CAST(0xA14E0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (25, 25, 2, 66, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (26, 26, 2, 55, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (27, 1, 1, 66, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (28, 28, 2, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (30, 2, 2, 55, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (31, 3, 2, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (32, 4, 2, NULL, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (33, 5, 2, 77, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (34, 6, 2, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (35, 7, 1, 77, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (36, 8, 2, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (37, 9, 2, 76, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (38, 10, 2, NULL, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (39, 11, 2, 44, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (40, 12, 1, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (41, 13, 2, 70, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (42, 14, 2, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (43, 15, 2, 33, CAST(0xA1660000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (47, 16, 2, 93, CAST(0xA1740000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (48, 17, 2, 33, CAST(0xA1740000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (61, 18, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (62, 19, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (63, 20, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (64, 21, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (65, 22, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (66, 23, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (67, 24, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (68, 25, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (69, 26, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (70, 27, 3, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (84, 2, 4, 94, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (85, 3, 2, 95, CAST(0xA1E50000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (86, 4, 10, 99, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (87, 5, 4, 99, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (88, 6, 4, 95, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (89, 7, 7, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (90, 8, 4, 89, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (91, 9, 4, 95, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (92, 10, 4, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (93, 11, 4, 100, CAST(0xA1890000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (106, 12, 1, 100, CAST(0xA1EE0000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (107, 13, 2, 100, CAST(0xA2A60000 AS SmallDateTime))
INSERT [dbo].[Result] ([Id], [StudentNo], [SubjectId], [StudentResult], [ExamDate]) VALUES (109, 20, 4, NULL, CAST(0xA1760000 AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Result] OFF
/****** Object:  Table [dbo].[ContentInfo]    Script Date: 04/08/2014 12:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContentInfo](
	[dId] [int] IDENTITY(1,1) NOT NULL,
	[dTId] [int] NOT NULL,
	[dName] [nvarchar](100) NOT NULL,
	[dContent] [varchar](max) NULL,
	[dInTime] [datetime] NULL,
	[dEditTime] [datetime] NULL,
	[dIsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[dId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ContentInfo] ON
INSERT [dbo].[ContentInfo] ([dId], [dTId], [dName], [dContent], [dInTime], [dEditTime], [dIsDeleted]) VALUES (1, 3, N'C#操作文件', N'IO操作....', CAST(0x0000A280011DAA9B AS DateTime), CAST(0x0000A280011DAA9B AS DateTime), 0)
INSERT [dbo].[ContentInfo] ([dId], [dTId], [dName], [dContent], [dInTime], [dEditTime], [dIsDeleted]) VALUES (2, 3, N'C#操数据库', N'数据库操作....', CAST(0x0000A280011DAA9B AS DateTime), CAST(0x0000A280011DAA9B AS DateTime), 0)
INSERT [dbo].[ContentInfo] ([dId], [dTId], [dName], [dContent], [dInTime], [dEditTime], [dIsDeleted]) VALUES (3, 3, N'C#加密解密', N'加密解密....', CAST(0x0000A280011DAA9B AS DateTime), CAST(0x0000A280011DAA9B AS DateTime), 0)
INSERT [dbo].[ContentInfo] ([dId], [dTId], [dName], [dContent], [dInTime], [dEditTime], [dIsDeleted]) VALUES (4, 3, N'C#...', N'C#操作....', CAST(0x0000A280011DAA9B AS DateTime), CAST(0x0000A280011DAA9B AS DateTime), 0)
INSERT [dbo].[ContentInfo] ([dId], [dTId], [dName], [dContent], [dInTime], [dEditTime], [dIsDeleted]) VALUES (10, 6, N'笑话', N'asdfg', CAST(0x0000A2A400A2E23C AS DateTime), CAST(0x0000A2A400A2E23C AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[ContentInfo] OFF
/****** Object:  Default [DF_Admin_pwd]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Admin] ADD  CONSTRAINT [DF_Admin_pwd]  DEFAULT ((123456)) FOR [pwd]
GO
/****** Object:  Default [DF_Area_AAddTime]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Areas] ADD  CONSTRAINT [DF_Area_AAddTime]  DEFAULT (getdate()) FOR [AAddTime]
GO
/****** Object:  Default [DF_Area_ADelFlag]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Areas] ADD  CONSTRAINT [DF_Area_ADelFlag]  DEFAULT ((0)) FOR [ADelFlag]
GO
/****** Object:  Default [DF_data_dIntime]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[ContentInfo] ADD  CONSTRAINT [DF_data_dIntime]  DEFAULT (getdate()) FOR [dInTime]
GO
/****** Object:  Default [DF_data_dEditTime]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[ContentInfo] ADD  CONSTRAINT [DF_data_dEditTime]  DEFAULT (getdate()) FOR [dEditTime]
GO
/****** Object:  Default [DF_data_dIsDeleted]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[ContentInfo] ADD  CONSTRAINT [DF_data_dIsDeleted]  DEFAULT ((0)) FOR [dIsDeleted]
GO
/****** Object:  Default [DF_Student_LoginPwd]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_LoginPwd]  DEFAULT ((123456)) FOR [LoginPwd]
GO
/****** Object:  Default [DF_Student_Sex]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_Sex]  DEFAULT ('男') FOR [Sex]
GO
/****** Object:  Default [DF_Student_Address]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_Address]  DEFAULT (N'学生宿舍') FOR [Address]
GO
/****** Object:  Default [DF_Student_isDel]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_isDel]  DEFAULT ((0)) FOR [isDel]
GO
/****** Object:  Default [DF_Subject_ClassHour]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Subject] ADD  CONSTRAINT [DF_Subject_ClassHour]  DEFAULT ((0)) FOR [ClassHour]
GO
/****** Object:  Check [ck_cmoey]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[bank]  WITH CHECK ADD  CONSTRAINT [ck_cmoey] CHECK  (([cmoney]>=(1)))
GO
ALTER TABLE [dbo].[bank] CHECK CONSTRAINT [ck_cmoey]
GO
/****** Object:  Check [CK_Result]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Result]  WITH CHECK ADD  CONSTRAINT [CK_Result] CHECK  (([StudentResult] IS NULL OR [StudentResult]>=(0) AND [StudentResult]<=(100)))
GO
ALTER TABLE [dbo].[Result] CHECK CONSTRAINT [CK_Result]
GO
/****** Object:  Check [CK_Student]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [CK_Student] CHECK  ((len([LoginPwd])>=(6)))
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [CK_Student]
GO
/****** Object:  Check [CK_Student_1]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [CK_Student_1] CHECK  (([Sex]='男' OR [Sex]='女'))
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [CK_Student_1]
GO
/****** Object:  Check [CK_Subject]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Subject]  WITH CHECK ADD  CONSTRAINT [CK_Subject] CHECK  (([ClassHour]>(0)))
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [CK_Subject]
GO
/****** Object:  ForeignKey [FK__ContentInf__dTId__276EDEB3]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[ContentInfo]  WITH CHECK ADD FOREIGN KEY([dTId])
REFERENCES [dbo].[Category] ([tId])
GO
/****** Object:  ForeignKey [FK__ContentInf__dTId__286302EC]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[ContentInfo]  WITH CHECK ADD FOREIGN KEY([dTId])
REFERENCES [dbo].[Category] ([tId])
GO
/****** Object:  ForeignKey [FK_Result_subject_subjectid]    Script Date: 04/08/2014 12:22:20 ******/
ALTER TABLE [dbo].[Result]  WITH CHECK ADD  CONSTRAINT [FK_Result_subject_subjectid] FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subject] ([SubjectId])
GO
ALTER TABLE [dbo].[Result] CHECK CONSTRAINT [FK_Result_subject_subjectid]
GO
