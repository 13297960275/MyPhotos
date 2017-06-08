using JPager.Net;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyPhotos.Models
{
    /// <summary>
    /// 用户分页模型
    /// </summary>
    public class UserParams : PagerInBase
    {
        /// <summary>
        /// 用户ID
        /// </summary>
        [Key]
        public int UserID { get; set; }

        /// <summary>
        /// 用户名
        /// </summary>
        [Required(ErrorMessage = "必填")]
        [StringLength(20, MinimumLength = 4, ErrorMessage = "{1}到{0}个字符")]
        [Display(Name = "用户名")]
        public string UserName { get; set; }

        /// <summary>
        /// 角色ID
        /// </summary>
        [ForeignKey("Roles")]
        [Display(Name = "角色ID")]
        public int RoleID { get; set; }

        /// <summary>
        /// 显示名
        /// </summary>
        [Required(ErrorMessage = "必填")]
        [StringLength(20, MinimumLength = 2, ErrorMessage = "{1}到{0}个字符")]
        [Display(Name = "显示名")]
        public string DisplayName { get; set; }

        /// <summary>
        /// 密码
        /// </summary>
        [Required(ErrorMessage = "必填")]
        [Display(Name = "密码")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
        [Required(ErrorMessage = "必填")]
        [Display(Name = "邮箱")]
        [DataType(DataType.EmailAddress, ErrorMessage = "邮箱格式不合法")]
        public string Email { get; set; }

        /// <summary>
        /// 用户状态<br />
        /// 0正常，1锁定，2未通过邮件验证，3未通过管理员
        /// </summary>
        [Display(Name = "用户状态")]
        public int Status { get; set; }

        /// <summary>
        /// 注册时间
        /// </summary>
        [Display(Name = "注册时间")]
        public DateTime? RegistrationTime { get; set; }

        /// <summary>
        /// 上次登陆时间
        /// </summary>
        [Display(Name = "上次登陆时间")]
        public DateTime? LoginTime { get; set; }

        /// <summary>
        /// 上次登陆IP
        /// </summary>
        [Display(Name = "上次登陆IP")]
        public string LoginIP { get; set; }


        public virtual Role Roles { get; set; }
    }

    /// <summary>
    /// 图片分页模型
    /// </summary>
    public class PhotosParams : PagerInBase
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
        /// 录入时间
        /// </summary>
        [Display(Name = "录入时间")]
        public DateTime? _ptime { get; set; }

        /// <summary>
        /// 点击率
        /// </summary>
        [Display(Name = "点击率")]
        public int? _pclicks { get; set; }

        /// <summary>
        /// 下载次数
        /// </summary>
        [Display(Name = "下载次数")]
        public int? _pdownload { get; set; }

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