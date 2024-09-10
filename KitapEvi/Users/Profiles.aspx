<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Users/Users.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="KitapEvi.Users.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-container {
            max-width: 800px;
            margin: auto;
            padding: 20px;
            background-color: #f7f7f7;
            border-radius: 8px;
        }

        .profile-section {
            margin-bottom: 20px;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
        }

        .btn-primary {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .table {
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
        }

        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.05);
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
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link" href="/Users/Defaults.aspx">Ana Sayfa</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Users/Books.aspx">Kitaplar</a>
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
    <div class="profile-container">
        <div class="profile-header">
            <h2>Profilim</h2>
        </div>

        <!-- User Information Section -->
        <div class="profile-section">
            <h3>Kullanıcı Bilgileri</h3>
            <div class="form-group">
                <label for="txtName">Ad Soyad</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" Placeholder="Adınız ve soyadınız"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtPassword">Yeni Şifre</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="Şifrenizi güncelleyin"></asp:TextBox>
            </div>
            <asp:Button ID="btnUpdateProfile" runat="server" Text="Güncelle" CssClass="btn btn-primary" OnClick="btnUpdateProfile_Click" />
        </div>

        <!-- Borrowed Books Section (Order History) -->
        <div class="profile-section">
            <h3>Alınan Kitaplar (Sipariş Geçmişi)</h3>
            <asp:GridView ID="gvBorrowedBooks" runat="server" CssClass="table table-striped" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="BookTitle" HeaderText="Kitap Adı" />
                    <asp:BoundField DataField="BorrowDate" HeaderText="Alış Tarihi" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="ReturnDate" HeaderText="İade Tarihi" DataFormatString="{0:dd/MM/yyyy}" />
                </Columns>
            </asp:GridView>
        </div>
    </div><br /><br />
</asp:Content>
