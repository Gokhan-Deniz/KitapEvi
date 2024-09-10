<%@ Page Title="" Language="C#" MasterPageFile="~/Admins/Admins.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="KitapEvi.Admins.Users" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-inline {
            display: flex;
            gap: 10px; /* TextBox'lar arasında boşluk bırakır */
            flex-wrap: wrap;
            align-items: center;
        }

        .form-inline .form-control {
            min-width: 150px; /* Her TextBox için minimum genişlik */
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="container mt-4">
        <h2>Kullanıcılar</h2>
        <!-- Kullanıcı detayları için yatay form -->
        <div class="form-inline mb-3">
            <asp:HiddenField ID="hfUserId" runat="server" />
            <asp:Label AssociatedControlID="txtName" runat="server" Text="Ad:" CssClass="form-label" />
            <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>

            <asp:Label AssociatedControlID="txtEmail" runat="server" Text="Email:" CssClass="form-label" />
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>

            <asp:Label AssociatedControlID="txtPassword" runat="server" Text="Şifre:" CssClass="form-label" />
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>

            <asp:Label AssociatedControlID="ddlRole" runat="server" Text="Role:" CssClass="form-label" />
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                <asp:ListItem Value="user">USER</asp:ListItem>
                <asp:ListItem Value="admin">ADMIN</asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnSaveChanges" runat="server" CssClass="btn btn-primary" Text="KAYDET" OnClick="btnSaveChanges_Click" />
        </div>

        <!-- Kullanıcı listeleme tablosu -->
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" OnRowCommand="gvUsers_RowCommand">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="Role" HeaderText="Role" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" CommandName="EditUser" CommandArgument="<%# Container.DataItemIndex %>" Text="Düzenle" CssClass="btn btn-primary btn-sm" />
                        <asp:Button ID="btnDelete" runat="server" CommandName="DeleteUser" CommandArgument="<%# Container.DataItemIndex %>" Text="Sil" CssClass="btn btn-danger btn-sm" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>
