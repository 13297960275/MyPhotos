using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using MyPhotos.Common;

namespace MyPhotos.App_Start
{
    /// <summary>
    /// WaterMaker 的摘要说明
    /// </summary>
    public class GlobalWaterMaker : IHttpHandler
    {

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "image/jpeg";
            //  RawUrl:  /images/01.jpg
            string imgPath = context.Request.MapPath(context.Request.RawUrl);
            string logoPath = context.Request.MapPath("Referances/rabit.png");//LOGO路径
            Thumbnail thb = new Thumbnail();
            try
            {
                using (Image img = Image.FromFile(imgPath))
                {
                    using (Image logo = thb.GetScaleImage(90, 90, logoPath))
                    {
                        using (Graphics g = Graphics.FromImage(img))
                        {
                            int x = 0;
                            int y = img.Height - logo.Height;
                            g.DrawImage(logo, x, y, logo.Width, logo.Height);
                            img.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

    }
}