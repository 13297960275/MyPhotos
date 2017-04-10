using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
namespace Test.Utilities
{
    public class DownLoad
    {
        protected void TransmitFiles(object sender, EventArgs e)
        {
            /*
            微软为HttpContext.Current.Response对象提供了一个新的方法TransmitFile来解决使用HttpContext.Current.Response.BinaryWrite
            下载超过400mb的文件时导致Aspnet_wp.exe进程回收而无法成功下载的问题。
            代码如下：
            */
            HttpContext.Current.Response.ContentType = "application/x-zip-compressed";
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=z.zip");
            string filename = HttpContext.Current.Server.MapPath("DownLoad/aaa.zip");
            HttpContext.Current.Response.TransmitFile(filename);
        }
        //WriteFile实现下载
        protected void Button2_Click(object sender, EventArgs e)
        {
            /*
            using System.IO;
            */
            string fileName = "aaa.zip";//客户端保存的文件名
            string filePath = HttpContext.Current.Server.MapPath("DownLoad/aaa.zip");//路径
            FileInfo fileInfo = new FileInfo(filePath);
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
            HttpContext.Current.Response.AddHeader("Content-Length", fileInfo.Length.ToString());
            HttpContext.Current.Response.AddHeader("Content-Transfer-Encoding", "binary");
            HttpContext.Current.Response.ContentType = "application/octet-stream";
            HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
            HttpContext.Current.Response.WriteFile(fileInfo.FullName);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.End();
        }
        //WriteFile分块下载
        protected void Button3_Click(object sender, EventArgs e)
        {
            string fileName = "aaa.zip";//客户端保存的文件名
            string filePath = HttpContext.Current.Server.MapPath("DownLoad/aaa.zip");//路径
            System.IO.FileInfo fileInfo = new System.IO.FileInfo(filePath);
            if (fileInfo.Exists == true)
            {
                const long ChunkSize = 102400;//100K 每次读取文件，只读取100Ｋ，这样可以缓解服务器的压力
                byte[] buffer = new byte[ChunkSize];
                HttpContext.Current.Response.Clear();
                System.IO.FileStream iStream = System.IO.File.OpenRead(filePath);
                long dataLengthToRead = iStream.Length;//获取下载的文件总大小
                HttpContext.Current.Response.ContentType = "application/octet-stream";
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(fileName));
                while (dataLengthToRead > 0 && HttpContext.Current.Response.IsClientConnected)
                {
                    int lengthRead = iStream.Read(buffer, 0, Convert.ToInt32(ChunkSize));//读取的大小
                    HttpContext.Current.Response.OutputStream.Write(buffer, 0, lengthRead);
                    HttpContext.Current.Response.Flush();
                    dataLengthToRead = dataLengthToRead - lengthRead;
                }
                HttpContext.Current.Response.Close();
            }
        }
        //流方式下载
        protected void Button4_Click(object sender, EventArgs e)
        {
            string fileName = "aaa.zip";//客户端保存的文件名
            string filePath = HttpContext.Current.Server.MapPath("DownLoad/aaa.zip");//路径
                                                                                     //以字符流的形式下载文件
            FileStream fs = new FileStream(filePath, FileMode.Open);
            byte[] bytes = new byte[(int)fs.Length];
            fs.Read(bytes, 0, bytes.Length);
            fs.Close();
            HttpContext.Current.Response.ContentType = "application/octet-stream";
            //通知浏览器下载文件而不是打开
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));
            HttpContext.Current.Response.BinaryWrite(bytes);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.End();
        }
    }
}