using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace KitapEvi.Admins
{
    public partial class Admins : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Eğer kullanıcı giriş yapmamışsa (Session boşsa), giriş sayfasına yönlendir
                if (Session["Name"] == null && Session["Email"] == null)
                {
                    Response.Redirect("../Users/Logins.aspx");
                }
            }
        }

        // Logout işlemi
        protected void lbLogout_Click(object sender, EventArgs e)
        {
            // Oturumu sonlandır
            Session.Abandon();
            Session.Clear(); // Tüm session bilgilerini temizle

            // Kullanıcıyı giriş sayfasına yönlendir
            Response.Redirect("../Users/Logins.aspx");
        }
    }
}
