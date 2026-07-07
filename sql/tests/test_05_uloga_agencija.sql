USE TuristickaAgencija;
GO

EXEC sp_setapprole 'DataProviderAGENCIJA', 'Agencija#Lozinka123';
GO

PRINT N'--- 1) SELECT iz api_agencija.ARANZMAN (ocekuje se uspeh) ---';
SELECT Id, DatumPolaska, Cena, NazivDestinacije, SlobodnaMesta
FROM api_agencija.ARANZMAN;
GO

PRINT N'--- 2) Agencija vidi desifrovan Email (ocekuje se uspeh) ---';
SELECT Id, ImeGosta, Email FROM api_agencija.REZERVACIJA;
GO

PRINT N'--- 3) Pretraga kroz proceduru (ocekuje se uspeh) ---';
EXEC api_agencija.PretragaAranzmana @nazivDestinacije = N'Грчка';
GO

PRINT N'--- 4) SELECT iz impl.tblRezervacija (ocekuje se ODBIJENO) ---';
SELECT * FROM impl.tblRezervacija;
GO

PRINT N'--- 5) SELECT iz spec.vw_REZERVACIJA (ocekuje se ODBIJENO) ---';
SELECT * FROM spec.vw_REZERVACIJA;
GO

PRINT N'--- 6) SELECT iz api_web.ARANZMAN - tudja sema (ocekuje se ODBIJENO) ---';
SELECT * FROM api_web.ARANZMAN;
GO

PRINT N'--- 7) Direktan INSERT u impl tabelu (ocekuje se ODBIJENO) ---';
INSERT INTO impl.tblDestinacija (Naziv, Zemlja, OpisXML)
VALUES (N'Проба', N'Проба', N'<opis><prevoz>x</prevoz><smestaj>x</smestaj><ukljuceno>x</ukljuceno></opis>');
GO
