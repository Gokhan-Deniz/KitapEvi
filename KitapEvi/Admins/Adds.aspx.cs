using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KitapEvi.Admins
{
    public partial class Adds : System.Web.UI.Page
    {
        string connectionString = "Data Source=DESKTOP-H7FAETO\\SQLEXPRESS;Initial Catalog=KitapEvim;Integrated Security=True;";
        string addImageFolderPath = "/Uploads/Adds/";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateAddList();
            }
        }

        private void PopulateAddList()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM [Add] ORDER BY order_number";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAddList.DataSource = dt;
                gvAddList.DataBind();
            }
        }

        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            string query;
            bool isNewRecord = hdnId.Value == "0";

            // Determine if it's a new record or an update
            if (isNewRecord)
            {
                query = "INSERT INTO [Add] (title, description, image_path, order_number) VALUES (@Title, @Description, @ImagePath, @OrderNumber)";
            }
            else
            {
                query = "UPDATE [Add] SET title=@Title, description=@Description, image_path=@ImagePath, order_number=@OrderNumber WHERE id=@Id";
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);

                // Add parameters to avoid SQL injection
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                cmd.Parameters.AddWithValue("@OrderNumber", Convert.ToInt32(txtOrderNumber.Text));

                // Image Handling
                string imagePath = SaveFile(fuImage, addImageFolderPath);
                if (string.IsNullOrEmpty(imagePath) && !isNewRecord)
                {
                    imagePath = GetCurrentImagePath(Convert.ToInt32(hdnId.Value));
                }
                cmd.Parameters.AddWithValue("@ImagePath", imagePath);

                // Add ID parameter only for updates
                if (!isNewRecord)
                {
                    if (int.TryParse(hdnId.Value, out int parsedId))
                    {
                        cmd.Parameters.AddWithValue("@Id", parsedId);
                    }
                    else
                    {
                        // Handle invalid ID
                        return;
                    }
                }

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                ResetForm();
                PopulateAddList();
            }
        }

        private string SaveFile(FileUpload fileUpload, string folderPath)
        {
            if (fileUpload.HasFile)
            {
                string fileName = Path.GetFileName(fileUpload.PostedFile.FileName);
                string relativePath = folderPath + fileName;
                string filePath = Server.MapPath(relativePath);
                fileUpload.SaveAs(filePath);
                return relativePath;
            }
            return string.Empty;
        }

        private string GetCurrentImagePath(int addId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT image_path FROM [Add] WHERE id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", addId);

                conn.Open();
                object result = cmd.ExecuteScalar();
                conn.Close();

                return result?.ToString() ?? string.Empty;
            }
        }

        private void DeleteAdd(int addId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM [Add] WHERE id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", addId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                PopulateAddList();
                Response.Redirect("Adds.aspx");
            }
        }

        protected void gvAddList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int addId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Edit")
            {
                LoadAddForEdit(addId);
            }
            else if (e.CommandName == "Delete")
            {
                DeleteAdd(addId);
            }
        }

        protected void gvAddList_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Cancel the RowDeleting event to prevent GridView from handling it automatically
            e.Cancel = true;
        }

        private void LoadAddForEdit(int addId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM [Add] WHERE id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", addId);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hdnId.Value = reader["id"].ToString();
                    txtTitle.Text = reader["title"].ToString();
                    txtDescription.Text = reader["description"].ToString();
                    txtOrderNumber.Text = reader["order_number"].ToString();
                }
                conn.Close();
            }
        }

        private void ResetForm()
        {
            hdnId.Value = "0";
            txtTitle.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtOrderNumber.Text = string.Empty;
            fuImage.Attributes.Clear();
        }

        protected void gvAddList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            e.Cancel = true;  // Cancel edit operation in GridView
        }
    }
}
