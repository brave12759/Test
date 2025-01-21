namespace Test.Models
{
    /// <summary>
    /// 儲存程序輸入模型
    /// </summary>
    public class JsonInputModel
    {
        /// <summary>
        /// 儲存程序的名稱
        /// </summary>
        public string ProcedureName { get; set; } = string.Empty;

        /// <summary>
        /// 傳入儲存程序的 JSON 資料
        /// </summary>
        public string JsonData { get; set; } = string.Empty;
    }
}
