USE TuristickaAgencija;
GO

INSERT INTO impl.tblDestinacija (Naziv, Zemlja, OpisXML) VALUES
(N'Грчка — Санторини', N'Грчка',
 N'<opis><prevoz>Авион</prevoz><smestaj>Хотел 4*</smestaj><ukljuceno>Доручак</ukljuceno><opis_mesta>Романтично острво</opis_mesta></opis>'),
(N'Италија — Рим', N'Италија',
 N'<opis><prevoz>Аутобус</prevoz><smestaj>Хотел 3*</smestaj><ukljuceno>Полупансион</ukljuceno></opis>'),
(N'Шпанија — Барселона', N'Шпанија',
 N'<opis><prevoz>Авион</prevoz><smestaj>Апартман</smestaj><ukljuceno>Само смештај</ukljuceno></opis>');
GO

INSERT INTO impl.tblAranzman (IdDestinacije, DatumPolaska, BrojMesta, Cena) VALUES
(1, '2027-07-15', 20, 1299.99),
(1, '2027-08-10', 15, 1199.99),
(2, '2027-06-20', 30,  799.99),
(3, '2027-09-01', 25,  999.99);
GO

EXEC spec.upr_KreirajRezerv @idAranzmana = 1, @imeGosta = N'Марко Петровић',
                            @email = N'marko@example.rs',  @datumRez = '2025-03-15';
EXEC spec.upr_KreirajRezerv @idAranzmana = 1, @imeGosta = N'Ана Николић',
                            @email = N'ana@example.rs',    @datumRez = '2025-03-16';
EXEC spec.upr_KreirajRezerv @idAranzmana = 3, @imeGosta = N'Стефан Јовановић',
                            @email = N'stefan@example.rs', @datumRez = '2025-04-01';
GO

PRINT N'--- Destinacije ---';
SELECT Id, Naziv, Zemlja FROM impl.tblDestinacija;

PRINT N'--- Aranzmani (kroz pogled, sa slobodnim mestima) ---';
SELECT Id, DatumPolaska, BrojMesta, Cena, NazivDestinacije, SlobodnaMesta
FROM spec.vw_ARANZMAN;

PRINT N'--- Rezervacije: email je u tabeli sifrovan (VARBINARY) ---';
SELECT Id, ImeGosta, Email_Enc, DatumRez, IdAranzmana FROM impl.tblRezervacija;

PRINT N'--- Rezervacije: kroz spec pogled email se desifruje ---';
SELECT Id, ImeGosta, Email, DatumRez, IdAranzmana FROM spec.vw_REZERVACIJA;
GO
