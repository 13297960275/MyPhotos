namespace MyPhotos.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class photosMD5 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Photos", "MD5", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Photos", "MD5");
        }
    }
}
