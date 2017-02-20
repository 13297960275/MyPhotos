using System.Web;
using System.Web.Mvc;
using System.Web.WebPages;
using Mvc.JQuery.DataTables;

[assembly: PreApplicationStartMethod(typeof(T7_DataTables.RegisterDataTablesModelBinder), "Start")]

namespace T7_DataTables
{
    public static class RegisterDataTablesModelBinder
    {
        public static void Start()
        {
            if (!ModelBinders.Binders.ContainsKey(typeof(DataTablesParam)))
                ModelBinders.Binders.Add(typeof(DataTablesParam), new DataTablesModelBinder());
        }
    }
}
