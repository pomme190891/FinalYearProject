using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using SALuminousWeb.DTOs;
using SALuminousWeb.Database;

namespace SALuminousWeb.Controllers
{
    public class PromoMaintenanceController : Controller
    {
        private const int pageSize = 10;
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult PromotionSection()
        {
            var serializer = new JavaScriptSerializer();
            var allPromotions = PromoManagement.GetAllPromotionList();
            var promotions = ApplyPaging(allPromotions, 1);

            ViewBag.PromotionDetail = serializer.Serialize(new EditPromotionDTO());
            ViewBag.Promotions = serializer.Serialize(promotions);
            ViewBag.TotalPromotionPage = (int)Math.Ceiling(((double)allPromotions.Count() / (double)pageSize));
            return View();
        }

        public ActionResult GetPromotionDetail(string promotionCode)
        {
            var promotion = PromoManagement.GetAllPromotionList().Single(x=>x.CodeId == promotionCode);
            var promotionDetail = new EditPromotionDTO
            {
                CodeId = promotion.CodeId,
                Price = promotion.Price,
                Rate = promotion.Rate,
                IsCreating = false,
                Hidden = promotion.Hidden
            };
            return Json(new { promotionDetail }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Paging(int num)
        {
            var list = PromoManagement.GetAllPromotionList();
            var promotions = ApplyPaging(list, num);

            return Json(promotions, JsonRequestBehavior.AllowGet);
        }

        public ActionResult CreateUpdatePromotion(EditPromotionDTO dto)
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
                    PromoManagement.AddPromotion(dto);
                }
                else
                {
                    PromoManagement.UpdatePromotion(dto);
                }

                var promotions = PromoManagement.GetAllPromotionList();

                var totalProductPage = (int)Math.Ceiling(((double)promotions.Count() / (double)pageSize));
                return Json(new
                {
                    promotions = ApplyPaging(promotions, 1),
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

        public IEnumerable<PromoManagement.Promotion> ApplyPaging(IEnumerable<PromoManagement.Promotion> promotions, int num)
        {
            return promotions.Skip((num - 1) * pageSize)
                .Take(pageSize);
        }

        public List<string> Validate(EditPromotionDTO promotion, out List<string> invalidIds)
        {
            var validationMessage = new List<string>();
            var validationId = new List<string>();

            if (promotion.IsCreating && string.IsNullOrEmpty(promotion.CodeId))
            {
                validationMessage.Add("Code is empty.");
                validationId.Add("PromotionCodeId");
            }

            if (promotion.Price == default(double) && promotion.Rate == default(int))
            {
                validationMessage.Add("Price and Rate are both empty. At least one must be set.");
                validationId.Add("PromotionPrice");
                validationId.Add("PromotionRate");
            }

            if (promotion.Price != default(double) && promotion.Rate != default(int))
            {
                validationMessage.Add("Price and Rate cannot be set at the same time.");
                validationId.Add("PromotionPrice");
                validationId.Add("PromotionRate");
            }

            invalidIds = validationId;
            return validationMessage;
        }
    }
}
