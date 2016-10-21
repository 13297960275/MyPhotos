using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyPhotos.Models
{
    public class Comments
    {
        [Key]
        public int _cid { get; set; }

        [ForeignKey("Photos")]
        public int _cphotoid { get; set; }

        public string _cusername { get; set; }

        public string _ctext { get; set; }

        public DateTime? _ctime { get; set; }

        public int? _cup { get; set; }

        public int? _cdown { get; set; }


        public virtual Photos Photos { get; set; }
    }
}

