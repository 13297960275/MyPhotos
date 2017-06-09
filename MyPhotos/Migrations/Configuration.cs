namespace MyPhotos.Migrations
{
    using Models;
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;

    internal sealed class Configuration : DbMigrationsConfiguration<MyPhotos.DAL.BaseDBContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(MyPhotos.DAL.BaseDBContext context)
        {
            //This method will be called after migrating to the latest version.

            //You can use the DbSet<T>.AddOrUpdate() helper extension method
            //to avoid creating duplicate seed data.E.g.

            context.PhotoTypes.AddOrUpdate(
                p => p._typeid,
                new PhotoType
                {
                    _typeid = 1,
                    _typename = "风景",
                    _typedes = "风景这边更好",
                    _tcover = "AddPhotos.png"
                },
                new PhotoType
                {
                    _typeid = 2,
                    _typename = "美女",
                    _typedes = "窈窕淑女",
                    _tcover = "AddPhotos.png"
                },
                new PhotoType
                {
                    _typeid = 3,
                    _typename = "自拍",
                    _typedes = "自恋的小凳子",
                    _tcover = "AddPhotos.png"
                }
            );
            context.Roles.AddOrUpdate(
                r => r.RoleID,
                new Role
                {
                    RoleID = 1,
                    RoleName = "注册用户",
                    RoleDescription = "普通权限"
                },
                new Role
                {
                    RoleID = 2,
                    RoleName = "管理员",
                    RoleDescription = "管理员权限"
                },
                new Role
                {
                    RoleID = 3,
                    RoleName = "超级管理员",
                    RoleDescription = "最高权限"
                }
            );
        }
    }
}
