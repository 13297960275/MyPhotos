using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Test.Utilities;

namespace Test.Controllers
{
    public class PhotosController : Controller
    {
        string warning = "";
        //string suoluepic = Skeletonize.Resizepic(savepath, ImageDealLib.ResizeType.XY, "/images/", ImageDealLib.ImageType.JPEG, 1280, 800, ImageDealLib.FileCache.Save, out warning);
        //string waterpic = Watermark.makewatermark(suoluepic, "/images/w.png", ImageDealLib.WaterType.Random, "/images/", ImageDealLib.ImageType.JPEG, ImageDealLib.FileCache.Save, out warning2);
        // GET: Photos
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Uploadfile()
        {
            //上传文件
            HttpPostedFileBase hp = Request.Files["pic"];

            string waring = ""; //上传警告信息

            string savepath = Utilities.Uploadfile.uploadbystream(hp.InputStream, "~/images/", out waring);

            return Content(savepath); //----返回给页面剪辑图片使用
        }

        [HttpPost]
        public ActionResult Crop(FormCollection collection)
        {
            int x1 = int.Parse(collection["x1"]);
            int y1 = int.Parse(collection["y1"]);
            int width = int.Parse(collection["width"]);
            int height = int.Parse(collection["height"]);
            string picpath = collection["picpath"];

            string warning = "";  //剪辑警告信息

            string d = Imgcrop.imgcrop(picpath, "~/images/", x1, y1, width, height, ImageDealLib.FileCache.Save, out warning);

            return Content(d);
        }
    }
}