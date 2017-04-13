using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using JPager.Net;
using JPager.Net.Web.Models;
using System.IO;

namespace JPager.Net.Web.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index(UserParams param)
        {

            //每页显示的条数默认10
            //param.PageSize = 10;

            //保存搜索条件
            ViewBag.SearchName = param.Name;
            ViewBag.SearchAge = param.Age;

            //获取数据集合
            var list = PageContent();

            //根据条件检索
            var query = param.Name != null ?
              list.Where(t => t.Name.Contains(param.Name)).ToList() :
              list.ToList();

            //分页数据
            var data = query.Skip(param.Skip).Take(param.PageSize);

            //总页数
            var count = query.Count;

            var res = new PagerResult<User>
            {
                Code = 0,
                DataList = data,
                Total = count,
                PageSize = param.PageSize,
                PageIndex = param.PageIndex,
                RequestUrl = param.RequetUrl
            };
            return View(res);
        }

        //测试数据                        
        public List<User> PageContent()
        {
            var list = new List<User>();
            for (var t = 0; t < 10000; t++)
            {
                list.Add(new User
                {
                    Id = t,
                    Name = "Joye.net" + t.ToString(),
                    Age = t + 10,
                    Score = t,
                    Address = "http://yinrq.cnblogs.com/",
                    AddTime = DateTime.Now
                });
            }

            return list;
        }

        #region 上传和下载
        public static string FilePath = string.Empty;
        public static byte[] FileContent;

        /// <summary>
        /// 视图
        /// </summary>
        /// <returns></returns>
        public ActionResult UpFile()
        {
            return View();
        }

        /// <summary>
        /// submit
        /// </summary>
        [HttpPost]
        public void UpLoadPic()
        {
            SaveFileDirect();
            //SaveFileStream();
            Response.Redirect("Upfile");
        }

        /// <summary>
        /// ajaxSubmit
        /// </summary>
        [HttpPost]
        public void UpLoadPic1()
        {
            SaveFileDirect();
            //SaveFileStream();
            Response.Redirect("Upfile");
        }

        /// <summary>
        /// ajaxfileupload.js
        /// </summary>
        [HttpPost]
        public void UpLoadPic2()
        {
            //SaveFileDirect();
            SaveFileStream();
        }

        /// <summary>
        /// jquery.uploadify.js
        /// </summary>
        public void UpLoadPic3()
        {
            //SaveFileDirect();
            SaveFileStream();
        }

        /// <summary>
        /// FormData
        /// </summary>
        public void UpLoadPic4()
        {
            //SaveFileDirect();
            SaveFileStream();
        }

        /// <summary>
        /// 直接保存上传文件到指定目录
        /// </summary>
        public void SaveFileDirect()
        {
            // 获取文件
            var upfile = Request.Files[0];
            // 拼接保存路径
            string uppath = Server.MapPath("~/UpFile/") + Path.GetFileName(upfile.FileName);
            // 存入指定目录
            if (upfile.ContentLength > 0)
            {
                upfile.SaveAs(uppath);
            }

            FilePath = uppath;
            FileContent = null;
        }

        /// <summary>
        /// 通过二进制流保存文件，可以存入数据库
        /// </summary>
        public void SaveFileStream()
        {
            // 获取文件
            var upfile = Request.Files[0];
            // 拼接保存路径
            string uppath = Server.MapPath("~/UpFile/") + Path.GetFileName(upfile.FileName);
            // 读入文件流
            byte[] temp = new byte[upfile.InputStream.Length];
            upfile.InputStream.Read(temp, 0, (int)upfile.InputStream.Length);
            // 写到指定目录
            using (FileStream fs = new FileStream(uppath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.ReadWrite))
            {
                fs.Write(temp, 0, temp.Length);
            }
            FilePath = uppath;
            FileContent = temp;
        }

        /// <summary>
        /// FileContentResult方式下载
        /// </summary>
        /// <returns></returns>
        public FileResult GetFileByContent()
        {
            List<string> typeList = new List<string>() { ".png", ".jpg", ".jpeg" };
            string FileName = Path.GetFileName(FilePath);

            if (FileContent != null && FileContent.Length > 0)
            {
                if (typeList.Contains(Path.GetExtension(FileName)))
                {
                    return File(FileContent, "image/jpg");
                }
                // 存在fileDownLoad属性的FileResult以附件形式下载，默认会以内联方式打开
                return File(FileContent, "application/octet-stream", FileName);
            }
            return null;
        }

        /// <summary>
        /// FilePathResult方式下载
        /// </summary>
        /// <returns></returns>
        public FileResult GetFileByPath()
        {
            List<string> typeList = new List<string>() { ".png", ".jpg", ".jpeg" };
            string FileName = Path.GetFileName(FilePath);

            if (FileName != null)
            {
                if (typeList.Contains(Path.GetExtension(FileName)))
                {
                    return File(FilePath, "image/jpg");
                }
                // 存在fileDownLoad属性的FileResult以附件形式下载，默认会以内联方式打开
                return File(FilePath, "application/octet-stream", FileName);
            }
            return null;
        }
        #endregion
    }
}