using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace FinPlanWeb.Database
{
    public class CategoryManagement
    {
        public class Category
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public DateTime DateAdded { get; set; }
            public DateTime? LastModifiedDate { get; set; }
        }

        public static string GetConnection()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["standard"].ConnectionString;
        }

        public static IEnumerable<Category> GetAllCategory()
        {
            var categories = new List<Category>();
            using (var connection = new SqlConnection(GetConnection()))
            {
                const string sql =
                    @"SELECT [categoriesID]
                          ,[categoriesName]
                          ,[date_added]
                          ,[last_modified]
                      FROM [finplanweb].[dbo].[categories]";
                var cmd = new SqlCommand(sql, connection);
                connection.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var order = new Category
                        {
                            Id = reader.GetInt32(0),
                            Name = reader.GetString(1),
                            DateAdded = reader.GetDateTime(2),
                            LastModifiedDate = reader.IsDBNull(3) ? (DateTime?) null : reader.GetDateTime(3),
                        };

                        categories.Add(order);
                    }

                }

                return categories;
            }
        }
    }
}