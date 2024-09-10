<%@ Page Title="" Language="C#" MasterPageFile="~/Users/Users.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="KitapEvi.Users.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .error-message {
            color: red;
        }
        .success-message {
            color: green;
        }
        .register-form {
            max-width: 400px;
            margin: auto;
        }
        .form-container {
            background-color: #f7f7f7;
            padding: 30px;
            border-radius: 8px;
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
            </div>
        </nav>
    </div>
</header><br /><br />
    <div class="register-form">
        <div class="form-container">
            <h2>Kayıt Ol</h2>

            <!-- Name input -->
            <div class="form-group">
                <label for="txtName">Ad</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Adınızı girin"></asp:TextBox>
            </div>

            <!-- Email input -->
            <div class="form-group">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email adresinizi girin"></asp:TextBox>
            </div>

            <!-- Password input -->
            <div class="form-group">
                <label for="txtPassword">Şifre</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Şifrenizi girin" TextMode="Password"></asp:TextBox>
            </div>

            <!-- Error Message Label -->
            <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>

            <!-- Success Message Label -->
            <asp:Label ID="lblSuccess" runat="server" CssClass="success-message" Visible="false"></asp:Label>

            <!-- Register button -->
            <div class="form-group">
                <asp:Button ID="btnRegister" runat="server" Text="Kayıt Ol" CssClass="btn btn-primary" OnClick="btnRegister_Click" />
            </div>
            <br />
            <!-- Login Link -->
            <div class="form-group">
                <p>Hesabınız var mı? <a href="Logins.aspx">Giriş Yap</a></p>
            </div>
        </div>
    </div><br /><br /><br /><br />
</asp:Content>
