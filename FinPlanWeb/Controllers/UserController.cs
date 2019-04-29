using Helper;
using SALuminousWeb.Database;
using SALuminousWeb.Models;
using System;
using System.Web.Mvc;


namespace SALuminousWeb.Controllers
{
  public class UserController : BaseController
  {
    [HttpGet]
    public ActionResult Registration()
    {
      return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public ActionResult Registration([Bind(Exclude = "IsEmailVerified,ActivationCode")] UserData user)
    {
      bool status = false;
      string message = "";

      if(ModelState.IsValid)
      {
        // Validate if the email address is already existed.
        var emailExisted = IsEmailExist(user.Email);
        if(emailExisted)
        {
          ModelState.AddModelError("EmailExist", "Your Email Address is already in use");
          return View(user);
        }

        // Generate activation code
        var code = Guid.NewGuid().ToString("N");

        user.Password = PasswordHash.CreateHash(user.Password);
        user.ConfirmPassword = PasswordHash.CreateHash(user.ConfirmPassword);

        // This is always going to be false...
        user.IsEmailVerified = false;

        UserManagement.Add(user);
        

      }
      else
      {
        message = "Invalid Request";
      }


      //Password
      
      return View(user);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="email"></param>
    /// <returns></returns>
    [NonAction]
    public bool IsEmailExist(string email)
    {
      return UserManagement.ValidateEmail(email);
    }

  }
}
