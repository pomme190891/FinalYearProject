using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using FinPlanWeb.DTOs;
using FinPlanWeb.Database;

namespace FinPlanWeb.Controllers
{
    public class OrderManagementController : BaseController
    {
        private const int pageSize = 10;

        public ActionResult Search(string from, string to, string paymentType, string firm)
        {
            var users = UserManagement.GetAllUserList();
            var orders = OrderManagement.GetAllOrders();
            var filteredOrders = SearchFunction(@from, to, paymentType, firm, orders, users,1);

            var orderList = PopulateOrderList(filteredOrders, users);
            var totalPage = (int)Math.Ceiling(((double)orders.Count() / (double)pageSize));
            return Json(new { orderList, totalPage }, JsonRequestBehavior.AllowGet);
        }

        private static IEnumerable<OrderManagement.Order> SearchFunction(string @from, string to, string paymentType, string firm, IEnumerable<OrderManagement.Order> orders,
                                                  IEnumerable<UserManagement.User> users,int pageNum)
        {
            if (!string.IsNullOrEmpty(@from))
            {
                var fromDate = DateTime.ParseExact(@from, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                orders = orders.Where(x => x.DateCreated >= fromDate);
            }
            if (!string.IsNullOrEmpty(to))
            {
                var toDate = DateTime.ParseExact(to, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                orders = orders.Where(x => x.DateCreated <= toDate);
            }
            if (!string.IsNullOrEmpty(paymentType))
            {
                orders = orders.Where(x => x.PaymentType == paymentType);
            }
            if (!string.IsNullOrEmpty(firm))
            {
                var firmUser = users.Where(x => x.FirmName == firm).Select(x => x.Id);
                orders = orders.Where(x => firmUser.Contains(x.UserId));
            }

            return orders.Skip((pageNum - 1) * pageSize)
                .Take(pageSize);
        }

        public ActionResult OrderHistory()
        {
            var users = UserManagement.GetAllUserList();
            var orders = OrderManagement.GetAllOrders();
            var filteredOrders = SearchFunction(null, null, null, null, orders, users, 1);
            var orderList = PopulateOrderList(filteredOrders, users);
            ViewBag.Orders = new JavaScriptSerializer().Serialize(orderList);
            ViewBag.TotalOrdersPage = (int)Math.Ceiling(((double)orders.Count() / (double)pageSize)); ;
            return View();
        }

        private static List<OrderDTO> PopulateOrderList(IEnumerable<OrderManagement.Order> orders, IEnumerable<UserManagement.User> users)
        {
            var orderList = new List<OrderDTO>();

            foreach (var order in orders)
            {
                var user = users.Single(x => x.Id == order.UserId);
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

        public ActionResult Paging(int pageNum, string from, string to, string paymentType, string firm)
        {
            var users = UserManagement.GetAllUserList();
            var orders = OrderManagement.GetAllOrders();
            var filteredOrders = SearchFunction(@from, to, paymentType, firm, orders, users, pageNum);

            var orderList = PopulateOrderList(filteredOrders, users);
            return Json(new { orderList }, JsonRequestBehavior.AllowGet);
        }
    }
}
