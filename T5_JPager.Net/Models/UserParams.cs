
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace T5_JPager.Net.Models
{
    public class UserParams : JPager.Net.PagerInBase
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? Age { get; set; }
        public int Score { get; set; }
        public string Address { get; set; }
        public DateTime AddTime { get; set; }
    }
}
