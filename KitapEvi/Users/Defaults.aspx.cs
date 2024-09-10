using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Net;

namespace KitapEvi.Users
{
    public partial class Defaults : System.Web.UI.Page
    {
        // Veritabanı bağlantı dizesi
        string connectionString = "Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBookList(); // Sayfa yüklendiğinde kitap listesini yükle
                LoadSliderContent();
                LoadTopSellingBooks();
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

        private void LoadBookList()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // En son eklenen 20 kitabı ve is_active olanları çekmek için SQL sorgusu
                string query = @"SELECT TOP 20 id, Title, Price, cover_image, Description, Discount, difficulty_level, average_reading_time, sold_count
                         FROM Book 
                         WHERE is_active = 1
                         ORDER BY id DESC"; // En son eklenenlere göre sırala

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // rptBooks adlı Repeater kontrolüne veriyi bağlama
                rptBooks.DataSource = dt;
                rptBooks.DataBind();
            }
        }

        private void LoadTopSellingBooks()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // En çok satan 20 kitabı çekmek için SQL sorgusu
                string query = @"SELECT TOP 20 id, title, price, cover_image, description, discount, sold_count, difficulty_level, average_reading_time,category_id
                         FROM Book 
                         WHERE is_active = 1
                         ORDER BY sold_count DESC"; // Satış sayısına göre en çok satanlardan sırala

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // rptTopSellingBooks adlı Repeater kontrolüne veriyi bağlama
                rptTopSellingBooks.DataSource = dt;
                rptTopSellingBooks.DataBind();
            }
        }


        [WebMethod]
        public static Book GetBookDetails(int id)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["KitapEvim"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT Title, Price, cover_image, Description FROM Book WHERE id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    Book book = new Book
                    {
                        Title = reader["Title"].ToString(),
                        Price = Convert.ToDecimal(reader["Price"]),
                        cover_image = reader["cover_image"].ToString(),
                        Description = reader["Description"].ToString()
                    };
                    return book;
                }
                else
                {
                    return null;
                }
            }
        }

        private void LoadSliderContent()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // 'Add' tablosunda order_number alanına göre sıralama yaparak veriyi çekiyoruz
                string query = "SELECT * FROM [Add] ORDER BY order_number ASC";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                int slideCount = 0;
                string sliderContent = "";
                string indicatorsContent = "";

                while (reader.Read())
                {
                    string activeClass = slideCount == 0 ? "active" : "";

                    // Slider içeriğini oluştur
                    sliderContent += $@"
            <div class='carousel-item {activeClass}'>
                <div class='container-fluid'>
                    <div class='row'>
                        <div class='col-md-6'>
                            <div class='detail-box'>
                                <h1>{reader["title"]}</h1>
                                <p>{reader["description"]}</p>
                            </div>
                        </div>
                        <div class='col-md-6'>
                            <div class='img-box'>
                                <img src='{reader["image_path"]}' alt=''>
                            </div>
                        </div>
                    </div>
                </div>
            </div>";

                    // Slider göstergelerini (dots) oluştur
                    indicatorsContent += $@"
            <li data-target='#customCarousel1' data-slide-to='{slideCount}' class='{activeClass}'></li>";

                    slideCount++;
                }

                conn.Close();

                // Default.aspx sayfasındaki Literal kontrollerine slider içeriğini aktar
                litSliderContent.Text = sliderContent;
                litIndicatorsContent.Text = indicatorsContent;
            }
        }

    }
    public class Book
    {
        public string Title { get; set; }
        public decimal Price { get; set; }
        public string cover_image { get; set; }
        public string Description { get; set; }
    }
}