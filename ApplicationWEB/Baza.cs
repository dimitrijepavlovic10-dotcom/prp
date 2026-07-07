using System;
using Microsoft.Data.SqlClient;

namespace ApplicationWEB
{
    public static class Baza
    {
        private const string KonekcioniString =
            "Server=localhost;Database=TuristickaAgencija;" +
            "User Id=AppKorisnik;Password=App#Lozinka123;" +
            "TrustServerCertificate=True;Pooling=false";

        private static SqlConnection konekcija;
        public static void Otvori()
        {
            konekcija = new SqlConnection(KonekcioniString);
            konekcija.Open();

            SqlCommand cmd = new SqlCommand("sp_setapprole", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@rolename", "DataProviderWEB");
            cmd.Parameters.AddWithValue("@password", "Web#Lozinka123");
            cmd.ExecuteNonQuery();
        }

        public static void Zatvori()
        {
            if (konekcija != null)
                konekcija.Close();
        }

        public static void PrikaziDestinacije()
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT Id, Naziv, Zemlja FROM api_web.DESTINACIJA ORDER BY Id", konekcija);

            SqlDataReader citac = cmd.ExecuteReader();
            Console.WriteLine();
            Console.WriteLine("{0,-5} {1,-30} {2,-15}", "Id", "Naziv", "Zemlja");
            Console.WriteLine(new string('-', 52));
            while (citac.Read())
            {
                Console.WriteLine("{0,-5} {1,-30} {2,-15}",
                    citac.GetInt64(0), citac.GetString(1), citac.GetString(2));
            }
            citac.Close();
        }

        public static void PrikaziAranzmane()
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT Id, DatumPolaska, BrojMesta, Cena, NazivDestinacije, SlobodnaMesta " +
                "FROM api_web.ARANZMAN ORDER BY DatumPolaska", konekcija);

            SqlDataReader citac = cmd.ExecuteReader();
            IspisiAranzmane(citac);
            citac.Close();
        }

        public static void DetaljiAranzmana(long idAranzmana)
        {
            SqlCommand cmd = new SqlCommand("api_web.DetaljiAranzmana", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idAranzmana", idAranzmana);

            SqlDataReader citac = cmd.ExecuteReader();
            if (citac.Read())
            {
                Console.WriteLine();
                Console.WriteLine("Aranzman:      " + citac["Id"]);
                Console.WriteLine("Destinacija:   " + citac["NazivDestinacije"] + " (" + citac["Zemlja"] + ")");
                Console.WriteLine("Polazak:       " + string.Format("{0:yyyy-MM-dd}", citac["DatumPolaska"]));
                Console.WriteLine("Cena:          " + citac["Cena"]);
                Console.WriteLine("Broj mesta:    " + citac["BrojMesta"]);
                Console.WriteLine("Slobodno:      " + citac["SlobodnaMesta"]);
                Console.WriteLine("Opis (XML):    " + citac["OpisXML"]);
            }
            else
            {
                Console.WriteLine("Aranzman nije pronadjen.");
            }
            citac.Close();
        }

        public static void DodajRezervaciju(long idAranzmana, string imeGosta, string email)
        {
            SqlCommand cmd = new SqlCommand("api_web.KreirajRezervaciju", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idAranzmana", idAranzmana);
            cmd.Parameters.AddWithValue("@imeGosta", imeGosta);
            cmd.Parameters.AddWithValue("@email", email);

            object noviId = cmd.ExecuteScalar();
            Console.WriteLine("Rezervacija je kreirana, Id = " + noviId);
        }

        public static void OtkaziRezervaciju(long id)
        {
            SqlCommand cmd = new SqlCommand("api_web.OtkaziRezervaciju", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idRezervacije", id);
            cmd.ExecuteNonQuery();
            Console.WriteLine("Rezervacija je otkazana.");
        }

        public static void PretragaAranzmana(string nazivDestinacije, decimal? maxCena)
        {
            SqlCommand cmd = new SqlCommand("api_web.PretragaAranzmana", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            if (nazivDestinacije != "")
                cmd.Parameters.AddWithValue("@nazivDestinacije", nazivDestinacije);
            if (maxCena != null)
                cmd.Parameters.AddWithValue("@maxCena", maxCena);

            SqlDataReader citac = cmd.ExecuteReader();
            IspisiAranzmane(citac);
            citac.Close();
        }

        public static void PretragaPoOpisu(string prevoz, string smestaj)
        {
            SqlCommand cmd = new SqlCommand("api_web.PretragaPoOpisu", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@prevoz", prevoz);
            cmd.Parameters.AddWithValue("@smestaj", smestaj);

            SqlDataReader citac = cmd.ExecuteReader();
            IspisiAranzmane(citac);
            citac.Close();
        }

        private static void IspisiAranzmane(SqlDataReader citac)
        {
            Console.WriteLine();
            Console.WriteLine("{0,-5} {1,-12} {2,-8} {3,-10} {4,-30} {5,-9}",
                "Id", "Polazak", "Mesta", "Cena", "Destinacija", "Slobodno");
            Console.WriteLine(new string('-', 78));
            while (citac.Read())
            {
                Console.WriteLine("{0,-5} {1,-12:yyyy-MM-dd} {2,-8} {3,-10} {4,-30} {5,-9}",
                    citac["Id"], citac["DatumPolaska"], citac["BrojMesta"],
                    citac["Cena"], citac["NazivDestinacije"], citac["SlobodnaMesta"]);
            }
        }
    }
}
