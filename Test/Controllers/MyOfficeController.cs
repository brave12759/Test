using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Test.Models;
using Test.Services.Interface;

namespace Test.Controllers
{
    /// <summary>
    /// 提供對 MyOffice_ACPD 的 CRUD 操作 API
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class MyOfficeController(IMyOfficeService myOfficeService) : ControllerBase
    {
        /// <summary>
        /// 新增 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="input">新增資料的輸入模型</param>
        /// <returns>新增的資料主鍵</returns>
        [HttpPost("create")]
        [SwaggerOperation(Summary = "新增 MyOffice_ACPD 資料", Description = "透過 JSON 格式輸入新增一筆資料")]
        [SwaggerResponse(200, "成功新增資料", typeof(string))]
        [SwaggerResponse(400, "輸入格式無效")]
        [SwaggerResponse(500, "伺服器內部錯誤")]
        public async Task<IActionResult> Create([FromBody] MyOfficeCreateModel input)
        {
            if (!ModelState.IsValid)
                return BadRequest("輸入的資料格式無效");

            try
            {
                var result = await myOfficeService.CreateAsync(input);
                return Ok(new { Message = "新增成功", InsertedSID = result });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][CREATE]: {ex.Message}");
                return StatusCode(500, $"伺服器發生錯誤：{ex.Message}");
            }
        }

        /// <summary>
        /// 查詢 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="input">查詢條件模型</param>
        /// <returns>查詢結果</returns>
        [HttpPost("read")]
        [SwaggerOperation(Summary = "查詢 MyOffice_ACPD 資料", Description = "透過 JSON 格式條件查詢資料")]
        [SwaggerResponse(200, "成功查詢資料", typeof(IEnumerable<MyOfficeDataModel>))]
        [SwaggerResponse(400, "輸入格式無效")]
        [SwaggerResponse(500, "伺服器內部錯誤")]
        public async Task<IActionResult> Read([FromBody] MyOfficeQueryModel input)
        {
            if (!ModelState.IsValid)
                return BadRequest("輸入的查詢條件格式無效");

            try
            {
                var results = await myOfficeService.QueryAsync(input);
                return Ok(results);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][READ]: {ex.Message}");
                return StatusCode(500, $"伺服器發生錯誤：{ex.Message}");
            }
        }

        /// <summary>
        /// 更新 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="input">更新資料的輸入模型</param>
        /// <returns>是否成功</returns>
        [HttpPut("update")]
        [SwaggerOperation(Summary = "更新 MyOffice_ACPD 資料", Description = "透過 JSON 格式條件更新資料")]
        [SwaggerResponse(200, "更新成功")]
        [SwaggerResponse(400, "輸入格式無效")]
        [SwaggerResponse(500, "伺服器內部錯誤")]
        public async Task<IActionResult> Update([FromBody] MyOfficeUpdateModel input)
        {
            if (!ModelState.IsValid)
                return BadRequest("輸入的更新資料格式無效");

            try
            {
                var isUpdated = await myOfficeService.UpdateAsync(input);
                return isUpdated ? Ok("更新成功") : NotFound("找不到資料");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][UPDATE]: {ex.Message}");
                return StatusCode(500, $"伺服器發生錯誤：{ex.Message}");
            }
        }

        /// <summary>
        /// 刪除 MyOffice_ACPD 資料
        /// </summary>
        /// <param name="input">刪除條件模型</param>
        /// <returns>是否成功</returns>
        [HttpDelete("delete")]
        [SwaggerOperation(Summary = "刪除 MyOffice_ACPD 資料", Description = "透過 JSON 格式條件刪除資料")]
        [SwaggerResponse(200, "刪除成功")]
        [SwaggerResponse(400, "輸入格式無效")]
        [SwaggerResponse(500, "伺服器內部錯誤")]
        public async Task<IActionResult> Delete([FromBody] MyOfficeDeleteModel input)
        {
            if (!ModelState.IsValid)
                return BadRequest("輸入的刪除條件格式無效");

            try
            {
                var isDeleted = await myOfficeService.DeleteAsync(input);
                return isDeleted ? Ok("刪除成功") : NotFound("找不到資料");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR][DELETE]: {ex.Message}");
                return StatusCode(500, $"伺服器發生錯誤：{ex.Message}");
            }
        }
    }
}