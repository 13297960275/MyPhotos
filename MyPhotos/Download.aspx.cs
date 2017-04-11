using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test.T3
{
    public partial class Download : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        { }

        protected void Button1_Click(object sender, EventArgs e)
        {
            /*
            微软为Response对象提供了一个新的方法TransmitFile来解决使用Response.BinaryWrite
            下载超过400mb的文件时导致Aspnet_wp.exe进程回收而无法成功下载的问题。
            代码如下：
            */
            Response.ContentType = "application/x-zip-compressed";
            Response.AddHeader("Content-Disposition", "attachment;filename=Tulips.jpg");
            string filename = Server.MapPath("Images/" + "fe5dde79-32fc-48ed-bafa-7d7bcb9097bf.jpg");
            Response.TransmitFile(filename);
        }

        //WriteFile实现下载
        protected void Button2_Click(object sender, EventArgs e)
        {
            //using System.IO;
            string fileName = "fe5dde79-32fc-48ed-bafa-7d7bcb9097bf.jpg";//客户端保存的文件名
            string filePath = Server.MapPath("Images/" + fileName);//路径
            FileInfo fileInfo = new FileInfo(filePath);
            Response.Clear();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
            Response.AddHeader("Content-Length", fileInfo.Length.ToString());
            Response.AddHeader("Content-Transfer-Encoding", "binary");
            Response.ContentType = "application/octet-stream";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");
            Response.WriteFile(fileInfo.FullName);
            Response.Flush();
            Response.End();
        }

        //WriteFile分块下载
        protected void Button3_Click(object sender, EventArgs e)
        {
            string fileName = "fe5dde79-32fc-48ed-bafa-7d7bcb9097bf.jpg";//客户端保存的文件名
            string filePath = Server.MapPath("/Images/" + fileName);//路径
            System.IO.FileInfo fileInfo = new System.IO.FileInfo(filePath);
            if (fileInfo.Exists == true)
            {
                const long ChunkSize = 102400;//100K 每次读取文件，只读取100Ｋ，这样可以缓解服务器的压力
                byte[] buffer = new byte[ChunkSize];
                Response.Clear();
                System.IO.FileStream iStream = System.IO.File.OpenRead(filePath);
                long dataLengthToRead = iStream.Length;//获取下载的文件总大小
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(fileName));
                while (dataLengthToRead > 0 && Response.IsClientConnected)
                {
                    int lengthRead = iStream.Read(buffer, 0, Convert.ToInt32(ChunkSize));//读取的大小
                    Response.OutputStream.Write(buffer, 0, lengthRead);
                    Response.Flush();
                    dataLengthToRead = dataLengthToRead - lengthRead;
                }
                Response.Close();
            }
            else Response.Write("<script>alert('您所选择的文件不存在');</script>");
        }

        //流方式下载
        protected void Button4_Click(object sender, EventArgs e)
        {
            string fileName = "fe5dde79-32fc-48ed-bafa-7d7bcb9097bf.jpg";//客户端保存的文件名
            string filePath = Server.MapPath("Images/" + fileName);//路径
            //以字符流的形式下载文件
            FileStream fs = new FileStream(filePath, FileMode.Open);
            byte[] bytes = new byte[(int)fs.Length];
            fs.Read(bytes, 0, bytes.Length);
            fs.Close();
            Response.ContentType = "application/octet-stream";
            //通知浏览器下载文件而不是打开
            Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }
    }
}