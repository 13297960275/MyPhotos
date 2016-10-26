
using System;
using System.Web;
using System.IO;
public class Upload : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        HttpResponse response = context.Response;
        HttpRequest request = context.Request;
        HttpServerUtility server = context.Server;
        context.Response.ContentType = "text/plain";
        HttpPostedFile httpPostedFile = request.Files["FileData"];
        string uploadpath = request["folder"] + "\\";// server.MapPath(request["folder"] + "\\"); 
        if (httpPostedFile != null)
        {
            CCNF.Plugin.Upload.Upload upload = new CCNF.Plugin.Upload.Upload();
            upload.SaveFolder = uploadpath;
            upload.PicSize = new int[,] { { 200, 150 } };//生成缩略图，要生成哪些尺寸规格的缩略图，请自行定义二维数组 
            int result = upload.SaveAs(httpPostedFile);
            if (result == 1)
            {
                context.Response.Write("1");
            }
            else
            {
                throw new Exception(upload.Error(result));
                // context.Response.Write("0"); 
            }
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
