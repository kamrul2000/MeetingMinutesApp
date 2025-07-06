using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace MeetingMinutesApp
{
    [Serializable]
    public class DetailItem
    {
        public int ProductServiceId { get; set; }
        public string ProductServiceName { get; set; }
        public string Unit { get; set; }
        public int Quantity { get; set; }
    }

    [Serializable]
    public class CustomerItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public partial class SinglePage : System.Web.UI.Page
    {
        private string conStr = ConfigurationManager.ConnectionStrings["MeetingDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductService();
                LoadCorporateCustomers();
                LoadIndividualCustomers();
                ViewState["Details"] = new List<DetailItem>();
                BindGrid();
            }
        }

        private void LoadProductService()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Products_Service_Tbl", con);
                SqlDataReader rdr = cmd.ExecuteReader();
                ddlProductService.DataSource = rdr;
                ddlProductService.DataTextField = "Name";
                ddlProductService.DataValueField = "Id";
                ddlProductService.DataBind();
            }
        }

        private void LoadCorporateCustomers()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Corporate_Customer_Tbl", con);
                SqlDataReader rdr = cmd.ExecuteReader();
                ddllCustomer.DataSource = rdr;
                ddllCustomer.DataTextField = "Name";
                ddllCustomer.DataValueField = "Id";
                ddllCustomer.DataBind();
                ddllCustomer.Items.Insert(0, new ListItem("-- Select Customer --", ""));
            }
        }

        private void LoadIndividualCustomers()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Individual_Customer_Tbl", con);
                SqlDataReader rdr = cmd.ExecuteReader();
                ddlCustomer.DataSource = rdr;
                ddlCustomer.DataTextField = "Name";
                ddlCustomer.DataValueField = "Id";
                ddlCustomer.DataBind();
                ddlCustomer.Items.Insert(0, new ListItem("-- Select Customer --", ""));
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            List<DetailItem> list = (List<DetailItem>)ViewState["Details"];

            list.Add(new DetailItem
            {
                ProductServiceId = int.Parse(ddlProductService.SelectedValue),
                ProductServiceName = ddlProductService.SelectedItem.Text,
                Unit = txtUnit.Text,
                Quantity = int.Parse(txtQuantity.Text)
            });

            ViewState["Details"] = list;
            BindGrid();
            txtQuantity.Text = "";
        }

        protected void gvDetails_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            List<DetailItem> list = (List<DetailItem>)ViewState["Details"];
            list.RemoveAt(e.RowIndex);
            ViewState["Details"] = list;
            BindGrid();
        }

        private void BindGrid()
        {
            gvDetails.DataSource = (List<DetailItem>)ViewState["Details"];
            gvDetails.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string customerType = Request.Form["CustomerType"];
            int customerId = customerType == "Corporate"
                ? int.Parse(ddllCustomer.SelectedValue)
                : int.Parse(ddlCustomer.SelectedValue);

            DateTime date = DateTime.Parse(txtDate.Text);
            string time = txtTime.Text;
            string place = txtMeetingPlace.Text;
            string hostAttendees = txtHostAttendees.Text;
            string clientAttendees = txtClientAttendees.Text;
            string agenda = txtAgenda.Text;
            string discussion = txtDiscussion.Text;
            string decision = txtDecision.Text;

            int masterId = 0;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand("Meeting_Minutes_Master_Save_SP", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CustomerType", customerType);
                cmd.Parameters.AddWithValue("@CustomerId", customerId);
                cmd.Parameters.AddWithValue("@MeetingDate", date);
                cmd.Parameters.AddWithValue("@MeetingTime", time);
                cmd.Parameters.AddWithValue("@MeetingPlace", place);
                cmd.Parameters.AddWithValue("@HostAttendees", hostAttendees);
                cmd.Parameters.AddWithValue("@ClientAttendees", clientAttendees);
                cmd.Parameters.AddWithValue("@Agenda", agenda);
                cmd.Parameters.AddWithValue("@Discussion", discussion);
                cmd.Parameters.AddWithValue("@Decision", decision);

                SqlParameter outputId = new SqlParameter("@NewId", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(outputId);

                cmd.ExecuteNonQuery();
                masterId = Convert.ToInt32(outputId.Value);

                List<DetailItem> list = (List<DetailItem>)ViewState["Details"];
                foreach (var item in list)
                {
                    SqlCommand cmdDetail = new SqlCommand("Meeting_Minutes_Details_Save_SP", con);
                    cmdDetail.CommandType = CommandType.StoredProcedure;
                    cmdDetail.Parameters.AddWithValue("@MasterId", masterId);
                    cmdDetail.Parameters.AddWithValue("@ProductServiceId", item.ProductServiceId);
                    cmdDetail.Parameters.AddWithValue("@Unit", item.Unit);
                    cmdDetail.Parameters.AddWithValue("@Quantity", item.Quantity);
                    cmdDetail.ExecuteNonQuery();
                }
            }

            // Optionally show a success message or clear form
            ViewState["Details"] = new List<DetailItem>();
            BindGrid();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.RawUrl); // reload the page
        }

        [WebMethod]
        public static List<CustomerItem> GetCustomers(string customerType)
        {
            string conStr = ConfigurationManager.ConnectionStrings["MeetingDBConnection"].ConnectionString;
            List<CustomerItem> customers = new List<CustomerItem>();

            try
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    con.Open();
                    string tableName = customerType == "Corporate" ? "Corporate_Customer_Tbl" : "Individual_Customer_Tbl";
                    SqlCommand cmd = new SqlCommand($"SELECT Id, Name FROM {tableName}", con);
                    SqlDataReader rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        customers.Add(new CustomerItem
                        {
                            Id = Convert.ToInt32(rdr["Id"]),
                            Name = rdr["Name"].ToString()
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetCustomers: {ex.Message}");
            }

            return customers;
        }

        [WebMethod]
        public static string GetUnit(int productId)
        {
            string conStr = ConfigurationManager.ConnectionStrings["MeetingDBConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Unit FROM Products_Service_Tbl WHERE Id = @Id", con);
                cmd.Parameters.AddWithValue("@Id", productId);
                return Convert.ToString(cmd.ExecuteScalar());
            }
        }
    }
}
