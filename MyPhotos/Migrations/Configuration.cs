namespace MyPhotos.Migrations
{
    using System.Data.Entity.Migrations;

    internal sealed class Configuration : DbMigrationsConfiguration<MyPhotos.DAL.BaseDBContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true;
        }

        protected override void Seed(MyPhotos.DAL.BaseDBContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //context.Users.AddOrUpdate(
            //  p => p.UserName,
            //  new User { UserName = "Andrew Peters" },
            //  new User { UserName = "Brice Lambson" },
            //  new User { UserName = "Rowan Miller" }
            //);
            //
        }
    }
}
