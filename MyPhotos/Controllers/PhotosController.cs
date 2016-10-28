using JPager.Net;
using MyPhotos.DAL;
using MyPhotos.Models;
using System;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace MyPhotos.Controllers
{
    public class PhotosController : Controller
    {
        private BaseDBContext db = new BaseDBContext();

        /// <summary>
        /// 分页显示图片列表
        /// </summary>
        /// <param name="param">继承了PagerInBase的Photos</param>
        /// <returns></returns>
        public ActionResult PagerIndex(PhotosParams param)
        {
            //每页显示的条数默认10
            param.PageSize = 12;

            //保存搜索条件
            //ViewBag.SearchUserName = param.UserName;
            //ViewBag.SearchRegisterTime = param.RegistrationTime;
            //ViewBag.SearchRoleName = param.Roles.RoleName;

            //获取数据集合
            //var list = PageContent();
            var list = db.Photos.Include(u => u.PhotoTypes).ToList();
            //var list = new List<User>();

            //根据条件检索
            var query = param._purl
                != null ?
              list.Where(t => t._purl.Contains(param._purl)).ToList() :
              list.ToList();

            //分页数据
            var data = query.Skip(param.Skip).Take(param.PageSize);

            //总页数
            var count = query.Count;

            var res = new PagerResult<Photos>
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

        // GET: Photos
        public ActionResult Index()
        {
            var photos = db.Photos.Include(p => p.PhotoTypes);
            //ViewBag.url = HttpContext.Server.MapPath("");
            return View(photos.ToList());
        }

        // GET: Photos/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Photos photos = db.Photos.Find(id);
            if (photos == null)
            {
                return HttpNotFound();
            }
            return View(photos);
        }

        // GET: Photos/Create
        public ActionResult Create()
        {
            ViewBag._ptypeid = new SelectList(db.PhotoTypes, "_typeid", "_typename");
            return View();
        }

        // POST: Photos/Create
        // 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        // 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(HttpPostedFileBase uploadFile, [Bind(Include = "_pid,_ptypeid,_ptitle,_purl,_pdes,_ptime,_pclicks,_pdownload,_pup,_pdown")] Photos photos)
        {
            /*采用MD5识别相同文件，防止重复上传，实现方法在此处添加*/

            if (ModelState.IsValid)
            {
                if (uploadFile != null && uploadFile.ContentLength > 0)//判断是否存在文件
                {
                    if (uploadFile.ContentType == "image/jpeg")//判断是否是图片文件
                    {
                        string path = Server.MapPath("~/Images/");
                        string oldname = uploadFile.FileName;
                        string newname = Guid.NewGuid().ToString() + Path.GetExtension(oldname);
                        //string filetype = filedata.ContentType;
                        //int filesize = filedata.ContentLength;
                        uploadFile.SaveAs(Path.Combine(path, newname));
                        photos._purl = newname;
                        photos._pdownload = 0;
                        photos._pclicks = 0;
                        photos._pdown = 0;
                        photos._pup = 0;
                        photos._ptime = DateTime.Now;
                        db.Photos.Add(photos);
                        db.SaveChanges();
                        return RedirectToAction("Index");
                    }
                    HttpContext.Response.Write("请选择图片文件！");
                }
                HttpContext.Response.Write("请选择文件！");
            }
            ViewBag._ptypeid = new SelectList(db.PhotoTypes, "_typeid", "_typename", photos._ptypeid);
            return View(photos);
        }

        public ActionResult Upload()
        {
            //ViewBag._ptypeid = new SelectList(db.PhotoTypes, "_typeid", "_typename");
            return View();
        }

        [HttpPost]
        public ActionResult Upload(HttpPostedFileBase uploadFile/*, [Bind(Include = "_ptypeid")] Photos photos*/)
        {
            if (uploadFile != null && uploadFile.ContentLength > 0)
            {
                string path = Server.MapPath("~/Images/");
                string oldname = uploadFile.FileName;
                string newname = Guid.NewGuid().ToString() + Path.GetExtension(oldname);
                //string filetype = filedata.ContentType;
                //int filesize = filedata.ContentLength;
                uploadFile.SaveAs(Path.Combine(path, newname));
                return Content("成功");
            }
            return Content("失败");
        }

        // GET: Photos/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Photos photos = db.Photos.Find(id);
            if (photos == null)
            {
                return HttpNotFound();
            }
            ViewBag._ptypeid = new SelectList(db.PhotoTypes, "_typeid", "_typename", photos._ptypeid);
            return View(photos);
        }

        // POST: Photos/Edit/5
        // 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        // 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "_pid,_ptypeid,_ptitle,_purl,_pdes,_pclicks,_ptime,_pup,_pdown")] Photos photos)
        {
            if (ModelState.IsValid)
            {
                //photos._ptime = DateTime.Now;
                db.Entry(photos).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag._ptypeid = new SelectList(db.PhotoTypes, "_typeid", "_typename", photos._ptypeid);
            return View(photos);
        }

        // GET: Photos/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Photos photos = db.Photos.Find(id);
            if (photos == null)
            {
                return HttpNotFound();
            }
            return View(photos);
        }

        // POST: Photos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Photos photos = db.Photos.Find(id);
            db.Photos.Remove(photos);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        //public ActionResult test()
        //{
        //    return View();
        //}

        //public ActionResult Upload()
        //{
        //    return View();
        //}

        //[HttpPost]
        //public ActionResult Upload(HttpPostedFileBase Filedata)
        //{
        //    // 没有文件上传，直接返回
        //    if (Filedata == null || string.IsNullOrEmpty(Filedata.FileName) || Filedata.ContentLength == 0)
        //    {
        //        return HttpNotFound();
        //    }

        //    //获取文件完整文件名(包含绝对路径)
        //    //文件存放路径格式：/files/upload/{日期}/{md5}.{后缀名}
        //    //例如：/files/upload/20130913/43CA215D947F8C1F1DDFCED383C4D706.jpg
        //    //string fileMD5 = CommonFuncs.GetStreamMD5(Filedata.InputStream);
        //    string FileEextension = Path.GetExtension(Filedata.FileName);
        //    string uploadDate = DateTime.Now.ToString("yyyyMMdd");

        //    string imgType = Request["imgType"];
        //    string virtualPath = "/";
        //    if (imgType == "normal")
        //    {
        //        virtualPath = string.Format("~/Images/{0}{1}", uploadDate, /*fileMD5, */FileEextension);
        //    }
        //    else
        //    {
        //        virtualPath = string.Format("~/Images/{0}{1}", uploadDate, /*fileMD5,*/ FileEextension);
        //    }
        //    string fullFileName = this.Server.MapPath(virtualPath);

        //    //创建文件夹，保存文件
        //    string path = Path.GetDirectoryName(fullFileName);
        //    Directory.CreateDirectory(path);
        //    if (!System.IO.File.Exists(fullFileName))
        //    {
        //        Filedata.SaveAs(fullFileName);
        //    }

        //    var data = new { imgtype = imgType, imgpath = virtualPath.Remove(0, 1) };
        //    return Json(data, JsonRequestBehavior.AllowGet);
        //}

        //     /// <summary>
        //     /// 上传功能
        //     /// </summary>
        //     /// <param name="uploadedFile">从HttpPostedfileBase对象中获取文件信息，该对象包含上传的文件的基本信息如Filename属性，Contenttype属性，inputStream属性等内容，这些信息都可以用来验证服务器端接收的文件是否有错，也可以用来保存文件。</param>
        //     /// <returns></returns>
        //     [HttpPost]
        //     public JsonResult Upload(HttpPostedFileBase uploadedFile)
        //     {
        //         if (uploadedFile != null && uploadedFile.ContentLength > 0)
        //         {
        //             byte[] FileByteArray = new byte[uploadedFile.ContentLength];
        //             uploadedFile.InputStream.Read(FileByteArray, 0, uploadedFile.ContentLength);
        //             Attachment newAttchment = new Attachment();
        //             newAttchment.FileName = uploadedFile.FileName;
        //             newAttchment.FileType = uploadedFile.ContentType;
        //             newAttchment.FileContent = FileByteArray;
        //             OperationResult operationResult = attachmentManager.SaveAttachment(newAttchment);
        //             if (operationResult.Success)
        //             {
        //                 string HTMLString = CaptureHelper.RenderViewToString
        //                   ("_AttachmentItem", newAttchment, this.ControllerContext);
        //                 return Json(new
        //                 {
        //                     statusCode = 200,
        //                     status = operationResult.Message,
        //                     NewRow = HTMLString
        //                 }, JsonRequestBehavior.AllowGet);
        //             }
        //             else
        //             {
        //                 return Json(new
        //                 {
        //                     statusCode = 400,
        //                     status = operationResult.Message,
        //                     file = uploadedFile.FileName
        //                 }, JsonRequestBehavior.AllowGet);
        //             }
        //         }
        //         return Json(new
        //         {
        //             statusCode = 400,
        //             status = "Bad Request! Upload Failed",
        //             file = string.Empty
        //         }, JsonRequestBehavior.AllowGet);
        //     }

        //     public JsonResult UplodMultiple(HttpPostedFileBase[] uploadedFiles)
        //2:  dataString.append("uploadedFiles", selectedFiles[i]);
    }
}
