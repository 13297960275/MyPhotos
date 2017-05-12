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
