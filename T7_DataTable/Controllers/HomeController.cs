﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using JQuery.DataTable.Models;
using System.Reflection;

namespace JQuery.DataTable.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetJsonCitys(int? secho)
        {
            var cityList = new List<Citys>();
            for (int i = 0; i < 100; i++)
            {
                cityList.Add(new Citys
                {
                    Id = i,
                    CityName = Guid.NewGuid().ToString(),
                    ZipCode = DateTime.Now.Millisecond
                });
            }

            var objs = new List<object>();
            foreach (var city in cityList)
            {
                objs.Add(GetPropertyList(city).ToArray());
            }
            return Json(new
            {
                sEcho = secho,
                iTotalRecords = cityList.Count(),
                aaData = objs
            }, JsonRequestBehavior.AllowGet);
        }

        private List<string> GetPropertyList(object obj)
        {
            var propertyList = new List<string>();
            var properties = obj.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public);
            foreach (var property in properties)
            {
                object o = property.GetValue(obj, null);
                propertyList.Add(o == null ? "" : o.ToString());
            }
            return propertyList;
        }
    }
}
