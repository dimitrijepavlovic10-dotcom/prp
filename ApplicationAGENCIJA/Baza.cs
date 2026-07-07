using System;
using Microsoft.Data.SqlClient;

namespace ApplicationAGENCIJA
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
            cmd.Parameters.AddWithValue("@rolename", "DataProviderAGENCIJA");
            cmd.Parameters.AddWithValue("@password", "Agencija#Lozinka123");
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
                "SELECT Id, Naziv, Zemlja FROM api_agencija.DESTINACIJA ORDER BY Id", konekcija);

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

        public static void DodajDestinaciju(string naziv, string zemlja,
            string prevoz, string smestaj, string ukljuceno, string opisMesta)
        {
            string opisXml = "<opis><prevoz>" + prevoz + "</prevoz>" +
                             "<smestaj>" + smestaj + "</smestaj>" +
                             "<ukljuceno>" + ukljuceno + "</ukljuceno>";
            if (opisMesta != "")
                opisXml = opisXml + "<opis_mesta>" + opisMesta + "</opis_mesta>";
            opisXml = opisXml + "</opis>";

            SqlCommand cmd = new SqlCommand("api_agencija.KreirajDestinaciju", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@naziv", naziv);
            cmd.Parameters.AddWithValue("@zemlja", zemlja);
            cmd.Parameters.AddWithValue("@opisXml", opisXml);

            object noviId = cmd.ExecuteScalar();
            Console.WriteLine("Destinacija je dodata, Id = " + noviId);
        }

        public static void ObrisiDestinaciju(long id)
        {
            SqlCommand cmd = new SqlCommand("api_agencija.ObrisiDestinaciju", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idDestinacije", id);
            cmd.ExecuteNonQuery();
            Console.WriteLine("Destinacija je obrisana.");
        }

        public static void PrikaziAranzmane()
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT Id, DatumPolaska, BrojMesta, Cena, NazivDestinacije, SlobodnaMesta " +
                "FROM api_agencija.ARANZMAN ORDER BY DatumPolaska", konekcija);

            SqlDataReader citac = cmd.ExecuteReader();
            IspisiAranzmane(citac);
            citac.Close();
        }

        public static void DodajAranzman(DateTime datumPolaska, int brojMesta, decimal cena, long idDestinacije)
        {
            SqlCommand cmd = new SqlCommand("api_agencija.KreirajAranzman", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@datumPolaska", datumPolaska);
            cmd.Parameters.AddWithValue("@brojMesta", brojMesta);
            cmd.Parameters.AddWithValue("@cena", cena);
            cmd.Parameters.AddWithValue("@idDestinacije", idDestinacije);

            object noviId = cmd.ExecuteScalar();
            Console.WriteLine("Aranzman je dodat, Id = " + noviId);
        }

        public static void ObrisiAranzman(long id)
        {
            SqlCommand cmd = new SqlCommand("api_agencija.ObrisiAranzman", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idAranzmana", id);
            cmd.ExecuteNonQuery();
            Console.WriteLine("Aranzman je obrisan.");
        }

        public static void PrikaziRezervacije()
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT Id, ImeGosta, Email, DatumRez, IdAranzmana " +
                "FROM api_agencija.REZERVACIJA ORDER BY Id", konekcija);

            SqlDataReader citac = cmd.ExecuteReader();
            Console.WriteLine();
            Console.WriteLine("{0,-5} {1,-25} {2,-25} {3,-12} {4,-10}",
                "Id", "Ime gosta", "Email", "Datum", "Aranzman");
            Console.WriteLine(new string('-', 80));
            while (citac.Read())
            {
                Console.WriteLine("{0,-5} {1,-25} {2,-25} {3,-12:yyyy-MM-dd} {4,-10}",
                    citac.GetInt64(0), citac.GetString(1),
                    citac.IsDBNull(2) ? "" : citac.GetString(2),
                    citac.GetDateTime(3), citac.GetInt64(4));
            }
            citac.Close();
        }

        public static void DodajRezervaciju(long idAranzmana, string imeGosta, string email)
        {
            SqlCommand cmd = new SqlCommand("api_agencija.KreirajRezervaciju", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idAranzmana", idAranzmana);
            cmd.Parameters.AddWithValue("@imeGosta", imeGosta);
            cmd.Parameters.AddWithValue("@email", email);

            object noviId = cmd.ExecuteScalar();
            Console.WriteLine("Rezervacija je kreirana, Id = " + noviId);
        }

        public static void OtkaziRezervaciju(long id)
        {
            SqlCommand cmd = new SqlCommand("api_agencija.OtkaziRezervaciju", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idRezervacije", id);
            cmd.ExecuteNonQuery();
            Console.WriteLine("Rezervacija je otkazana.");
        }

        public static void PretragaAranzmana(string nazivDestinacije, decimal? maxCena)
        {
            SqlCommand cmd = new SqlCommand("api_agencija.PretragaAranzmana", konekcija);
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
            SqlCommand cmd = new SqlCommand("api_agencija.PretragaPoOpisu", konekcija);
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
