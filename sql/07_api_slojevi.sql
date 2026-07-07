USE TuristickaAgencija;
GO

CREATE VIEW api_agencija.DESTINACIJA
AS
SELECT Id, Naziv, Zemlja, OpisXML
FROM spec.vw_DESTINACIJA;
GO

CREATE VIEW api_agencija.ARANZMAN
AS
SELECT Id, DatumPolaska, BrojMesta, Cena, IdDestinacije,
       NazivDestinacije, Zemlja, SlobodnaMesta
FROM spec.vw_ARANZMAN;
GO

CREATE VIEW api_agencija.REZERVACIJA
AS
SELECT Id, ImeGosta, Email, DatumRez, IdAranzmana
FROM spec.vw_REZERVACIJA;
GO

CREATE PROCEDURE api_agencija.KreirajDestinaciju
    @naziv   NVARCHAR(200),
    @zemlja  NVARCHAR(100),
    @opisXml NVARCHAR(MAX)
AS
    EXEC spec.upr_KreirajDestinaciju @naziv, @zemlja, @opisXml;
GO

CREATE PROCEDURE api_agencija.ObrisiDestinaciju
    @idDestinacije BIGINT
AS
    EXEC spec.upr_ObrisiDestinaciju @idDestinacije;
GO

CREATE PROCEDURE api_agencija.KreirajAranzman
    @datumPolaska  DATE,
    @brojMesta     INT,
    @cena          DECIMAL(10,2),
    @idDestinacije BIGINT
AS
    EXEC spec.upr_KreirajAranzman @datumPolaska, @brojMesta, @cena, @idDestinacije;
GO

CREATE PROCEDURE api_agencija.ObrisiAranzman
    @idAranzmana BIGINT
AS
    EXEC spec.upr_ObrisiAranzman @idAranzmana;
GO

CREATE PROCEDURE api_agencija.KreirajRezervaciju
    @idAranzmana BIGINT,
    @imeGosta    NVARCHAR(100),
    @email       NVARCHAR(200),
    @datumRez    DATE = NULL
AS
    EXEC spec.upr_KreirajRezerv @idAranzmana, @imeGosta, @email, @datumRez;
GO

CREATE PROCEDURE api_agencija.OtkaziRezervaciju
    @idRezervacije BIGINT
AS
    EXEC spec.upr_OtkaziRezerv @idRezervacije;
GO

CREATE PROCEDURE api_agencija.PretragaAranzmana
    @nazivDestinacije NVARCHAR(200) = NULL,
    @maxCena          DECIMAL(10,2) = NULL
AS
    EXEC spec.upr_PretragaAranzman @nazivDestinacije, @maxCena;
GO

CREATE PROCEDURE api_agencija.PretragaPoOpisu
    @prevoz  NVARCHAR(100),
    @smestaj NVARCHAR(100)
AS
    EXEC spec.upr_PretragaPoOpisu @prevoz, @smestaj;
GO

CREATE SYNONYM api_agencija.Aranzmani    FOR api_agencija.ARANZMAN;
GO
CREATE SYNONYM api_agencija.Destinacije  FOR api_agencija.DESTINACIJA;
GO
CREATE SYNONYM api_agencija.Rezervacije  FOR api_agencija.REZERVACIJA;
GO

CREATE VIEW api_web.DESTINACIJA
AS
SELECT Id, Naziv, Zemlja, OpisXML
FROM spec.vw_DESTINACIJA;
GO

CREATE VIEW api_web.ARANZMAN
AS
SELECT Id, DatumPolaska, BrojMesta, Cena, IdDestinacije,
       NazivDestinacije, Zemlja, SlobodnaMesta
FROM spec.vw_ARANZMAN;
GO

CREATE VIEW api_web.REZERVACIJA
AS
SELECT Id, ImeGosta, DatumRez, IdAranzmana
FROM spec.vw_REZERVACIJA;
GO

CREATE PROCEDURE api_web.KreirajRezervaciju
    @idAranzmana BIGINT,
    @imeGosta    NVARCHAR(100),
    @email       NVARCHAR(200),
    @datumRez    DATE = NULL
AS
    EXEC spec.upr_KreirajRezerv @idAranzmana, @imeGosta, @email, @datumRez;
GO

CREATE PROCEDURE api_web.OtkaziRezervaciju
    @idRezervacije BIGINT
AS
    EXEC spec.upr_OtkaziRezerv @idRezervacije;
GO

CREATE PROCEDURE api_web.PretragaAranzmana
    @nazivDestinacije NVARCHAR(200) = NULL,
    @maxCena          DECIMAL(10,2) = NULL
WITH EXECUTE AS OWNER
AS
    EXEC spec.upr_PretragaAranzman @nazivDestinacije, @maxCena;
GO

CREATE PROCEDURE api_web.DetaljiAranzmana
    @idAranzmana BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.Id, a.DatumPolaska, a.BrojMesta, a.Cena, a.SlobodnaMesta,
           a.NazivDestinacije, a.Zemlja, d.OpisXML
    FROM spec.vw_ARANZMAN a
    JOIN spec.vw_DESTINACIJA d ON d.Id = a.IdDestinacije
    WHERE a.Id = @idAranzmana;
END
GO

CREATE PROCEDURE api_web.PretragaPoOpisu
    @prevoz  NVARCHAR(100),
    @smestaj NVARCHAR(100)
AS
    EXEC spec.upr_PretragaPoOpisu @prevoz, @smestaj;
GO

CREATE SYNONYM api_web.Aranzmani   FOR api_web.ARANZMAN;
GO
CREATE SYNONYM api_web.Destinacije FOR api_web.DESTINACIJA;
GO

PRINT N'API sloj (api_agencija i api_web) je kreiran.';
GO
