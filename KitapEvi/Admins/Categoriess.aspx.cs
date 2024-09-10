using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KitapEvi.Admins
{
    public partial class Categoriess : System.Web.UI.Page
    {
        string connectionString = "Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Name"] == null || !IsAdmin())
            {
                // Eğer kullanıcı giriş yapmadıysa ya da admin değilse giriş sayfasına yönlendirme
                Response.Redirect("~/Users/Login.aspx");
            }

            if (!IsPostBack)
            {
                PopulateCategoryList();
            }
        }

        private bool IsAdmin()
        {
            // Session'da kayıtlı role bilgisine göre kontrol
            return Session["Role"] != null && Session["Role"].ToString() == "admin";
        }

        private void PopulateCategoryList()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Category";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCategoryList.DataSource = dt;
                gvCategoryList.DataBind();
            }
        }

        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query;
                if (hdnId.Value == "0")  // Yeni kayıt ekleme
                {
                    query = "INSERT INTO Category (name) VALUES (@Name)";
                }
                else  // Güncelleme işlemi
                {
                    query = "UPDATE Category SET name=@Name WHERE id=@Id";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", hdnId.Value);  // Güncelleme için ID kullanılır
                cmd.Parameters.AddWithValue("@Name", txtCategoryName.Text);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                // İşlem sonrası formu sıfırla ve listeyi yenile
                ResetForm();
                PopulateCategoryList();
            }
        }

        private void DeleteCategory(int categoryId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Kitapların category_id'sini NULL yap
                string updateBooksQuery = "UPDATE Book SET category_id=NULL WHERE category_id=@CategoryId";
                SqlCommand updateBooksCmd = new SqlCommand(updateBooksQuery, conn);
                updateBooksCmd.Parameters.AddWithValue("@CategoryId", categoryId);

                conn.Open();
                updateBooksCmd.ExecuteNonQuery();

                // Daha sonra kategoriyi sil
                string deleteCategoryQuery = "DELETE FROM Category WHERE id=@Id";
                SqlCommand deleteCategoryCmd = new SqlCommand(deleteCategoryQuery, conn);
                deleteCategoryCmd.Parameters.AddWithValue("@Id", categoryId);
                deleteCategoryCmd.ExecuteNonQuery();

                conn.Close();

                // Listeyi yenile
                PopulateCategoryList();

                Response.Redirect("Categoriess.aspx");

            }
        }


        protected void gvCategoryList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int categoryId = Convert.ToInt32(e.CommandArgument);
                LoadCategoryForEdit(categoryId);  // Seçilen satırdaki verileri yükle
            }
            else if (e.CommandName == "Delete")
            {
                int categoryId = Convert.ToInt32(e.CommandArgument);
                DeleteCategory(categoryId);  // Silme işlemi
            }
        }

        private void LoadCategoryForEdit(int categoryId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Category WHERE id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", categoryId);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Form alanlarına verileri doldur
                    hdnId.Value = reader["id"].ToString();
                    txtCategoryName.Text = reader["name"].ToString();
                }
                conn.Close();
            }
        }

        private void ResetForm()
        {
            hdnId.Value = "0";
            txtCategoryName.Text = string.Empty;
        }

        protected void gvCategoryList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // RowEditing olayını iptal et
            e.Cancel = true;
        }
    }
}