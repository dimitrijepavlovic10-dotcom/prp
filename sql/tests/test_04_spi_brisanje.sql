USE TuristickaAgencija;
GO

PRINT N'--- 1) Brisanje destinacije sa aranzmanima (ocekuje se greska) ---';
EXEC spec.upr_ObrisiDestinaciju @idDestinacije = 1;
GO

PRINT N'--- 2) Brisanje aranzmana sa rezervacijama (ocekuje se greska) ---';
EXEC spec.upr_ObrisiAranzman @idAranzmana = 1;
GO

PRINT N'--- 3) Direktan DELETE destinacije - FK zastita (ocekuje se greska) ---';
DELETE FROM impl.tblDestinacija WHERE Id = 1;
GO

PRINT N'--- 4) Brisanje nepostojece destinacije (ocekuje se greska) ---';
EXEC spec.upr_ObrisiDestinaciju @idDestinacije = 999;
GO
