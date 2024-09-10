<%@ Page Title="" Language="C#" MasterPageFile="~/Admins/Admins.Master" AutoEventWireup="true" CodeBehind="Categoriess.aspx.cs" Inherits="KitapEvi.Admins.Categoriess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pcoded-inner-content pt-0">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-block">
                                    <!-- Category Entry Form -->
                                    <div class="row mt-4">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Kategori İsmi</label>
                                                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Kategori ismi giriniz"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Güncelleme veya Yeni Kayıt için Gizli Alanlar -->
                                    <asp:HiddenField ID="hdnId" runat="server" Value="0" />

                                    <!-- Kaydet/Güncelle Butonu -->
                                    <asp:Button ID="btnSave" runat="server" Text="Kaydet" CssClass="btn btn-primary" OnClick="btnAddOrUpdate_Click" />

                                    <h4 class="sub-title mt-4">Kategori Listesi</h4>
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvCategoryList" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False"
                                            DataKeyNames="id" OnRowCommand="gvCategoryList_RowCommand" OnRowEditing="gvCategoryList_RowEditing">
                                            <Columns>
                                                <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" Visible="False" />

                                                <asp:BoundField DataField="name" HeaderText="Kategori İsmi" />

                                                <asp:TemplateField HeaderText="İşlemler">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-warning btn-sm" CommandName="Edit" CommandArgument='<%# Eval("id") %>'>
                                                            <i class="fa fa-edit"></i> Düzenle
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" CommandName="Delete" CommandArgument='<%# Eval("id") %>'
                                                            OnClientClick="return confirm('Bu kaydı silmek istediğinizden emin misiniz?');">
                                                            <i class="fa fa-trash"></i> Sil
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
