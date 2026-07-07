USE TuristickaAgencija;
GO

CREATE TABLE impl.tblDestinacija
(
    Id      BIGINT IDENTITY(1,1) NOT NULL,
    Naziv   NVARCHAR(200)        NOT NULL,
    Zemlja  NVARCHAR(100)        NOT NULL,
    OpisXML XML(impl.schOpis)    NOT NULL,

    CONSTRAINT pkDestinacija PRIMARY KEY (Id),
    CONSTRAINT DestinacijaId CHECK (Id > 0),
    CONSTRAINT DestinacijaNaziv CHECK (LEN(Naziv) > 0 AND LEN(Zemlja) > 0)
);
GO

CREATE TABLE impl.tblAranzman
(
    Id            BIGINT IDENTITY(1,1) NOT NULL,
    DatumPolaska  DATE                 NOT NULL,
    BrojMesta     INT                  NOT NULL,
    Cena          DECIMAL(10,2)        NOT NULL,
    IdDestinacije BIGINT               NOT NULL,

    CONSTRAINT pkAranzman PRIMARY KEY (Id),
    CONSTRAINT AranzmanId CHECK (Id > 0),
    CONSTRAINT AranzmanDatumPolaska CHECK (DatumPolaska > CAST(GETDATE() AS DATE)),
    CONSTRAINT AranzmanBrojMesta CHECK (BrojMesta >= 1),
    CONSTRAINT AranzmanCena CHECK (Cena > 0),
    CONSTRAINT fkAranzmanDestinacija FOREIGN KEY (IdDestinacije)
        REFERENCES impl.tblDestinacija (Id)
);
GO

CREATE INDEX idxAranzmanIdDestinacije ON impl.tblAranzman (IdDestinacije);
GO

CREATE TABLE impl.tblRezervacija
(
    Id          BIGINT IDENTITY(1,1) NOT NULL,
    ImeGosta    NVARCHAR(100)        NOT NULL,
    Email_Enc   VARBINARY(256)       NOT NULL,
    EmailHash   VARBINARY(32)        NOT NULL,
    DatumRez    DATE                 NOT NULL,
    IdAranzmana BIGINT               NOT NULL,

    CONSTRAINT pkRezervacija PRIMARY KEY (Id),
    CONSTRAINT RezervacijaId CHECK (Id > 0),
    CONSTRAINT RezervacijaImeGosta CHECK (LEN(ImeGosta) > 0),
    CONSTRAINT RezervacijaDatum CHECK (DatumRez <= CAST(GETDATE() AS DATE)),

    CONSTRAINT fkRezervacijaAranzman FOREIGN KEY (IdAranzmana)
        REFERENCES impl.tblAranzman (Id)
);
GO

CREATE INDEX idxRezervacijaIdAranzmana ON impl.tblRezervacija (IdAranzmana);
GO
CREATE INDEX idxRezervacijaEmailHash ON impl.tblRezervacija (EmailHash);
GO

PRINT N'Tabele tblDestinacija, tblAranzman i tblRezervacija su kreirane.';
GO
