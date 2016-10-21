using System;
using System.ComponentModel.DataAnnotations;

namespace MyPhotos.Models
{
    /// <summary>
    /// 图片类型模型
    /// </summary>
    public class PhotoType
    {
        /// <summary>
        /// 图片类型ID
        /// </summary>
        [Key]
        [Display(Name = "图片类型ID")]
        public int _typeid { get; set; }

        /// <summary>
        /// 类型名
        /// </summary>
        [Display(Name = "类型名")]
        public string _typename { get; set; }

        /// <summary>
        /// 类型XX1
        /// </summary>
        [Display(Name = "类型XX1")]
        public string _typedes { get; set; }

        /// <summary>
        /// 类型XX2
        /// </summary>
        [Display(Name = "类型XX2")]
        public string _tcover { get; set; }
    }
}

