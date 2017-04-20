
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
namespace Test
{
    /// <summary>
    /// ApplicationCount 的摘要说明
    /// </summary>
    public class ApplicationCount : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");

            context.Response.Write("当前在线人数" + context.Application["count"].ToString());
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}