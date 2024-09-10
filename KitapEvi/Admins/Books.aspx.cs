using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace KitapEvi.Admins
{
    public partial class Books : System.Web.UI.Page
    {
        string connectionString = "Data Source= ;Initial Catalog=KitapEvim;Integrated Security=True;";//bağlantı için source gir


        // Masaüstünüzdeki Kitap ve Kapak klasörlerinin yolları
        string kitapFolderPath = @"/Uploads/Books/";
        string kapakFolderPath = @"/Uploads/img_books/";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateCategoryDropdown();
                PopulateBookList();
            }
        }

        private void PopulateCategoryDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT id, name FROM Category";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                ddlCategory.DataSource = cmd.ExecuteReader();
                ddlCategory.DataTextField = "name";
                ddlCategory.DataValueField = "id";
                ddlCategory.DataBind();
                ddlCategory.Items.Insert(0, new ListItem("Select Category", "0"));
            }
        }

        private void PopulateBookList()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT b.*, c.name AS category_name 
            FROM Book b
            LEFT JOIN Category c ON b.category_id = c.id";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvBookList.DataSource = dt;
                gvBookList.DataBind();
            }
        }


        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query;

                // İndirim oranını hesapla ve son fiyatı belirle
                decimal price = Convert.ToDecimal(txtPrice.Text);
                decimal discount = Convert.ToDecimal(txtDiscount.Text);
                decimal discountedPrice = price - (price * discount / 100);

                if (hdnId.Value == "0")  // Yeni kayıt ekleme
                {
                    query = "INSERT INTO Book (title, description, difficulty_level, average_reading_time, price, discount, category_id, pdf_file, cover_image, is_active) " +
                            "VALUES (@Title, @Description, @DifficultyLevel, @AverageReadingTime, @Price, @Discount, @CategoryId, @PdfFile, @CoverImage, @IsActive)";
                }
                else  // Güncelleme işlemi
                {
                    query = "UPDATE Book SET title=@Title, description=@Description, difficulty_level=@DifficultyLevel, average_reading_time=@AverageReadingTime, " +
                            "price=@Price, discount=@Discount, category_id=@CategoryId, pdf_file=@PdfFile, cover_image=@CoverImage, is_active=@IsActive WHERE id=@Id";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", hdnId.Value);  // Eğer güncelleme işlemi ise ID kullanılır
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                cmd.Parameters.AddWithValue("@DifficultyLevel", txtDifficultyLevel.Text);
                cmd.Parameters.AddWithValue("@AverageReadingTime", txtAverageReadingTime.Text);
                cmd.Parameters.AddWithValue("@Price", discountedPrice); // İndirimli fiyatı kullan
                cmd.Parameters.AddWithValue("@Discount", txtDiscount.Text);
                cmd.Parameters.AddWithValue("@CategoryId", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                // Dosya yollarını kontrol et (yeni dosya yüklenmemişse eski dosya yolunu kullan)
                string pdfPath = SaveFile(fuPdfFile, kitapFolderPath);
                string coverImagePath = SaveFile(fuCoverImage, kapakFolderPath);

                if (string.IsNullOrEmpty(pdfPath))
                {
                    pdfPath = hdnPdfFile.Value;  // Eğer yeni dosya yüklenmediyse eski dosya yolunu kullan
                }

                if (string.IsNullOrEmpty(coverImagePath))
                {
                    coverImagePath = hdnCoverImage.Value;  // Eğer yeni dosya yüklenmediyse eski dosya yolunu kullan
                }

                cmd.Parameters.AddWithValue("@PdfFile", pdfPath);
                cmd.Parameters.AddWithValue("@CoverImage", coverImagePath);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                // İşlem sonrası formu sıfırla ve listeyi yenile
                ResetForm();
                PopulateBookList();
            }
        }

        private string SaveFile(FileUpload fileUpload, string folderPath)
        {
            if (fileUpload.HasFile)
            {
                // Dosya adını al
                string fileName = Path.GetFileName(fileUpload.PostedFile.FileName);
                // Web uygulamasına göre yolu belirle
                string relativePath = "~/Uploads/Books/" + fileName;
                string filePath = Server.MapPath(relativePath);
                // Dosyayı sunucudaki klasöre kaydet
                fileUpload.SaveAs(filePath);
                return relativePath; // Kaydedilen dosyanın yolunu döndür (web yolu)
            }
            return string.Empty; // Eğer dosya yüklenmemişse boş döndür
        }

        private void DeleteBook(int bookId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Book WHERE id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", bookId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                // Silme işlemi başarılı olduğunda Book.aspx sayfasına geri yönlendir
                Response.Redirect("Books.aspx");
            }
        }

        protected void gvBookList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int bookId = Convert.ToInt32(e.CommandArgument);
                LoadBookForEdit(bookId);  // Seçilen satırdaki verileri yükle
            }
            else if (e.CommandName == "Delete")
            {
                int bookId = Convert.ToInt32(e.CommandArgument);
                DeleteBook(bookId);  // Silme işlemi
            }
        }


        private void LoadBookForEdit(int bookId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Kategori Dropdown'u doldur
                PopulateCategoryDropdown();

                string query = "SELECT * FROM Book WHERE id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", bookId);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Form alanlarına verileri doldur
                    hdnId.Value = reader["id"].ToString();
                    txtTitle.Text = reader["title"].ToString();
                    txtDescription.Text = reader["description"].ToString();
                    txtDifficultyLevel.Text = reader["difficulty_level"].ToString();
                    txtAverageReadingTime.Text = reader["average_reading_time"].ToString();
                    txtPrice.Text = reader["price"].ToString();
                    txtDiscount.Text = reader["discount"].ToString();

                    // Seçilen kategori DropDownList'te bulunmuyorsa hata oluşur, kontrol edelim
                    string categoryId = reader["category_id"].ToString();
                    ListItem selectedCategory = ddlCategory.Items.FindByValue(categoryId);
                    if (selectedCategory != null)
                    {
                        ddlCategory.SelectedValue = categoryId;
                    }
                    else
                    {
                        // Kategori listesinde bulunmuyorsa, geçici olarak listeye ekleyelim
                        ddlCategory.Items.Insert(1, new ListItem("Unknown Category", categoryId));
                        ddlCategory.SelectedValue = categoryId;
                    }

                    chkIsActive.Checked = Convert.ToBoolean(reader["is_active"]);

                    // Gizli alanlara dosya yollarını ekle
                    hdnPdfFile.Value = reader["pdf_file"].ToString();
                    hdnCoverImage.Value = reader["cover_image"].ToString();
                }
                conn.Close();
            }
        }


        private void ResetForm()
        {
            hdnId.Value = "0";
            txtTitle.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtDifficultyLevel.Text = string.Empty;
            txtAverageReadingTime.Text = string.Empty;
            txtPrice.Text = string.Empty;
            txtDiscount.Text = string.Empty;
            ddlCategory.SelectedIndex = 0;
            chkIsActive.Checked = false;
        }

        protected void gvBookList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // RowEditing olayını iptal et
            e.Cancel = true;
        }

    }
}
