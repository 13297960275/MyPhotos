using JPager.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using T5_JPager.Net.Models;

namespace T5_JPager.Net.Controllers
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

        public ActionResult PreViewing()
        {
            return View();
        }


    }
}