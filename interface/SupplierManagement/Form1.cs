using System;
using System.Data;
using System.Windows.Forms;
using Npgsql;

namespace SupplierManagement
{
    public partial class Form1 : Form
    {
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=asdrty12;Database=PCStore";
        private string formName;
        public Form1()
        {
            InitializeComponent();
            LoadSuppliers();
        }

        private void LoadSuppliers()
        {
            try
            {
                using (var conn = new NpgsqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT * FROM suppliers";
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dataGridSuppliers.DataSource = dt;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading suppliers: {ex.Message}");
            }
        }

        private void button1_Click(object sender, EventArgs e) // Insert
        {
            if (string.IsNullOrWhiteSpace(txtSupplierID.Text))
            {
                MessageBox.Show("Supplier ID cannot be empty.");
                return;
            }

            try
            {
                using (var connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "INSERT INTO suppliers (\"supplierID\", name, city, address, contactemail, phonenumber) " +
                                   "VALUES (@supplierID, @name, @city, @address, @contactemail, @phonenumber)";
                    using (var cmd = new NpgsqlCommand(query, connection))
                    {
                        cmd.Parameters.Add("@supplierID", NpgsqlTypes.NpgsqlDbType.Integer).Value = int.Parse(txtSupplierID.Text);
                        cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtName.Text;
                        cmd.Parameters.Add("@city", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtCity.Text;
                        cmd.Parameters.Add("@address", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtAddress.Text;
                        cmd.Parameters.Add("@contactemail", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtContactEmail.Text;
                        cmd.Parameters.Add("@phonenumber", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtPhoneNumber.Text;

                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Supplier added successfully.");
                        LoadSuppliers();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error adding supplier: {ex.Message}");
            }
        }

        private void button2_Click(object sender, EventArgs e) // Update
        {
            try
            {
                using (var conn = new NpgsqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE suppliers SET name = @name, address = @address, city = @city, " +
                                   "contactemail = @contactemail, phonenumber = @phonenumber WHERE \"supplierID\" = @supplierID";
                    using (var cmd = new NpgsqlCommand(query, conn))
                    {
                        cmd.Parameters.Add("@supplierID", NpgsqlTypes.NpgsqlDbType.Integer).Value = int.Parse(txtSupplierID.Text);
                        cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtName.Text;
                        cmd.Parameters.Add("@address", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtAddress.Text;
                        cmd.Parameters.Add("@city", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtCity.Text;
                        cmd.Parameters.Add("@contactemail", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtContactEmail.Text;
                        cmd.Parameters.Add("@phonenumber", NpgsqlTypes.NpgsqlDbType.Varchar).Value = txtPhoneNumber.Text;

                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Supplier updated successfully.");
                        LoadSuppliers();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error updating supplier: {ex.Message}");
            }
        }

        private void button3_Click(object sender, EventArgs e) // Delete
        {
            if (string.IsNullOrWhiteSpace(txtSupplierID.Text))
            {
                MessageBox.Show("Please enter a valid Supplier ID to delete.");
                return;
            }

            try
            {
                using (var conn = new NpgsqlConnection(connectionString))
                {
                    conn.Open();

                    // Kontrol amaçlı silinecek kaydı doğrulama
                    string checkQuery = "SELECT * FROM suppliers WHERE \"supplierID\" = @supplierID";
                    using (var checkCmd = new NpgsqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.Add("@supplierID", NpgsqlTypes.NpgsqlDbType.Integer).Value = int.Parse(txtSupplierID.Text);
                        using (var reader = checkCmd.ExecuteReader())
                        {
                            if (!reader.HasRows)
                            {
                                MessageBox.Show("No supplier found with the given Supplier ID.");
                                return; // Kaydı bulamadığı için silme işlemini durdur
                            }
                        }
                    }

                    // DELETE sorgusu
                    string deleteQuery = "DELETE FROM suppliers WHERE \"supplierID\" = @supplierID";
                    using (var deleteCmd = new NpgsqlCommand(deleteQuery, conn))
                    {
                        deleteCmd.Parameters.Add("@supplierID", NpgsqlTypes.NpgsqlDbType.Integer).Value = int.Parse(txtSupplierID.Text);

                        int rowsAffected = deleteCmd.ExecuteNonQuery(); // Etkilenen satır sayısını al
                        if (rowsAffected > 0)
                        {
                            MessageBox.Show("Supplier deleted successfully.");
                        }
                        else
                        {
                            MessageBox.Show("Deletion failed. Please check the Supplier ID.");
                        }

                        // Veritabanını güncelle
                        LoadSuppliers();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error deleting supplier: {ex.Message}");
            }
        }

        private void button4_Click(object sender, EventArgs e) // Search
        {
            try
            {
                using (var conn = new NpgsqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT * FROM suppliers WHERE name ILIKE @name";
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(query, conn);
                    da.SelectCommand.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = "%" + txtName.Text + "%";
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dataGridSuppliers.DataSource = dt;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error searching suppliers: {ex.Message}");
            }
        }

        private void dataGridSuppliers_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridSuppliers.Rows[e.RowIndex];
                txtSupplierID.Text = row.Cells["supplierID"]?.Value?.ToString();
                txtName.Text = row.Cells["name"]?.Value?.ToString();
                txtAddress.Text = row.Cells["address"]?.Value?.ToString();
                txtCity.Text = row.Cells["city"]?.Value?.ToString();
                txtContactEmail.Text = row.Cells["contactemail"]?.Value?.ToString();
                txtPhoneNumber.Text = row.Cells["phonenumber"]?.Value?.ToString();
            }
        }
    }
}