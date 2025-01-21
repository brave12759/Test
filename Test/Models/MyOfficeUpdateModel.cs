using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace Test.Models
{
    /// <summary>
    /// 更新 MyOffice_ACPD 資料
    /// </summary>
    public class MyOfficeUpdateModel
    {
        [Required]
        public string ACPD_SID { get; set; } = string.Empty;
        public string ACPD_Cname { get; set; } = string.Empty;
        public string ACPD_Email { get; set; } = string.Empty;
        public string ACPD_Memo { get; set; } = string.Empty;
        public DateTime? ACPD_UPDDateTime { get; set; }=DateTime.UtcNow;
        public string ACPD_UPDID { get; set; } = string.Empty;

        public string ToJson()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
