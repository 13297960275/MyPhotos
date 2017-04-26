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

            try
            {
                Thumbnail thb = new Thumbnail();
                //Image scaleimg = thb.GetScaleImage(90, 90, logoPath);
                Image scaleimg = thb.GetScaleImage(90, 90, logoPath);
                Image bmp = new Bitmap(scaleimg);
                scaleimg.Dispose();
                using (bmp)
                {
                    using (bmp)
                    {
                        int x = 0;
                        int y = bmp.Height - scaleimg.Height;
                        using (Graphics g = Graphics.FromImage(bmp))
                        {
                            g.DrawImage(scaleimg, x, y, scaleimg.Width, scaleimg.Height);
                            bmp.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
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