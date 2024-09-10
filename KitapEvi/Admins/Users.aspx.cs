using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KitapEvi.Admins
{
    public partial class Users : System.Web.UI.Page
    {
        // Veritabanı bağlantı dizesi
        private string connectionString = "Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers(); // Kullanıcıları yükler
            }
        }

        // Kullanıcıları GridView'e yükleyen metot
        private void LoadUsers()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT [Id], [Name], [Email], [Role] FROM [Users]", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        // GridView'deki satır komutlarına (düzenle/sil) yanıt veren metot
        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = gvUsers.Rows[index];
            string userId = row.Cells[0].Text; // Seçili satırın ID'sini al

            if (e.CommandName == "EditUser")
            {
                LoadUserDetails(userId); // Kullanıcı detaylarını form alanlarına yükler
            }
            else if (e.CommandName == "DeleteUser")
            {
                DeleteUser(userId); // Kullanıcıyı siler
                LoadUsers(); // GridView'i günceller
            }
        }

        // Kullanıcı detaylarını form alanlarına yükleyen metot
        private void LoadUserDetails(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT [Id], [Name], [Email], [Role] FROM [Users] WHERE [Id] = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hfUserId.Value = reader["Id"].ToString();
                    txtName.Text = reader["Name"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    ddlRole.SelectedValue = reader["Role"].ToString();
                }
            }
        }

        // Formdaki değişiklikleri kaydetmek için Save Changes butonuna basıldığında çalışan metot
        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            string userId = hfUserId.Value;
            string name = txtName.Text;
            string email = txtEmail.Text;
            string password = txtPassword.Text;
            string role = ddlRole.SelectedValue;

            // Şifre girildiyse hash'le
            string hashedPassword = string.IsNullOrEmpty(password) ? null : HashPassword(password);

            UpdateUser(userId, name, email, hashedPassword, role); // Kullanıcıyı güncelle
            LoadUsers(); // GridView'i günceller

            // TextBox'ları temizler
            ClearFormFields();
        }

        // TextBox'ları ve diğer form alanlarını temizleyen metot
        private void ClearFormFields()
        {
            hfUserId.Value = string.Empty;
            txtName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            ddlRole.ClearSelection(); // Role alanını sıfırlar
            ddlRole.Items[0].Selected = true; // Default olarak ilk öğeyi seçer (User)
        }


        // Kullanıcı güncelleme metodu
        private void UpdateUser(string userId, string name, string email, string hashedPassword, string role)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("UPDATE [Users] SET [Name] = @Name, [Email] = @Email, [Role] = @Role" +
                    (hashedPassword != null ? ", [Password] = @Password" : "") + " WHERE [Id] = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", userId);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Role", role);
                if (hashedPassword != null)
                {
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                }
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Kullanıcı silme metodu
        private void DeleteUser(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM [Users] WHERE [Id] = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", userId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Şifre hashleme metodu
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
