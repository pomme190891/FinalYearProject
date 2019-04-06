using System.Web.Mvc;
using System.Web.Routing;
using SALuminousWeb.DTOs;

namespace SALuminousWeb.Controllers
{
    public class BaseController : Controller
    {
        protected override void Initialize(RequestContext requestContext)
        {
            base.Initialize(requestContext);
            ViewBag.User = Session["User"] as UserLoginDto;
        }
    }
}