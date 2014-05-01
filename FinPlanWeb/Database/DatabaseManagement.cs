namespace FinPlanWeb.Database
{
    public class DatabaseManagement
    {
        /// This part checks if the user with password is existing within the database 
        /// Taking the input of email address and password
        /// return if the data is existed or not
        public static string GetConnection()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["standard"].ConnectionString;
        }
    }
}