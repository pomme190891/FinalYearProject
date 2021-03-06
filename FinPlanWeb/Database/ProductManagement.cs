﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using SALuminousWeb.DTOs;

namespace SALuminousWeb.Database
{

    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }
        public double Price { get; set; }
        public DateTime AddedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string PriceInStr
        {
            get { return string.Format("{0:0.00}", Price); }
        }
        public int CategoryId { get; set; }

        public bool Hidden { get; set; }
    }

    public class ProductManagement : DatabaseManagement
    {
        public enum ProductType
        {
            All = 0,
            Cloud,
            DataTransafer,
            ITSupport
        }

        public static Product GetProduct(string productCode)
        {
            using (var connection = new SqlConnection(GetConnection()))
            {
                const string sql = @"SELECT * FROM [dbo].[products] where productCode = @c ";
                var cmd = new SqlCommand(sql, connection);

                cmd.Parameters
                          .Add(new SqlParameter("@c", SqlDbType.NVarChar))
                          .Value = productCode;

                connection.Open();
                var reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    reader.Read();
                    return new Product
                     {
                         Id = reader.GetInt32(0),
                         Code = reader.GetString(1),
                         Name = reader.GetString(2),
                         AddedDate = reader.GetDateTime(3),
                         ModifiedDate = reader.IsDBNull(4) ? null : (DateTime?)reader.GetDateTime(4),
                         Price = reader.GetSqlMoney(5).ToDouble(),
                         CategoryId = reader.GetInt32(6),
                         Hidden = reader.GetBoolean(7)
                     };
                }
                reader.Dispose();
                cmd.Dispose();
                return null;
            }
        }


        public static IEnumerable<Product> GetProductsIncludeHidden()
        {
            var products = new List<Product>();
            using (var connection = new SqlConnection(GetConnection()))
            {

                var sql = @"SELECT * FROM [dbo].[products]";
                var cmd = new SqlCommand(sql, connection);

                connection.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var product = new Product
                        {
                            Id = reader.GetInt32(0),
                            Code = reader.GetString(1),
                            Name = reader.GetString(2),
                            AddedDate = reader.GetDateTime(3),
                            ModifiedDate = reader.IsDBNull(4) ? null : (DateTime?)reader.GetDateTime(4),
                            Price = reader.GetSqlMoney(5).ToDouble(),
                            CategoryId = reader.GetInt32(6),
                            Hidden = reader.GetBoolean(7)
                        };

                        products.Add(product);
                    }
                }
                return products;
            }
        }


        /// <summary>
        /// Get all Products
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>

        public static IEnumerable<Product> GetProducts(ProductType type)
        {
            var products = new List<Product>();
            using (var connection = new SqlConnection(GetConnection()))
            {

                var sql = @"SELECT * FROM [dbo].[products] WHERE hidden = 0";
                if (type != ProductType.All)
                {
                    sql += " AND categoriesID = @t";
                }
                var cmd = new SqlCommand(sql, connection);

                connection.Open();
                if (type != ProductType.All)
                {
                    cmd.Parameters
                     .Add(new SqlParameter("@t", SqlDbType.Int))
                     .Value = (int)type;
                }

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var product = new Product
                        {
                            Id = reader.GetInt32(0),
                            Code = reader.GetString(1),
                            Name = reader.GetString(2),
                            AddedDate = reader.GetDateTime(3),
                            ModifiedDate = reader.IsDBNull(4) ? null : (DateTime?)reader.GetDateTime(4),
                            Price = reader.GetSqlMoney(5).ToDouble(),
                            CategoryId = reader.GetInt32(6)
                        };

                        products.Add(product);
                    }
                }
                return products;
            }
        }

        public static void UpdateProduct(EditProductDTO product)
        {
            using (var connection = new SqlConnection(GetConnection()))
            {
                const string sql = @"UPDATE [dbo].[products] SET Description=@d, modifiedDate=@md, price=@p, categoriesID=@cid, hidden=@hide WHERE [productId] = @pid";
                connection.Open();
                var cmd = new SqlCommand(sql, connection);
                cmd.Parameters.Add(new SqlParameter("@d", SqlDbType.NVarChar)).Value = product.Name;
                cmd.Parameters.Add(new SqlParameter("@md", SqlDbType.DateTime)).Value = DateTime.Now;
                cmd.Parameters.Add(new SqlParameter("@p", SqlDbType.Money)).Value = product.Price;
                cmd.Parameters.Add(new SqlParameter("@cid", SqlDbType.Int)).Value = product.CategoryId;
                cmd.Parameters.Add(new SqlParameter("@hide", SqlDbType.Bit)).Value = product.Hidden;
                cmd.Parameters.Add(new SqlParameter("@pid", SqlDbType.Int)).Value = product.Id;
                cmd.ExecuteNonQuery();
            }
        }

        public static void CreateProduct(EditProductDTO dto)
        {
            SqlTransaction transaction = null;
            try
            {
                var con = new SqlConnection(GetConnection());
                con.Open();
                transaction = con.BeginTransaction();
                var cmd = new SqlCommand
                {
                    Transaction = transaction,
                    Connection = con,
                    CommandType = CommandType.Text,
                    CommandText =
                        @"INSERT INTO [SALuminousWeb].[dbo].[products]
                           ([productCode]
                           ,[description]
                           ,[addedDate]
                           ,[modifiedDate]
                           ,[price]
                           ,[categoriesID]
                           ,[hidden])" +
                        "VALUES (@code, @name, @addedDate, @modifiedDate, @price, @categoryID,0)"
                };
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@code", dto.Code);
                cmd.Parameters.AddWithValue("@name", dto.Name);
                cmd.Parameters.AddWithValue("@addedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@modifiedDate", DBNull.Value);
                cmd.Parameters.AddWithValue("@price", dto.Price);
                cmd.Parameters.AddWithValue("@categoryID", dto.CategoryId);
                cmd.ExecuteNonQuery();
                transaction.Commit();

                if (con.State != ConnectionState.Closed) return;
                con.Close();
            }
            catch (SqlException ex)
            {
                transaction.Rollback();
                var msg = "Insert errors";
                msg += ex.Message;
                throw new Exception(msg);
            }
        }
    }
}