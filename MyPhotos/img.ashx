<%@ WebHandler Language="C#" Class="img" %>

using System;
using System.Web;
using System.Drawing;
using MyPhotos.Common;
public class img : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            context.Response.ContentType = "image/jpeg";
            //文件的名字
            string s = context.Request.QueryString["u"];
            string path = context.Request.MapPath("~/Images/" + s);
            string s1 = context.Request.QueryString["w"];
            string s2 = context.Request.QueryString["h"];
            int width = int.Parse(s1);
            int height = int.Parse(s2);
            Thumbnail thb = new Thumbnail();
            //Image scaleimg = thb.GetScaleImage(width, height, path);
            Image thbimg = thb.GetThumbnail(width, height, path);
            thbimg.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            //scaleimg.Dispose();
            thbimg.Dispose();
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
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