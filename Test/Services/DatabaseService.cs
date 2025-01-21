using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Test.Services.Interface;

namespace Test.Services
{
    /// <summary>
    /// 提供與資料庫交互的服務，使用 Dapper 來執行儲存程序
    /// </summary>
    /// <param name="configuration">應用程式的設定物件</param>
    /// <exception cref="ArgumentNullException">當未設定連線字串時拋出</exception>
    public class DatabaseService(IConfiguration configuration) : IDatabaseService
    {
        /// <summary>
        /// 資料庫連線字串
        /// </summary>
        private readonly string _connectionString = configuration.GetConnectionString("DefaultConnection")
                             ?? throw new ArgumentNullException("未設定資料庫連線字串 'DefaultConnection'");

        /// <summary>
        /// 執行儲存程序並返回單一值
        /// </summary>
        /// <typeparam name="T">返回值的類型</typeparam>
        /// <param name="procedureName">儲存程序的名稱</param>
        /// <param name="parameters">儲存程序的參數</param>
        /// <returns>返回儲存程序執行的結果</returns>
        public async Task<T> ExecuteStoredProcedure<T>(string procedureName, object parameters)
        {
            if (string.IsNullOrWhiteSpace(procedureName))
            {
                throw new ArgumentException("儲存程序名稱不能為空或僅包含空白。", nameof(procedureName));
            }

            using var connection = new SqlConnection(_connectionString);
            return await connection.ExecuteScalarAsync<T>(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }

        /// <summary>
        /// 執行儲存程序並返回多筆資料的結果
        /// </summary>
        /// <typeparam name="T">每筆資料的類型</typeparam>
        /// <param name="procedureName">儲存程序的名稱</param>
        /// <param name="parameters">儲存程序的參數</param>
        /// <returns>返回儲存程序執行的多筆資料集合</returns>
        public async Task<IEnumerable<T>> QueryStoredProcedure<T>(string procedureName, object parameters)
        {
            if (string.IsNullOrWhiteSpace(procedureName))
            {
                throw new ArgumentException("儲存程序名稱不能為空或僅包含空白。", nameof(procedureName));
            }

            using var connection = new SqlConnection(_connectionString);
            return await connection.QueryAsync<T>(procedureName, parameters, commandType: CommandType.StoredProcedure);
        }
    }
}