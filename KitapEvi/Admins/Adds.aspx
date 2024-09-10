<%@ Page Title="" Language="C#" MasterPageFile="~/Admins/Admins.Master" AutoEventWireup="true" CodeBehind="Adds.aspx.cs" Inherits="KitapEvi.Admins.Adds" %>
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
                                <!-- Slider İçeriği Ekleme Formu -->
                                <div class="row mt-4">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Başlık</label>
                                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Başlık giriniz"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Açıklama</label>
                                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="Açıklama giriniz" TextMode="MultiLine"></asp:TextBox>
                                        </div>
                                    </div>
                                                                       <div class="col-md-4">
    <div class="form-group">
        <label>Sıra Numarası</label>
        <asp:TextBox ID="txtOrderNumber" runat="server" CssClass="form-control" placeholder="Sıra numarası giriniz"></asp:TextBox>
    </div>
</div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Resim</label>
                                            <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Gizli Alanlar -->
                                <asp:HiddenField ID="hdnId" runat="server" Value="0" />

                                <!-- Kaydet/Güncelle Butonu -->
                                <asp:Button ID="btnSave" runat="server" Text="Kaydet" CssClass="btn btn-primary" OnClick="btnAddOrUpdate_Click" />

                                <h4 class="sub-title mt-4">Slider İçerik Listesi</h4>
                                <div class="table-responsive">
                                  

<asp:GridView ID="gvAddList" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False"
    DataKeyNames="id" OnRowCommand="gvAddList_RowCommand" OnRowEditing="gvAddList_RowEditing">
    <Columns>
        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" Visible="False" />
        <asp:BoundField DataField="title" HeaderText="Başlık" />
        <asp:BoundField DataField="description" HeaderText="Açıklama" />
        <asp:BoundField DataField="order_number" HeaderText="Sıra Numarası" />
        <asp:TemplateField HeaderText="Resim">
            <ItemTemplate>
                <img src='<%# Eval("image_path").ToString() %>' alt="Resim" style="width: 100px; height: 50px;" />
            </ItemTemplate>
        </asp:TemplateField>
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
