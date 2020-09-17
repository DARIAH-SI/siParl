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
    
    <!-- vstavi ob procesiranju nove verzije -->
    <xsl:param name="edition">2.0</xsl:param>
    <!-- vstavim CLARIN.SI Handle, kjer bo korpus shranjen v repozitoriju -->
    <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1300</xsl:param>
    
    <xsl:variable name="source-united-speaker-document">
        <xsl:copy-of select="document('../speaker.xml')" copy-namespaces="no"/>
    </xsl:variable>
    
    <xsl:template match="documentsList">
        <xsl:result-document href="../speech.xml">
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude" xml:lang="sl" xml:id="siParl">
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
                            <xsl:for-each-group select="//meeting" group-by="@n">
                                <meeting n="{current-grouping-key()}" corresp="{current-group()[1]/@corresp}" ana="{current-group()[1]/@ana}">
                                    <xsl:value-of select="current-group()[1]"/>
                                </meeting>
                            </xsl:for-each-group>
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
                            <funder>DARIAH-SI</funder>
                            <funder>CLARIN.SI</funder>
                        </titleStmt>
                        <editionStmt>
                            <edition>
                                <xsl:value-of select="$edition"/>
                            </edition>
                        </editionStmt>
                        <extent>
                            <xsl:variable name="measures">
                                <xsl:for-each select="folder/teiHeader/fileDesc/extent/measure">
                                    <xsl:choose>
                                        <xsl:when test="@unit='texts'">
                                            <texts>
                                                <xsl:value-of select="@quantity"/>
                                            </texts>
                                        </xsl:when>
                                        <xsl:when test="@unit='words'">
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
                            <measure unit="texts" quantity="{sum($measures/tei:texts)}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($measures/tei:texts),'#,###')"/>
                                <xsl:text> texts</xsl:text>
                            </measure>
                            <measure unit="words" quantity="{format-number(sum($measures/tei:words),'#')}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($measures/tei:words),'#,###')"/>
                                <xsl:text> words</xsl:text>
                            </measure>
                        </extent>
                        <publicationStmt>
                            <publisher>
                                <orgName xml:lang="sl">Inštitut za novejšo zgodovino</orgName>
                                <orgName xml:lang="en">Institute of Contemporary History</orgName>
                                <ref target="http://www.inz.si/">http://www.inz.si/</ref>
                                <email>inz@inz.si</email>
                            </publisher>
                            <distributor>DARIAH-SI</distributor>
                            <distributor>CLARIN.SI</distributor>
                            <xsl:if test="string-length($clarinHandle) gt 0">
                                <pubPlace>
                                    <xsl:value-of select="$clarinHandle"/>
                                </pubPlace>
                            </xsl:if>
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
                                <title type="main">Website of the National Assembly</title>
                                <title type="sub">Hansard</title>
                                <idno type="URI">https://www.dz-rs.si</idno>
                                <date from="1990-05-05" to="2018-06-22"/>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <tagsDecl>
                            <namespace name="http://www.tei-c.org/ns/1.0">
                                <xsl:for-each-group select="//tagUsage" group-by="@gi">
                                    <tagUsage gi="{current-grouping-key()}" occurs="{format-number(sum(for $n in current-group() return $n/@occurs),'#')}"/>
                                </xsl:for-each-group>
                            </namespace>
                        </tagsDecl>
                        <classDecl>
                            <taxonomy xml:id="parla.legislature">
                                <desc xml:lang="en">Legislature</desc>
                                <desc xml:lang="sl">Zakonodajna oblast</desc>
                                <category xml:id="parla.geo-political">
                                    <desc xml:lang="en">Geo-political or administrative units</desc>
                                    <desc xml:lang="sl">Geopolitične ali upravne enote</desc>
                                    <category xml:id="parla.supranational">
                                        <catDesc xml:lang="en"><term>Supranational legislature</term></catDesc>
                                        <catDesc xml:lang="sl"><term>Nadnacionalna zakonodajna oblast</term></catDesc>
                                    </category>
                                    <category xml:id="parla.national">
                                        <catDesc xml:lang="en"><term>National legislature</term></catDesc>
                                        <catDesc xml:lang="sl"><term>Nacionalna zakonodajna oblast</term></catDesc>
                                    </category>
                                    <category xml:id="parla.regional">
                                        <catDesc xml:lang="en"><term>Regional legislature</term></catDesc>
                                        <catDesc xml:lang="sl"><term>Regionalna zakonodajna oblast</term></catDesc>
                                    </category>
                                    <category xml:id="parla.local">
                                        <catDesc xml:lang="en"><term>Local legislature</term></catDesc>
                                        <catDesc xml:lang="sl"><term>Lokalna zakonodajna oblast</term></catDesc>
                                    </category>
                                </category>
                                <category xml:id="parla.organization">
                                    <desc xml:lang="en">Organization</desc>
                                    <desc xml:lang="sl">Organiziranost</desc>
                                    <category xml:id="parla.chambers">
                                        <desc xml:lang="en">Chambers</desc>
                                        <desc xml:lang="sl">Zbori</desc>
                                        <category xml:id="parla.uni">
                                            <catDesc xml:lang="en"><term>Unicameralism</term></catDesc>
                                            <catDesc xml:lang="sl"><term>Enodomen</term></catDesc>
                                        </category>
                                        <category xml:id="parla.bi">
                                            <catDesc xml:lang="en"><term>Bicameralism</term></catDesc>
                                            <catDesc xml:lang="sl"><term>Dvodomen</term></catDesc>
                                            <category xml:id="parla.upper">
                                                <catDesc xml:lang="en"><term>Upper house</term></catDesc>
                                                <catDesc xml:lang="sl"><term>Zgornji dom</term></catDesc>
                                            </category>
                                            <category xml:id="parla.lower">
                                                <catDesc xml:lang="en"><term>Lower house</term></catDesc>
                                                <catDesc xml:lang="sl"><term>Spodnji dom</term></catDesc>
                                            </category>
                                        </category>
                                        <category xml:id="parla.multi">
                                            <catDesc xml:lang="en"><term>Multicameralism</term></catDesc>
                                            <catDesc xml:lang="sl"><term>Večdomen</term></catDesc>
                                            <category xml:id="parla.chamber">
                                                <catDesc xml:lang="en"><term>Chamber</term></catDesc>
                                                <catDesc xml:lang="sl"><term>Zbor</term></catDesc>
                                            </category>
                                        </category>
                                    </category>
                                    <category xml:id="parla.committee">
                                        <catDesc xml:lang="en"><term>Committee</term></catDesc>
                                        <catDesc xml:lang="sl"><term>Delovno telo</term></catDesc>
                                        <category xml:id="parla.committee.standing">
                                            <catDesc xml:lang="en"><term>Standing committee</term></catDesc>
                                            <catDesc xml:lang="sl"><term>Stalno delovno telo</term></catDesc>
                                        </category>
                                        <category xml:id="parla.committee.special">
                                            <catDesc xml:lang="en"><term>Special committee</term></catDesc>
                                            <catDesc xml:lang="sl"><term>Začasno delovno telo</term></catDesc>
                                        </category>
                                        <category xml:id="parla.committee.inquiry">
                                            <catDesc xml:lang="en"><term>Committee of inquiry </term></catDesc>
                                            <catDesc xml:lang="sl"><term>Preiskovalna komisija</term></catDesc>
                                        </category>
                                    </category>
                                </category>
                                <category xml:id="parla.term">
                                    <catDesc xml:lang="en"><term>Legislative period</term>: term of the parliament between
                                        general elections.</catDesc>
                                    <catDesc xml:lang="sl">Zakonodajno obdobje</catDesc>
                                    <category xml:id="parla.session">
                                        <catDesc xml:lang="en"><term>Legislative session</term>: the period of time in which
                                            a legislature is convened for purpose of lawmaking, usually being
                                            one of two or more smaller divisions of the entire time between two
                                            elections. A session is a meeting or series of connected meetings
                                            devoted to a single order of business, program, agenda, or announced
                                            purpose.</catDesc>
                                        <catDesc xml:lang="sl">Parlamentaro zasedanje</catDesc>
                                        <category xml:id="parla.meeting">
                                            <catDesc xml:lang="en"><term>Meeting</term>: Each meeting may be a
                                                separate session or part of a group of meetings constituting a
                                                session. The session/meeting may take one or more
                                                days.</catDesc>
                                            <catDesc xml:lang="sl"><term>Seja</term></catDesc>
                                            <category xml:id="parla.meeting-types">
                                                <desc xml:lang="en">Types of meetings</desc>
                                                <category xml:id="parla.meeting.regular">
                                                    <catDesc xml:lang="en"><term>Regular meeting</term></catDesc>
                                                    <catDesc xml:lang="sl"><term>Redna seja</term></catDesc>
                                                </category>
                                                <category xml:id="parla.meeting.special">
                                                    <catDesc xml:lang="en"><term>Special meeting</term></catDesc>
                                                    <catDesc xml:lang="sl"><term>Posebna seja</term></catDesc>
                                                    <category xml:id="parla.meeting.extraordinary">
                                                        <catDesc xml:lang="en"><term>Extraordinary meeting</term></catDesc>
                                                        <catDesc xml:lang="sl"><term>Izredna seja</term></catDesc>
                                                    </category>
                                                    <category xml:id="parla.meeting.urgent">
                                                        <catDesc xml:lang="en"><term>Urgent meeting</term></catDesc>
                                                        <catDesc xml:lang="sl"><term>Nujna seja</term></catDesc>
                                                    </category>
                                                    <category xml:id="parla.meeting.ceremonial">
                                                        <catDesc xml:lang="en"><term>Ceremonial meeting</term></catDesc>
                                                        <catDesc xml:lang="sl"><term>Slavnostna seja</term></catDesc>
                                                    </category>
                                                    <category xml:id="parla.meeting.commemorative">
                                                        <catDesc xml:lang="en"><term>Commemorative meeting</term></catDesc>
                                                        <catDesc xml:lang="sl"><term>Žalna seja</term></catDesc>
                                                    </category>
                                                    <category xml:id="parla.meeting.opinions">
                                                        <catDesc xml:lang="en"><term>Public presentation of opinions</term></catDesc>
                                                        <catDesc xml:lang="sl"><term>Javna predstavitev mnenj</term></catDesc>
                                                    </category>
                                                </category>
                                                <category xml:id="parla.meeting.continued">
                                                    <catDesc xml:lang="en"><term>Continued meeting</term></catDesc>
                                                </category>
                                                <category xml:id="parla.meeting.public">
                                                    <catDesc xml:lang="en"><term>Public meeting</term></catDesc>
                                                    <catDesc xml:lang="sl"><term>Javna seja</term></catDesc>
                                                </category>
                                                <category xml:id="parla.meeting.executive">
                                                    <catDesc xml:lang="en"><term>Executive meeting</term></catDesc>
                                                    <catDesc xml:lang="sl"><term>Zaprta seja</term></catDesc>
                                                </category>
                                            </category>
                                            <category xml:id="parla.sitting">
                                                <catDesc xml:lang="en"><term>Sitting</term>: sitting day</catDesc>
                                                <catDesc xml:lang="sl"><term>Dan seje</term></catDesc>
                                            </category>
                                        </category>
                                    </category>
                                </category>
                            </taxonomy>
                            <taxonomy xml:id="speaker_types">
                                <desc xml:lang="en">Types of speakers</desc>
                                <desc xml:lang="sl">Vrste govornikov</desc>
                                <category xml:id="chair">
                                    <catDesc xml:lang="en"><term>Chairperson</term>: chairman of a meeting</catDesc>
                                    <catDesc xml:lang="sl"><term>Predsedujoči</term>: predsedujoči zasedanja</catDesc>
                                </category>
                                <category xml:id="regular">
                                    <catDesc xml:lang="en"><term>Regular</term>: a regular speaker at a meeting</catDesc>
                                    <catDesc xml:lang="sl"><term>Navadni</term>: navadni govorec na zasedanju</catDesc>
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
                                <name type="country" key="YU" from="1990-05-05" to="1991-06-25">Yugoslavia</name>
                                <name type="region" from="1990-05-05" to="1991-06-25">Slovenia</name>
                                <name type="country" key="SI" from="1991-06-25" to="2018-06-22">Slovenia</name>
                                <date from="1990-05-05" to="2018-06-22"/>
                            </setting>
                        </settingDesc>
                        <particDesc>
                            <listOrg>
                                <org xml:id="SK" role="parliament" ana="#parla.regional #parla.national #parla.multi">
                                    <orgName from="1990-06-23" to="1992-12-23" xml:lang="sl">Skupščina Republike Slovenije</orgName>
                                    <orgName from="1990-06-23" to="1992-12-23" xml:lang="en">Assembly of the Republic of Slovenia</orgName>
                                    <orgName from="1963-06-24" to="1990-06-23" xml:lang="sl">Skupščina Socialistične republike Slovenije</orgName>
                                    <orgName from="1963-06-24" to="1990-06-23" xml:lang="en">Assembly of Socialist Republic of Slovenia</orgName>
                                    <event from="1963-06-24" to="1992-12-23">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia"
                                        >https://sl.wikipedia.org/wiki/Skup%C5%A1%C4%8Dina_Socialisti%C4%8Dne_republike_Slovenije</idno>
                                    <listEvent>
                                        <head>Legislative period</head>
                                        <event xml:id="SK.11" from="1990-05-08" to="1992-12-23">
                                            <label xml:lang="sl">11. sklic</label>
                                            <label xml:lang="en">Term 11</label>
                                        </event>
                                    </listEvent>
                                    <listOrg xml:id="chambers">
                                        <head xml:lang="sl">Zbori Skupščine Republike Slovenije</head>
                                        <head xml:lang="en">Chambers of the Assembly of the Republic of Slovenia</head>
                                        <org xml:id="DruzPolZb" ana="#parla.chamber">
                                            <orgName xml:lang="sl">Družbeno-politični zbor</orgName>
                                            <orgName xml:lang="en">Socio-Political Chamber</orgName>
                                            <event from="1974" to="1992-12-23">
                                                <label xml:lang="en">existence</label>
                                            </event>
                                        </org>
                                        <org xml:id="ZbObc" ana="#parla.chamber">
                                            <orgName xml:lang="sl">Zbor občin</orgName>
                                            <orgName xml:lang="en">Chamber of Municipalities</orgName>
                                            <event from="1974" to="1992-12-23">
                                                <label xml:lang="en">existence</label>
                                            </event>
                                        </org>
                                        <org xml:id="ZbZdruDel" ana="#parla.chamber">
                                            <orgName xml:lang="sl">Zbor združenega dela</orgName>
                                            <orgName xml:lang="en">Chamber of Associated Labour</orgName>
                                            <event from="1974" to="1992-12-23">
                                                <label xml:lang="en">existence</label>
                                            </event>
                                        </org>
                                    </listOrg>
                                </org>
                                <org xml:id="DZ" role="parliament" ana="#parla.national #parla.lower">
                                    <orgName xml:lang="sl">Državni zbor Republike Slovenije</orgName>
                                    <orgName xml:lang="en">National Assembly of the Republic of Slovenia</orgName>
                                    <event from="1992-12-23">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia"
                                        >https://sl.wikipedia.org/wiki/Dr%C5%BEavni_zbor_Republike_Slovenije</idno>
                                    <listEvent>
                                        <head>Legislative period</head>
                                        <event xml:id="DZ.1" from="1992-12-23" to="1996-11-27">
                                            <label xml:lang="sl">1. mandat</label>
                                            <label xml:lang="en">Term 1</label>
                                        </event>
                                        <event xml:id="DZ.2" from="1996-11-28" to="2000-10-26">
                                            <label xml:lang="sl">2. mandat</label>
                                            <label xml:lang="en">Term 2</label>
                                        </event>
                                        <event xml:id="DZ.3" from="2000-10-27" to="2004-10-21">
                                            <label xml:lang="sl">3. mandat</label>
                                            <label xml:lang="en">Term 3</label>
                                        </event>
                                        <event xml:id="DZ.4" from="2004-10-22" to="2008-10-14">
                                            <label xml:lang="sl">4. mandat</label>
                                            <label xml:lang="en">Term 4</label>
                                        </event>
                                        <event xml:id="DZ.5" from="2008-10-15" to="2011-12-15">
                                            <label xml:lang="sl">5. mandat</label>
                                            <label xml:lang="en">Term 5</label>
                                        </event>
                                        <event xml:id="DZ.6" from="2011-12-16" to="2014-07-31">
                                            <label xml:lang="sl">6. mandat</label>
                                            <label xml:lang="en">Term 6</label>
                                        </event>
                                        <event xml:id="DZ.7" from="2014-08-01" to="2018-06-21">
                                            <label xml:lang="sl">7. mandat</label>
                                            <label xml:lang="en">Term 7</label>
                                        </event>
                                    </listEvent>
                                    <listOrg xml:id="workingBodies">
                                        <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                                        <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                                        <xsl:for-each-group select="folder[matches(@label,'SDT')]/teiHeader/profileDesc/particDesc/listOrg/org/listOrg[@xml:id='workingBodies']/org" group-by="@xml:id">
                                            <xsl:sort select="current-grouping-key()"/>
                                            <org xml:id="{current-grouping-key()}" ana="#parla.committee">
                                                <orgName>
                                                    <xsl:value-of select="normalize-space(current-group()[1])"/>
                                                </orgName>
                                            </org>
                                        </xsl:for-each-group>
                                    </listOrg>
                                </org>
                                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listOrg/tei:org[not(@role ='parliament')]">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                                <xsl:copy-of select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listOrg/tei:listRelation" copy-namespaces="no"/>
                            </listOrg>
                            <listPerson>
                                <head xml:lang="sl">Seznam govornikov</head>
                                <head xml:lang="en">List of speakers</head>
                                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person">
                                    <person xml:id="{@xml:id}">
                                        <xsl:for-each select="*">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                    </person>
                                </xsl:for-each>
                            </listPerson>
                        </particDesc>
                        <langUsage>
                            <language ident="sl">Slovenian</language>
                            <language ident="en">English</language>
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