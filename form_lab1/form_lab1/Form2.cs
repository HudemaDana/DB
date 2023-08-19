using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace form_lab1
{
    public partial class Form2 : Form
    {
        SqlConnection cs = new SqlConnection("Data Source=DESKTOP-KT5J9SD\\SQLEXPRESS;Initial Catalog=PoliceStation;Integrated Security=True; Trust Server Certificate=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        public Form2()
        {
            InitializeComponent();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            da.SelectCommand = new SqlCommand("SELECT * FROM CallCenterPeople", cs);
            ds.Clear();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                da.DeleteCommand = new SqlCommand("DELETE FROM CallCenterPeople WHERE CCPid = @id", cs);
                da.DeleteCommand.Parameters.Add("@id", SqlDbType.Int).Value = int.Parse(textBox1.Text);
                cs.Open();
                da.DeleteCommand.ExecuteNonQuery();
                MessageBox.Show("Delete Succesfull from the Database");
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

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                da.UpdateCommand = new SqlCommand("UPDATE CallCenterPeople SET CNP = @cnp , fname = @fn, lname = @ln, PSid = @psid where CCPid = @id", cs);
                da.UpdateCommand.Parameters.Add("@id", SqlDbType.Int).Value = int.Parse(textBox1.Text);
                da.UpdateCommand.Parameters.Add("@cnp", SqlDbType.VarChar).Value = textBox2.Text;
                da.UpdateCommand.Parameters.Add("@fn", SqlDbType.VarChar).Value = textBox3.Text;
                da.UpdateCommand.Parameters.Add("@ln", SqlDbType.VarChar).Value = textBox4.Text;
                da.UpdateCommand.Parameters.Add("@psid", SqlDbType.Int).Value = int.Parse(textBox5.Text);
                cs.Open();
                da.UpdateCommand.ExecuteNonQuery();
                MessageBox.Show("Update Succesfull to the Database");
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

        int i;
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            i = e.RowIndex;
            if (i > 0)
            {
                DataGridViewRow row = dataGridView1.Rows[i];
                textBox1.Text = row.Cells[0].Value.ToString();
                textBox2.Text = row.Cells[1].Value.ToString();
                textBox3.Text = row.Cells[2].Value.ToString();
                textBox4.Text = row.Cells[3].Value.ToString();
                textBox5.Text = row.Cells[4].Value.ToString();
            }
        }
    }
}
