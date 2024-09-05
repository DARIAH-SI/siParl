<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei" version="2.0">
    
<!--Input: Mapping-full.xml
    Output: listOrg.xml-->  
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="documentsList" mode="pass0">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>List of speakers</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Base for construction of listPerson</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                        <p>
                            <xsl:value-of select="document-uri(.)"/>
                        </p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    
                        <listOrg>
                    <listOrg xml:id="workingBodies">
                        <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                        <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                        <xsl:variable name="allOrg" as="xs:string*"> 
                            <xsl:for-each select="ref">
                                <xsl:variable name="targetDoc" select="document(.)"/>
                                <xsl:sequence select="$targetDoc//tei:listOrg//tei:orgName[@key]/@key"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:for-each select="distinct-values($allOrg)">
                            <xsl:sort select="."/>
                            <org>
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                                <xsl:attribute name="ana">
                                    <xsl:text>#parla.committee</xsl:text>
                                </xsl:attribute>
                                <orgName>
                                    <xsl:choose>
                                        <xsl:when test="contains(., 'KZP')">
                                            <xsl:text>Komisija za poslovnik</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'KZNS')">
                                            <xsl:text>Komisija za narodni skupnosti</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'KZPÄPIEM')">
                                            <xsl:text>Komisija za peticije, človekove pravice in enake možnosti</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'KZNOIVS')">
                                            <xsl:text>Komisija za nadzor obveščevalnih in varnostnih služb</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZG')">
                                            <xsl:text>Odbor za gospodarstvo</xsl:text>
                                        </xsl:when>
					<xsl:when test="contains(., 'OZIZSIM')">
					  <xsl:text>Odbor za izobraževanje, znanost, šport in mladino</xsl:text>
					</xsl:when>
                                        <xsl:when test="contains(., 'OZIOIP')">
                                            <xsl:text>Odbor za infrastrukturo, okolje in prostor</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZKGIP')">
                                            <xsl:text>Odbor za kmetijstvo, gozdarstvo in prehrano</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZF')">
                                            <xsl:text>Odbor za finance</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'KZNJF')">
                                            <xsl:text>Komisija za nadzor javnih financ</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZZEU')">
                                            <xsl:text>Odbor za zadeve Evropske unije</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZZP')">
                                            <xsl:text>Odbor za zunanjo politiko</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZO')">
                                            <xsl:text>Odbor za obrambo</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZZ')">
                                            <xsl:text>Odbor za zdravstvo</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'PZSROVRS')">
                                            <xsl:text>Pododbor za spremljanje rakavih obolenj v Republiki Sloveniji</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZIZŠIM')">
                                            <xsl:text>Odbor za izobraževanje, znanost, šport in mladino</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZDDSZII')">
                                            <xsl:text>Odbor za delo, družino, socialne zadeve in invalide</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'KZOSSVZIPS')">
                                            <xsl:text>Komisija za odnose s Slovenci v zamejstvu in po svetu</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'UK')">
                                            <xsl:text>Ustavna komisija</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'MK')">
                                            <xsl:text>Mandatno-volilna komisija</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'SO')">
                                            <xsl:text>Skupni odbor</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZP')">
                                            <xsl:text>Odbor za pravosodje</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZNZJUILS')">
                                            <xsl:text>Odbor za notranje zadeve, javno upravo in lokalno samoupravo</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'PZSRT')">
                                            <xsl:text>Pododbor za spremljanje romske tematike</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZK')">
                                            <xsl:text>Odbor za kulturo</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'Skupna')">
                                            <xsl:text>Skupna seja</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'OZIZZIM')">
                                            <xsl:text>Odbor za izobraževanje, znanost, šport in mladino</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="contains(., 'KPDZ')">
                                            <xsl:text>Kolegij predsednika Državnega zbora</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:message>
                                                <xsl:value-of
                                                    select="concat('Error: ', ., 'Missing full name')"/>
                                            </xsl:message>
                                        </xsl:otherwise>
                                </xsl:choose>
                                </orgName>
                            </org>
                        </xsl:for-each>
                        </listOrg>
                        <org xml:id="party.DLGV" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Državljanska lista Gregorja Viranta</orgName>
                            <orgName full="yes" xml:lang="en">Gregor Virant's Civic List</orgName>
                            <orgName full="abb">DLGV</orgName>
                            <event from="2011-10-21" to="2012-04-24">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Dr%C5%BEavljanska_lista</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Civic_List_(Slovenia)</idno>
                        </org>
                        <org xml:id="party.DL" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Državljanska lista</orgName>
                            <orgName full="yes" xml:lang="en">Civic List</orgName>
                            <orgName full="abb">DL</orgName>
                            <event from="2012-04-24">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Dr%C5%BEavljanska_lista</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Civic_List_(Slovenia)</idno>
                        </org>
                        <org xml:id="party.DeSUS" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Demokratična stranka upokojencev Slovenije</orgName>
                            <orgName full="yes" xml:lang="en">Democratic Party of Pensioners of Slovenia</orgName>
                            <orgName full="abb">DeSUS</orgName>
                            <event from="1991-05-30">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Demokrati%C4%8Dna_stranka_upokojencev_Slovenije</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Democratic_Party_of_Pensioners_of_Slovenia</idno>
                        </org>
                        <org xml:id="party.LDS.2" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Liberalna demokracija Slovenije</orgName>
                            <orgName full="yes" xml:lang="en">Liberal Democracy of Slovenia</orgName>
                            <orgName full="abb">LDS</orgName>
                            <event from="1994-03-12">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Liberalna_demokracija_Slovenije</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Liberal_Democracy_of_Slovenia</idno>
                        </org>
                        <org xml:id="party.Levica.1" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Združena levica</orgName>
                            <orgName full="yes" xml:lang="en">United Left</orgName>
                            <orgName full="abb">ZL</orgName>
                            <event from="2014-03-01" to="2017-06-24">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/United_Left_(Slovenia)</idno>
                        </org>
                        <org xml:id="party.Levica.2" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Levica</orgName>
                            <orgName full="yes" xml:lang="en">The Left</orgName>
                            <orgName full="abb">Levica</orgName>
                            <event from="2017-06-24">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/The_Left_(Slovenia)</idno>
                        </org>
                        <org xml:id="party.LMŠ" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Lista Marjana Šarca</orgName>
                            <orgName full="yes" xml:lang="en">The List of Marjan Šarec</orgName>
                            <orgName full="abb">LMŠ</orgName>
                            <event from="2014-05-31">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Lista_Marjana_%C5%A0arca</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/List_of_Marjan_%C5%A0arec</idno>
                        </org>
                        <org xml:id="party.Lipa" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Lipa</orgName>
                            <orgName full="yes" xml:lang="en">Party Lime Tree</orgName>
                            <orgName full="abb">Lipa</orgName>
                            <event from="2008-03-01">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Lipa_(stranka)</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Lipa_(political_party)</idno>
                        </org>
                        <org xml:id="party.NeP" role="independent">
                            <orgName full="yes" xml:lang="sl">Nepovezani poslanci</orgName>
                            <orgName full="yes" xml:lang="en">Unrelated members of parliament</orgName>
                            <orgName full="abb">NeP</orgName>
                        </org>
                        <org xml:id="party.NP" role="parliamentaryGroup">
                            <orgName full="yes" xml:lang="sl">Poslanska skupina nepovezanih poslancev</orgName>
                            <orgName full="yes" xml:lang="en">Parliamentary group of unrelated members of parliament</orgName>
                            <orgName full="abb">NP</orgName>
                        </org>
                        <org xml:id="party.IMNS" role="ethnicCommunity">
                            <orgName full="yes" xml:lang="sl">Poslanci italijanske in madžarske narodne skupnosti</orgName>
                            <orgName full="yes" xml:lang="en">Members of the Italian and Hungarian national communities</orgName>
                            <orgName full="abb">IMNS</orgName>
                        </org>
                        <org xml:id="party.NSi" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Nova Slovenija – Krščanski demokrati</orgName>
                            <orgName full="yes" xml:lang="en">New Slovenia – Christian Democrats</orgName>
                            <orgName full="abb">NSi</orgName>
                            <event from="2000-08-04">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Nova_Slovenija</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/New_Slovenia</idno>
                        </org>
                        <org xml:id="party.PS" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Pozitivna Slovenija</orgName>
                            <orgName full="yes" xml:lang="en">Positive Slovenia</orgName>
                            <orgName full="abb">PS</orgName>
                            <event from="2011-10-22">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Pozitivna_Slovenija</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Positive_Slovenia</idno>
                        </org>
                        <org xml:id="party.SD" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Socialni demokrati</orgName>
                            <orgName full="yes" xml:lang="en">Social Democrats</orgName>
                            <orgName full="abb">SD</orgName>
                            <event from="2005-04-02">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Socialni_demokrati</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Social_Democrats_(Slovenia)</idno>
                        </org>
                        <org xml:id="party.SDS.1" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Socialdemokratska stranka Slovenije</orgName>
                            <orgName full="yes" xml:lang="en">Social Democratic Union of Slovenia</orgName>
                            <orgName full="abb">SDS</orgName>
                            <event from="1989-02-16" to="2003-09-19">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Slovenska_demokratska_stranka</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Slovenian_Democratic_Party</idno>
                        </org>
                        <org xml:id="party.SDS.2" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Slovenska demokratska stranka</orgName>
                            <orgName full="yes" xml:lang="en">Slovenian Democratic Party</orgName>
                            <orgName full="abb">SDS</orgName>
                            <event from="2003-09-19">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Slovenska_demokratska_stranka</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Slovenian_Democratic_Party</idno>
                        </org>
                        <org xml:id="party.SLS.2" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Slovenska ljudska stranka</orgName>
                            <orgName full="yes" xml:lang="en">Slovenian People's Party</orgName>
                            <orgName full="abb">SLS</orgName>
                            <event from="2001-12-17">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Slovenska_ljudska_stranka</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Slovenian_People%27s_Party</idno>
                        </org>
                        <org xml:id="party.SLS-SKD" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">SLS+SKD Slovenska ljudska stranka</orgName>
                            <orgName full="yes" xml:lang="en">Slovenian People's Party and Slovene Christian Democrats</orgName>
                            <orgName full="abb">SLS+SKD</orgName>
                            <event from="2000-04-15" to="2001-12-17">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/SLS%2BSKD_Slovenska_ljudska_stranka</idno>
                        </org>
                        <org xml:id="party.SMC.1" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Stranka Mira Cerarja</orgName>
                            <orgName full="yes" xml:lang="en">Party of Miro Cerar</orgName>
                            <orgName full="abb">SMC</orgName>
                            <event from="2014-06-02" to="2015-03-07">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
                        </org>
                        <org xml:id="party.SMC.2" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Stranka modernega centra</orgName>
                            <orgName full="yes" xml:lang="en">Modern Centre Party</orgName>
                            <orgName full="abb">SMC</orgName>
                            <event from="2015-03-07" to="2021-12-04">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
                        </org>
                        <org xml:id="party.Konkretno" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Konkretno</orgName>
                            <orgName full="yes" xml:lang="en">Concretely</orgName>
                            <orgName full="abb">Konkretno</orgName>
                            <event from="2021-12-04">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Konkretno</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Concretely</idno>
                        </org>
                        <org xml:id="party.GAS" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Gospodarsko aktivna stranka</orgName>
                            <orgName full="abb">GAS</orgName>
                            <event from="2017-06-24" to="2021-12-04">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Gospodarsko_aktivna_stranka</idno>
                        </org>
                        <org xml:id="party.SMS" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Stranka mladih Slovenije</orgName>
                            <orgName full="yes" xml:lang="en">Youth Party of Slovenia</orgName>
                            <orgName full="abb">SMS</orgName>
                            <event from="2000-07-04" to="2009-07-04">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_mladih_-_Zeleni_Evrope</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Youth_Party_%E2%80%93_European_Greens</idno>
                        </org>
                        <org xml:id="party.SNS" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Slovenska nacionalna stranka</orgName>
                            <orgName full="yes" xml:lang="en">Slovenian National Party</orgName>
                            <orgName full="abb">SNS</orgName>
                            <event from="1991-03-17">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Slovenska_nacionalna_stranka</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Slovenian_National_Party</idno>
                        </org>
                        <org xml:id="party.ZLSD" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Združena lista socialnih demokratov</orgName>
                            <orgName full="yes" xml:lang="en">United List of Social Democrats</orgName>
                            <orgName full="abb">ZLSD</orgName>
                            <event from="1993-05-29" to="2005-04-02">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Socialni_demokrati</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Social_Democrats_(Slovenia)</idno>
                        </org>
                        <org xml:id="party.ZaAB" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Zavezništvo Alenke Bratušek</orgName>
                            <orgName full="yes" xml:lang="en">Alliance of Alenka Bratušek</orgName>
                            <orgName full="abb">ZaAB</orgName>
                            <event from="2014-05-31" to="2016-05-21">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                        </org>
                        <org xml:id="party.ZaSLD" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Zavezništvo socialno-liberalnih demokratov</orgName>
                            <orgName full="yes" xml:lang="en">Alliance of Social Liberal Democrats</orgName>
                            <event from="2016-05-21" to="2017-10-07">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                        </org>
                        <org xml:id="party.SAB" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Stranka Alenke Bratušek</orgName>
                            <orgName full="yes" xml:lang="en">Party of Alenka Bratušek</orgName>
                            <orgName full="abb">SAB</orgName>
                            <event from="2017-10-07">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                        </org>
                        <org xml:id="party.Zares.1" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Zares - nova politika</orgName>
                            <orgName full="yes" xml:lang="en">Really — New Politics</orgName>
                            <orgName full="abb">Zares</orgName>
                            <event from="2007-10-06" to="2011-10-15">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Zares</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Zares</idno>
                        </org>
                        <org xml:id="party.Zares.2" role="politicalParty">
                            <orgName full="yes" xml:lang="sl">Zares - socialno liberalni</orgName>
                            <orgName full="yes" xml:lang="en">Really — Social Liberals</orgName>
                            <orgName full="abb">Zares</orgName>
                            <event from="2011-10-15" to="2015-10-06">
                                <label xml:lang="en">existence</label>
                            </event>
                            <idno type="URI" subtype="wikimedia">https://sl.wikipedia.org/wiki/Zares</idno>
                            <idno type="URI" subtype="wikimedia">https://en.wikipedia.org/wiki/Zares</idno>
                        </org>
                        </listOrg>
                </body>
            </text>
        </TEI>
    </xsl:template>
 
 <xsl:template match="/">
     <xsl:variable name="var1">
     <xsl:apply-templates mode="pass0"/>
     </xsl:variable>
     <xsl:variable name="var2">
         <xsl:apply-templates select="$var1" mode="pass1"/>
     </xsl:variable>
     <xsl:copy-of select="$var2"/>
 </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:idno" mode="pass1">
        <idno type="URI" subtype="wikimedia">
            <xsl:attribute name="xml:lang">
                <xsl:choose>
                    <xsl:when test="matches(., 'sl\.')">
                        <xsl:text>sl</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(., 'en\.')">
                        <xsl:text>en</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </idno>
    </xsl:template>
    
</xsl:stylesheet>
