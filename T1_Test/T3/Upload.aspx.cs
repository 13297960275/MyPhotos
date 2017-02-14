using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test.T3
{
    public partial class Upload : System.Web.UI.Page
    {
        //文件处理
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpPostedFile file = Request.Files["filedata"];
            string uploadpath = Server.MapPath("~/Upload/");
            if (file != null)
            {
                if (!Directory.Exists(uploadpath))
                {
                    Directory.CreateDirectory(uploadpath);
                }

                file.SaveAs(uploadpath + file.FileName);
            }
        }

    }
}