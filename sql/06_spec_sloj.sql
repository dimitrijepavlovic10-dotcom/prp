USE TuristickaAgencija;
GO

CREATE FUNCTION spec.fns_BrojSlobodnihMesta (@idAranzmana BIGINT)
RETURNS INT
WITH ENCRYPTION
AS
BEGIN
    DECLARE @slobodno INT;

    SELECT @slobodno = a.BrojMesta - (SELECT COUNT(*)
                                      FROM impl.tblRezervacija r
                                      WHERE r.IdAranzmana = a.Id)
    FROM impl.tblAranzman a
    WHERE a.Id = @idAranzmana;

    RETURN @slobodno;
END
GO

CREATE VIEW spec.vw_DESTINACIJA
WITH ENCRYPTION
AS
SELECT Id, Naziv, Zemlja, OpisXML
FROM impl.tblDestinacija;
GO

CREATE VIEW spec.vw_ARANZMAN
WITH ENCRYPTION
AS
SELECT a.Id, a.DatumPolaska, a.BrojMesta, a.Cena, a.IdDestinacije,
       d.Naziv  AS NazivDestinacije,
       d.Zemlja AS Zemlja,
       spec.fns_BrojSlobodnihMesta(a.Id) AS SlobodnaMesta
FROM impl.tblAranzman a
JOIN impl.tblDestinacija d ON d.Id = a.IdDestinacije;
GO

CREATE VIEW spec.vw_REZERVACIJA
WITH ENCRYPTION
AS
SELECT r.Id, r.ImeGosta,
       CONVERT(NVARCHAR(200),
               DECRYPTBYKEYAUTOCERT(CERT_ID('CertEmail'), NULL, r.Email_Enc)) AS Email,
       r.DatumRez, r.IdAranzmana
FROM impl.tblRezervacija r;
GO

CREATE PROCEDURE spec.upr_KreirajDestinaciju
    @naziv   NVARCHAR(200),
    @zemlja  NVARCHAR(100),
    @opisXml NVARCHAR(MAX)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @naziv IS NULL OR LEN(@naziv) = 0 OR @zemlja IS NULL OR LEN(@zemlja) = 0
            RAISERROR (N'Назив и земља не смеју бити празни.', 16, 1);
        DECLARE @opis XML(impl.schOpis);
        SET @opis = CONVERT(XML(impl.schOpis), @opisXml);

        INSERT INTO impl.tblDestinacija (Naziv, Zemlja, OpisXML)
        VALUES (@naziv, @zemlja, @opis);

        SELECT SCOPE_IDENTITY() AS NoviId;
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() IN (6908, 6965)
            RAISERROR (N'XML описа мора садржати <prevoz>, <smestaj> и <ukljuceno>.', 16, 1);
        ELSE
        BEGIN
            DECLARE @poruka NVARCHAR(2048) = ERROR_MESSAGE();
            RAISERROR (@poruka, 16, 1);
        END
    END CATCH
END
GO

CREATE PROCEDURE spec.upr_ObrisiDestinaciju
    @idDestinacije BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM impl.tblDestinacija WHERE Id = @idDestinacije)
            RAISERROR (N'Дестинација не постоји.', 16, 1);
        IF EXISTS (SELECT 1 FROM impl.tblAranzman WHERE IdDestinacije = @idDestinacije)
            RAISERROR (N'Дестинација има активне аранжмане. Брисање није могуће.', 16, 1);

        DELETE FROM impl.tblDestinacija WHERE Id = @idDestinacije;
    END TRY
    BEGIN CATCH
        DECLARE @poruka NVARCHAR(2048) = ERROR_MESSAGE();
        RAISERROR (@poruka, 16, 1);
    END CATCH
END
GO

CREATE PROCEDURE spec.upr_KreirajAranzman
    @datumPolaska  DATE,
    @brojMesta     INT,
    @cena          DECIMAL(10,2),
    @idDestinacije BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM impl.tblDestinacija WHERE Id = @idDestinacije)
            RAISERROR (N'Дестинација не постоји. Аранжман не може бити унет.', 16, 1);

        IF @datumPolaska IS NULL OR @datumPolaska <= CAST(GETDATE() AS DATE)
            RAISERROR (N'Датум поласка мора бити у будућности.', 16, 1);

        IF @brojMesta IS NULL OR @brojMesta < 1
            RAISERROR (N'Број места мора бити најмање 1.', 16, 1);

        IF @cena IS NULL OR @cena <= 0
            RAISERROR (N'Цена мора бити позитивна.', 16, 1);

        INSERT INTO impl.tblAranzman (DatumPolaska, BrojMesta, Cena, IdDestinacije)
        VALUES (@datumPolaska, @brojMesta, @cena, @idDestinacije);

        SELECT SCOPE_IDENTITY() AS NoviId;
    END TRY
    BEGIN CATCH
        DECLARE @poruka NVARCHAR(2048) = ERROR_MESSAGE();
        RAISERROR (@poruka, 16, 1);
    END CATCH
END
GO
CREATE PROCEDURE spec.upr_ObrisiAranzman
    @idAranzmana BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM impl.tblAranzman WHERE Id = @idAranzmana)
            RAISERROR (N'Аранжман не постоји.', 16, 1);
        IF EXISTS (SELECT 1 FROM impl.tblRezervacija WHERE IdAranzmana = @idAranzmana)
            RAISERROR (N'Аранжман има активне резервације. Брисање није могуће.', 16, 1);

        DELETE FROM impl.tblAranzman WHERE Id = @idAranzmana;
    END TRY
    BEGIN CATCH
        DECLARE @poruka NVARCHAR(2048) = ERROR_MESSAGE();
        RAISERROR (@poruka, 16, 1);
    END CATCH
END
GO

CREATE PROCEDURE spec.upr_KreirajRezerv
    @idAranzmana BIGINT,
    @imeGosta    NVARCHAR(100),
    @email       NVARCHAR(200),
    @datumRez    DATE = NULL
WITH ENCRYPTION, EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @datumRez IS NULL
            SET @datumRez = CAST(GETDATE() AS DATE);
        IF @imeGosta IS NULL OR LEN(@imeGosta) = 0
            RAISERROR (N'Име госта не сме бити празно.', 16, 1);

        IF @email IS NULL OR LEN(@email) = 0
            RAISERROR (N'Емаил госта не сме бити празан.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM impl.tblAranzman WHERE Id = @idAranzmana)
            RAISERROR (N'Аранжман не постоји. Резервација не може бити унета.', 16, 1);

        IF spec.fns_BrojSlobodnihMesta(@idAranzmana) < 1
            RAISERROR (N'Нема слободних места у аранжману (аранжман је попуњен).', 16, 1);

        BEGIN TRANSACTION;
        OPEN SYMMETRIC KEY KljucEmail DECRYPTION BY CERTIFICATE CertEmail;

        INSERT INTO impl.tblRezervacija (ImeGosta, Email_Enc, EmailHash, DatumRez, IdAranzmana)
        VALUES (@imeGosta,
                ENCRYPTBYKEY(KEY_GUID('KljucEmail'), @email),
                HASHBYTES('SHA2_256', @email),
                @datumRez,
                @idAranzmana);

        CLOSE SYMMETRIC KEY KljucEmail;
        COMMIT TRANSACTION;

        SELECT SCOPE_IDENTITY() AS NoviId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @poruka NVARCHAR(2048) = ERROR_MESSAGE();
        RAISERROR (@poruka, 16, 1);
    END CATCH
END
GO

CREATE PROCEDURE spec.upr_OtkaziRezerv
    @idRezervacije BIGINT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM impl.tblRezervacija WHERE Id = @idRezervacije)
            RAISERROR (N'Резервација не постоји.', 16, 1);

        DELETE FROM impl.tblRezervacija WHERE Id = @idRezervacije;
    END TRY
    BEGIN CATCH
        DECLARE @poruka NVARCHAR(2048) = ERROR_MESSAGE();
        RAISERROR (@poruka, 16, 1);
    END CATCH
END
GO

CREATE PROCEDURE spec.upr_PretragaAranzman
    @nazivDestinacije NVARCHAR(200) = NULL,
    @maxCena          DECIMAL(10,2) = NULL
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id, DatumPolaska, BrojMesta, Cena, IdDestinacije,
           NazivDestinacije, Zemlja, SlobodnaMesta
    FROM spec.vw_ARANZMAN
    WHERE (@nazivDestinacije IS NULL OR NazivDestinacije LIKE '%' + @nazivDestinacije + '%')
      AND (@maxCena IS NULL OR Cena <= @maxCena)
    ORDER BY DatumPolaska;
END
GO

CREATE PROCEDURE spec.upr_PretragaPoOpisu
    @prevoz  NVARCHAR(100),
    @smestaj NVARCHAR(100)
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    SELECT a.Id, a.DatumPolaska, a.BrojMesta, a.Cena,
           d.Naziv AS NazivDestinacije, d.Zemlja,
           spec.fns_BrojSlobodnihMesta(a.Id) AS SlobodnaMesta
    FROM impl.tblAranzman a
    JOIN impl.tblDestinacija d ON d.Id = a.IdDestinacije
    WHERE d.OpisXML.exist('/opis[contains((prevoz)[1], sql:variable("@prevoz"))
                                 and contains((smestaj)[1], sql:variable("@smestaj"))]') = 1
    ORDER BY a.DatumPolaska;
END
GO

PRINT N'Spec sloj (pogledi, funkcija i procedure) je kreiran.';
GO
