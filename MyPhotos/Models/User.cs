using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyPhotos.Models
{
    /// <summary>
    /// 用户模型
    /// </summary>
    public class User
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
}
