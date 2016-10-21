using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyPhotos.Models
{
    /// <summary>
    /// 图片模型
    /// </summary>
    public class Photos
    {
        /// <summary>
        /// 图片ID
        /// </summary>
        [Key]
        [Display(Name = "图片ID")]
        public int _pid { get; set; }

        /// <summary>
        /// 图片类型ID
        /// </summary>
        [ForeignKey("PhotoTypes")]
        [Display(Name = "图片类型ID")]
        public int _ptypeid { get; set; }

        /// <summary>
        /// 标题
        /// </summary>
        [Display(Name = "标题")]
        public string _ptitle { get; set; }

        /// <summary>
        /// 路径
        /// </summary>
        [Display(Name = "路径")]
        public string _purl { get; set; }

        /// <summary>
        /// 图片XX
        /// </summary>
        [Display(Name = "图片XX")]
        public string _pdes { get; set; }

        /// <summary>
        /// 点击率
        /// </summary>
        [Display(Name = "点击率")]
        public int? _pclicks { get; set; }

        /// <summary>
        /// 时间
        /// </summary>
        [Display(Name = "时间")]
        public DateTime? _ptime { get; set; }

        /// <summary>
        /// 支持
        /// </summary>
        [Display(Name = "顶")]
        public int? _pup { get; set; }

        /// <summary>
        /// 反对
        /// </summary>
        [Display(Name = "踩")]
        public int? _pdown { get; set; }


        public virtual PhotoType PhotoTypes { get; set; }
    }
}

