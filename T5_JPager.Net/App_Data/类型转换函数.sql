--类型转换函数
--+在使用时首先是运算符，系统会做隐藏的类型转换，如果可以转换那就OK，否则报错
select 1+'1'
--除非两边都是字符串类型，那么+号就是字符串连接符
select '1'+'1'
--cast(源数据 as 目标类型)
print '我的总成绩是：'+cast(200 as varchar(30))
--Convert(目标类型，源数据,格式)
print '我的总成绩是：'+convert(char(3),200)
--为日期值添加格式
select CONVERT(char(30),GETDATE(),102)