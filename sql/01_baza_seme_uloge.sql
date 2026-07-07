USE master;
GO

IF DB_ID('TuristickaAgencija') IS NOT NULL
BEGIN
    ALTER DATABASE TuristickaAgencija SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TuristickaAgencija;
END
GO

CREATE DATABASE TuristickaAgencija
COLLATE Serbian_Cyrillic_100_CI_AS;
GO

USE TuristickaAgencija;
GO

CREATE SCHEMA impl;
GO
CREATE SCHEMA spec;
GO
CREATE SCHEMA api_agencija;
GO
CREATE SCHEMA api_web;
GO

IF SUSER_ID('AppKorisnik') IS NULL
    CREATE LOGIN AppKorisnik WITH PASSWORD = 'App#Lozinka123', CHECK_POLICY = OFF;
GO

CREATE USER AppKorisnik FOR LOGIN AppKorisnik;
GO

PRINT N'Baza TuristickaAgencija, seme i korisnik su kreirani.';
GO
