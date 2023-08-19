using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace form_lab1
{
    public partial class Form1 : Form
    {
        SqlConnection cs = new SqlConnection("Data Source=DESKTOP-KT5J9SD\\SQLEXPRESS;Initial Catalog=PoliceStation;Integrated Security=True; Trust Server Certificate=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            da.SelectCommand = new SqlCommand("SELECT * FROM PoliceStation", cs);
            ds.Clear();
            da.Fill(ds);
            if (dataGridView1.ColumnCount > 5)
            {
                dataGridView1.Columns["CCPid"].Visible = false;
                dataGridView1.Columns["CNP"].Visible = false;
                dataGridView1.Columns["fname"].Visible = false;
                dataGridView1.Columns["lname"].Visible = false;

                dataGridView1.Columns["address"].Visible = true;
                dataGridView1.Columns["city"].Visible = true;
                dataGridView1.Columns["country"].Visible = true;
                dataGridView1.Columns["phone_number"].Visible = true;
            }
            dataGridView1.DataSource = ds.Tables[0];

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {


                da.SelectCommand = new SqlCommand("SELECT * FROM CallCenterPeople Where PSid = @id", cs);
                da.SelectCommand.Parameters.Add("@id", SqlDbType.Int).Value = int.Parse(textBox1.Text);
                ds.Clear();
                da.Fill(ds);
                if (dataGridView1.ColumnCount > 5)
                {
                    dataGridView1.Columns["CCPid"].Visible = true;
                    dataGridView1.Columns["CNP"].Visible = true;
                    dataGridView1.Columns["fname"].Visible = true;
                    dataGridView1.Columns["lname"].Visible = true;

                    dataGridView1.Columns["address"].Visible = false;
                    dataGridView1.Columns["city"].Visible = false;
                    dataGridView1.Columns["country"].Visible = false;
                    dataGridView1.Columns["phone_number"].Visible = false;
                }
                dataGridView1.DataSource = ds.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }
        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                da.InsertCommand = new SqlCommand("INSERT INTO CallCenterPeople (CNP, fname, lname, PSid) VALUES(@cnp, @fn, @ln, @id)", cs);
                da.InsertCommand.Parameters.Add("@cnp", SqlDbType.VarChar).Value = textBox2.Text;
                da.InsertCommand.Parameters.Add("@fn", SqlDbType.VarChar).Value = textBox3.Text;
                da.InsertCommand.Parameters.Add("@ln", SqlDbType.VarChar).Value = textBox4.Text;
                da.InsertCommand.Parameters.Add("@id", SqlDbType.Int).Value = int.Parse(textBox1.Text);
                cs.Open();
                da.InsertCommand.ExecuteNonQuery();
                MessageBox.Show("Inserted Succesfull to the Database");
                cs.Close();
                da.Fill(ds);
                dataGridView1.DataSource = ds.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                cs.Close();
            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
        }

        int i;
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            i = e.RowIndex;
            DataGridViewRow row = dataGridView1.Rows[i];
            textBox1.Text = row.Cells[0].Value.ToString();

        }
    }
}
