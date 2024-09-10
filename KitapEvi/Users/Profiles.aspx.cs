using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KitapEvi.Users
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kullanıcı oturumu kontrol et
                if (Session["Email"] == null)
                {
                    Response.Redirect("~/Users/Logins.aspx?ReturnUrl=Profiles.aspx");
                    return;
                }

                LoadUserProfile();
                LoadBorrowedBooks();
            }
        }
        protected void lbLogout_Click(object sender, EventArgs e)
        {
            // Oturumu sonlandır
            Session.Abandon();
            Session.Clear(); // Tüm session bilgilerini temizle

            // Kullanıcıyı giriş sayfasına yönlendir
            Response.Redirect("~/Users/Logins.aspx");
        }

        private void LoadUserProfile()
        {
            string email = Session["Email"].ToString();
            //kaynak girmeyi unutmaaaa
            using (SqlConnection conn = new SqlConnection("Data Source=  ;  Initial Catalog=KitapEvim;Integrated Security=True;"))
            {
                conn.Open();
                string query = "SELECT Name, Email FROM Users WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtName.Text = reader["Name"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                }
            }
        }

        private void LoadBorrowedBooks()
        {
            string email = Session["Email"].ToString();

            using (SqlConnection conn = new SqlConnection("Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;"))
            {
                //burada aldığı kitaplar listelenip erişime açılacak
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();
            string name = txtName.Text.Trim();
            string newPassword = txtPassword.Text.Trim();
            string hashedPassword = string.IsNullOrEmpty(newPassword) ? null : HashPassword(newPassword);

            using (SqlConnection conn = new SqlConnection("Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;"))
            {
                conn.Open();
                string query = "UPDATE Users SET Name = @Name" + (hashedPassword != null ? ", Password = @Password" : "") + " WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Email", email);
                if (hashedPassword != null)
                {
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                }

                cmd.ExecuteNonQuery();
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
