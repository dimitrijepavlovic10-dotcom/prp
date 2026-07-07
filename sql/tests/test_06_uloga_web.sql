USE TuristickaAgencija;
GO

EXEC sp_setapprole 'DataProviderWEB', 'Web#Lozinka123';
GO

PRINT N'--- 1) SELECT iz api_web.ARANZMAN (ocekuje se uspeh) ---';
SELECT Id, DatumPolaska, Cena, NazivDestinacije, SlobodnaMesta
FROM api_web.ARANZMAN;
GO

PRINT N'--- 2) api_web.REZERVACIJA nema kolonu Email (ocekuje se uspeh, bez email-a) ---';
SELECT * FROM api_web.REZERVACIJA;
GO

PRINT N'--- 3) Pokusaj citanja kolone Email (ocekuje se greska - kolona ne postoji) ---';
SELECT Id, Email FROM api_web.REZERVACIJA;
GO

PRINT N'--- 4) Kreiranje rezervacije kroz api_web (ocekuje se uspeh) ---';
EXEC api_web.KreirajRezervaciju @idAranzmana = 4, @imeGosta = N'Веб Гост', @email = N'webgost@example.rs';
GO

PRINT N'--- 5) SELECT iz impl.tblRezervacija (ocekuje se ODBIJENO) ---';
SELECT * FROM impl.tblRezervacija;
GO

PRINT N'--- 6) SELECT iz api_agencija.REZERVACIJA - tudja sema (ocekuje se ODBIJENO) ---';
SELECT * FROM api_agencija.REZERVACIJA;
GO

PRINT N'--- 7) Otkazivanje test rezervacije (ciscenje, ocekuje se uspeh) ---';
DECLARE @idRez BIGINT = (SELECT MAX(Id) FROM api_web.REZERVACIJA);
EXEC api_web.OtkaziRezervaciju @idRezervacije = @idRez;
PRINT N'Test rezervacija je otkazana.';
GO
