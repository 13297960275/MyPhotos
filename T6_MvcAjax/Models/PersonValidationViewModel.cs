using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MvcAjax.Models
{
    public class PersonValidationViewModel
    {
        [Required]
        [StringLength(15, ErrorMessage = "{0} 必须至少包含 {2} 个字符。", MinimumLength = 4)]
        [Display(Name = "姓")]
        public string FirstName { set; get; }

        [Required]
        [StringLength(15, ErrorMessage = "{0} 必须至少包含 {2} 个字符。", MinimumLength = 4)]
        [Display(Name = "名")]
        public string LastName { set; get; }

        [Required]
        [Display(Name = "姓")]
        [DataType(DataType.DateTime)]
        public string BirthDate { set; get; }
    }
}