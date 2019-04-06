using SALuminousWeb.Database;

namespace SALuminousWeb.DTOs
{
    public class EditProductDTO
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public int CategoryId { get; set; }
        public bool IsCreating { get; set; }
        public bool Hidden { get; set; }
    }
}