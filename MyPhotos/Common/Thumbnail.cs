using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System;
using System.Web;
namespace MyPhotos.Common
{
    public class Thumbnail
    {
        FileLogger log = new FileLogger();

        //生成指定大小的图片
        public Image GetThumbnail(int width, int height, string path)
        {
            try
            {
                Image img = GetScaleImage(width, height, path);
                //200*200
                Bitmap bitmap = new Bitmap(width, height);
                Graphics g = Graphics.FromImage(bitmap);
                g.DrawImage(img, 0, 0);
                //bitmap.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                img.Dispose();
                //log.LogMessage("生成指定大小的图片成功");
                return bitmap;
            }
            catch (Exception e)
            {
                //log.LogException(e);
                Console.WriteLine(e.Message);
                return null;
            }
        }

        //生成按比例缩放的图片
        public Image GetScaleImage(int width, int height, string path)
        {
            try
            {
                //原图
                Image img = Image.FromFile(path);
                //保持横纵比例
                if (img.Width < img.Height)
                {
                    height = width * img.Height / img.Width;
                }
                else
                {
                    height = height * img.Width / img.Height;
                }
                //缩略图
                Bitmap bitmap = new Bitmap(width, height);
                Graphics g = Graphics.FromImage(bitmap);
                g.DrawImage(img, 0, 0, bitmap.Width, bitmap.Height);
                img.Dispose();
                //log.LogMessage("生成按比例缩放的图片成功");
                return bitmap;
            }
            catch (Exception e)
            {
                //log.LogException(e);
                Console.WriteLine(e.Message);
                return null;
            }
        }

    }

}