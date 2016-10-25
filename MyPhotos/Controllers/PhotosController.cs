using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MyPhotos.Models;
using MyPhotos.DAL;
using MyPhotos.Common;
using System.IO;

namespace MyPhotos.Controllers
{
    public class PhotosController : Controller
    {
        private BaseDBContext db = new BaseDBContext();

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
        public ActionResult Create([Bind(Include = "_pid,_ptypeid,_ptitle,_purl,_pdes,_pclicks,_ptime,_pup,_pdown")] Photos photos, HttpPostedFileBase filedata)
        {
            //foreach (string upload in Request.Files)
            //{
            //    if (!Request.Files[upload].HasFile()) continue;
            //    string path = AppDomain.CurrentDomain.BaseDirectory + "Images/";
            //    string filename = Path.GetFileName(Request.Files[upload].FileName);
            //    photos._purl = filename;
            //    Request.Files[upload].SaveAs(Path.Combine(path, filename));
            //}

            if ((filedata != null && filedata.ContentLength > 0))
            {
                string path = Server.MapPath("~/Images/");
                string oldname = filedata.FileName;
                string newname = Guid.NewGuid().ToString() + Path.GetExtension(oldname);
                //string filetype = filedata.ContentType;
                //int filesize = filedata.ContentLength;
                filedata.SaveAs(Path.Combine(path, newname));
                photos._purl = newname;
            }
            if (ModelState.IsValid)
            {
                photos._pclicks = 0;
                photos._pdown = 0;
                photos._pup = 0;
                photos._ptime = DateTime.Now;
                db.Photos.Add(photos);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag._ptypeid = new SelectList(db.PhotoTypes, "_typeid", "_typename", photos._ptypeid);
            return View(photos);
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
    }
}
