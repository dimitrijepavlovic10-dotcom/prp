USE TuristickaAgencija;
GO

PRINT N'--- Priprema: test aranzman sa 2 mesta ---';
INSERT INTO impl.tblAranzman (DatumPolaska, BrojMesta, Cena, IdDestinacije)
VALUES ('2027-11-11', 2, 100.00, 1);

DECLARE @idTest BIGINT = SCOPE_IDENTITY();
PRINT N'Test aranzman Id = ' + CAST(@idTest AS NVARCHAR(20));
GO

PRINT N'--- 1) Prazno ime gosta (ocekuje se greska) ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
EXEC spec.upr_KreirajRezerv @idAranzmana = @idTest, @imeGosta = N'', @email = N'x@example.rs';
GO

PRINT N'--- 2) Nepostojeci aranzman (ocekuje se greska) ---';
EXEC spec.upr_KreirajRezerv @idAranzmana = 999, @imeGosta = N'Тест Гост', @email = N'x@example.rs';
GO

PRINT N'--- 3) Datum rezervacije u buducnosti (ocekuje se greska) ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
EXEC spec.upr_KreirajRezerv @idAranzmana = @idTest, @imeGosta = N'Тест Гост',
                            @email = N'x@example.rs', @datumRez = '2030-01-01';
GO

PRINT N'--- 4) Dve validne rezervacije (ocekuje se uspeh) ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
EXEC spec.upr_KreirajRezerv @idAranzmana = @idTest, @imeGosta = N'Гост Један', @email = N'gost1@example.rs';
EXEC spec.upr_KreirajRezerv @idAranzmana = @idTest, @imeGosta = N'Гост Два',   @email = N'gost2@example.rs';

SELECT spec.fns_BrojSlobodnihMesta(@idTest) AS SlobodnaMesta;
GO

PRINT N'--- 5) Treca rezervacija na pun aranzman (ocekuje se greska) ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
EXEC spec.upr_KreirajRezerv @idAranzmana = @idTest, @imeGosta = N'Гост Три', @email = N'gost3@example.rs';
GO

PRINT N'--- 6) Direktan INSERT na pun aranzman - triger (ocekuje se greska) ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
INSERT INTO impl.tblRezervacija (ImeGosta, Email_Enc, EmailHash, DatumRez, IdAranzmana)
VALUES (N'Гост Триk', 0x00, HASHBYTES('SHA2_256', N'gost3@example.rs'), GETDATE(), @idTest);
GO

PRINT N'--- 7) Otkazivanje rezervacije (ocekuje se uspeh) ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
DECLARE @idRez BIGINT = (SELECT MAX(Id) FROM impl.tblRezervacija WHERE IdAranzmana = @idTest);
EXEC spec.upr_OtkaziRezerv @idRezervacije = @idRez;

SELECT spec.fns_BrojSlobodnihMesta(@idTest) AS SlobodnaMestaPosleOtkaza;
GO

PRINT N'--- Ciscenje test podataka ---';
DECLARE @idTest BIGINT = (SELECT MAX(Id) FROM impl.tblAranzman);
DECLARE @idRez BIGINT = (SELECT MAX(Id) FROM impl.tblRezervacija WHERE IdAranzmana = @idTest);
EXEC spec.upr_OtkaziRezerv @idRezervacije = @idRez;
EXEC spec.upr_ObrisiAranzman @idAranzmana = @idTest;
PRINT N'Test podaci su obrisani.';
GO
