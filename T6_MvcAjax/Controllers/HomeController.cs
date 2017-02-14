using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MvcAjax.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        /// <summary>  
        /// 获取系统时间 强制不缓存  
        /// </summary>  
        /// <returns></returns>  
        [OutputCache(NoStore = true, Duration = 0)]
        public ActionResult GetTime()
        {
            return Content(DateTime.Now.ToString());
        }

        [HttpPost]
        public ActionResult GetPostStr(FormCollection form)
        {
            string userName = form["username"];
            string userAge = form["userage"];
            return Content(userName + userAge);
        }

        /// <summary>  
        /// 删除用户  
        /// </summary>  
        /// <returns></returns>  
        [HttpPost]
        public ActionResult DeleteUser()
        {
            //省略操作部分  
            return JavaScript("alert('删除成功')");
        }

        public ActionResult ConfirmPass(int id)
        {
            //省略操作部分  
            return new HttpStatusCodeResult(System.Net.HttpStatusCode.OK);
        }

        /* 
         *  需安装Microsoft jQuery Unobtrusive Ajax 这个 NuGet 插件 
            AjaxOptions中还有其他可以指定的属性： 
            Confirm                 等效于javascript中的return confirm(msg)，在点击该链接时先提示需要确认的信息。 
            HttpMethod              指定使用Get或者是Post方式发送Http请求 
            InsertMode              指定使用何种方式在指定的元素更新数据，"InsertAfter", "InsertBefore", or "Replace" 默认为：Replace 
            LoadingElementDuration  Loading元素显示的时间 
            LoadingElementId        可以指定在Http请求期间显示的Loading元素 
            OnBegin                 在Http请求之前执行的javascript方法 
            OnComplete              在Http请求结束时执行的方法 
            OnFailure               在Http请求失败时执行的方法 
            OnSuccess               在Http请求成功时执行的方法 
            UpdateTargetId          Http请求更新的页面元素 
            Url Http请求的Url          
         */
    }
}