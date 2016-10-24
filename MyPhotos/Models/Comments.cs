using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyPhotos.Models
{
    public class Comments
    {
        /// <summary>
        /// 评论ID
        /// </summary>
        [Key]
        [Display(Name = "评论ID")]
        public int _cid { get; set; }

        /// <summary>
        /// 图片ID
        /// </summary>
        [Display(Name = "图片ID")]
        [ForeignKey("Photos")]
        public int _cphotoid { get; set; }

        /// <summary>
        /// 用户名
        /// </summary>
        [Display(Name = "用户名")]
        public string _cusername { get; set; }

        /// <summary>
        /// 评论内容
        /// </summary>
        [Display(Name = "评论内容")]
        public string _ctext { get; set; }

        /// <summary>
        /// 评论时间
        /// </summary>
        [Display(Name = "评论时间")]
        public DateTime? _ctime { get; set; }

        /// <summary>
        /// 顶
        /// </summary>
        [Display(Name = "顶")]
        public int? _cup { get; set; }

        /// <summary>
        /// 踩
        /// </summary>
        [Display(Name = "踩")]
        public int? _cdown { get; set; }


        public virtual Photos Photos { get; set; }
    }
}

