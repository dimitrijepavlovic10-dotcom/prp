USE TuristickaAgencija;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

PRINT N'--- 1) Pretraga preko HASHBYTES hesa ---';
DECLARE @trazeniEmail NVARCHAR(200) = N'marko@example.rs';

SELECT Id, ImeGosta, DatumRez, IdAranzmana
FROM impl.tblRezervacija
WHERE EmailHash = HASHBYTES('SHA2_256', @trazeniEmail);
GO

PRINT N'--- 2) Pretraga desifrovanjem svakog reda (DECRYPTBYKEY) ---';
DECLARE @trazeniEmail2 NVARCHAR(200) = N'marko@example.rs';

OPEN SYMMETRIC KEY KljucEmail DECRYPTION BY CERTIFICATE CertEmail;
SELECT Id, ImeGosta, DatumRez, IdAranzmana
FROM impl.tblRezervacija
WHERE CONVERT(NVARCHAR(200), DECRYPTBYKEY(Email_Enc)) = @trazeniEmail2;

CLOSE SYMMETRIC KEY KljucEmail;
GO

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT N'Pretraga preko hesa poredi 32-bajtne vrednosti i koristi indeks nad kolonom EmailHash,';
PRINT N'dok pretraga desifrovanjem mora da desifruje Email_Enc u svakom redu tabele,';
PRINT N'pa je na vecem broju redova visestruko sporija (vidi statistiku iznad).';
GO
