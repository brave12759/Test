MyOffice_ACPD API 專案

1.專案概覽
  此專案實現了基於MyOffice_ACPD資料表的完整CRUD操作，
  使用 ASP.NET Core8 WebAPI、SQL Server和Dapper。
  解決方案透過儲存程序與資料庫進行交互，並包含Swagger文件化功能，方便API測試。

2.功能
  新增 (Create)：新增資料至 MyOffice_ACPD 資料表。
  查詢 (Read)：查詢 MyOffice_ACPD 資料表中的資料。
  更新 (Update)：修改現有資料。
  刪除 (Delete)：移除資料表中的資料。

3.需求
  3-1.開發環境：
    Visual Studio 2022 或更新版本
    .NET Core 8
    SQL Server 2016 或更新版本
  3-2.NuGet 套件：
    Dapper
    Swashbuckle.AspNetCore
    Swashbuckle.AspNetCore.Filters

4.安裝與配置
  4-1.下載專案：
    https://github.com/brave12759/Test
  4-2.安裝依賴項：
    運行以下命令來還原必要的 NuGet 套件：
    dotnet restore
  4-3.配置資料庫：
    打開 appsettings.json 檔案。
    更新連線字串：
    "ConnectionStrings": {
      "DefaultConnection": "Server=<ServerName>;Database=TestDB;Trusted_Connection=True;"
    }
  4-4.執行資料庫腳本：
    使用 SQL Server Management Studio (SSMS) 執行專案內提供的SQL腳本，建立資料表與儲存程序
  4-5.啟動專案：
    在專案資料夾中執行
    訪問 Swagger：
    打開瀏覽器，訪問：
    https://localhost:<port>/swagger
    通過 Swagger 測試 API。
  4-6.測試 API：
    使用提供的 JSON 範例測試每個 CRUD 操作
    使用 Swagger
    瀏覽至 /swagger。
    直接從 Swagger UI 測試每個 API 端點


5.專案結構
  Controllers：
  包含 API 端點控制器，例如 MyOfficeController
  Services：
  實現業務邏輯，例如 MyOfficeService
  Models：
  包含資料模型，例如 MyOfficeCreateModel
6.後續優化：
  6-1.資料模型曾加入詳細驗證機制與自定義驗證(因時間不足所以沒有實現)
  6-2.加入針對各項需求的過濾器
7.聯絡資訊
  姓名：Aaron Chen
  聯絡方式：brave12759@gmail.com
  專案日期：2025/01/21

