using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FinPlanWeb.DTOs
{
    public class ProductDTO
    {
        public int ProductId { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public string DateAdded { get; set; }
        public string LastModifiedDate { get; set; }
        public decimal Price { get; set; }
        public string Category { get; set; }
    }
}