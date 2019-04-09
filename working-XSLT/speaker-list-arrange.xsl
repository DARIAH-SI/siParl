<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakorkatni *-speaker-1.xml -->
    <!-- prečiščim seznam govornikov: odstranim odvečne elemente in dodam metapodatke -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Seznam govornikov v slovenskem parlamentu</title>
                        <respStmt>
                            <persName>Andrej Pančur</persName>
                            <resp xml:lang="sl">Kodiranje TEI</resp>
                            <resp xml:lang="en">TEI corpus encoding</resp>
                        </respStmt>
                        <respStmt>
                            <persName>Mihael Ojsteršek</persName>
                            <resp xml:lang="sl">Kodiranje TEI</resp>
                            <resp xml:lang="en">TEI corpus encoding</resp>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <orgName xml:lang="sl">Inštitut za novejšo zgodovino</orgName>
                            <orgName xml:lang="en">Institute of Contemporary History</orgName>
                            <ref target="http://www.inz.si/">http://www.inz.si/</ref>
                            <address>
                                <street>Kongresni trg 1</street>
                                <settlement>Ljubljana</settlement>
                                <postCode>1000</postCode>
                                <country xml:lang="sl">Slovenija</country>
                                <country xml:lang="en">Slovenia</country>
                            </address>
                            <email>inz@inz.si</email>
                        </publisher>
                        <distributor>DARIAH-SI</distributor>
                        <distributor>CLARIN.SI</distributor>
                        <availability status="free">
                            <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                            <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                Attribution 4.0 International License</ref>.</p>
                            <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                        </availability>
                        <date when="{current-date()}"/>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Born digital.</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <listPerson>
                        <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:listPerson/tei:person">
                            <xsl:sort select="@xml:id"/>
                            <person xml:id="{@xml:id}">
                                <xsl:copy-of select="tei:persName"/>
                            </person>
                        </xsl:for-each>
                    </listPerson>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
</xsl:stylesheet>