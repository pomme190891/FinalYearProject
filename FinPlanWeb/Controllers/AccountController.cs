using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using System.Web.Security;
using SALuminousWeb.Database;
using SALuminousWeb.DTOs;
using SALuminousWeb.Models;


namespace SALuminousWeb.Controllers
{
    public class AccountController : BaseController
    {
        private const int pageSize = 10;

        [HttpGet]
        public ActionResult LogIn()
        {
            var returnUrl = TempData["ReturnUrl"];
            if (returnUrl != null && !string.IsNullOrEmpty(returnUrl.ToString()))
            {
                TempData["ReturnUrl"] = returnUrl;
            }
            return View();
        }

        [CheckUserSession]
        public ActionResult AccountInfo()
        {
            var serializer = new JavaScriptSerializer();
            var user = PopulateUserInfo(serializer);

            var orders = OrderManagement.GetUserOrders(user.Id);
            var filteredOrders = ApplyPaging(orders, 1);
            var orderList = PopulateOrderList(filteredOrders, user);
            ViewBag.Orders = serializer.Serialize(orderList);
            ViewBag.TotalOrdersPage = (int)Math.Ceiling(((double)orders.Count() / (double)pageSize));
            ViewBag.OrderDetail = serializer.Serialize(new OrderDetailDTO());
            return View();
        }

        public ActionResult Paging(int num,int userId)
        {
            var orders = OrderManagement.GetUserOrders(userId);
            var filteredOrders = ApplyPaging(orders, 1);
            var user = UserManagement.GetUser(userId);
            var orderList = PopulateOrderList(filteredOrders, user);
            return Json(new { orderList }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="orders"></param>
        /// <param name="users"></param>
        /// <returns></returns>
        private static List<OrderDTO> PopulateOrderList(IEnumerable<OrderManagement.Order> orders, UserManagement.User user)
        {
            var orderList = new List<OrderDTO>();

            foreach (var order in orders)
            {
                orderList.Add(new OrderDTO
                {
                    Id = order.Id,
                    BuyerFirmName = user.FirmName,
                    BuyerUsername = user.UserName,
                    Currency = order.Currency,
                    PaymentType = order.PaymentType,
                    Name = user.FirstName + " " + user.SurName,
                    TransactionDate = order.DateCreated.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture)
                });
            }
            return orderList;
        }

        public IEnumerable<OrderManagement.Order> ApplyPaging(IEnumerable<OrderManagement.Order> orders, int num)
        {
            return orders.Skip((num - 1) * pageSize)
                .Take(pageSize);
        }

        private UserManagement.User PopulateUserInfo(JavaScriptSerializer serializer)
        {
            var userSession = Session["User"] as UserLoginDto;
            var user = UserManagement.GetUser(userSession.Id);

            ViewBag.UserInfo = serializer.Serialize(new EditUserInfoDTO
                {
                    Email = user.Email,
                    FirmName = user.FirmName,
                    FirstName = user.FirstName,
                    Surname = user.SurName,
                    UserId = user.Id
                });
            return user;
        }

        public ActionResult UpdatePassword(int userId, string newPassword)
        {
            var validationIds = new List<string>();
            var validationMessage = ValidatePassword(newPassword, out validationIds);
            if (!validationMessage.Any())
            {
                UserManagement.UpdateUserPassword(userId, newPassword);
            }

            return Json(new
            {
                passed = !validationMessage.Any(),
                validationIds,
                validationMessage = string.Join("</br>", validationMessage)
            });
        }

        public List<string> ValidateUserEdit(EditUserInfoDTO info, out List<string> invalidIds)
        {
            var validationMessage = new List<string>();
            var validationId = new List<string>();

            if (string.IsNullOrEmpty(info.FirstName))
            {
                validationMessage.Add("First Name is empty.");
                validationId.Add("Firstname");
            }

            if (string.IsNullOrEmpty(info.Surname))
            {
                validationMessage.Add("Surname is empty.");
                validationId.Add("Surname");
            }

            if (string.IsNullOrEmpty(info.FirmName))
            {
                validationMessage.Add("Firmname is empty.");
                validationId.Add("Firmname");
            }

            if (string.IsNullOrEmpty(info.Email))
            {
                validationMessage.Add("Email is empty.");
                validationId.Add("Email");
            }
            else
            {

                var regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
                var match = regex.Match(info.Email);
                if (!match.Success)
                {
                    validationMessage.Add("Invalid email format.");
                    validationId.Add("Email");
                }
            }
            invalidIds = validationId;
            return validationMessage;
        }

        public List<string> ValidatePassword(string newPassword, out List<string> invalidIds)
        {
            var validationMessage = new List<string>();
            var validationId = new List<string>();

            if (string.IsNullOrEmpty(newPassword))
            {
                validationMessage.Add("New password is empty. ");
                validationId.Add("ChangePassword");
            }

            if (!string.IsNullOrEmpty(newPassword))
            {
                var regex = new Regex(@"^.*(?=.{6,})(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$");
                var match = regex.Match(newPassword);
                if (!match.Success)
                {
                    validationMessage.Add("Invalid Password. Password must contain at least a digit, a uppercase and a lowercase letter. Mininum 6 characters are required. ");
                    validationId.Add("ChangePassword");
                }
            }

            invalidIds = validationId;
            return validationMessage;
        }

        public ActionResult UpdateUserDetail(EditUserInfoDTO dto)
        {
            var validationIds = new List<string>();
            var validationMessage = ValidateUserEdit(dto, out validationIds);
            if (!validationMessage.Any())
            {
               UserManagement.UpdateUser(dto);
            }

            return Json(new
            {
                passed = !validationMessage.Any(),
                validationIds,
                validationMessage = string.Join("</br>", validationMessage)
            });
        }

        public ActionResult ResetPassword()
        {
            return View();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
    
        [HttpPost]
        public ActionResult Login(UserData user)
        {
            var returnUrl = TempData["ReturnUrl"];
            if (ModelState.IsValid)
            {
                if (UserManagement.IsValid(user.Email, user.Password))
                {
                    var validUser = UserManagement.GetValidUserList().Single(x => x.UserName == user.Email);
                    FormsAuthentication.SetAuthCookie(user.Email, true);
                    Session["User"] = new UserLoginDto { Username = user.Email, Id = validUser.Id, IsAdmin = validUser.IsAdmin};
                    if (validUser.IsAdmin)
                    {
                        return RedirectToAction("Dashboard", "Admin");
                    }

                    if (returnUrl != null && !string.IsNullOrEmpty(returnUrl.ToString()))
                    {
                        return Redirect(returnUrl.ToString());
                    }
                    return RedirectToAction("ProductView", "Product");
                }

                if (!UserManagement.IsValidUsername(user.Email))
                {
                    ModelState.AddModelError("Username", "This username cannot be found.");
                }
                else
                {
                    ModelState.AddModelError("Password", "Password is incorrect!");
                }
                TempData["ReturnUrl"] = returnUrl;
            }
            return View(user);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult LogOut()
        {
            FormsAuthentication.SignOut();
            Session["User"] = null;
            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]

        public ActionResult Registration(Register register)
        {
            if (ModelState.IsValid)
            {
                if (register.Password == register.ConfirmPassword)
                {
                    //UserManagement.AddUser(register.Username, register.Password, register.EmailAddress);
                    //register.Username = "";
                    //register.EmailAddress = "";
                    //ModelState.Clear();
                }
            }
            else
                ModelState.AddModelError("", "Missing some field(s)");
            return View("Register", register);
        }
    }
}
