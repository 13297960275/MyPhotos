using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web.Mvc;
using MyPhotos.Models;
using MyPhotos.DAL;

namespace MyPhotos.Controllers
{
    public class PhotoTypesController : Controller
    {
        private BaseDBContext db = new BaseDBContext();

        // GET: PhotoTypes
        public ActionResult Index()
        {
            return View(db.PhotoTypes.ToList());
        }

        // GET: PhotoTypes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhotoType photoType = db.PhotoTypes.Find(id);
            if (photoType == null)
            {
                return HttpNotFound();
            }
            return View(photoType);
        }

        // GET: PhotoTypes/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: PhotoTypes/Create
        // 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        // 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "_typeid,_typename,_typedes,_tcover")] PhotoType photoType)
        {
            if (ModelState.IsValid)
            {
                db.PhotoTypes.Add(photoType);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(photoType);
        }

        // GET: PhotoTypes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhotoType photoType = db.PhotoTypes.Find(id);
            if (photoType == null)
            {
                return HttpNotFound();
            }
            return View(photoType);
        }

        // POST: PhotoTypes/Edit/5
        // 为了防止“过多发布”攻击，请启用要绑定到的特定属性，有关 
        // 详细信息，请参阅 http://go.microsoft.com/fwlink/?LinkId=317598。
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "_typeid,_typename,_typedes,_tcover")] PhotoType photoType)
        {
            if (ModelState.IsValid)
            {
                db.Entry(photoType).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(photoType);
        }

        // GET: PhotoTypes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhotoType photoType = db.PhotoTypes.Find(id);
            if (photoType == null)
            {
                return HttpNotFound();
            }
            return View(photoType);
        }

        // POST: PhotoTypes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            PhotoType photoType = db.PhotoTypes.Find(id);
            db.PhotoTypes.Remove(photoType);
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
