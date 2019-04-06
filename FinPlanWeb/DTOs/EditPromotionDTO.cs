namespace SALuminousWeb.DTOs
{
    public class EditPromotionDTO
    {
        public string CodeId { get; set; }
        public int Rate { get; set; }
        public double Price { get; set; }
        public bool Hidden { get; set; }
        public bool IsCreating { get; set; }
    }
}