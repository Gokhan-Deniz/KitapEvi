<%@ Page Title="" Language="C#" MasterPageFile="~/Users/Users.Master" AutoEventWireup="true" CodeBehind="Defaults.aspx.cs" Inherits="KitapEvi.Users.Defaults" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="hero_area">
    <div class="hero_social">
        <a href="">
            <i class="fa fa-facebook" aria-hidden="true"></i>
        </a>
        <a href="">
            <i class="fa fa-twitter" aria-hidden="true"></i>
        </a>
        <a href="">
            <i class="fa fa-linkedin" aria-hidden="true"></i>
        </a>
        <a href="">
            <i class="fa fa-instagram" aria-hidden="true"></i>
        </a>
    </div>
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
    <!-- slider section -->
    <section class="slider_section">
    <div id="customCarousel1" class="carousel slide" data-ride="carousel" data-interval="6000">
        <div class="carousel-inner">
            <asp:Literal ID="litSliderContent" runat="server"></asp:Literal>
        </div>
        <ol class="carousel-indicators">
            <asp:Literal ID="litIndicatorsContent" runat="server"></asp:Literal>
        </ol>
    </div>
</section>
    <!-- end slider section -->
</div>

<!-- shop section -->
<section class="shop_section layout_padding">
    <div class="container">
        <div class="heading_container heading_center">
            <h2>Son Çıkan Kitaplar</h2>
        </div>
        <div class="row">
            <asp:Repeater ID="rptBooks" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-xl-3">
                        <div class="box">
                            <!-- Kitap Detayları İçin Modal Tetikleyici -->
                            <a href="#" data-toggle="modal" data-target="#bookModal<%# Eval("Id") %>">
                                <div class="img-box">
                                    <img src='<%# ResolveUrl(Eval("cover_image") != DBNull.Value ? Eval("cover_image").ToString() : "~/TemplateFiles/images/default-book.png") %>' alt="">
                                </div>
                                <div class="detail-box">
                                    <h6><%# Eval("Title") %></h6>
                                    <h6>Fiyat: <span>₺<%# Eval("Price") %></span></h6>
                                </div>
                                <div class="new">
                                    <span>Yeni</span>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- Kitap Detaylarını Gösteren Modal -->
                    <div class="modal fade" id="bookModal<%# Eval("Id") %>" tabindex="-1" role="dialog" aria-labelledby="bookModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="bookModalLabel"><%# Eval("Title") %></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <!-- Sol Kısım - Kitap Kapağı -->
                                        <div class="col-md-4">
                                            <img src='<%# ResolveUrl(Eval("cover_image") != DBNull.Value ? Eval("cover_image").ToString() : "~/TemplateFiles/images/default-book.png") %>' class="img-fluid" alt="">
                                        </div>

                                        <!-- Sağ Kısım - Kitap Bilgileri -->
                                        <div class="col-md-8">
                                            <p><strong>Açıklama:</strong> <%# Eval("Description") %></p>
                                            <p><strong>Zorluk Seviyesi:</strong> <%# Eval("difficulty_level") %></p>
                                            <p><strong>Okuma Süresi:</strong> <%# Eval("average_reading_time") %> saat</p>
                                            <p><strong>Fiyat:</strong> ₺<%# Eval("Price") %></p>
                                            <p><strong>İndirim:</strong> <%# Eval("Discount") %> %</p>
                                            <p><strong>Satış Sayısı:</strong> <%# Eval("sold_count") %></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Kapat</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="btn-box">
            <a href="/Users/Books.aspx">Hepsine Bak</a>
        </div>
    </div>
</section>


<!-- end shop section -->

<!-- Top seller section -->
    <section class="shop_section layout_padding">
    <div class="container">
        <div class="heading_container heading_center">
            <h2>En Çok Satan Kitaplar</h2>
        </div>
        <div class="row">
            <asp:Repeater ID="rptTopSellingBooks" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-xl-3">
                        <div class="box">
                            <!-- Kitap Detayları İçin Modal Tetikleyici -->
                            <a href="#" data-toggle="modal" data-target="#topSellingBookModal<%# Eval("Id") %>">
                                <div class="img-box">
                                    <img src='<%# ResolveUrl(Eval("cover_image") != DBNull.Value ? Eval("cover_image").ToString() : "~/TemplateFiles/images/default-book.png") %>' alt="">
                                </div>
                                <div class="detail-box">
                                    <h6><%# Eval("Title") %></h6>
                                    <h6>Fiyat: <span>₺<%# Eval("Price") %></span></h6>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- Kitap Detaylarını Gösteren Modal -->
                    <div class="modal fade" id="topSellingBookModal<%# Eval("Id") %>" tabindex="-1" role="dialog" aria-labelledby="bookModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="bookModalLabel"><%# Eval("Title") %></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <!-- Sol Kısım - Kitap Kapağı -->
                                        <div class="col-md-4">
                                            <img src='<%# ResolveUrl(Eval("cover_image") != DBNull.Value ? Eval("cover_image").ToString() : "~/TemplateFiles/images/default-book.png") %>' class="img-fluid" alt="">
                                        </div>

                                        <!-- Sağ Kısım - Kitap Bilgileri -->
                                        <div class="col-md-8">
                                            <p><strong>Açıklama:</strong> <%# Eval("Description") %></p>
                                            <p><strong>Zorluk Seviyesi:</strong> <%# Eval("difficulty_level") %></p>
                                            <p><strong>Okuma Süresi:</strong> <%# Eval("average_reading_time") %> saat</p>
                                            <p><strong>Fiyat:</strong> ₺<%# Eval("Price") %></p>
                                            <p><strong>İndirim:</strong> <%# Eval("Discount") %> %</p>
                                            <p><strong>Satış Sayısı:</strong> <%# Eval("sold_count") %></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Kapat</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="btn-box">
            <a href="/Users/Books.aspx">Hepsine Bak</a>
        </div>
    </div>
</section>

<!-- Top seller section end -->
<!-- about section -->

<section class="about_section layout_padding">
    <div class="container">
        <div class="row">
            <div class="col-md-6 col-lg-3">
                <div class="img-box">
                    <img src="../TemplateFiles/images/about.png" alt="">
                </div><br />
            </div>
            <div class="col-md-6 col-lg-9">
                <div class="detail-box">
                    <div class="row">
                        <div class="col-sm-5 col-lg-3">
                            <div class="box">
                                <div class="img-box">
                                    <img src="../TemplateFiles/images/aboutt.png" alt="">
                                </div><br />
                                <div class="detail-box">
                                    <h4>
                                        Hakkımızda
                                    </h4>
                                    <p>
                                        Kitap tutkunlarının buluşma noktası olan KitapEvim, sizlere en geniş kitap yelpazesini sunmak için kuruldu. Amacımız, her yaştan ve her zevkten okuyucunun aradığı kitabı kolayca bulabileceği, güvenli ve keyifli bir alışveriş deneyimi yaşamasını sağlamaktır.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-5 col-lg-3">
                            <div class="box">
                                <div class="img-box">
                                    <img src="../TemplateFiles/images/mission.png" alt="">
                                </div><br />
                                <div class="detail-box">
                                    <h4>
                                        Misyonumuz
                                    </h4>
                                    <p>
                                        Kitapların büyülü dünyasını herkesle buluşturmak ve okuma alışkanlığını yaygınlaştırmak. Siz değerli okuyucularımıza en güncel ve popüler kitapları, uygun fiyatlarla ve hızlı teslimat seçenekleriyle sunmak için buradayız.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-5 col-lg-3">
                            <div class="box">
                                <div class="img-box">
                                    <img src="../TemplateFiles/images/vision.png" alt="">
                                </div><br />
                                <div class="detail-box">
                                    <h4>
                                        Vizyonumuz
                                    </h4>
                                    <p>
                                        Dijital çağın gereksinimlerine uygun olarak, kitap okuma deneyimini online platforma taşımak ve bu alanda öncü bir marka olmak. Teknolojinin sunduğu imkanlarla, kitap okuma alışkanlığını daha erişilebilir ve keyifli hale getirmek.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-5 col-lg-3">
                            <div class="box">
                                <div class="img-box">
                                    <img src="../TemplateFiles/images/whoarewe.png" alt="">
                                </div><br />
                                <div class="detail-box">
                                    <h4>
                                        Biz Kimiz?
                                    </h4>
                                    <p>
                                        Kitaplara gönül vermiş bir ekip olarak, sizlere en iyi hizmeti sunmak için buradayız. 2024 yılında kurulan KitapEvim, kısa sürede kitap severlerin vazgeçilmez adresi olmayı başardı. Müşteri memnuniyetini her zaman ön planda tutarak, sizlere en iyi alışveriş deneyimini sunmayı hedefliyoruz.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- end about section -->
<!-- contact section -->

<section class="contact_section">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="form_container">
                    <div class="heading_container">
                        <h2>
                            İletişim
                        </h2>
                    </div>
                    <form id="contactForm">
                        <div>
                            <input type="text" id="txtName" placeholder="İsminiz" required />
                        </div>
                        <div>
                            <input type="email" id="txtEmail" placeholder="Email" required />
                        </div>
                        <div>
                            <textarea id="txtMessage" class="message-box" placeholder="Mesajınız" required></textarea>
                        </div>
                        <div class="d-flex">
                            <button type="button" onclick="sendEmail()">
                                Gönder
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-md-6">
                <div class="img-box">
                    <img src="../TemplateFiles/images/img-contact.jpg" alt="">
                </div>
            </div>
        </div>
    </div>
</section>
<!-- end contact section -->
</asp:Content>
