using System.Runtime.CompilerServices;

namespace SALuminousWeb.DTOs
{
    public class UserLoginDto
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Firstname { get; set; }
        public string Surname { get; set; }
        public bool IsAdmin { get; set; }
    }
}