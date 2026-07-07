USE TuristickaAgencija;
GO

PRINT N'--- 1) XQuery: avion + hotel (ocekuju se aranzmani 1 i 2 - Santorini) ---';
EXEC spec.upr_PretragaPoOpisu @prevoz = N'Авион', @smestaj = N'Хотел';
GO

PRINT N'--- 2) XQuery: avion + apartman (ocekuje se aranzman 4 - Barselona) ---';
EXEC spec.upr_PretragaPoOpisu @prevoz = N'Авион', @smestaj = N'Апартман';
GO

PRINT N'--- 3) XQuery: autobus + hotel (ocekuje se aranzman 3 - Rim) ---';
EXEC spec.upr_PretragaPoOpisu @prevoz = N'Аутобус', @smestaj = N'Хотел';
GO

PRINT N'--- 4) XQuery: voz - nema pogodaka (ocekuje se prazan rezultat) ---';
EXEC spec.upr_PretragaPoOpisu @prevoz = N'Воз', @smestaj = N'Хотел';
GO

PRINT N'--- 5) Pretraga po hesu: ana@example.rs (ocekuje se Ана Николић) ---';
SELECT Id, ImeGosta, DatumRez
FROM impl.tblRezervacija
WHERE EmailHash = HASHBYTES('SHA2_256', N'ana@example.rs');
GO

PRINT N'--- 6) Pretraga po hesu: nepostojeci email (ocekuje se prazan rezultat) ---';
SELECT Id, ImeGosta, DatumRez
FROM impl.tblRezervacija
WHERE EmailHash = HASHBYTES('SHA2_256', N'nepostojeci@example.rs');
GO
