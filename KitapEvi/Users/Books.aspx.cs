using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace KitapEvi.Users
{
    public partial class Books : System.Web.UI.Page
    {
        string connectionString = "Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadBooks();
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

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT id, name FROM Category";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCategories.DataSource = dt;
                ddlCategories.DataTextField = "name";
                ddlCategories.DataValueField = "id";
                ddlCategories.DataBind();

                ddlCategories.Items.Insert(0, new ListItem("Tüm Kategoriler", "0"));
            }
        }

        private void LoadBooks(int? categoryId = null, string sortOrder = null, string searchQuery = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT id, title, price, cover_image, description, difficulty_level, average_reading_time, discount, sold_count
                                 FROM Book
                                 WHERE is_active = 1";

                if (categoryId.HasValue && categoryId.Value != 0)
                {
                    query += " AND category_id = @CategoryId";
                }

                if (!string.IsNullOrEmpty(searchQuery))
                {
                    query += " AND title LIKE @SearchQuery";
                }

                // Sıralama işlemi
                if (sortOrder != "none")
                {
                    switch (sortOrder)
                    {
                        case "name_asc":
                            query += " ORDER BY title ASC";
                            break;
                        case "name_desc":
                            query += " ORDER BY title DESC";
                            break;
                        case "price_asc":
                            query += " ORDER BY price ASC";
                            break;
                        case "price_desc":
                            query += " ORDER BY price DESC";
                            break;
                        case "sales_asc":
                            query += " ORDER BY sold_count ASC";
                            break;
                        case "sales_desc":
                            query += " ORDER BY sold_count DESC";
                            break;
                    }
                }

                SqlDataAdapter da = new SqlDataAdapter(query, conn);

                if (categoryId.HasValue && categoryId.Value != 0)
                {
                    da.SelectCommand.Parameters.AddWithValue("@CategoryId", categoryId.Value);
                }

                if (!string.IsNullOrEmpty(searchQuery))
                {
                    da.SelectCommand.Parameters.AddWithValue("@SearchQuery", "%" + searchQuery + "%");
                }

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptBooks.DataSource = dt;
                rptBooks.DataBind();
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["Email"] == null)
            {
                Response.Redirect("~/Users/Logins.aspx?ReturnUrl=Carts.aspx");
                return;
            }

            // Kitap id'sini al
            int bookId = Convert.ToInt32(((Button)sender).CommandArgument);

            // Kitap bilgilerini veritabanından çekiyoruz
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT title, price FROM Book WHERE id = @BookId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@BookId", bookId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    AddToCart(bookId, reader["title"].ToString(), Convert.ToDecimal(reader["price"]));
                }
            }
        }

        private void AddToCart(int bookId, string title, decimal price)
        {
            // Sepet işlemi
            DataTable cart = Session["Cart"] as DataTable;

            if (cart == null)
            {
                cart = new DataTable();
                cart.Columns.Add("BookId", typeof(int));
                cart.Columns.Add("Title", typeof(string));
                cart.Columns.Add("Price", typeof(decimal));
                cart.Columns.Add("Quantity", typeof(int));
            }

            DataRow row = cart.NewRow();
            row["BookId"] = bookId;
            row["Title"] = title;
            row["Price"] = price;
            row["Quantity"] = 1;
            cart.Rows.Add(row);

            Session["Cart"] = cart;
            Response.Redirect("Carts.aspx");
        }

        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedCategory = int.Parse(ddlCategories.SelectedValue);
            string selectedSortOrder = ddlSorting.SelectedValue;
            string searchQuery = txtSearch.Text;
            LoadBooks(selectedCategory == 0 ? null : (int?)selectedCategory, selectedSortOrder, searchQuery);
        }

        protected void ddlSorting_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedCategory = int.Parse(ddlCategories.SelectedValue);
            string selectedSortOrder = ddlSorting.SelectedValue;
            string searchQuery = txtSearch.Text;
            LoadBooks(selectedCategory == 0 ? null : (int?)selectedCategory, selectedSortOrder, searchQuery);
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            int selectedCategory = int.Parse(ddlCategories.SelectedValue);
            string selectedSortOrder = ddlSorting.SelectedValue;
            string searchQuery = txtSearch.Text;
            LoadBooks(selectedCategory == 0 ? null : (int?)selectedCategory, selectedSortOrder, searchQuery);
        }
    }
}
