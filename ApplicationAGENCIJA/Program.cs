using System;

namespace ApplicationAGENCIJA
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            if (!Console.IsInputRedirected)
                Console.InputEncoding = System.Text.Encoding.UTF8;

            try
            {
                Baza.Otvori();
                Console.WriteLine("Povezano na bazu TuristickaAgencija (uloga DataProviderAGENCIJA).");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska pri povezivanju: " + ex.Message);
                return;
            }

            bool kraj = false;
            while (!kraj)
            {
                Console.WriteLine();
                Console.WriteLine("===== APLIKACIJA AGENCIJE =====");
                Console.WriteLine("1  - Prikazi destinacije");
                Console.WriteLine("2  - Dodaj destinaciju");
                Console.WriteLine("3  - Obrisi destinaciju");
                Console.WriteLine("4  - Prikazi aranzmane");
                Console.WriteLine("5  - Dodaj aranzman");
                Console.WriteLine("6  - Obrisi aranzman");
                Console.WriteLine("7  - Prikazi rezervacije (sa email-om)");
                Console.WriteLine("8  - Kreiraj rezervaciju");
                Console.WriteLine("9  - Otkazi rezervaciju");
                Console.WriteLine("10 - Pretraga aranzmana (destinacija/cena)");
                Console.WriteLine("11 - Pretraga po XML opisu (prevoz/smestaj)");
                Console.WriteLine("0  - Izlaz");
                Console.Write("Izbor: ");

                string izbor = Console.ReadLine();
                try
                {
                    if (izbor == "1")
                    {
                        Baza.PrikaziDestinacije();
                    }
                    else if (izbor == "2")
                    {
                        Console.Write("Naziv: ");
                        string naziv = Console.ReadLine();
                        Console.Write("Zemlja: ");
                        string zemlja = Console.ReadLine();
                        Console.Write("Prevoz: ");
                        string prevoz = Console.ReadLine();
                        Console.Write("Smestaj: ");
                        string smestaj = Console.ReadLine();
                        Console.Write("Ukljuceno: ");
                        string ukljuceno = Console.ReadLine();
                        Console.Write("Opis mesta (moze prazno): ");
                        string opisMesta = Console.ReadLine();
                        Baza.DodajDestinaciju(naziv, zemlja, prevoz, smestaj, ukljuceno, opisMesta);
                    }
                    else if (izbor == "3")
                    {
                        Console.Write("Id destinacije: ");
                        long id = long.Parse(Console.ReadLine());
                        Baza.ObrisiDestinaciju(id);
                    }
                    else if (izbor == "4")
                    {
                        Baza.PrikaziAranzmane();
                    }
                    else if (izbor == "5")
                    {
                        Console.Write("Datum polaska (yyyy-MM-dd): ");
                        DateTime datum = DateTime.Parse(Console.ReadLine());
                        Console.Write("Broj mesta: ");
                        int brojMesta = int.Parse(Console.ReadLine());
                        Console.Write("Cena: ");
                        decimal cena = decimal.Parse(Console.ReadLine());
                        Console.Write("Id destinacije: ");
                        long idDest = long.Parse(Console.ReadLine());
                        Baza.DodajAranzman(datum, brojMesta, cena, idDest);
                    }
                    else if (izbor == "6")
                    {
                        Console.Write("Id aranzmana: ");
                        long id = long.Parse(Console.ReadLine());
                        Baza.ObrisiAranzman(id);
                    }
                    else if (izbor == "7")
                    {
                        Baza.PrikaziRezervacije();
                    }
                    else if (izbor == "8")
                    {
                        Console.Write("Id aranzmana: ");
                        long idAr = long.Parse(Console.ReadLine());
                        Console.Write("Ime gosta: ");
                        string ime = Console.ReadLine();
                        Console.Write("Email: ");
                        string email = Console.ReadLine();
                        Baza.DodajRezervaciju(idAr, ime, email);
                    }
                    else if (izbor == "9")
                    {
                        Console.Write("Id rezervacije: ");
                        long id = long.Parse(Console.ReadLine());
                        Baza.OtkaziRezervaciju(id);
                    }
                    else if (izbor == "10")
                    {
                        Console.Write("Naziv destinacije (moze prazno): ");
                        string naziv = Console.ReadLine();
                        Console.Write("Maksimalna cena (moze prazno): ");
                        string cenaTekst = Console.ReadLine();
                        decimal? maxCena = null;
                        if (cenaTekst != "")
                            maxCena = decimal.Parse(cenaTekst);
                        Baza.PretragaAranzmana(naziv, maxCena);
                    }
                    else if (izbor == "11")
                    {
                        Console.Write("Prevoz (npr. Авион): ");
                        string prevoz = Console.ReadLine();
                        Console.Write("Smestaj (npr. Хотел): ");
                        string smestaj = Console.ReadLine();
                        Baza.PretragaPoOpisu(prevoz, smestaj);
                    }
                    else if (izbor == "0")
                    {
                        kraj = true;
                    }
                    else
                    {
                        Console.WriteLine("Nepoznata opcija.");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("GRESKA: " + ex.Message);
                }
            }

            Baza.Zatvori();
            Console.WriteLine("Dovidjenja!");
        }
    }
}
