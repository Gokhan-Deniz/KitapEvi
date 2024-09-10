using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace KitapEvi.Users
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Initial page load logic can go here
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Retrieve user inputs
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hashedPassword = HashPassword(password); // Hash the password

            if (IsUserExists(email))
            {
                lblError.Text = "Bu email adresi zaten kayıtlı!";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            // Insert the user into the database
            using (SqlConnection conn = new SqlConnection("Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;"))
            {
                conn.Open();
                string query = "INSERT INTO Users (Name, Email, Password, Role) VALUES (@Name, @Email, @Password, @Role)";
                SqlCommand cmd = new SqlCommand(query, conn);

                // Add parameters
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", hashedPassword);
                cmd.Parameters.AddWithValue("@Role", "user"); // Default role for new users

                try
                {
                    cmd.ExecuteNonQuery();
                    lblSuccess.Text = "Kayıt başarılı! Şimdi giriş yapabilirsiniz.";
                    lblSuccess.Visible = true;
                    lblError.Visible = false;
                }
                catch (Exception ex)
                {
                    lblError.Text = "Bir hata oluştu: " + ex.Message;
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                }
            }
        }

        // Check if the email is already registered
        private bool IsUserExists(string email)
        {
            using (SqlConnection conn = new SqlConnection("Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;"))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);

                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        // Hash password using SHA256
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
