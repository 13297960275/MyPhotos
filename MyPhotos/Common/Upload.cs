using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MyPhotos.Common
{
    public static class Upload
    {
        /// <summary>
        /// 查看文件是否被上传
        /// </summary>
        /// <param name="file">HttpPostedFileBase 上传的文件</param>
        /// <returns></returns>
        public static bool HasFile(this HttpPostedFileBase file)
        {
            return (file != null && file.ContentLength > 0) ? true : false;
        }

    }
}