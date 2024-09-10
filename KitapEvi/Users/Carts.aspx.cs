using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KitapEvi.Users
{
    public partial class Carts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kullanıcı oturumu kontrol et
            if (Session["Email"] == null)
            {
                // Giriş yapılmamışsa kullanıcıyı logine yönlendir
                Response.Redirect("~/Users/Logins.aspx?ReturnUrl=Carts.aspx");
                return;
            }

            // Giriş yapıldıysa sepet içeriğini yükle
            if (!IsPostBack)
            {
                rptCartItems.ItemDataBound += rptCartItems_ItemDataBound;
                BindCartItems();
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

        private void BindCartItems()
        {
            if (Session["Cart"] != null)
            {
                DataTable dt = (DataTable)Session["Cart"];
                rptCartItems.DataSource = dt;
                rptCartItems.DataBind();

                // Toplam tutarı hesapla
                decimal totalPrice = 0;
                foreach (DataRow row in dt.Rows)
                {
                    totalPrice += Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Quantity"]);
                }

                // Repeater Footer içinde bulunan lblTotalPrice kontrolüne ulaşarak fiyatı set et
                RepeaterItem footerItem = rptCartItems.Controls[rptCartItems.Controls.Count - 1] as RepeaterItem;
                if (footerItem != null)
                {
                    Label lblTotalPrice = footerItem.FindControl("lblTotalPrice") as Label;
                    if (lblTotalPrice != null)
                    {
                        lblTotalPrice.Text = totalPrice.ToString("0.00");
                    }
                }

                Session["CartTotal"] = totalPrice;
            }
            else
            {
                // Eğer sepet boşsa, kullanıcıyı anasayfaya yönlendir
                Response.Redirect("/Users/Books.aspx");
            }
        }

        protected void rptCartItems_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
                Label lblTotalPrice = (Label)e.Item.FindControl("lblTotalPrice");
                if (lblTotalPrice != null)
                {
                    decimal totalPrice = 0;

                    // Sepet tutarını hesapla
                    if (Session["Cart"] != null)
                    {
                        DataTable dt = (DataTable)Session["Cart"];
                        foreach (DataRow row in dt.Rows)
                        {
                            totalPrice += Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Quantity"]);
                        }
                    }

                    lblTotalPrice.Text = totalPrice.ToString("0.00");
                }
            }
        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int bookId = Convert.ToInt32(btn.CommandArgument);

            // Sepet tablosunu al
            DataTable dt = (DataTable)Session["Cart"];
            DataRow[] rows = dt.Select("BookId=" + bookId);

            if (rows.Length > 0)
            {
                dt.Rows.Remove(rows[0]);
            }

            // Eğer sepet boşaldıysa session'ı temizle ve yönlendir
            if (dt.Rows.Count == 0)
            {
                Session["Cart"] = null;
                Response.Redirect("/Users/Books.aspx");
            }
            else
            {
                Session["Cart"] = dt;
                BindCartItems();  // Sepet güncellenir
            }
        }

        protected void btnUpdateCart_Click(object sender, EventArgs e)
        {
            // Sepet tablosunu al
            DataTable dt = (DataTable)Session["Cart"];

            foreach (RepeaterItem item in rptCartItems.Items)
            {
                TextBox txtQuantity = (TextBox)item.FindControl("txtQuantity");
                int quantity = int.Parse(txtQuantity.Text);

                HiddenField hdnBookId = (HiddenField)item.FindControl("hdnBookId");
                int bookId = int.Parse(hdnBookId.Value);

                // Seçilen ürünün miktarını güncelle
                DataRow[] rows = dt.Select("BookId=" + bookId);
                if (rows.Length > 0)
                {
                    rows[0]["Quantity"] = quantity;
                }
            }

            Session["Cart"] = dt;
            BindCartItems();  // Sepet güncellenir
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Kullanıcıyı satın alma işlemine yönlendir
            Response.Redirect("Checkout.aspx");
        }

        protected void btnContinueShopping_Click(object sender, EventArgs e)
        {
            // Kullanıcıyı kitaplar sayfasına yönlendir
            Response.Redirect("Books.aspx");
        }

    }
}
