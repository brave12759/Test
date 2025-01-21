using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace Test.Models
{
    /// <summary>
    /// 刪除 MyOffice_ACPD 資料
    /// </summary>
    public class MyOfficeDeleteModel
    {
        [Required]
        public string ACPD_SID { get; set; } = string.Empty;

        public string ToJson()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
