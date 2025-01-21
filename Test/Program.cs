using Test.Services.Interface;
using Test.Services;

var builder = WebApplication.CreateBuilder(args);

// DIª`¤J
builder.Services.AddScoped<IDatabaseService, DatabaseService>();
builder.Services.AddScoped<IMyOfficeService, MyOfficeService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// ¨Ï¥Î Middleware
app.UseMiddleware<Test.Middleware.ExceptionMiddleware>();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
