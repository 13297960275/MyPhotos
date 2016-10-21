using System.ComponentModel.DataAnnotations;

namespace MyPhotos.Models
{
    /// <summary>
    /// 角色
    /// </summary>
    public class Role
    {
        /// <summary>
        /// 角色ID
        /// </summary>
        [Key]
        public int RoleID { get; set; }

        /// <summary>
        /// 角色类型
        /// </summary>
        [Required(ErrorMessage = "必须输入{0}")]
        [StringLength(20, MinimumLength = 2, ErrorMessage = "{0}长度为{2}-{1}个字符")]
        [Display(Name = "角色类型")]
        public string RoleName { get; set; }

        /// <summary>
        /// 角色说明
        /// </summary>
        [StringLength(1000, ErrorMessage = "{0}必须少于{1}个字符")]
        [Display(Name = "角色说明")]
        public string RoleDescription { get; set; }

    }
}