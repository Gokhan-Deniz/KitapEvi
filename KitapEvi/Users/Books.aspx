<%@ Page Title="" Language="C#" MasterPageFile="~/Users/Users.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="KitapEvi.Users.Books" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />

    <!-- jQuery ve Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <!-- CSS Tasarımı -->
    <style>
        /* Kategori Kutucuğu */
        .category-filter-box {
            background-color: rgba(255, 255, 255, 0.7); /* Saydam beyaz kutu */
            border-radius: 15px; /* Köşeleri kavisli yap */
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Hafif gölge */
        }

        /* Kategorilerdeki linklerin tasarımı */
        .category-filter-box h4 {
            margin-bottom: 15px;
        }

        .category-filter-box a {
            display: inline-block;
            margin-right: 10px;
            padding: 5px 15px;
            background-color: #007bff;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .category-filter-box a:hover {
            background-color: #0056b3;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <!-- header section strats -->
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
<!-- end header section -->
    <!-- shop section -->

  <section class="shop_section layout_padding">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <!-- Category Dropdown -->
                    <asp:DropDownList ID="ddlCategories" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCategories_SelectedIndexChanged">
                        <asp:ListItem Value="0" Text="Tüm Kategoriler" />
                    </asp:DropDownList>
                </div>

                <div class="col-md-4 mb-3">
                    <!-- Search Bar -->
                    <asp:TextBox ID="txtSearch" CssClass="form-control" runat="server" AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" placeholder="Kitap İsmi Ara"></asp:TextBox>
                </div>
                
                <div class="col-md-4 mb-3">
                    <!-- Sorting Dropdown -->
                    <asp:DropDownList ID="ddlSorting" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSorting_SelectedIndexChanged">
                        <asp:ListItem Value="none" Text="Tüm Sıralamalar" />
                        <asp:ListItem Value="name_asc" Text="İsme Göre Artan" />
                        <asp:ListItem Value="name_desc" Text="İsme Göre Azalan" />
                        <asp:ListItem Value="price_asc" Text="Fiyata Göre Artan" />
                        <asp:ListItem Value="price_desc" Text="Fiyata Göre Azalan" />
                        <asp:ListItem Value="sales_asc" Text="Satış Miktarına Göre Artan" />
                        <asp:ListItem Value="sales_desc" Text="Satış Miktarına Göre Azalan" />
                    </asp:DropDownList>
                </div>
                <br />
                <!-- Kitap Listesi -->
                <div class="col-md-12">
                    <div class="heading_container heading_center">
                        <h2>Kitaplar</h2>
                    </div>
                    <div class="row">
                        <asp:Repeater ID="rptBooks" runat="server">
                            <ItemTemplate>
                                <div class="col-md-6 col-xl-3">
                                    <div class="box">
                                        <a href="#" data-toggle="modal" data-target="#bookModal<%# Eval("Id") %>">
                                            <div class="img-box">
                                                <img src='<%# ResolveUrl(Eval("cover_image") != DBNull.Value ? Eval("cover_image").ToString() : "~/TemplateFiles/images/default-book.png") %>' alt="">
                                            </div>
                                            <div class="detail-box">
                                                <h6><%# Eval("Title") %></h6>
                                                <h6>Fiyat: <span>₺<%# Eval("Price") %></span></h6>
                                            </div>
                                        </a>
                                        <asp:Button ID="btnAddToCart" runat="server" Text="Sepete Ekle" CommandArgument='<%# Eval("id") %>' OnClick="btnAddToCart_Click" CssClass="btn btn-success" />
                                    </div>
                                </div>

                                <!-- Kitap Detayları Modal -->
                                <div class="modal fade" id="bookModal<%# Eval("Id") %>" tabindex="-1" role="dialog" aria-labelledby="bookModalLabel" aria-hidden="true">
                                    <div class="modal-dialog" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="bookModalLabel"><%# Eval("title") %></h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <img src='<%# ResolveUrl(Eval("cover_image") != DBNull.Value ? Eval("cover_image").ToString() : "~/TemplateFiles/images/default-book.png") %>' class="img-fluid" alt="">
                                                    </div>
                                                    <div class="col-md-8">
                                                        <p><strong>Açıklama:</strong> <%# Eval("description") %></p>
                                                        <p><strong>Zorluk Seviyesi:</strong> <%# Eval("difficulty_level") %></p>
                                                        <p><strong>Okuma Süresi:</strong> <%# Eval("average_reading_time") %> saat</p>
                                                        <p><strong>Fiyat:</strong> ₺<%# Eval("price") %></p>
                                                        <p><strong>İndirim:</strong> <%# Eval("discount") %> %</p>
                                                        <p><strong>Satış:</strong> <%# Eval("sold_count") %> adet</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <asp:Button ID="btnModalAddToCart" runat="server" CssClass="btn btn-success" Text="Sepete Ekle" CommandArgument='<%# Eval("Id") %>' OnClick="btnAddToCart_Click" />
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Kapat</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </section>

  <!-- end shop section -->
</asp:Content>
