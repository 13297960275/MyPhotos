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
        /// 图片标题
        /// </summary>
        [Display(Name = "图片标题")]
        public string _ptitle { get; set; }

        /// <summary>
        /// 图片
        /// </summary>
        [Display(Name = "图片")]
        public string _purl { get; set; }

        /// <summary>
        /// 图片描述
        /// </summary>
        [Display(Name = "图片描述")]
        public string _pdes { get; set; }

        /// <summary>
        /// 点击率
        /// </summary>
        [Display(Name = "点击率")]
        public int? _pclicks { get; set; }

        /// <summary>
        /// 录入时间
        /// </summary>
        [Display(Name = "录入时间")]
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

