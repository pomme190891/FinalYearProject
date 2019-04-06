using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using SALuminousWeb.DTOs;

namespace SALuminousWeb.Database
{
    public class PromoManagement : DatabaseManagement
    {
        public class Promotion
        {
            public string CodeId { get; set; }
            public int Rate { get; set; }
            public double Price { get; set; }
            public bool Hidden { get; set; }
        }

        /// <summary>
        /// Get Promotion Codes
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public static Promotion GetActivePromotion(string code)
        {
            using (var connection = new SqlConnection(GetConnection()))
            {
                const string sql = @"SELECT * FROM [dbo].[promotion] where codeID = @c and hidden = 0";
                var cmd = new SqlCommand(sql, connection);

                cmd.Parameters
                          .Add(new SqlParameter("@c", SqlDbType.NVarChar))
                          .Value = code;

                connection.Open();
                var reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    reader.Read();
                    return new Promotion
                    {
                        CodeId = reader.GetString(0),
                        Rate = reader.GetInt32(1),
                        Price = reader.GetSqlMoney(2).ToDouble()

                    };
                }
                reader.Dispose();
                cmd.Dispose();
                return null;
            }
        }

        public static IEnumerable<Promotion> GetAllPromotionList()
        {
            var promotions = new List<Promotion>();
            using (var connection = new SqlConnection(GetConnection()))
            {
                const string sql = @"SELECT * FROM [dbo].[promotion]";
                var cmd = new SqlCommand(sql, connection);
                connection.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var promotion = new Promotion
                        {
                            CodeId = reader.GetString(0),
                            Rate = reader.GetInt32(1),
                            Price = reader.GetSqlMoney(2).ToDouble(),
                            Hidden = reader.GetBoolean(3)
                        };
                        promotions.Add(promotion);
                    }
                }

                return promotions;
            }
        }

        public static void UpdatePromotion(EditPromotionDTO promotion)
        {
            try
            {
                var con = new SqlConnection(GetConnection());
                var cmd = new SqlCommand
                {
                    Connection = con,
                    CommandType = CommandType.Text,
                    CommandText =
                        "Update [dbo].[promotion] SET rate = @rate, price = @price, hidden=@hidden WHERE codeId = @codeId"
                };
                cmd.Parameters.AddWithValue("@rate", promotion.Rate);
                cmd.Parameters.AddWithValue("@price", promotion.Price);
                cmd.Parameters.AddWithValue("@hidden", promotion.Hidden);
                cmd.Parameters.AddWithValue("@codeId", promotion.CodeId);

                if (con.State != ConnectionState.Closed) return;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (SqlException ex)
            {
                var msg = "Update errors";
                msg += ex.Message;
                throw new Exception(msg);
            }
        }

        public static void AddPromotion(EditPromotionDTO promotion)
        {
            try
            {
                var con = new SqlConnection(GetConnection());
                var cmd = new SqlCommand
                {
                    Connection = con,
                    CommandType = CommandType.Text,
                    CommandText =
                        "INSERT INTO [dbo].[promotion](codeID,rate, price, hidden) " +
                        "VALUES (@codeId,@rate, @price, @hidden)"
                };
                cmd.Parameters.Clear();

                cmd.Parameters.AddWithValue("@codeId", promotion.CodeId);
                cmd.Parameters.AddWithValue("@rate", promotion.Rate);
                cmd.Parameters.AddWithValue("@price", promotion.Price);
                cmd.Parameters.AddWithValue("@hidden", promotion.Hidden);

                if (con.State != ConnectionState.Closed) return;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (SqlException ex)
            {
                var msg = "Insert errors";
                msg += ex.Message;
                throw new Exception(msg);
            }
        }


    }
}