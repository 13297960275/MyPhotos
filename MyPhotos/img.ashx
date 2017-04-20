<%@ WebHandler Language="C#" Class="img" %>

using System;
using System.Web;
using System.Drawing;
public class img : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "image/jpeg";

        //文件的名字
        //string s = context.Request.QueryString["u"];
        //string path = context.Request.MapPath("images/" + s);
        string path = context.Request.MapPath("circle.gif");
        string s1 = context.Request.QueryString["w"];
        string s2 = context.Request.QueryString["h"];

        //int width = int.Parse(s1);
        //int height = int.Parse(s2);

        int width = 275;
        int height = 170;

        //按比例缩放
        using (Image img = GetImg(width, height, path))
        {
            //200*200
            using (Bitmap bitmap = new Bitmap(width, height))
            {
                using (Graphics g = Graphics.FromImage(bitmap))
                {
                    g.DrawImage(img, 0, 0);
                    bitmap.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                }
            }
        }

    }


    Image GetImg(int width, int height, string path)
    {
        //原图
        using (Image img = Image.FromFile(path))
        {
            //保持横纵比例

            if (img.Width < img.Height)
            {
                height = width * img.Height / img.Width;
            }
            else
            {
                width = height * img.Width / img.Height;
            }


            //缩略图
            Bitmap bitmap = new Bitmap(width, height);
            using (Graphics g = Graphics.FromImage(bitmap))
            {
                g.DrawImage(img, 0, 0, bitmap.Width, bitmap.Height);
            }
            return bitmap;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}