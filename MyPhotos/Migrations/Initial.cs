namespace MyPhotos.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Comments",
                c => new
                    {
                        _cid = c.Int(nullable: false, identity: true),
                        _cphotoid = c.Int(nullable: false),
                        _cusername = c.String(),
                        _ctext = c.String(),
                        _ctime = c.DateTime(),
                        _cup = c.Int(),
                        _cdown = c.Int(),
                    })
                .PrimaryKey(t => t._cid)
                .ForeignKey("dbo.Photos", t => t._cphotoid, cascadeDelete: true)
                .Index(t => t._cphotoid);
            
            CreateTable(
                "dbo.Photos",
                c => new
                    {
                        _pid = c.Int(nullable: false, identity: true),
                        _ptypeid = c.Int(nullable: false),
                        _ptitle = c.String(),
                        _purl = c.String(),
                        _pdes = c.String(),
                        _ptime = c.DateTime(),
                        _pclicks = c.Int(),
                        _pdownload = c.Int(),
                        _pup = c.Int(),
                        _pdown = c.Int(),
                    })
                .PrimaryKey(t => t._pid)
                .ForeignKey("dbo.PhotoTypes", t => t._ptypeid, cascadeDelete: true)
                .Index(t => t._ptypeid);
            
            CreateTable(
                "dbo.PhotoTypes",
                c => new
                    {
                        _typeid = c.Int(nullable: false, identity: true),
                        _typename = c.String(),
                        _typedes = c.String(),
                        _tcover = c.String(),
                    })
                .PrimaryKey(t => t._typeid);
            
            CreateTable(
                "dbo.Roles",
                c => new
                    {
                        RoleID = c.Int(nullable: false, identity: true),
                        RoleName = c.String(nullable: false, maxLength: 20),
                        RoleDescription = c.String(maxLength: 1000),
                    })
                .PrimaryKey(t => t.RoleID);
            
            CreateTable(
                "dbo.Users",
                c => new
                    {
                        UserID = c.Int(nullable: false, identity: true),
                        UserName = c.String(nullable: false, maxLength: 20),
                        RoleID = c.Int(nullable: false),
                        DisplayName = c.String(nullable: false, maxLength: 20),
                        Password = c.String(nullable: false),
                        Email = c.String(nullable: false),
                        Status = c.Int(nullable: false),
                        RegistrationTime = c.DateTime(),
                        LoginTime = c.DateTime(),
                        LoginIP = c.String(),
                    })
                .PrimaryKey(t => t.UserID)
                .ForeignKey("dbo.Roles", t => t.RoleID, cascadeDelete: true)
                .Index(t => t.RoleID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Users", "RoleID", "dbo.Roles");
            DropForeignKey("dbo.Comments", "_cphotoid", "dbo.Photos");
            DropForeignKey("dbo.Photos", "_ptypeid", "dbo.PhotoTypes");
            DropIndex("dbo.Users", new[] { "RoleID" });
            DropIndex("dbo.Photos", new[] { "_ptypeid" });
            DropIndex("dbo.Comments", new[] { "_cphotoid" });
            DropTable("dbo.Users");
            DropTable("dbo.Roles");
            DropTable("dbo.PhotoTypes");
            DropTable("dbo.Photos");
            DropTable("dbo.Comments");
        }
    }
}
