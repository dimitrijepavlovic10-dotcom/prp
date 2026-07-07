# PRP — Projekat 13: Turistička agencija

Projekat iz predmeta Projektovanje računarskih programa. Baza podataka
`TuristickaAgencija` (SQL Server) sa troslojnom arhitekturom
(impl / spec / api), dve konzolne aplikacije i SOAP servis.

## Struktura

- `sql/` — skripte za kreiranje baze, redom od `01` do `12`
  (šeme i uloge, XML šema, enkripcija, tabele, trigeri, spec sloj,
  api slojevi, aplikacione uloge, demo podaci, SOAP endpoint,
  XQuery/FLWOR primeri, HASHBYTES pretraga)
- `sql/tests/` — test skripte
- `ApplicationAGENCIJA/` — konzolna aplikacija za zaposlene u agenciji
  (destinacije, aranžmani, rezervacije — pun pristup)
- `ApplicationWEB/` — konzolna aplikacija za klijente
  (pregled, pretraga, rezervisanje)
- `SoapServis/` — SOAP web servis (CoreWCF)

## Pokretanje

1. Izvršiti SQL skripte iz foldera `sql/` redom (01–09) na lokalnom
   SQL Server-u.
2. Pokrenuti aplikacije:

```
dotnet run --project ApplicationAGENCIJA
dotnet run --project ApplicationWEB
dotnet run --project SoapServis
```

Aplikacije se povezuju na `localhost` (Windows autentifikacija) i koriste
aplikacione uloge `DataProviderAGENCIJA` i `DataProviderWEB`.
