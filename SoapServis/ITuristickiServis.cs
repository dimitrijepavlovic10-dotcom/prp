using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel;

namespace SoapServis
{
    [ServiceContract(Namespace = "http://turistickaagencija.rs/webservice")]
    public interface ITuristickiServis
    {
        [OperationContract]
        List<Aranzman> PretragaAranzman(string nazivDestinacije, decimal maxCena);

        [OperationContract]
        AranzmanDetalji DetaljiAranzman(long idAranzmana);
    }

    [DataContract(Namespace = "http://turistickaagencija.rs/webservice")]
    public class Aranzman
    {
        [DataMember] public long Id { get; set; }
        [DataMember] public DateTime DatumPolaska { get; set; }
        [DataMember] public int BrojMesta { get; set; }
        [DataMember] public decimal Cena { get; set; }
        [DataMember] public string NazivDestinacije { get; set; }
        [DataMember] public string Zemlja { get; set; }
        [DataMember] public int SlobodnaMesta { get; set; }
    }

    [DataContract(Namespace = "http://turistickaagencija.rs/webservice")]
    public class AranzmanDetalji
    {
        [DataMember] public long Id { get; set; }
        [DataMember] public DateTime DatumPolaska { get; set; }
        [DataMember] public int BrojMesta { get; set; }
        [DataMember] public decimal Cena { get; set; }
        [DataMember] public string NazivDestinacije { get; set; }
        [DataMember] public string Zemlja { get; set; }
        [DataMember] public int SlobodnaMesta { get; set; }
        [DataMember] public string OpisXML { get; set; }
    }
}
