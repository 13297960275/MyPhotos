using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MyPhotos.Common
{
    //通过Session 变量来识别用户身份，非管理员用户登录时，隐藏AddNew链接
    //但是这样还不够，如果非管理员用户直接输入AddNew URL，则会直接跳转到对应页面。
    //为此，引入MVC action 过滤器。Action 过滤器使得在action方法中添加一些预处理和
    //后处理的逻辑判断问题。在整个实验中，会注重ActionFilters预处理的支持和后处理的功能。
    //继承 ActionFilterAttribute
    public class AdminFilter : ActionFilterAttribute
    {
        //重写 OnActionExecuting方法
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (!Convert.ToBoolean(filterContext.HttpContext.Session["IsAdmin"]))
            {
                filterContext.Result = new ContentResult()
                {
                    Content = "Unauthorized to access specified resource."
                };
            }
        }
        //      可以通过浏览器直接调用GetAddNewLink方法吗？
        // 可以直接调用，也可直接停止”GetAddNewLink“的运行。

        //      Html.Action有什么作用？
        //与Html.RenderAction作用相同，Html.Action会执行action 方法，并在View中显示结果。
        //语法：
        //    @Html.Action("GetAddNewLink");

        //      Html.RenderAction 和 Html.Action两者之间有什么不同？更推荐使用哪种方法？
        //Html.RenderAction会将Action 方法的执行结果直接写入HTTP 响应请求流中，
        //而 Html.Action会返回MVCHTMLString。更推荐使用Html.RenderAction，因为它更快。
        //当我们想在显示前修改action执行的结果时，推荐使用Html.Action。

        //      什么是 ActionFilter ?
        //与AuthorizationFilter类似，ActionFilter是ASP.NET MVC过滤器中的一种，
        //允许在action 方法中添加预处理和后处理逻辑。
    }
}