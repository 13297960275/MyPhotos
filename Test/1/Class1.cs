
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
namespace CCNF.Plugin.Upload
{
    /// <summary> 
    /// 上传功能的接口 
    /// </summary> 
    /// <creator>Marc</creator> 
    public interface IUpload
    {
        /// <summary> 
        /// 上传单个文件。 
        /// </summary> 
        /// <param name="sourcefile"></param> 
        /// <returns></returns> 
        /// <author>Marc</author> 
        int SaveAs(HttpPostedFile sourcefile);
    }
}