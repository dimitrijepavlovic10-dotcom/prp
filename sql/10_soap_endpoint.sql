-- SOAP HTTP endpointi (CREATE ENDPOINT ... FOR SOAP) postoje samo u
-- SQL Serveru 2005-2008 R2 i uklonjeni su od verzije 2012, pa se na
-- SQL Serveru 2022 ne mogu izvrsiti. Zato se ovde izvrsava samo deo
-- sa loginom i privilegijama, a CREATE ENDPOINT je dokumentovan dole
-- po sintaksi SQL Servera 2008 (K1 str. 412-422, K2 str. 364-373,
-- K4 str. 275-280).

USE master;
GO

IF SUSER_ID('WebServisKorisnik') IS NULL
    CREATE LOGIN WebServisKorisnik WITH PASSWORD = 'WebServis#Lozinka123', CHECK_POLICY = OFF;
GO

GRANT CONNECT SQL TO WebServisKorisnik;
GO

USE TuristickaAgencija;
GO

IF USER_ID('WebServisKorisnik') IS NULL
    CREATE USER WebServisKorisnik FOR LOGIN WebServisKorisnik;
GO

GRANT EXECUTE ON OBJECT::api_web.PretragaAranzmana TO WebServisKorisnik;
GRANT EXECUTE ON OBJECT::api_web.DetaljiAranzmana  TO WebServisKorisnik;
GO

PRINT N'Login WebServisKorisnik i privilegije su kreirani.';
GO

-- Web metode api_web.PretragaAranzmana i api_web.DetaljiAranzmana su
-- kreirane u skripti 07 sa WITH EXECUTE AS OWNER (zahtev 7).
--
-- Na SQL Serveru 2005-2008 R2 endpoint bi se kreirao ovako:
--
-- USE master;
-- GO
-- CREATE ENDPOINT epTuristickaAgencija
--     STATE = STARTED
-- AS HTTP
-- (
--     PATH = '/sql/turistickaagencija',
--     AUTHENTICATION = (INTEGRATED),
--     PORTS = (CLEAR),
--     CLEAR_PORT = 8080,
--     SITE = 'localhost'
-- )
-- FOR SOAP
-- (
--     WEBMETHOD 'PretragaAranzman'
--     (
--         NAME   = 'TuristickaAgencija.api_web.PretragaAranzmana',
--         SCHEMA = STANDARD
--     ),
--     WEBMETHOD 'DetaljiAranzman'
--     (
--         NAME   = 'TuristickaAgencija.api_web.DetaljiAranzmana',
--         SCHEMA = STANDARD
--     ),
--     WSDL = DEFAULT,
--     BATCHES = DISABLED,
--     DATABASE = 'TuristickaAgencija',
--     NAMESPACE = 'http://turistickaagencija.rs/webservice'
-- );
-- GO
--
-- GRANT CONNECT ON ENDPOINT::epTuristickaAgencija TO WebServisKorisnik;
-- GO
--
-- WSDL generisan od strane servera bi se proverio u browseru:
-- http://localhost:8080/sql/turistickaagencija?wsdl
