namespace Test.Services.Interface
{
    public interface IDatabaseService
    {
        Task<T> ExecuteStoredProcedure<T>(string procedureName, object parameters);
        Task<IEnumerable<T>> QueryStoredProcedure<T>(string procedureName, object parameters);
    }
}