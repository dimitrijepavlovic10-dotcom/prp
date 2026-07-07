USE TuristickaAgencija;
GO

PRINT N'--- 1) Datum u proslosti (ocekuje se greska) ---';
EXEC spec.upr_KreirajAranzman
     @datumPolaska = '2020-01-01', @brojMesta = 10, @cena = 500.00, @idDestinacije = 1;
GO

PRINT N'--- 2) Broj mesta 0 (ocekuje se greska) ---';
EXEC spec.upr_KreirajAranzman
     @datumPolaska = '2027-10-01', @brojMesta = 0, @cena = 500.00, @idDestinacije = 1;
GO

PRINT N'--- 3) Negativna cena (ocekuje se greska) ---';
EXEC spec.upr_KreirajAranzman
     @datumPolaska = '2027-10-01', @brojMesta = 10, @cena = -5.00, @idDestinacije = 1;
GO

PRINT N'--- 4) Nepostojeca destinacija (ocekuje se greska) ---';
EXEC spec.upr_KreirajAranzman
     @datumPolaska = '2027-10-01', @brojMesta = 10, @cena = 500.00, @idDestinacije = 999;
GO

PRINT N'--- 5) Direktan INSERT sa datumom u proslosti (ocekuje se CHECK greska) ---';
INSERT INTO impl.tblAranzman (DatumPolaska, BrojMesta, Cena, IdDestinacije)
VALUES ('2020-01-01', 10, 500.00, 1);
GO

PRINT N'--- 6) Validan aranzman + brisanje (ocekuje se uspeh) ---';
EXEC spec.upr_KreirajAranzman
     @datumPolaska = '2027-10-01', @brojMesta = 10, @cena = 500.00, @idDestinacije = 1;

DECLARE @id BIGINT;
SELECT @id = MAX(Id) FROM impl.tblAranzman;
EXEC spec.upr_ObrisiAranzman @idAranzmana = @id;
PRINT N'Test aranzman je obrisan.';
GO
