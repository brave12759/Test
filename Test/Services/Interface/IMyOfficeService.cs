using Test.Models;

namespace Test.Services.Interface
{
    public interface IMyOfficeService
    {
        Task<string> CreateAsync(MyOfficeCreateModel model);
        Task<IEnumerable<MyOfficeDataModel>> QueryAsync(MyOfficeQueryModel model);
        Task<bool> UpdateAsync(MyOfficeUpdateModel model);
        Task<bool> DeleteAsync(MyOfficeDeleteModel model);
    }
}