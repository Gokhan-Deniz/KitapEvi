<%@ Page Title="" Language="C#" MasterPageFile="~/Admins/Admins.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="KitapEvi.Admins.Books" %>
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
                                    <!-- Book Entry Form -->
                                    <div class="row mt-4">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Kitap İsmi</label>
                                                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Kitap ismi giriniz" required></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Açıklama</label>
                                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="Açıklama giriniz" TextMode="MultiLine" required></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Zorluk Seviyesi</label>
                                                <asp:TextBox ID="txtDifficultyLevel" runat="server" CssClass="form-control" placeholder="Zorluk seviyesi giriniz"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Ortalama Okuma Süresi (Saat)</label>
                                                <asp:TextBox ID="txtAverageReadingTime" runat="server" CssClass="form-control" placeholder="Ortalama okuma süresi giriniz"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Fiyat</label>
                                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="Fiyat giriniz"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>İndirim</label>
                                                <asp:TextBox ID="txtDiscount" runat="server" CssClass="form-control" placeholder="İndirim giriniz"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Kategori</label>
                                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Kitap Dosyası</label>
                                                <asp:FileUpload ID="fuPdfFile" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Kapak Resmi</label>
                                                <asp:FileUpload ID="fuCoverImage" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Aktif Mi?</label>
                                                <asp:CheckBox ID="chkIsActive" runat="server" />
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Güncelleme veya Yeni Kayıt için Gizli Alanlar -->
                                    <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                                    <asp:HiddenField ID="hdnPdfFile" runat="server" />
                                    <asp:HiddenField ID="hdnCoverImage" runat="server" />

                                    <!-- Kaydet/Güncelle Butonu -->
                                    <asp:Button ID="btnSave" runat="server" Text="Kaydet" CssClass="btn btn-primary" OnClick="btnAddOrUpdate_Click" />

                                    <h4 class="sub-title mt-4">Kitap Listesi</h4>
<div class="table-responsive">
    <asp:GridView ID="gvBookList" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False"
        DataKeyNames="id" OnRowCommand="gvBookList_RowCommand" OnRowEditing="gvBookList_RowEditing">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" Visible="False" />

            <asp:BoundField DataField="title" HeaderText="Kitap İsmi" />

            <asp:BoundField DataField="description" HeaderText="Açıklama" />

            <asp:BoundField DataField="difficulty_level" HeaderText="Zorluk Seviyesi" />

            <asp:BoundField DataField="average_reading_time" HeaderText="Okuma Süresi (Saat)" />

            <asp:BoundField DataField="price" HeaderText="Fiyat" />

            <asp:BoundField DataField="discount" HeaderText="İndirim" />

            <asp:BoundField DataField="category_name" HeaderText="Kategori" />

            <asp:TemplateField HeaderText="Aktif Mi?">
                <ItemTemplate>
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked='<%# Convert.ToBoolean(Eval("is_active")) %>' Enabled="false" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Kitap Dosyası (PDF)">
                <ItemTemplate>
                    <asp:HyperLink ID="hlPdfFile" runat="server" Text="PDF Görüntüle" 
                        NavigateUrl='<%# ResolveUrl(Eval("pdf_file").ToString()) %>' Target="_blank"
                        OnClientClick="window.open(this.href, '_blank'); return false;" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Kapak Resmi">
                <ItemTemplate>
                    <asp:HyperLink ID="hlCoverImage" runat="server" 
                        NavigateUrl='<%# ResolveUrl(Eval("cover_image").ToString()) %>' Target="_blank">
                        <img src='<%# ResolveUrl(Eval("cover_image").ToString()) %>' alt="Kapak Resmi" style="width: 50px; height: 50px;" />
                    </asp:HyperLink>
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
