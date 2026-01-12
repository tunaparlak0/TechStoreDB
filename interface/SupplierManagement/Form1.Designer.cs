namespace SupplierManagement
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.txtSupplierID = new System.Windows.Forms.TextBox();
            this.txtName = new System.Windows.Forms.TextBox();
            this.txtAddress = new System.Windows.Forms.TextBox();
            this.txtCity = new System.Windows.Forms.TextBox();
            this.txtContactEmail = new System.Windows.Forms.TextBox();
            this.txtPhoneNumber = new System.Windows.Forms.TextBox();
            this.SupplierID = new System.Windows.Forms.Label();
            this.Name = new System.Windows.Forms.Label();
            this.Address = new System.Windows.Forms.Label();
            this.City = new System.Windows.Forms.Label();
            this.Email = new System.Windows.Forms.Label();
            this.Phone = new System.Windows.Forms.Label();
            this.dataGridSuppliers = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridSuppliers)).BeginInit();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(511, 48);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "Insert";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(511, 109);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 1;
            this.button2.Text = "Update";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(511, 173);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 2;
            this.button3.Text = "Delete";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(511, 245);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(75, 23);
            this.button4.TabIndex = 3;
            this.button4.Text = "Search";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // txtSupplierID
            // 
            this.txtSupplierID.Location = new System.Drawing.Point(174, 18);
            this.txtSupplierID.Name = "txtSupplierID";
            this.txtSupplierID.Size = new System.Drawing.Size(100, 22);
            this.txtSupplierID.TabIndex = 4;
            // 
            // txtName
            // 
            this.txtName.Location = new System.Drawing.Point(174, 64);
            this.txtName.Name = "txtName";
            this.txtName.Size = new System.Drawing.Size(100, 22);
            this.txtName.TabIndex = 5;
            // 
            // txtAddress
            // 
            this.txtAddress.Location = new System.Drawing.Point(174, 113);
            this.txtAddress.Name = "txtAddress";
            this.txtAddress.Size = new System.Drawing.Size(100, 22);
            this.txtAddress.TabIndex = 6;
            // 
            // txtCity
            // 
            this.txtCity.Location = new System.Drawing.Point(174, 155);
            this.txtCity.Name = "txtCity";
            this.txtCity.Size = new System.Drawing.Size(100, 22);
            this.txtCity.TabIndex = 7;
            // 
            // txtContactEmail
            // 
            this.txtContactEmail.Location = new System.Drawing.Point(174, 200);
            this.txtContactEmail.Name = "txtContactEmail";
            this.txtContactEmail.Size = new System.Drawing.Size(100, 22);
            this.txtContactEmail.TabIndex = 8;
            // 
            // txtPhoneNumber
            // 
            this.txtPhoneNumber.Location = new System.Drawing.Point(174, 250);
            this.txtPhoneNumber.Name = "txtPhoneNumber";
            this.txtPhoneNumber.Size = new System.Drawing.Size(100, 22);
            this.txtPhoneNumber.TabIndex = 9;
            // 
            // SupplierID
            // 
            this.SupplierID.AutoSize = true;
            this.SupplierID.Location = new System.Drawing.Point(68, 21);
            this.SupplierID.Name = "SupplierID";
            this.SupplierID.Size = new System.Drawing.Size(70, 16);
            this.SupplierID.TabIndex = 10;
            this.SupplierID.Text = "SupplierID";
           
            // 
            // Name
            // 
            this.Name.AutoSize = true;
            this.Name.Location = new System.Drawing.Point(68, 67);
            this.Name.Name = "Name";
            this.Name.Size = new System.Drawing.Size(44, 16);
            this.Name.TabIndex = 11;
            this.Name.Text = "Name";
            // 
            // Address
            // 
            this.Address.AutoSize = true;
            this.Address.Location = new System.Drawing.Point(66, 116);
            this.Address.Name = "Address";
            this.Address.Size = new System.Drawing.Size(58, 16);
            this.Address.TabIndex = 12;
            this.Address.Text = "Address";
            // 
            // City
            // 
            this.City.AutoSize = true;
            this.City.Location = new System.Drawing.Point(68, 158);
            this.City.Name = "City";
            this.City.Size = new System.Drawing.Size(29, 16);
            this.City.TabIndex = 13;
            this.City.Text = "City";
            // 
            // Email
            // 
            this.Email.AutoSize = true;
            this.Email.Location = new System.Drawing.Point(66, 203);
            this.Email.Name = "Email";
            this.Email.Size = new System.Drawing.Size(41, 16);
            this.Email.TabIndex = 14;
            this.Email.Text = "Email";
            // 
            // Phone
            // 
            this.Phone.AutoSize = true;
            this.Phone.Location = new System.Drawing.Point(66, 253);
            this.Phone.Name = "Phone";
            this.Phone.Size = new System.Drawing.Size(46, 16);
            this.Phone.TabIndex = 15;
            this.Phone.Text = "Phone";
            // 
            // dataGridSuppliers
            // 
            this.dataGridSuppliers.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridSuppliers.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dataGridSuppliers.Location = new System.Drawing.Point(0, 290);
            this.dataGridSuppliers.Name = "dataGridSuppliers";
            this.dataGridSuppliers.RowHeadersWidth = 51;
            this.dataGridSuppliers.RowTemplate.Height = 24;
            this.dataGridSuppliers.Size = new System.Drawing.Size(800, 160);
            this.dataGridSuppliers.TabIndex = 16;
            this.dataGridSuppliers.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridSuppliers_CellContentClick);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.dataGridSuppliers);
            this.Controls.Add(this.Phone);
            this.Controls.Add(this.Email);
            this.Controls.Add(this.City);
            this.Controls.Add(this.Address);
            this.Controls.Add(this.Name);
            this.Controls.Add(this.SupplierID);
            this.Controls.Add(this.txtPhoneNumber);
            this.Controls.Add(this.txtContactEmail);
            this.Controls.Add(this.txtCity);
            this.Controls.Add(this.txtAddress);
            this.Controls.Add(this.txtName);
            this.Controls.Add(this.txtSupplierID);
            this.Controls.Add(this.button4);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.button1);
            this.formName = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridSuppliers)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.TextBox txtSupplierID;
        private System.Windows.Forms.TextBox txtName;
        private System.Windows.Forms.TextBox txtAddress;
        private System.Windows.Forms.TextBox txtCity;
        private System.Windows.Forms.TextBox txtContactEmail;
        private System.Windows.Forms.TextBox txtPhoneNumber;
        private System.Windows.Forms.Label SupplierID;
        private System.Windows.Forms.Label Name;
        private System.Windows.Forms.Label Address;
        private System.Windows.Forms.Label City;
        private System.Windows.Forms.Label Email;
        private System.Windows.Forms.Label Phone;
        private System.Windows.Forms.DataGridView dataGridSuppliers;
    }
}

