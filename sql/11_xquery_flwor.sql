USE TuristickaAgencija;
GO

PRINT N'--- 1) FLWOR sa contains(): destinacije sa avionom i hotelom ---';
SELECT d.Id, d.Naziv,
       d.OpisXML.query('
           for $o in /opis
           where contains(($o/prevoz)[1], "Авион")
             and contains(($o/smestaj)[1], "Хотел")
           return
               <pogodak>
                   <prevoz>{data($o/prevoz)}</prevoz>
                   <smestaj>{data($o/smestaj)}</smestaj>
               </pogodak>
       ') AS Rezultat
FROM impl.tblDestinacija d;
GO

PRINT N'--- 2) Aranzmani gde opis sadrzi avionski prevoz i hotel ---';
SELECT a.Id, a.DatumPolaska, a.Cena, d.Naziv AS NazivDestinacije
FROM impl.tblAranzman a
JOIN impl.tblDestinacija d ON d.Id = a.IdDestinacije
WHERE d.OpisXML.exist('/opis[contains((prevoz)[1], "Авион")
                             and contains((smestaj)[1], "Хотел")]') = 1;
GO

PRINT N'--- 3) FLWOR sa string-length(): destinacije sa opisom mesta ---';
SELECT d.Id, d.Naziv,
       d.OpisXML.query('
           for $o in /opis
           where string-length(($o/opis_mesta)[1]) > 0
           return <opisMesta>{data($o/opis_mesta)}</opisMesta>
       ') AS OpisMesta
FROM impl.tblDestinacija d
WHERE d.OpisXML.exist('/opis[string-length((opis_mesta)[1]) > 0]') = 1;
GO

PRINT N'--- 4) Pretraga kroz proceduru upr_PretragaPoOpisu ---';
EXEC spec.upr_PretragaPoOpisu @prevoz = N'Авион', @smestaj = N'Хотел';
GO
