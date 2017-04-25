DROP TABLE IF EXISTS websites;
DROP TABLE IF EXISTS access_log;
DROP TABLE IF EXISTS apps;

CREATE TABLE apps (
  id int  identity(1,1) NOT NULL ,
  app_name nvarchar(20) NOT NULL DEFAULT '',
  url nvarchar(255) NOT NULL DEFAULT '',
  country nvarchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
)
CREATE TABLE access_log (
  aid int  identity(1,1) NOT NULL ,
  site_id int NOT NULL DEFAULT '0',
  count int NOT NULL DEFAULT '0',
  date date NOT NULL,
  PRIMARY KEY (aid)
) 
CREATE TABLE websites (
  id int identity(1,1) NOT NULL ,
  name nvarchar(20) NOT NULL DEFAULT '' ,
  url nvarchar(255) NOT NULL DEFAULT '',
  alexa int NOT NULL DEFAULT '0' ,
  country nvarchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) 

INSERT INTO websites VALUES ( 'Google', 'https://www.google.cm/', '1', 'USA'), ( '淘宝', 'https://www.taobao.com/', '13', 'CN'), ( '菜鸟教程', 'http://www.runoob.com/', '4689', 'CN'), ( '微博', 'http://weibo.com/', '20', 'CN'), ( 'Facebook', 'https://www.facebook.com/', '3', 'USA');
INSERT INTO access_log VALUES ( '1', '45', '2016-05-10'), ( '3', '100', '2016-05-13'), ( '1', '230', '2016-05-14'), ( '2', '10', '2016-05-14'), ( '5', '205', '2016-05-14'), ( '4', '13', '2016-05-15'), ( '3', '220', '2016-05-15'), ('5', '545', '2016-05-16'), ( '3', '201', '2016-05-17');
INSERT INTO apps VALUES ( 'QQ APP', 'http://im.qq.com/', 'CN'), ( '微博 APP', 'http://weibo.com/', 'CN'), ( '淘宝 APP', 'https://www.taobao.com/', 'CN');

select * from websites;
select * from apps;
select * from access_log;

/*
INNER JOIN：如果表中有至少一个匹配，则返回行
LEFT JOIN：即使右表中没有匹配，也从左表返回所有的行
RIGHT JOIN：即使左表中没有匹配，也从右表返回所有的行
FULL JOIN：只要其中一个表中存在匹配，则返回行
*/
SELECT Websites.id, Websites.name, access_log.count, access_log.date
FROM Websites
INNER JOIN access_log
ON Websites.id=access_log.site_id;

--LEFT JOIN：即使右表中没有匹配，也从左表返回所有的行;把 Websites 作为左表，access_log 作为右表：
SELECT Websites.name, access_log.count, access_log.date
FROM Websites
LEFT JOIN access_log
ON Websites.id=access_log.site_id
ORDER BY access_log.count DESC;

--RIGHT JOIN：即使左表中没有匹配，也从右表返回所有的行;把 access_log 作为左表，Websites 作为右表：
SELECT Websites.name, access_log.count, access_log.date
FROM access_log
RIGHT JOIN Websites
ON access_log.site_id=Websites.id
ORDER BY access_log.count DESC;

--FULL OUTER JOIN 关键字返回左表（Websites）和右表（access_log）中所有的行。如果 "Websites" 表中的行在 "access_log" 中没有匹配或者 "access_log" 表中的行在 "Websites" 表中没有匹配，也会列出这些行。
SELECT Websites.name, access_log.count, access_log.date
FROM Websites
FULL OUTER JOIN access_log
ON Websites.id=access_log.site_id
ORDER BY access_log.count DESC;

SELECT *
INTO WebsitesBackup2017
FROM Websites;

INSERT INTO Websites (name, country)
SELECT app_name, country FROM apps
WHERE id=1;

SELECT websites.name, SUM(access_log.count) AS nums FROM (access_log
INNER JOIN websites
ON access_log.site_id=websites.id)
GROUP BY websites.name
HAVING SUM(access_log.count) > 200;

SELECT Websites.name, SUM(access_log.count) AS nums FROM Websites
INNER JOIN access_log
ON Websites.id=access_log.site_id
WHERE Websites.alexa < 200 
GROUP BY Websites.name
HAVING SUM(access_log.count) > 200;