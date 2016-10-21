using MyPhotos.Migrations;
using MyPhotos.Models;
using System.Data.Entity;

namespace MyPhotos.DAL
{
    public class BaseDBContext : DbContext
    {
        /// <summary>
        /// 当应用程序运行时，先检查所面向的数据库是否是最新的；如果不是，便会应用所有挂起的迁移。
        /// </summary>
        static void MigrateDBToLatestVersion()
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<BaseDBContext, Configuration>());
        }

        public DbSet<Comments> Comments { get; set; }

        public DbSet<Photos> Photos { get; set; }

        public DbSet<PhotoType> PhotoTypes { get; set; }

        public DbSet<User> Users { get; set; }

        public DbSet<Role> Roles { get; set; }
    }

    //public class MigrateDBToLatestVersion
    //{
    //    static MigrateDBToLatestVersion()
    //    {
    //        Database.SetInitializer(new MigrateDatabaseToLatestVersion<BaseDBContext, Configuration>());
    //    }
    //}
}