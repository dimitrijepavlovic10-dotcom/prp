USE TuristickaAgencija;
GO

CREATE XML SCHEMA COLLECTION impl.schOpis AS
N'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="opis">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="prevoz"     type="xs:string" />
        <xs:element name="smestaj"    type="xs:string" />
        <xs:element name="ukljuceno"  type="xs:string" />
        <xs:element name="opis_mesta" type="xs:string" minOccurs="0" />
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>';
GO

PRINT N'XML Schema Collection schOpis je kreirana.';
GO
