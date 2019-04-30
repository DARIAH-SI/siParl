<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhaja iz speech-list.xml -->
    <!-- naredi korpus datoteko, ki vključuje vse TEI dokumente iz speech/ -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="documentsList">
        <xsl:result-document href="../speech.xml">
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title xml:lang="sl" type="main">Slovenski parlamentarni korpus siParl</title>
                            <title xml:lang="en" type="main">Slovenian parliamentary corpus siParl</title>
                            <title type="sub" xml:lang="sl">Skupščina Republike Slovenije: 11. mandat (1990-1992)</title>
                            <title type="sub" xml:lang="en">Assembly of the Republic of Slovenia: 11th legislative period 1990-1992</title>
                            <title type="sub" xml:lang="sl">Državni zbor Republik Slovenije: od 1. do 7. mandata (1992-2018)</title>
                            <title type="sub" xml:lang="en">National Assembly of the Republic of Slovenia: from the 1st to the 7th legislative period 1992-2018</title>
                            <title type="sub" xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije: od 2. do 7. mandata (1996-2018)</title>
                            <title type="sub" xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia: from the 2nd to the 7th legislative period 1996-2018</title>
                            <title type="sub" xml:lang="sl">Kolegij predsednika Državnega zbora Republike Slovenije: od 2. do 7. mandata (1996-2018)</title>
                            <title type="sub" xml:lang="en">Council of the President of the National Assembly: from the 2nd to the 7th legislative period 1996-2018</title>
                            <respStmt>
                                <persName>Andrej Pančur</persName>
                                <resp xml:lang="sl">Kodiranje TEI</resp>
                                <resp xml:lang="en">TEI corpus encoding</resp>
                            </respStmt>
                            <respStmt>
                                <persName>Mojca Šorn</persName>
                                <resp xml:lang="sl">Kodiranje TEI</resp>
                                <resp xml:lang="en">TEI corpus encoding</resp>
                            </respStmt>
                            <respStmt>
                                <persName>Andrej Pančur</persName>
                                <resp xml:lang="sl">Urejanje seznama govornikov</resp>
                                <resp xml:lang="en">Editing a list of speakers</resp>
                            </respStmt>
                            <respStmt>
                                <persName>Mihael Ojsteršek</persName>
                                <resp xml:lang="sl">Urejanje seznama govornikov</resp>
                                <resp xml:lang="en">Editing a list of speakers</resp>
                            </respStmt>
                            <respStmt>
                                <persName>Neja Blaj Hribar</persName>
                                <resp xml:lang="sl">Urejanje seznama govornikov</resp>
                                <resp xml:lang="en">Editing a list of speakers</resp>
                            </respStmt>
                        </titleStmt>
                        <editionStmt>
                            <edition>1.0</edition>
                        </editionStmt>
                        <extent>
                            <xsl:variable name="measures">
                                <xsl:for-each select="folder/teiHeader/fileDesc/extent/measure">
                                    <xsl:choose>
                                        <xsl:when test="@unit='file'">
                                            <files>
                                                <xsl:value-of select="@quantity"/>
                                            </files>
                                        </xsl:when>
                                        <xsl:when test="@unit='word'">
                                            <words>
                                                <xsl:value-of select="@quantity"/>
                                            </words>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:message>Unknown measure/@unit: <xsl:value-of select="@unit"/></xsl:message>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>
                            <measure unit="file" quantity="{sum($measures/tei:files)}">
                                <xsl:text>Število TEI datotek: </xsl:text>
                                <xsl:value-of select="translate(format-number(sum($measures/tei:files),'#,###'),',','.')"/>
                            </measure>
                            <measure unit="word" quantity="{format-number(sum($measures/tei:words),'#')}">
                                <xsl:text>Število besed zapisnikov sej: </xsl:text>
                                <xsl:value-of select="translate(format-number(sum($measures/tei:words),'#,###'),',','.')"/>
                            </measure>
                        </extent>
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
                            <pubPlace>http://hdl.handle.net/11356/1236</pubPlace>
                            <pubPlace>https://github.com/DARIAH-SI/siParl</pubPlace>
                            <availability status="free">
                                <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                                <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                    Attribution 4.0 International License</ref>.</p>
                                <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                    Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                            </availability>
                            <date when="{current-date()}">
                                <xsl:value-of select="format-date(current-date(),'[D1]. [M1]. [Y0001]')"/>
                            </date>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <title>Portal Državnega zbora Republike Slovenije</title>
                                <idno type="URI">https://www.dz-rs.si</idno>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <projectDesc>
                            <p xml:lang="sl">Infrastrukturni program Raziskovalna infrastruktura slovenskega zgodovinopisja</p>
                            <p xml:lang="en">Infrastructure Programme Research infrastructure of Slovenian Historiography</p>
                        </projectDesc>
                        <tagsDecl>
                            <namespace name="http://www.tei-c.org/ns/1.0">
                                <xsl:for-each-group select="//tagUsage" group-by="@gi">
                                    <tagUsage gi="{current-grouping-key()}" occurs="{format-number(sum(for $n in current-group() return $n/@occurs),'#')}"/>
                                </xsl:for-each-group>
                            </namespace>
                        </tagsDecl>
                        <classDecl>
                            <taxonomy>
                                <desc xml:lang="en">Legislature</desc>
                                <desc xml:lang="sl">Zakonodajna oblast</desc>
                                <category>
                                    <desc xml:lang="en">Geo-political or administrative units</desc>
                                    <desc xml:lang="sl">Geopolitične ali upravne enote</desc>
                                    <category xml:id="parl.supranational">
                                        <catDesc xml:lang="en">
                                            <term>Supranational legislature</term>
                                        </catDesc>
                                        <catDesc xml:lang="sl">
                                            <term>Nadnacionalna zakonodajna oblast</term>
                                        </catDesc>
                                    </category>
                                    <category xml:id="parl.national">
                                        <catDesc xml:lang="en">
                                            <term>National legislature</term>
                                        </catDesc>
                                        <catDesc xml:lang="sl">
                                            <term>Nacionalna zakonodajna oblast</term>
                                        </catDesc>
                                    </category>
                                    <category xml:id="parl.regional">
                                        <catDesc xml:lang="en">
                                            <term>Regional legislature</term>
                                        </catDesc>
                                        <catDesc xml:lang="sl">
                                            <term>Regionalna zakonodajna oblast</term>
                                        </catDesc>
                                    </category>
                                    <category xml:id="parl.local">
                                        <catDesc xml:lang="en">
                                            <term>Local legislature</term>
                                        </catDesc>
                                        <catDesc xml:lang="sl">
                                            <term>Lokalna zakonodajna oblast</term>
                                        </catDesc>
                                    </category>
                                </category>
                                <category>
                                    <desc xml:lang="en">Organization</desc>
                                    <desc xml:lang="sl">Organiziranost</desc>
                                    <category>
                                        <desc xml:lang="en">Chambers</desc>
                                        <desc xml:lang="sl">Zbori</desc>
                                        <category xml:id="par.uni">
                                            <catDesc xml:lang="en">
                                                <term>Unicameralism</term>
                                            </catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Enodomen</term>
                                            </catDesc>
                                        </category>
                                        <category xml:id="par.bi">
                                            <catDesc xml:lang="en">
                                                <term>Bicameralism</term>
                                            </catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Dvodomen</term>
                                            </catDesc>
                                            <category xml:id="par.upper">
                                                <catDesc xml:lang="en">
                                                    <term>Upper house</term>
                                                </catDesc>
                                                <catDesc xml:lang="sl">
                                                    <term>Zgornji dom</term>
                                                </catDesc>
                                            </category>
                                            <category xml:id="par.lower">
                                                <catDesc xml:lang="en">
                                                    <term>Lower house</term>
                                                </catDesc>
                                                <catDesc xml:lang="sl">
                                                    <term>Spodnji dom</term>
                                                </catDesc>
                                            </category>
                                        </category>
                                        <category xml:id="par.multi">
                                            <catDesc xml:lang="en">
                                                <term>Multicameralism</term>
                                            </catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Večdomen</term>
                                            </catDesc>
                                            <category xml:id="par.chamber">
                                                <catDesc xml:lang="en">
                                                    <term>Chamber</term>
                                                </catDesc>
                                                <catDesc xml:lang="sl">
                                                    <term>Zbor</term>
                                                </catDesc>
                                            </category>
                                        </category>
                                    </category>
                                    <category xml:id="parl.committee">
                                        <catDesc xml:lang="en">
                                            <term>Committee</term>
                                        </catDesc>
                                        <catDesc xml:lang="sl">
                                            <term>Delovno telo</term>
                                        </catDesc>
                                        <category xml:id="parl.committee.standing">
                                            <catDesc xml:lang="en">
                                                <term>Standing committee</term>
                                            </catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Stalno delovno telo</term>
                                            </catDesc>
                                        </category>
                                        <category xml:id="parl.committee.special">
                                            <catDesc xml:lang="en">
                                                <term>Special committee</term>
                                            </catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Začasno delovno telo</term>
                                            </catDesc>
                                        </category>
                                        <category xml:id="parl.committee.inquiry">
                                            <catDesc xml:lang="en">
                                                <term>Committee of inquiry </term>
                                            </catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Preiskovalna komisija</term>
                                            </catDesc>
                                        </category>
                                    </category>
                                </category>
                                <category xml:id="parl.term">
                                    <catDesc xml:lang="en">
                                        <term>Legislative period</term>: term of the parliament between
                                        general elections.</catDesc>
                                    <catDesc xml:lang="sl">Zakonodajno obdobje</catDesc>
                                    <category xml:id="parl.session">
                                        <catDesc xml:lang="en">
                                            <term>Legislative session</term>: the period of time in which
                                            a legislature is convened for purpose of lawmaking, usually being
                                            one of two or more smaller divisions of the entire time between two
                                            elections. A session is a meeting or series of connected meetings
                                            devoted to a single order of business, program, agenda, or announced
                                            purpose.</catDesc>
                                        <catDesc xml:lang="sl">Parlamentaro zasedanje</catDesc>
                                        <category xml:id="parl.meeting">
                                            <catDesc xml:lang="en">
                                                <term>Meeting</term>: Each meeting may be a
                                                separate session or part of a group of meetings constituting a
                                                session. The session/meeting may take one or more
                                                days.</catDesc>
                                            <catDesc xml:lang="sl">
                                                <term>Seja</term>
                                            </catDesc>
                                            <category>
                                                <desc xml:lang="en">Types of meetings</desc>
                                                <category xml:id="parl.meeting.regular">
                                                    <catDesc xml:lang="en">
                                                        <term>Regular meeting</term>
                                                    </catDesc>
                                                    <catDesc xml:lang="sl">
                                                        <term>Redna seja</term>
                                                    </catDesc>
                                                </category>
                                                <category xml:id="parl.meeting.special">
                                                    <catDesc xml:lang="en">
                                                        <term>Special meeting</term>
                                                    </catDesc>
                                                    <catDesc xml:lang="sl">
                                                        <term>Posebna seja</term>
                                                    </catDesc>
                                                    <category xml:id="parl.meeting.extraordinary">
                                                        <catDesc xml:lang="en">
                                                            <term>Extraordinary meeting</term>
                                                        </catDesc>
                                                        <catDesc xml:lang="sl">
                                                            <term>Izredna seja</term>
                                                        </catDesc>
                                                    </category>
                                                    <category xml:id="parl.meeting.urgent">
                                                        <catDesc xml:lang="en">
                                                            <term>Urgent meeting</term>
                                                        </catDesc>
                                                        <catDesc xml:lang="sl">
                                                            <term>Nujna seja</term>
                                                        </catDesc>
                                                    </category>
                                                    <category xml:id="parl.meeting.ceremonial">
                                                        <catDesc xml:lang="en">
                                                            <term>Ceremonial meeting</term>
                                                        </catDesc>
                                                        <catDesc xml:lang="sl">
                                                            <term>Slavnostna seja</term>
                                                        </catDesc>
                                                    </category>
                                                    <category xml:id="parl.meeting.commemorative">
                                                        <catDesc xml:lang="en">
                                                            <term>Commemorative meeting</term>
                                                        </catDesc>
                                                        <catDesc xml:lang="sl">
                                                            <term>Žalna seja</term>
                                                        </catDesc>
                                                    </category>
                                                    <category xml:id="parl.meeting.opinions">
                                                        <catDesc xml:lang="en">
                                                            <term>Public presentation of opinions</term>
                                                        </catDesc>
                                                        <catDesc xml:lang="sl">
                                                            <term>Javna predstavitev mnenj</term>
                                                        </catDesc>
                                                    </category>
                                                </category>
                                                <category xml:id="parl.meeting.continued">
                                                    <catDesc xml:lang="en">
                                                        <term>Continued meeting</term>
                                                    </catDesc>
                                                </category>
                                                <category xml:id="parl.meeting.public">
                                                    <catDesc xml:lang="en">
                                                        <term>Public meeting</term>
                                                    </catDesc>
                                                    <catDesc xml:lang="sl">
                                                        <term>Javna seja</term>
                                                    </catDesc>
                                                </category>
                                                <category xml:id="parl.meeting.executive">
                                                    <catDesc xml:lang="en">
                                                        <term>Executive meeting</term>
                                                    </catDesc>
                                                    <catDesc xml:lang="sl">
                                                        <term>Zaprta seja</term>
                                                    </catDesc>
                                                </category>
                                            </category>
                                            <category xml:id="parl.sitting">
                                                <catDesc xml:lang="en">
                                                    <term>Sitting</term>: sitting day</catDesc>
                                                <catDesc xml:lang="sl">
                                                    <term>Dan seje</term>
                                                </catDesc>
                                            </category>
                                        </category>
                                    </category>
                                </category>
                            </taxonomy>
                            <taxonomy>
                                <desc xml:lang="en">Types of speakers</desc>
                                <desc xml:lang="sl">Vrste govornikov</desc>
                                <category xml:id="chair">
                                    <catDesc xml:lang="en">
                                        <term>Chairperson</term>: chairman of a meeting</catDesc>
                                    <catDesc xml:lang="sl">
                                        <term>Predsedujoči</term>: predsedujoči zasedanja</catDesc>
                                </category>
                                <category xml:id="regular">
                                    <catDesc xml:lang="en">
                                        <term>Regular speaker</term>:</catDesc>
                                    <catDesc xml:lang="sl">
                                        <term>Regularni govornik</term>:</catDesc>
                                </category>
                                <category xml:id="unauthorized">
                                    <catDesc xml:lang="en">
                                        <term>Unauthorized speaker</term>: unauthorized intervention in the speech of the main speaker.</catDesc>
                                    <catDesc xml:lang="sl">
                                        <term>Neavtorizirani govornik</term>: Neavtorizirana intervencija v govor glavnega govornika.</catDesc>
                                </category>
                            </taxonomy>
                        </classDecl>
                    </encodingDesc>
                    <profileDesc>
                        <abstract>
                            <p xml:lang="en">The siParl corpus contains minutes of the Assembly of the Republic of Slovenia 
                                for 11th legislative period 1990-1992, minutes of the National Assembly of the Republic of Slovenia
                                from the 1st to the 7th legislative period 1992-2018, minutes of the working bodies of the National
                                Assembly of the Republic of Slovenia from the 2nd to the 7th legislative period 1996-2018,
                                and minutes of the the Council of the President of the National Assembly
                                from the 2nd to the 7th legislative period 1996-2018.</p>
                        </abstract>
                        <settingDesc>
                            <setting>
                                <name type="city">Ljubljana</name>
                                <name type="country" key="YU" notAfter="1991-06-25">Yugoslavia</name>
                                <name type="region" notAfter="1991-06-25">Slovenia</name>
                                <name type="country" key="SI" notBefore="1991-06-25">Slovenia</name>
                                <xsl:for-each-group select="//setting/date" group-by=".">
                                    <date ana="#parl.term" notBefore="{current-group()[1]/@notBefore}" notAfter="{current-group()[1]/@notAfter}">
                                        <xsl:value-of select="normalize-space(current-group()[1])"/>
                                    </date>
                                </xsl:for-each-group>
                            </setting>
                        </settingDesc>
                        <particDesc>
                            <org xml:id="SK" ana="#parl.regional #parl.national #par.multi">
                                <orgName from="1990-06-23" to="1992-12-23" xml:lang="sl">Skupščina Republike Slovenije</orgName>
                                <orgName from="1990-06-23" to="1992-12-23" xml:lang="en">Assembly of the Republic of Slovenia</orgName>
                                <orgName from="1963-06-24" to="1990-06-23" xml:lang="sl">Skupščina Socialistične republike Slovenije</orgName>
                                <orgName from="1963-06-24" to="1990-06-23" xml:lang="en">Assembly of Socialist Republic of Slovenia</orgName>
                                <listOrg xml:id="chambers">
                                    <head xml:lang="sl">Zbori Skupščine Republike Slovenije</head>
                                    <head xml:lang="en">Chambers of the Assembly of the Republic of Slovenia</head>
                                    <org xml:id="DruzPolZb" ana="#par.chamber">
                                        <orgName from="1974" to="1992-12-23" xml:lang="sl">Družbeno-politični zbor</orgName>
                                        <orgName from="1974" to="1992-12-23" xml:lang="en">Socio-Political Chamber</orgName>
                                    </org>
                                    <org xml:id="ZbObc" ana="#par.chamber">
                                        <orgName from="1974" to="1992-12-23" xml:lang="sl">Zbor občin</orgName>
                                        <orgName from="1974" to="1992-12-23" xml:lang="en">Chamber of Municipalities</orgName>
                                    </org>
                                    <org xml:id="ZbZdruDel" ana="#par.chamber">
                                        <orgName from="1974" to="1992-12-23" xml:lang="sl">Zbor združenega dela</orgName>
                                        <orgName from="1974" to="1992-12-23" xml:lang="en">Chamber of Associated Labour</orgName>
                                    </org>
                                </listOrg>
                            </org>
                            <org xml:id="DZ" ana="#parl.national #par.lower">
                                <orgName xml:lang="sl">Državni zbor Republike Slovenije</orgName>
                                <orgName xml:lang="en">National Assembly of the Republic of Slovenia</orgName>
                                <listOrg xml:id="workingBodies">
                                    <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                                    <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                                    <xsl:for-each-group select="folder[matches(@label,'SDT')]/teiHeader/profileDesc/particDesc/org/listOrg[@xml:id='workingBodies']/org" group-by="@xml:id">
                                        <xsl:sort select="current-grouping-key()"/>
                                        <org xml:id="{current-grouping-key()}" ana="#parl.committee">
                                            <orgName>
                                                <xsl:value-of select="normalize-space(current-group()[1])"/>
                                            </orgName>
                                        </org>
                                    </xsl:for-each-group>
                                </listOrg>
                            </org>
                            <listPerson type="speaker">
                                <head xml:lang="sl">Seznam govornikov</head>
                                <head xml:lang="en">List of speakers</head>
                                <personGrp xml:id="SSK11.unknown">
                                    <state>
                                        <desc xml:lang="sl">Neidentificirani govornik</desc>
                                        <desc xml:lang="en">Unidentified speaker</desc>
                                    </state>
                                </personGrp>
                                <xsl:for-each select="folder/teiHeader/profileDesc/particDesc/listPerson/person">
                                    <xsl:sort select="tokenize(@xml:id,'\.')[2]"/>
                                    <person xml:id="{@xml:id}">
                                        <persName>
                                            <xsl:choose>
                                                <xsl:when test="persName/*">
                                                    <xsl:for-each select="persName/*">
                                                        <xsl:element name="{node-name(.)}">
                                                            <xsl:value-of select="."/>
                                                        </xsl:element>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="persName"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </persName>
                                        <xsl:if test="sex">
                                            <sex value="{sex/@value}"/>
                                        </xsl:if>
                                    </person>
                                </xsl:for-each>
                            </listPerson>
                        </particDesc>
                        <langUsage>
                            <language ident="sl" xml:lang="sl">slovenski</language>
                            <language ident="sl" xml:lang="en">Slovenian</language>
                            <language ident="en" xml:lang="sl">angleški</language>
                            <language ident="en" xml:lang="en">English</language>
                        </langUsage>
                    </profileDesc>
                </teiHeader>
                <xsl:for-each select="folder/ref">
                    <xsl:sort>
                        <xsl:analyze-string select="." regex="\d{{4}}-\d{{2}}-\d{{2}}">
                            <xsl:matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:sort>
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:value-of select="substring-after(.,'../')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </teiCorpus>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>