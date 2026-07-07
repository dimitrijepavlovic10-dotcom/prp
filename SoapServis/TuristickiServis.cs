using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;

namespace SoapServis
{
    public class TuristickiServis : ITuristickiServis
    {
        private const string KonekcioniString =
            "Server=localhost;Database=TuristickaAgencija;" +
            "User Id=AppKorisnik;Password=App#Lozinka123;" +
            "TrustServerCertificate=True;Pooling=false";

        private static SqlConnection Otvori()
        {
            SqlConnection konekcija = new SqlConnection(KonekcioniString);
            konekcija.Open();

            SqlCommand cmd = new SqlCommand("sp_setapprole", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@rolename", "DataProviderWEB");
            cmd.Parameters.AddWithValue("@password", "Web#Lozinka123");
            cmd.ExecuteNonQuery();

            return konekcija;
        }

        public List<Aranzman> PretragaAranzman(string nazivDestinacije, decimal maxCena)
        {
            List<Aranzman> rezultat = new List<Aranzman>();

            SqlConnection konekcija = Otvori();
            SqlCommand cmd = new SqlCommand("api_web.PretragaAranzmana", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            if (nazivDestinacije != null && nazivDestinacije != "")
                cmd.Parameters.AddWithValue("@nazivDestinacije", nazivDestinacije);
            if (maxCena > 0)
                cmd.Parameters.AddWithValue("@maxCena", maxCena);

            SqlDataReader citac = cmd.ExecuteReader();
            while (citac.Read())
            {
                Aranzman a = new Aranzman();
                a.Id = (long)citac["Id"];
                a.DatumPolaska = (DateTime)citac["DatumPolaska"];
                a.BrojMesta = (int)citac["BrojMesta"];
                a.Cena = (decimal)citac["Cena"];
                a.NazivDestinacije = (string)citac["NazivDestinacije"];
                a.Zemlja = (string)citac["Zemlja"];
                a.SlobodnaMesta = (int)citac["SlobodnaMesta"];
                rezultat.Add(a);
            }
            citac.Close();
            konekcija.Close();

            return rezultat;
        }

        public AranzmanDetalji DetaljiAranzman(long idAranzmana)
        {
            AranzmanDetalji detalji = null;

            SqlConnection konekcija = Otvori();
            SqlCommand cmd = new SqlCommand("api_web.DetaljiAranzmana", konekcija);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idAranzmana", idAranzmana);

            SqlDataReader citac = cmd.ExecuteReader();
            if (citac.Read())
            {
                detalji = new AranzmanDetalji();
                detalji.Id = (long)citac["Id"];
                detalji.DatumPolaska = (DateTime)citac["DatumPolaska"];
                detalji.BrojMesta = (int)citac["BrojMesta"];
                detalji.Cena = (decimal)citac["Cena"];
                detalji.NazivDestinacije = (string)citac["NazivDestinacije"];
                detalji.Zemlja = (string)citac["Zemlja"];
                detalji.SlobodnaMesta = (int)citac["SlobodnaMesta"];
                detalji.OpisXML = (string)citac["OpisXML"];
            }
            citac.Close();
            konekcija.Close();

            return detalji;
        }
    }
}
