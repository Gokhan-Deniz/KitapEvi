using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KitapEvi.Users
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Oturumu sonlandır ve kullanıcıyı giriş sayfasına yönlendir
            Session.Clear(); // Tüm session değişkenlerini temizler
            Session.Abandon(); // Oturumu sona erdirir
            FormsAuthentication.SignOut(); // FormsAuthentication için çıkış yap
            Server.Transfer("~/Users/Login.aspx"); // Giriş sayfasına yönlendir
        }
    }
}