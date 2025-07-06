<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SinglePage.aspx.cs" Inherits="MeetingMinutesApp.SinglePage" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid">
    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4 p-3 bg-secondary bg-gradient rounded">
        <h4 class="mb-0 text-white">Meeting Minutes</h4>
        <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-warning px-4" />
    </div>

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <h5 class="card-title">Customer Type</h5>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="CustomerType" id="corporateRadio" value="Corporate" checked />
                <label class="form-check-label" for="corporateRadio">Corporate</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="CustomerType" id="individualRadio" value="Individual" />
                <label class="form-check-label" for="individualRadio">Individual</label>
            </div>
        </div>
    </div>

    <!-- Meeting Info -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-secondary bg-gradient text-white">
            <h5 class="mb-0">Meeting Information</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Customer Name</label>
                        <asp:DropDownList ID="ddllCustomer" runat="server" CssClass="form-select" ClientIDMode="Static" />
                        <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select mt-2" ClientIDMode="Static" Style="display:none;" />
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Meeting Date</label>
                            <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Meeting Time</label>
                            <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" placeholder="hh:mm AM/PM" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Meeting Place*</label>
                        <asp:TextBox ID="txtMeetingPlace" runat="server" CssClass="form-control" placeholder="Meeting Place" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Attendees (Client)*</label>
                        <asp:TextBox ID="txtClientAttendees" runat="server" CssClass="form-control" placeholder="Present Client Side" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Attendees (Host)*</label>
                        <asp:TextBox ID="txtHostAttendees" runat="server" CssClass="form-control" placeholder="Present Self Side" />
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Meeting Agenda*</label>
                        <asp:TextBox ID="txtAgenda" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Meeting Agenda" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Meeting Discussion*</label>
                        <asp:TextBox ID="txtDiscussion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Meeting Discussion" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Meeting Decision*</label>
                        <asp:TextBox ID="txtDecision" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Meeting Decision" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Product/Service Selection -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-secondary bg-gradient text-white">
            <h5 class="mb-0">Product / Service</h5>
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label fw-bold">Select Product/Service</label>
                    <asp:DropDownList ID="ddlProductService" runat="server" CssClass="form-select" ClientIDMode="Static" />
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold">Unit</label>
                    <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" ReadOnly="true" ClientIDMode="Static" />
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold">Quantity</label>
                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" ClientIDMode="Static" />
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-secondary w-100" OnClick="btnAdd_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- GridView for Product/Service List -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-secondary bg-gradient text-white">
            <h5 class="mb-0">Selected Products/Services</h5>
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvDetails" runat="server" CssClass="table table-hover m-0" AutoGenerateColumns="false" OnRowDeleting="gvDetails_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="SL." HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <%# Container.DataItemIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ProductServiceName" HeaderText="Service Name" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                    <asp:BoundField DataField="Unit" HeaderText="Unit" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                    <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <asp:Button ID="btnEditRow" runat="server" Text="✏️" CssClass="btn btn-sm btn-outline-info" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowDeleteButton="true" DeleteText="❌" ButtonType="Button" ControlStyle-CssClass="btn btn-sm btn-outline-danger" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <div class="d-flex justify-content-start gap-3 mb-5">
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-success px-4" OnClick="btnSave_Click" />
        <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-secondary px-4" OnClick="btnRefresh_Click" />
    </div>
</div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#ddllCustomer').show();
            $('#ddlCustomer').hide();

            $('input[name="CustomerType"]').change(function () {
                var selected = $(this).val();
                if (selected === "Corporate") {
                    $('#ddllCustomer').show();
                    $('#ddlCustomer').hide();
                } else {
                    $('#ddlCustomer').show();
                    $('#ddllCustomer').hide();
                }
            });

            $('#ddlProductService').change(function () {
                var productId = $(this).val();
                $.ajax({
                    type: "POST",
                    url: "SinglePage.aspx/GetUnit",
                    data: JSON.stringify({ productId: parseInt(productId) }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $('#txtUnit').val(response.d);
                    },
                    error: function (xhr, status, error) {
                        console.error("Error: ", xhr.responseText);
                    }
                });
            });

            $('#txtQuantity').on('input', function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        });
    </script>

</asp:Content>
