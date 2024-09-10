using System;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace KitapEvi.Users
{
    public partial class Logins : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["ReturnUrl"] != null)
            {
                lblError.Text = "Lütfen önce giriş yapınız!";
                lblError.Visible = true;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(password);

            using (SqlConnection conn = new SqlConnection("Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;"))
            {
                conn.Open();
                string query = "SELECT Name, Email, Role FROM Users WHERE Email = @Email AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", hashedPassword);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Kullanıcı giriş yaptı, session bilgileri oluşturuluyor
                    string name = reader["Name"].ToString();
                    string role = reader["Role"].ToString();

                    FormsAuthentication.SetAuthCookie(email, false);
                    Session["Name"] = name;
                    Session["Role"] = role;
                    Session["Email"] = email; // Profilde kullanmak için email bilgisi

                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        // Rol bazlı yönlendirme
                        Response.Redirect("~/Users/Defaults.aspx");
                    }
                }
                else
                {
                    lblError.Text = "Geçersiz email veya şifre!";
                    lblError.Visible = true;
                }
            }
        }

        private string HashPassword(string password)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                System.Text.StringBuilder builder = new System.Text.StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
