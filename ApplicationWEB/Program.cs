using System;

namespace ApplicationWEB
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
                Console.WriteLine("Povezano na bazu TuristickaAgencija (uloga DataProviderWEB).");
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
                Console.WriteLine("===== WEB APLIKACIJA ZA KLIJENTE =====");
                Console.WriteLine("1 - Prikazi destinacije");
                Console.WriteLine("2 - Prikazi aranzmane");
                Console.WriteLine("3 - Detalji aranzmana");
                Console.WriteLine("4 - Pretraga aranzmana (destinacija/cena)");
                Console.WriteLine("5 - Pretraga po XML opisu (prevoz/smestaj)");
                Console.WriteLine("6 - Rezervisi aranzman");
                Console.WriteLine("7 - Otkazi rezervaciju");
                Console.WriteLine("0 - Izlaz");
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
                        Baza.PrikaziAranzmane();
                    }
                    else if (izbor == "3")
                    {
                        Console.Write("Id aranzmana: ");
                        long id = long.Parse(Console.ReadLine());
                        Baza.DetaljiAranzmana(id);
                    }
                    else if (izbor == "4")
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
                    else if (izbor == "5")
                    {
                        Console.Write("Prevoz (npr. Авион): ");
                        string prevoz = Console.ReadLine();
                        Console.Write("Smestaj (npr. Хотел): ");
                        string smestaj = Console.ReadLine();
                        Baza.PretragaPoOpisu(prevoz, smestaj);
                    }
                    else if (izbor == "6")
                    {
                        Console.Write("Id aranzmana: ");
                        long idAr = long.Parse(Console.ReadLine());
                        Console.Write("Vase ime: ");
                        string ime = Console.ReadLine();
                        Console.Write("Vas email: ");
                        string email = Console.ReadLine();
                        Baza.DodajRezervaciju(idAr, ime, email);
                    }
                    else if (izbor == "7")
                    {
                        Console.Write("Id rezervacije: ");
                        long id = long.Parse(Console.ReadLine());
                        Baza.OtkaziRezervaciju(id);
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
