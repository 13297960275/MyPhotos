using MvcAjax.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MvcAjax.Controllers
{
    public class TestController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Person(int? id)
        {
            //could add code here to get model based on id....
            return PartialView("_Person", id);
            //calling partial with existing model....
            //return PartialView("_Person", model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Person(PersonValidationViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var errors = GetErrorsFromModelState();
                return Json(new { success = false, errors = errors });
                //return PartialView("_Person", model);
            }

            //save to persistent store;
            //return data back to post OR do a normal MVC Redirect....
            return Json(new { success = true });  //perhaps you want to do more on return.... otherwise this if block is not necessary....
            //return RedirectToAction("Index");
        }

        private object GetErrorsFromModelState()
        {
            //throw new NotImplementedException();
            return "出错了";
        }
    }
}