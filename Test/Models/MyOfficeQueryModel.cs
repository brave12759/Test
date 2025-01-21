using Newtonsoft.Json;

namespace Test.Models
{
    /// <summary>
    /// 查詢 MyOffice_ACPD 資料
    /// </summary>
    public class MyOfficeQueryModel
    {
        public string ACPD_SID { get; set; } = string.Empty;
        public string ACPD_Cname { get; set; } = string.Empty;
        public string ACPD_Email { get; set; } = string.Empty;
        public int? ACPD_Status { get; set; } 
        public bool? ACPD_Stop { get; set; }

        public string ToJson()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
