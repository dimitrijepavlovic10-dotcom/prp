USE TuristickaAgencija;
GO

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Dmk#JakaLozinka123';
GO

CREATE CERTIFICATE CertEmail
WITH SUBJECT = 'Sertifikat za sifrovanje email adresa gostiju';
GO

CREATE SYMMETRIC KEY KljucEmail
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertEmail;
GO

PRINT N'Enkripcijska hijerarhija (DMK -> CertEmail -> KljucEmail) je kreirana.';
GO
