<%@ WebHandler Language="C#" Class="wm" %>

using System;
using System.Web;
using System.Drawing;
using MyPhotos.Common;
public class wm : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "image/jpeg";

        string s = context.Request.QueryString["u"];//页面传值的待处理图片名称
        string imgPath = context.Request.MapPath("~/Images/" + s);//待处理图片路径

        //string s3 = context.Request.QueryString["a"];//页面传值的水印图片添加的位置
        //int logoAddress = int.Parse(s3);//添加水印图片的位置

        string logoPath = context.Request.MapPath("~/Images/Referances/rabit.png");//LOGO路径
        string s1 = context.Request.QueryString["w"];//页面传值的LOGO宽度
        string s2 = context.Request.QueryString["h"];//页面传值的LOGO高度
        int logoWidth = int.Parse(s1);//水印图片宽度
        int logoWeight = int.Parse(s2);//水印图片高度

        Thumbnail thb = new Thumbnail();
        Image scaleimg = thb.GetScaleImage(logoWidth, logoWeight, logoPath);//对元水印图片进行缩放

        using (Image img = Image.FromFile(imgPath))
        {
            using (scaleimg)
            {

                //switch (logoAddress)
                //{
                //    case 1: int x = 0; int y = 0; break;
                //    case 2: int x = 0; int y = 0; break;
                //    case 3: int x = 0; int y = 0; break;
                //    case 4: int x = 0; int y = 0; break;
                //    case 5: int x = 0; int y = 0; break;
                //    default: int x = 0; int y = 0; break;
                //}
                //int x = img.Width - logo.Width;
                //int y = img.Height - scaleimg.Height;
                int x = 0;
                int y = img.Height - scaleimg.Height;
                using (Graphics g = Graphics.FromImage(img))
                {
                    g.DrawImage(scaleimg, x, y, scaleimg.Width, scaleimg.Height);
                    img.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                }
            }
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