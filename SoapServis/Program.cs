using SoapCore;
using SoapServis;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddSoapCore();
builder.Services.AddSingleton<ITuristickiServis, TuristickiServis>();

var app = builder.Build();
((IApplicationBuilder)app).UseSoapEndpoint<ITuristickiServis>("/TuristickiServis.asmx",
    new SoapEncoderOptions(), SoapSerializer.DataContractSerializer);

app.MapGet("/", () => "SOAP servis turisticke agencije radi. WSDL: /TuristickiServis.asmx?wsdl");
app.Run("http://localhost:8080");
