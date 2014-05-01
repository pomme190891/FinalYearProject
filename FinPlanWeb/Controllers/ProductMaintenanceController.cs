using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using FinPlanWeb.DTOs;
using FinPlanWeb.Database;

namespace FinPlanWeb.Controllers
{
    public class ProductMaintenanceController : BaseController
    {
        private const int pageSize = 10;

        public ActionResult Index()
        {
            var serializer = new JavaScriptSerializer();
            var products = ProductManagement.GetProducts(ProductManagement.ProductType.All);
            var categories = CategoryManagement.GetAllCategory();
            var productDTO = ApplyPaging(products, 1).Select(x => ConvertToProductDTO(x, categories));

            ViewBag.ProductDetail = serializer.Serialize(new EditProductDTO());
            ViewBag.Products = serializer.Serialize(productDTO);
            ViewBag.Categories = serializer.Serialize(categories.Select(x => new { x.Id, x.Name }));
            ViewBag.TotalProductPage = (int)Math.Ceiling(((double)products.Count() / (double)pageSize));
            return View();
        }

        public ActionResult Paging(int num)
        {
            var list = ProductManagement.GetProducts(ProductManagement.ProductType.All);
            var categories = CategoryManagement.GetAllCategory();
            var products = ApplyPaging(list, num).Select(x => ConvertToProductDTO(x, categories));

            return Json(products, JsonRequestBehavior.AllowGet);
        }

        private object ConvertToProductDTO(Product product, IEnumerable<CategoryManagement.Category> categories)
        {
            return new ProductDTO
                {
                    ProductId = product.Id,
                    Code = product.Code,
                    DateAdded = product.AddedDate.ToString("dd/MM/yyyy"),
                    Name = product.Name,
                    LastModifiedDate =
                        product.ModifiedDate == null ? "" : product.ModifiedDate.Value.ToString("dd/MM/yyyy"),
                    Price = Convert.ToDecimal(product.Price),
                    Category = categories.Single(c => c.Id == product.CategoryId).Name
                };
        }

        public IEnumerable<Product> ApplyPaging(IEnumerable<Product> products, int num)
        {
            return products.Skip((num - 1) * pageSize)
                .Take(pageSize);
        }

        public ActionResult CreateUpdateProduct(EditProductDTO dto)
        {
            if (dto == null)
            {
                throw new NullReferenceException("DTO cannot be null");
            }
            var validationIds = new List<string>();
            var validationMessage = Validate(dto, out validationIds);
            if (!validationMessage.Any())
            {
                if (dto.IsCreating)
                {
                    ProductManagement.CreateProduct(dto);
                }
                else
                {
                    ProductManagement.UpdateProduct(dto);
                }
                
                var products = ProductManagement.GetProducts(ProductManagement.ProductType.All);
                var categories = CategoryManagement.GetAllCategory();
                var totalProductPage = (int)Math.Ceiling(((double)products.Count() / (double)pageSize));
                return Json(new
                {
                    products = ApplyPaging(products, 1).Select(x => ConvertToProductDTO(x, categories)),
                    passed = !validationMessage.Any(),
                    validationIds,
                    validationMessage = string.Join("</br>", validationMessage),
                    totalProductPage
                });
            }

            return Json(new
            {
                passed = !validationMessage.Any(),
                validationIds,
                validationMessage = string.Join("</br>", validationMessage)
            });
        }

        public ActionResult GetProductDetail(string productCode)
        {
            var product = ProductManagement.GetProduct(productCode);
            var productDetail = new EditProductDTO
                {
                    Id = product.Id,
                    Name = product.Name,
                    CategoryId = product.CategoryId,
                    Code = product.Code,
                    Price = Convert.ToDecimal(product.Price),
                    IsCreating = false
                };
            return Json(new { productDetail }, JsonRequestBehavior.AllowGet);
        }

        public List<string> Validate(EditProductDTO product, out List<string> invalidIds)
        {
            var validationMessage = new List<string>();
            var validationId = new List<string>();

            if (product.IsCreating && string.IsNullOrEmpty(product.Code))
            {
                validationMessage.Add("Code is empty.");
                validationId.Add("Code");
            }

            if (product.CategoryId == default(int))
            {
                validationMessage.Add("Category is empty.");
                validationId.Add("Category");
            }

            if (string.IsNullOrEmpty(product.Name))
            {
                validationMessage.Add("Name is empty.");
                validationId.Add("Name");
            }

            if (product.Price == default(decimal))
            {
                validationMessage.Add("Price is empty.");
                validationId.Add("Price");
            }

            invalidIds = validationId;
            return validationMessage;
        }

    }
}
