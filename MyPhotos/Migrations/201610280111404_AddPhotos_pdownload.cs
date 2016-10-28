namespace MyPhotos.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPhotos_pdownload : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Photos", "_pdownload", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Photos", "_pdownload");
        }
    }
}
