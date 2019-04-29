using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Globalization;



namespace SALuminousWeb.Models
{
  
  public class UserData
  {
    private const string passregex = @"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";

    [Display(Name ="First Name")]
    [Required(AllowEmptyStrings = false, ErrorMessage = "First Name is required")]
    public string Firstname { get; set; }

    [Display(Name = "Last Name")]
    [Required(AllowEmptyStrings = false, ErrorMessage = "Last Name is required")]
    public string Surname { get; set; }

    [Display(Name = "Email Address")]
    [Required(AllowEmptyStrings = false, ErrorMessage = "Email is required")]
    [DataType(DataType.EmailAddress)]
    public string Email { get; set; }

    [Display(Name = "Date Of Birth")]
    [DataType(DataType.DateTime)]
    [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:MM/dd/yyyy}")]
    public DateTime DoB { get; set; }

    [Display(Name = "Password")]
    [Required(AllowEmptyStrings = false, ErrorMessage = "Password is required")]
    [DataType(DataType.Password)]
    [MinLength(8, ErrorMessage =("Minimum 8 characters"))]
    [RegularExpression(passregex, ErrorMessage = "Minimum eight characters, at least one letter, one number and one special character")]
    public string Password { get; set; }


    [Display(Name = "Confrim Password")]
    [DataType(DataType.Password)]
    [Compare("Password", ErrorMessage ="Your passowrd isn't matched!")]
    public string ConfirmPassword { get; set; }

    public bool IsEmailVerified { get; set; }

    public Guid ActivationCode { get; set; }




    /*
      [Required]
      [Display(Name = "Username")]
      public string Username { get; set; }

      [Required]
      [DataType(DataType.Password)]
      [Display(Name = "Password")]
      public string Password { get; set; }

      [Display(Name = "Remember this computer")]
      public bool RememberMe { get; set; }


      public string Role { get; set; }
      */
  }



}
   
