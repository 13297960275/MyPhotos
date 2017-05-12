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

