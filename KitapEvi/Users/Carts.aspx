<%@ Page Title="" Language="C#" MasterPageFile="~/Users/Users.Master" AutoEventWireup="true" CodeBehind="Carts.aspx.cs" Inherits="KitapEvi.Users.Carts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    .cart-container {
        margin: auto;
        padding: 20px;
    }

    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529;
    }

    .btn {
        padding: 10px 20px;
        cursor: pointer;
    }

    .total-price {
        margin-top: 20px;
        font-weight: bold;
        font-size: 1.5em;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <header class="header_section">
    <div class="container-fluid">
        <nav class="navbar navbar-expand-lg custom_nav-container ">
            <a class="navbar-brand" href="/Users/Defaults.aspx">
                <span>
                    KitapEvim
                </span>
            </a>

            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class=""> </span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link" href="/Users/Defaults.aspx">Ana Sayfa <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Users/Books.aspx"> Kitaplar </a>
                    </li>
                </ul>
                <div class="user_option-box">
                    <a href="/Users/Profiles.aspx">
                        <i class="fa fa-user" aria-hidden="true"></i>
                    </a>
                    <a href='<%= ResolveUrl("~/Users/Carts.aspx") %>'>
                        <i class="fa fa-cart-plus" aria-hidden="true"></i>
                    </a>
                    <a href="#" id="lbLogout" runat="server" onserverclick="lbLogout_Click">
                        <i class="fa fa-sign-out" aria-hidden="true"></i>
                    </a>
                </div>
            </div>
        </nav>
    </div>
</header>
    <br /><br />
    <section class="shop_section layout_padding">
    <div class="container">
        <h2>Sepetim</h2>
        <asp:Repeater ID="rptCartItems" runat="server">
            <HeaderTemplate>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Kitap</th>
                            <th>Fiyat</th>
                            <th>Adet</th>
                            <th>Toplam Fiyat</th>
                            <th>İşlem</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("Title") %></td>
                    <td>₺<%# Eval("Price") %></td>
                    <td><%# Eval("Quantity") %></td>
                    <td>₺<%# Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity")) %></td>
                    <td>
                        <asp:LinkButton ID="btnRemove" runat="server" Text="Kaldır" CommandArgument='<%# Eval("BookId") %>' OnClick="btnRemove_Click" />
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
                <div class="total-price">
                    Toplam Tutar: ₺<asp:Label ID="lblTotalPrice" runat="server"></asp:Label>
                </div>
                <div class="action-buttons">
                    <asp:Button ID="btnContinueShopping" runat="server" Text="Alışverişe Devam Et" OnClick="btnContinueShopping_Click" CssClass="btn btn-primary" />
                    <asp:Button ID="btnCheckout" runat="server" Text="Satın Al" OnClick="btnCheckout_Click" CssClass="btn btn-success" />
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</section><br /><br /><br /><br /><br /><br />
</asp:Content>
