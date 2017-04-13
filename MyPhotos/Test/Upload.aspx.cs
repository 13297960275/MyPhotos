using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyPhotos
{
    public partial class Upload : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region 文件上传
        /// <summary>
        /// 文件上传
        /// </summary>
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (FileUpload1.FileName == "")
            {
                Label1.Text = "上传文件不能为空";
                return;
            }

            bool fileIsValid = false;
            //如果确认了上传文件，则判断文件类型是否符合要求 
            if (FileUpload1.HasFile)
            {
                //获取上传文件的后缀 
                string fileExtension = Path.GetExtension(FileUpload1.FileName).ToLower();
                string[] restrictExtension = { ".gif", ".jpg", ".bmp", ".png" };
                //判断文件类型是否符合要求 
                for (int i = 0; i < restrictExtension.Length; i++)
                {
                    if (fileExtension == restrictExtension[i])
                    {
                        fileIsValid = true;
                    }
                    //如果文件类型符合要求,调用SaveAs方法实现上传,并显示相关信息 
                    if (fileIsValid == true)
                    {
                        //上传文件是否大于10M
                        if (FileUpload1.PostedFile.ContentLength > (10 * 1024 * 1024))
                        {
                            Label1.Text = "上传文件过大";
                            return;
                        }
                        try
                        {
                            Image1.ImageUrl = "File/" + FileUpload1.FileName;
                            FileUpload1.SaveAs(Server.MapPath("File/") + FileUpload1.FileName);
                            Label1.Text = "文件上传成功!";
                        }
                        catch
                        {
                            Label1.Text = "文件上传失败！";
                        }
                        finally
                        {

                        }
                    }
                    else
                    {
                        Label1.Text = "只能够上传后缀为.gif,.jpg,.bmp,.png的文件";
                    }
                }
            }
        }
        #endregion
    }
}