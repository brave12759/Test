using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Test.Models;
using Test.Services.Interface;

namespace Test.Services
{
    /// <summary>
    /// MyOffice_ACPD 資料表的業務邏輯實現
    /// </summary>
    /// <param name="configuration">應用程式的設定物件，用於讀取資料庫連線字串</param>
    public class MyOfficeService(IConfiguration configuration) : IMyOfficeService
    {
        private readonly string _connectionString = configuration.GetConnectionString("DefaultConnection");

        /// <summary>
        /// 新增 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="model">包含新增資料的模型</param>
        /// <returns>返回新增資料的主鍵</returns>
        public async Task<string> CreateAsync(MyOfficeCreateModel model)
        {
            try
            {
                using var connection = new SqlConnection(_connectionString);

                Console.WriteLine("[DEBUG][CREATE]: 開始執行儲存程序 usp_InsertMyOfficeData");
                var parameters = new { JsonInput = model.ToJson() };

                var result = await connection.ExecuteScalarAsync<string>(
                    "usp_InsertMyOfficeData",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                Console.WriteLine("[DEBUG][CREATE]: 執行完成，InsertedSID=" + result);
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][CREATE]: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// 查詢 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="model">包含查詢條件的模型</param>
        /// <returns>返回符合條件的資料集合</returns>
        public async Task<IEnumerable<MyOfficeDataModel>> QueryAsync(MyOfficeQueryModel model)
        {
            try
            {
                using var connection = new SqlConnection(_connectionString);

                Console.WriteLine("[DEBUG][READ]: 查詢條件 JSON：" + model.ToJson());
                var parameters = new { JsonInput = model.ToJson() };

                var results = await connection.QueryAsync<MyOfficeDataModel>(
                    "usp_SelectMyOfficeData",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                Console.WriteLine("[DEBUG][READ]: 查詢完成，共取得 " + results.Count() + " 筆資料。");
                return results;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][READ]: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// 更新 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="model">包含更新條件和更新內容的模型</param>
        /// <returns>返回更新是否成功</returns>
        public async Task<bool> UpdateAsync(MyOfficeUpdateModel model)
        {
            try
            {
                using var connection = new SqlConnection(_connectionString);

                Console.WriteLine("[DEBUG][UPDATE]: 更新條件 JSON：" + model.ToJson());
                var parameters = new { JsonInput = model.ToJson() };

                var affectedRows = await connection.ExecuteAsync(
                    "usp_UpdateMyOfficeData",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                Console.WriteLine("[DEBUG][UPDATE]: 更新完成，影響筆數=" + affectedRows);
                return affectedRows > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][UPDATE]: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// 刪除 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="model">包含刪除條件的模型</param>
        /// <returns>返回刪除是否成功</returns>
        public async Task<bool> DeleteAsync(MyOfficeDeleteModel model)
        {
            try
            {
                using var connection = new SqlConnection(_connectionString);

                Console.WriteLine("[DEBUG][DELETE]: 刪除條件 JSON：" + model.ToJson());
                var parameters = new { JsonInput = model.ToJson() };

                var affectedRows = await connection.ExecuteAsync(
                    "usp_DeleteMyOfficeData",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                Console.WriteLine("[DEBUG][DELETE]: 刪除完成，影響筆數=" + affectedRows);
                return affectedRows > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][DELETE]: {ex.Message}");
                throw;
            }
        }
    }
}