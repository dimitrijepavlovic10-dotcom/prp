USE TuristickaAgencija;
GO

PRINT N'--- 1) Prazan naziv (ocekuje se greska) ---';
EXEC spec.upr_KreirajDestinaciju
     @naziv = N'', @zemlja = N'Србија',
     @opisXml = N'<opis><prevoz>Бус</prevoz><smestaj>Хотел</smestaj><ukljuceno>Ништа</ukljuceno></opis>';
GO

PRINT N'--- 2) Nevalidan XML - nedostaje <ukljuceno> (ocekuje se greska) ---';
EXEC spec.upr_KreirajDestinaciju
     @naziv = N'Тест', @zemlja = N'Србија',
     @opisXml = N'<opis><prevoz>Бус</prevoz><smestaj>Хотел</smestaj></opis>';
GO

PRINT N'--- 3) Direktan INSERT nevalidnog XML-a (ocekuje se greska) ---';
INSERT INTO impl.tblDestinacija (Naziv, Zemlja, OpisXML)
VALUES (N'Тест', N'Србија', N'<opis><prevoz>Бус</prevoz></opis>');
GO

PRINT N'--- 4) Validna destinacija (ocekuje se uspeh) ---';
EXEC spec.upr_KreirajDestinaciju
     @naziv = N'Тест — Копаоник', @zemlja = N'Србија',
     @opisXml = N'<opis><prevoz>Аутобус</prevoz><smestaj>Апартман</smestaj><ukljuceno>Све</ukljuceno><opis_mesta>Планина</opis_mesta></opis>';
GO

PRINT N'--- 5) Brisanje test destinacije (ocekuje se uspeh) ---';
DECLARE @id BIGINT;
SELECT @id = Id FROM impl.tblDestinacija WHERE Naziv = N'Тест — Копаоник';
EXEC spec.upr_ObrisiDestinaciju @idDestinacije = @id;
PRINT N'Test destinacija je obrisana.';
GO
