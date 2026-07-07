USE TuristickaAgencija;
GO

CREATE TRIGGER impl.trgProveraMesta
ON impl.tblRezervacija
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS
    (
        SELECT a.Id
        FROM impl.tblAranzman a
        WHERE a.Id IN (SELECT i.IdAranzmana FROM inserted i)
          AND a.BrojMesta < (SELECT COUNT(*)
                             FROM impl.tblRezervacija r
                             WHERE r.IdAranzmana = a.Id)
    )
    BEGIN
        RAISERROR (N'Нема слободних места у аранжману (аранжман је попуњен).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

PRINT N'Triger trgProveraMesta je kreiran.';
GO
