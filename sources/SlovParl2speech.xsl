<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhodiščni dokument je SSK11-list.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- vstavi ob procesiranju nove verzije -->
    <xsl:param name="edition">2.0</xsl:param>
    <!-- vstavim CLARIN.SI Handle, kjer bo korpus shranjen v repozitoriju -->
    <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1300</xsl:param>
    
    <xsl:variable name="source-united-speaker-document">
        <xsl:copy-of select="document('../speaker.xml')" copy-namespaces="no"/>
    </xsl:variable>
    
    <xsl:variable name="terms">
        <term n="11" start="1990-05-05" end="1992-12-23">11. sklic (1990-1992)</term>
    </xsl:variable>
    
    <xsl:param name="taxonomy-legislature">
        <taxonomy xml:id="parl.legislature">
            <desc xml:lang="en">Legislature</desc>
            <desc xml:lang="sl">Zakonodajna oblast</desc>
            <category xml:id="parl.geo-political">
                <desc xml:lang="en">Geo-political or administrative units</desc>
                <desc xml:lang="sl">Geopolitične ali upravne enote</desc>
                <category xml:id="parl.supranational">
                    <catDesc xml:lang="en"><term>Supranational legislature</term></catDesc>
                    <catDesc xml:lang="sl"><term>Nadnacionalna zakonodajna oblast</term></catDesc>
                </category>
                <category xml:id="parl.national">
                    <catDesc xml:lang="en"><term>National legislature</term></catDesc>
                    <catDesc xml:lang="sl"><term>Nacionalna zakonodajna oblast</term></catDesc>
                </category>
                <category xml:id="parl.regional">
                    <catDesc xml:lang="en"><term>Regional legislature</term></catDesc>
                    <catDesc xml:lang="sl"><term>Regionalna zakonodajna oblast</term></catDesc>
                </category>
                <category xml:id="parl.local">
                    <catDesc xml:lang="en"><term>Local legislature</term></catDesc>
                    <catDesc xml:lang="sl"><term>Lokalna zakonodajna oblast</term></catDesc>
                </category>
            </category>
            <category xml:id="parl.organization">
                <desc xml:lang="en">Organization</desc>
                <desc xml:lang="sl">Organiziranost</desc>
                <category xml:id="parl.chambers">
                    <desc xml:lang="en">Chambers</desc>
                    <desc xml:lang="sl">Zbori</desc>
                    <category xml:id="par.uni">
                        <catDesc xml:lang="en"><term>Unicameralism</term></catDesc>
                        <catDesc xml:lang="sl"><term>Enodomen</term></catDesc>
                    </category>
                    <category xml:id="par.bi">
                        <catDesc xml:lang="en"><term>Bicameralism</term></catDesc>
                        <catDesc xml:lang="sl"><term>Dvodomen</term></catDesc>
                        <category xml:id="par.upper">
                            <catDesc xml:lang="en"><term>Upper house</term></catDesc>
                            <catDesc xml:lang="sl"><term>Zgornji dom</term></catDesc>
                        </category>
                        <category xml:id="par.lower">
                            <catDesc xml:lang="en"><term>Lower house</term></catDesc>
                            <catDesc xml:lang="sl"><term>Spodnji dom</term></catDesc>
                        </category>
                    </category>
                    <category xml:id="par.multi">
                        <catDesc xml:lang="en"><term>Multicameralism</term></catDesc>
                        <catDesc xml:lang="sl"><term>Večdomen</term></catDesc>
                        <category xml:id="par.chamber">
                            <catDesc xml:lang="en"><term>Chamber</term></catDesc>
                            <catDesc xml:lang="sl"><term>Zbor</term></catDesc>
                        </category>
                    </category>
                </category>
                <category xml:id="parl.committee">
                    <catDesc xml:lang="en"><term>Committee</term></catDesc>
                    <catDesc xml:lang="sl"><term>Delovno telo</term></catDesc>
                    <category xml:id="parl.committee.standing">
                        <catDesc xml:lang="en"><term>Standing committee</term></catDesc>
                        <catDesc xml:lang="sl"><term>Stalno delovno telo</term></catDesc>
                    </category>
                    <category xml:id="parl.committee.special">
                        <catDesc xml:lang="en"><term>Special committee</term></catDesc>
                        <catDesc xml:lang="sl"><term>Začasno delovno telo</term></catDesc>
                    </category>
                    <category xml:id="parl.committee.inquiry">
                        <catDesc xml:lang="en"><term>Committee of inquiry </term></catDesc>
                        <catDesc xml:lang="sl"><term>Preiskovalna komisija</term></catDesc>
                    </category>
                </category>
            </category>
            <category xml:id="parl.term">
                <catDesc xml:lang="en"><term>Legislative period</term>: term of the parliament between
                    general elections.</catDesc>
                <catDesc xml:lang="sl">Zakonodajno obdobje</catDesc>
                <category xml:id="parl.session">
                    <catDesc xml:lang="en"><term>Legislative session</term>: the period of time in which
                        a legislature is convened for purpose of lawmaking, usually being
                        one of two or more smaller divisions of the entire time between two
                        elections. A session is a meeting or series of connected meetings
                        devoted to a single order of business, program, agenda, or announced
                        purpose.</catDesc>
                    <catDesc xml:lang="sl">Parlamentaro zasedanje</catDesc>
                    <category xml:id="parl.meeting">
                        <catDesc xml:lang="en"><term>Meeting</term>: Each meeting may be a
                            separate session or part of a group of meetings constituting a
                            session. The session/meeting may take one or more
                            days.</catDesc>
                        <catDesc xml:lang="sl"><term>Seja</term></catDesc>
                        <category xml:id="parl.meeting-types">
                            <desc xml:lang="en">Types of meetings</desc>
                            <category xml:id="parl.meeting.regular">
                                <catDesc xml:lang="en"><term>Regular meeting</term></catDesc>
                                <catDesc xml:lang="sl"><term>Redna seja</term></catDesc>
                            </category>
                            <category xml:id="parl.meeting.special">
                                <catDesc xml:lang="en"><term>Special meeting</term></catDesc>
                                <catDesc xml:lang="sl"><term>Posebna seja</term></catDesc>
                                <category xml:id="parl.meeting.extraordinary">
                                    <catDesc xml:lang="en"><term>Extraordinary meeting</term></catDesc>
                                    <catDesc xml:lang="sl"><term>Izredna seja</term></catDesc>
                                </category>
                                <category xml:id="parl.meeting.urgent">
                                    <catDesc xml:lang="en"><term>Urgent meeting</term></catDesc>
                                    <catDesc xml:lang="sl"><term>Nujna seja</term></catDesc>
                                </category>
                                <category xml:id="parl.meeting.ceremonial">
                                    <catDesc xml:lang="en"><term>Ceremonial meeting</term></catDesc>
                                    <catDesc xml:lang="sl"><term>Slavnostna seja</term></catDesc>
                                </category>
                                <category xml:id="parl.meeting.commemorative">
                                    <catDesc xml:lang="en"><term>Commemorative meeting</term></catDesc>
                                    <catDesc xml:lang="sl"><term>Žalna seja</term></catDesc>
                                </category>
                                <category xml:id="parl.meeting.opinions">
                                    <catDesc xml:lang="en"><term>Public presentation of opinions</term></catDesc>
                                    <catDesc xml:lang="sl"><term>Javna predstavitev mnenj</term></catDesc>
                                </category>
                            </category>
                            <category xml:id="parl.meeting.continued">
                                <catDesc xml:lang="en"><term>Continued meeting</term></catDesc>
                            </category>
                            <category xml:id="parl.meeting.public">
                                <catDesc xml:lang="en"><term>Public meeting</term></catDesc>
                                <catDesc xml:lang="sl"><term>Javna seja</term></catDesc>
                            </category>
                            <category xml:id="parl.meeting.executive">
                                <catDesc xml:lang="en"><term>Executive meeting</term></catDesc>
                                <catDesc xml:lang="sl"><term>Zaprta seja</term></catDesc>
                            </category>
                        </category>
                        <category xml:id="parl.sitting">
                            <catDesc xml:lang="en"><term>Sitting</term>: sitting day</catDesc>
                            <catDesc xml:lang="sl"><term>Dan seje</term></catDesc>
                        </category>
                    </category>
                </category>
            </category>
        </taxonomy>
    </xsl:param>
    
    <xsl:param name="taxonomy-speakers">
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
    </xsl:param>
    
    <xsl:template match="documentsList">
        <xsl:variable name="corpus-label" select="tokenize(ref[1],'/')[1]"/>
        <xsl:variable name="corpus-term" select="substring($corpus-label,4)"/>
        <xsl:variable name="corpus-document" select="concat('../speech/',$corpus-label,'.xml')"/>
        <xsl:variable name="source-corpus-document" select="concat($corpus-label,'.xml')"/>
        <xsl:variable name="source-speaker-document" select="concat($corpus-label,'.xml')"/>
        <xsl:result-document href="{$corpus-document}">
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude" xml:id="siParl.{$corpus-label}" xml:lang="sl">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title type="main" xml:lang="sl">Dobesedni zapis sej Skupščine Republike Sloveije</title>
                            <title type="main" xml:lang="en">Verbatim record of sessions of the Assembly of the Republic of Slovenia</title>
                            <title type="sub" xml:lang="sl">
                                <xsl:value-of select="$terms/tei:term[@n=$corpus-term]"/>
                            </title>
                            <meeting n="{number($corpus-term)}" corresp="#SK" ana="#parl.term #SK.11">
                                <xsl:value-of select="$corpus-term"/>
                                <xsl:text>. sklic</xsl:text>
                            </meeting>
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
                            <funder>DARIAH-SI</funder>
                            <funder>CLARIN.SI</funder>
                        </titleStmt>
                        <editionStmt>
                            <edition>
                                <xsl:value-of select="$edition"/>
                            </edition>
                        </editionStmt>
                        <extent>
                            <xsl:variable name="count-files" select="count(ref)"/>
                            <measure unit="texts" quantity="{$count-files}">
                                <xsl:value-of select="$count-files"/>
                                <xsl:text> texts</xsl:text>
                            </measure>
                            <!-- Štetje besed -->
                            <xsl:variable name="counting">
                                <xsl:for-each select="ref">
                                    <string>
                                        <xsl:apply-templates select="document(.)/tei:TEI/tei:text/tei:body"/>
                                    </string>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="compoundString" select="normalize-space(string-join($counting/tei:string,' '))"/>
                            <xsl:variable name="count-words" select="count(tokenize($compoundString,'\W+')[. != ''])"/>
                            <measure unit="words" quantity="{$count-words}">
                                <xsl:value-of select="$count-words"/>
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
                            <date when="{current-date()}"><xsl:value-of select="format-date(current-date(),'[D1]. [M1]. [Y0001]')"/></date>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <title type="main">Slovenian parliamentary corpus SlovParl 2.0</title>
                                <author>Andrej Pančur</author>
                                <author>Mojca Šorn</author>
                                <author>Tomaž Erjavec</author>
                                <idno type="hdl">http://hdl.handle.net/11356/1167</idno>
                                <distributor>Slovenian language resource repository CLARIN.SI</distributor>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <editorialDecl>
                            <correction>
                                <p>No correction of source texts was performed. Only apparently typed errors were corrected.</p>
                            </correction>
                            <hyphenation>
                                <p>No end-of-line hyphens were present in the source.</p>
                            </hyphenation>
                            <quotation>
                                <p>Quotation marks have been left in the text and are not explicitly marked up.</p>
                            </quotation>
                            <segmentation>
                                <p>The texts are segmented into utterances (speeches) and segments (corresponding to paragraphs in the source transcription).</p>
                            </segmentation>
                        </editorialDecl>
                        <classDecl>
                            <xsl:copy-of select="$taxonomy-legislature"/>
                            <xsl:copy-of select="$taxonomy-speakers"/>
                        </classDecl>
                    </encodingDesc>
                    <profileDesc>
                        <settingDesc>
                            <setting>
                                <name type="city">Ljubljana</name>
                                <name type="country" key="YU" from="1990-05-05" to="1991-06-25">Jugoslavija</name>
                                <name type="region" from="1990-05-05" to="1991-06-25">Slovenija</name>
                                <name type="country" key="SI" from="1991-06-25" to="1992-12-23">Slovenija</name>
                                <date ana="#parl.term">
                                    <xsl:attribute name="from">
                                        <xsl:value-of select="$terms/tei:term[@n=$corpus-term]/@start"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="to">
                                        <xsl:value-of select="$terms/tei:term[@n=$corpus-term]/@end"/>
                                    </xsl:attribute>
                                </date>
                            </setting>
                        </settingDesc>
                        <particDesc>
                            <listOrg>
                                <org xml:id="SK" role="parliament" ana="#parl.regional #parl.national #par.multi">
                                    <orgName from="1990-06-23" to="1992-12-22" xml:lang="sl">Skupščina Republike Slovenije</orgName>
                                    <orgName from="1990-06-23" to="1992-12-22" xml:lang="en">Assembly of the Republic of Slovenia</orgName>
                                    <orgName from="1963-06-24" to="1990-06-22" xml:lang="sl">Skupščina Socialistične republike Slovenije</orgName>
                                    <orgName from="1963-06-24" to="1990-06-22" xml:lang="en">Assembly of Socialist Republic of Slovenia</orgName>
                                    <event from="1963-06-24" to="1992-12-22">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia"
                                        >https://sl.wikipedia.org/wiki/Skup%C5%A1%C4%8Dina_Socialisti%C4%8Dne_republike_Slovenije</idno>
                                    <listEvent>
                                        <head>Legislative period</head>
                                        <event xml:id="SK.11" from="1990-05-08" to="1992-12-22">
                                            <label xml:lang="sl">11. sklic</label>
                                            <label xml:lang="en">Term 11</label>
                                        </event>
                                    </listEvent>
                                    <listOrg xml:id="chambers">
                                        <head xml:lang="sl">Zbori Skupščine Republike Slovenije</head>
                                        <head xml:lang="en">Chambers of the Assembly of the Republic of Slovenia</head>
                                        <org xml:id="DruzPolZb" ana="#par.chamber">
                                            <orgName xml:lang="sl">Družbeno-politični zbor</orgName>
                                            <orgName xml:lang="en">Socio-Political Chamber</orgName>
                                            <event from="1974" to="1992-12-22">
                                                <label xml:lang="en">existence</label>
                                            </event>
                                        </org>
                                        <org xml:id="ZbObc" ana="#par.chamber">
                                            <orgName xml:lang="sl">Zbor občin</orgName>
                                            <orgName xml:lang="en">Chamber of Municipalities</orgName>
                                            <event from="1974" to="1992-12-22">
                                                <label xml:lang="en">existence</label>
                                            </event>
                                        </org>
                                        <org xml:id="ZbZdruDel" ana="#par.chamber">
                                            <orgName xml:lang="sl">Zbor združenega dela</orgName>
                                            <orgName xml:lang="en">Chamber of Associated Labour</orgName>
                                            <event from="1974" to="1992-12-22">
                                                <label xml:lang="en">existence</label>
                                            </event>
                                        </org>
                                    </listOrg>
                                </org>
                                <org xml:id="DZ" role="parliament" ana="#parl.national #par.lower">
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
                                    <xsl:if test="matches($corpus-label,'^SDT')">
                                        <listOrg xml:id="workingBodies">
                                            <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                                            <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                                            <xsl:for-each-group select="document($source-corpus-document)/tei:teiCorpus/tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org" group-by="tei:orgName/@key">
                                                <xsl:sort select="normalize-space(current-group()[1]/tei:orgName)"/>
                                                <org xml:id="{current-grouping-key()}" ana="#parl.committee">
                                                    <orgName>
                                                        <xsl:value-of select="normalize-space(current-group()[1]/tei:orgName)"/>
                                                    </orgName>
                                                </org>
                                            </xsl:for-each-group>
                                        </listOrg>
                                    </xsl:if>
                                </org>
                                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listOrg/tei:org[not(@role ='parliament')]">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                                <xsl:copy-of select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listOrg/tei:listRelation" copy-namespaces="no"/>
                            </listOrg>
                            <listPerson>
                                <head xml:lang="sl">Seznam govornikov</head>
                                <head xml:lang="en">List of speakers</head>
                                <!--<personGrp xml:id="{$corpus-label}.unknown">
                                    <state>
                                        <desc xml:lang="sl">Neidentificirani govornik</desc>
                                        <desc xml:lang="en">Unidentified speaker</desc>
                                    </state>
                                </personGrp>
                                <xsl:for-each select="document($source-speaker-document)/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson[position() = 2 or position() =3]/tei:person">
                                    <xsl:sort select="@xml:id"/>
                                    <person xml:id="{$corpus-label}.{@xml:id}">
                                        <xsl:copy-of select="tei:persName[1]" copy-namespaces="no"/>
                                        <xsl:copy-of select="tei:sex" copy-namespaces="no"/>
                                    </person>
                                </xsl:for-each>-->
                                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person[matches(@corresp,$corpus-label)]">
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
                <xsl:for-each select="ref">
                    <xsl:variable name="sourceDocument" select="tokenize(.,'/')[2]"/>
                    <xsl:variable name="year" select="tokenize($sourceDocument,'-')[1]"/>
                    <xsl:variable name="month" select="tokenize($sourceDocument,'-')[2]"/>
                    <xsl:variable name="day" select="tokenize($sourceDocument,'-')[3]"/>
                    <xsl:variable name="chamber" select="tokenize($sourceDocument,'-')[4]"/>
                    <xsl:variable name="sessionNum">
                        <xsl:analyze-string select="tokenize($sourceDocument,'-')[5]" regex="\d+">
                            <xsl:matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:variable name="sessionLabel">
                        <xsl:analyze-string select="tokenize($sourceDocument,'-')[5]" regex="\d+">
                            <xsl:non-matching-substring>
                                <xsl:choose>
                                    <xsl:when test=". = 's'">Seja</xsl:when>
                                    <xsl:when test=". = 'z'">Zasedanje</xsl:when>
                                    <xsl:when test=". = 'd'">Delovna</xsl:when>
                                    <xsl:when test=". = 'sl'">Slavnostna</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:message terminate="yes">Manjka session-type vrednost</xsl:message>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($corpus-label,'/',$chamber,'-',$sessionLabel,'-',$sessionNum,'-',$year,'-',$month,'-',$day,'.xml')"/>
                        </xsl:attribute>
                    </xsl:element>
                    
                    <!-- TEI dokumenti -->
                    <xsl:variable name="document" select="concat('../speech/',$corpus-label,'/',$chamber,'-',$sessionLabel,'-',$sessionNum,'-',$year,'-',$month,'-',$day,'.xml')"/>
                    <xsl:result-document href="{$document}">
                        <xsl:apply-templates select="document(.)" mode="pass0">
                            <xsl:with-param name="corpus-label" select="$corpus-label"/>
                            <xsl:with-param name="chamber" select="$chamber"/>
                            <xsl:with-param name="sessionNum" select="$sessionNum"/>
                            <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
                        </xsl:apply-templates>
                    </xsl:result-document>          
                </xsl:for-each>
            </teiCorpus>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="/" mode="pass0">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <xsl:variable name="var1">
            <xsl:apply-templates mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="var2">
            <xsl:apply-templates select="$var1" mode="pass2"/>
        </xsl:variable>
        <xsl:variable name="var3">
            <xsl:apply-templates select="$var2" mode="pass3"/>
        </xsl:variable>
        <xsl:variable name="var4">
            <xsl:apply-templates select="$var3" mode="pass4"/>
        </xsl:variable>
        
        <!-- kopiram zadnjo variablo z vsebino celotnega dokumenta -->
        <xsl:copy-of select="$var4" copy-namespaces="no"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:TEI" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <TEI>
            <xsl:apply-templates select="@*" mode="pass1"/>
            <xsl:attribute name="ana">#parl.sitting</xsl:attribute>
            <xsl:apply-templates mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>
        </TEI>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <titleStmt>
            <title type="main" xml:lang="sl">Dobesedni zapis seje Skupščine Republike Slovenije</title>
            <title type="main" xml:lang="en">Verbatim record of the session of the Assembly of the Republic of Slovenia</title>
            <title type="sub" xml:lang="sl">
                <xsl:choose>
                    <xsl:when test="$chamber = 'DruzPolZb'">Družbeno-politični zbor</xsl:when>
                    <xsl:when test="$chamber = 'ZbObc'">Zbor občin</xsl:when>
                    <xsl:when test="$chamber = 'ZbZdruDel'">Zbor združenega dela</xsl:when>
                    <xsl:when test="$chamber = 'VsiZbor'">Vsi zbori zasedajo skupaj</xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Neznana vrsta zbora: <xsl:value-of select="ancestor::tei:TEI/@xml:id"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>: </xsl:text>
                <xsl:if test="string-length($sessionNum) gt 0">
                    <xsl:value-of select="concat(number($sessionNum),'. ')"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$sessionLabel = 'Seja'">seja</xsl:when>
                    <xsl:when test="$sessionLabel = 'Zasedanje'">zasedanje</xsl:when>
                    <xsl:when test="$sessionLabel = 'Delovna'">delovna seja</xsl:when>
                    <xsl:when test="$sessionLabel = 'Slavnostna'">slavnostna seja</xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Neznana vrsta seje: <xsl:value-of select="ancestor::tei:TEI/@xml:id"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </title>
            <meeting n="{number($sessionNum)}">
                <xsl:variable name="teiIdentifier" select="ancestor::tei:TEI/@xml:id"/>
                <xsl:attribute name="corresp">
                    <xsl:choose>
                        <xsl:when test="$chamber = 'DruzPolZb'">
                            <xsl:value-of select="concat('#','DruzPolZb')"/>
                        </xsl:when>
                        <xsl:when test="$chamber = 'ZbObc'">
                            <xsl:value-of select="concat('#','ZbObc')"/>
                        </xsl:when>
                        <xsl:when test="$chamber = 'ZbZdruDel'">
                            <xsl:value-of select="concat('#','ZbZdruDel')"/>
                        </xsl:when>
                        <xsl:when test="$chamber = 'VsiZbor'">
                            <xsl:value-of select="concat('#','DruzPolZb ','#','ZbObc ','#','ZbZdruDel')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="ana">
                    <xsl:choose>
                        <xsl:when test="$sessionLabel = 'Seja'">#parl.meeting.regular</xsl:when>
                        <xsl:when test="$sessionLabel = 'Zasedanje'">#parl.meeting.special</xsl:when>
                        <xsl:when test="$sessionLabel = 'Delovna'">#parl.meeting.special</xsl:when>
                        <xsl:when test="$sessionLabel = 'Slavnostna'">#parl.meeting.ceremonial</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </meeting>
            <!-- dodam še za prikaz metapodatkov o mandatu -->
            <meeting n="11" corresp="#SK" ana="#parl.term #SK.11">
                <xsl:text>11. sklic</xsl:text>
            </meeting>
            <xsl:apply-templates select="tei:respStmt" mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>
        </titleStmt>
    </xsl:template>
    
    <xsl:template match="tei:pubPlace" mode="pass1">
        <xsl:if test="string-length($clarinHandle) gt 0">
            <pubPlace>
                <xsl:value-of select="$clarinHandle"/>
            </pubPlace>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt/tei:date" mode="pass1">
        <date when="{current-date()}"><xsl:value-of select="format-date(current-date(),'[D1]. [M1]. [Y0001]')"/></date>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc/tei:bibl" mode="pass1">
        <bibl>
            <title type="main">Slovenian parliamentary corpus SlovParl 2.0</title>
            <author>Andrej Pančur</author>
            <author>Mojca Šorn</author>
            <author>Tomaž Erjavec</author>
            <idno type="hdl">http://hdl.handle.net/11356/1167</idno>
            <distributor>Slovenian language resource repository CLARIN.SI</distributor>
        </bibl>
    </xsl:template>
    
    <xsl:template match="tei:profileDesc" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <profileDesc>
            <abstract>
                <list type="agenda">
                    <xsl:for-each select="ancestor::tei:TEI/tei:text/tei:front/tei:div[@type='contents']/tei:list/tei:item">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </list>
            </abstract>
            <xsl:apply-templates mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>
        </profileDesc>
    </xsl:template>
    
    <xsl:template match="tei:settingDesc" mode="pass1">
        <settingDesc>
            <setting>
                <name type="city">Ljubljana</name>
                <xsl:choose>
                    <xsl:when test="xs:date(tei:setting/tei:date/@when) lt xs:date('1991-06-25')">
                        <name type="country" key="YU">Jugoslavija</name>
                        <name type="region">Slovenija</name>
                    </xsl:when>
                    <xsl:otherwise>
                        <name type="country" key="SI">Slovenija</name>
                    </xsl:otherwise>
                </xsl:choose>
                <date when="{tei:setting/tei:date/@when}" ana="#parl.sitting">
                    <xsl:value-of select="format-date(tei:setting[1]/tei:date/@when,'[D1]. [M1]. [Y0001]')"/>
                </date>
            </setting>
        </settingDesc>
    </xsl:template>
    
    <xsl:template match="tei:particDesc" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <!--<xsl:param name="DruzPolZb">
            <org xml:id="{ancestor::tei:TEI/@xml:id}.DruzPolZb" ana="#par.chamber" corresp="#DruzPolZb">
                <orgName>Družbeno-politični zbor</orgName>
            </org>
        </xsl:param>
        <xsl:param name="ZbObc">
            <org xml:id="{ancestor::tei:TEI/@xml:id}.ZbObc" ana="#par.chamber" corresp="#ZbObc">
                <orgName>Zbor občin</orgName>
            </org>
        </xsl:param>
        <xsl:param name="ZbZdruDel">
            <org xml:id="{ancestor::tei:TEI/@xml:id}.ZbZdruDel" ana="#par.chamber" corresp="#ZbZdruDel">
                <orgName>Zbor združenega dela</orgName>
            </org>
        </xsl:param>
        <particDesc>
            <xsl:choose>
                <xsl:when test="$chamber = 'VsiZbor'">
                    <xsl:copy-of select="$DruzPolZb"/>
                    <xsl:copy-of select="$ZbObc"/>
                    <xsl:copy-of select="$ZbZdruDel"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$chamber = 'DruzPolZb'">
                            <xsl:copy-of select="$DruzPolZb"/>
                        </xsl:when>
                        <xsl:when test="$chamber = 'ZbObc'">
                            <xsl:copy-of select="$ZbObc"/>
                        </xsl:when>
                        <xsl:when test="$chamber = 'ZbZdruDel'">
                            <xsl:copy-of select="$ZbZdruDel"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <!-\- v vmesni fazi procesiram še povezave na predsedujoče -\->
            <!-\-<xsl:apply-templates mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>-\->
        </particDesc>-->
    </xsl:template>
    
    <xsl:template match="tei:address" mode="pass1">
        <!-- odstranim naslov INZ na Kongresnem trgu 1 -->
    </xsl:template>
    
    <xsl:template match="tei:front" mode="pass1">
        <!-- ga odstranim -->
    </xsl:template>
    <xsl:template match="tei:timeline" mode="pass1">
        <!-- ga odstranim -->
    </xsl:template>
    <xsl:template match="tei:anchor" mode="pass1">
        <!-- jih odstranim -->
    </xsl:template>
    
    <xsl:template match="tei:body" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <body>
            <div>
                <xsl:for-each select="tei:div[@type='preface']/tei:head">
                    <head>
                        <xsl:if test="position() = 2">
                            <xsl:attribute name="type">session</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </head>
                </xsl:for-each>
                <xsl:for-each select="tei:div[@type='preface']/tei:note">
                    <xsl:choose>
                        <xsl:when test="@type = 'date'">
                            <docDate>
                                <xsl:value-of select="."/>
                            </docDate>
                        </xsl:when>
                        <xsl:otherwise>
                            <note type="{if (@type='president') then 'chairman' else @type}">
                                <xsl:value-of select="."/>
                            </note>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:apply-templates mode="pass1">
                    <xsl:with-param name="corpus-label" select="$corpus-label"/>
                    <xsl:with-param name="chamber" select="$chamber"/>
                    <xsl:with-param name="sessionNum" select="$sessionNum"/>
                    <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
                </xsl:apply-templates>
            </div>
        </body>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='preface']" mode="pass1">
        <!-- ga odstranim, ker sem ga procesiral zgoraj -->
    </xsl:template>
    
    <xsl:template match="tei:div[@type='sp'] | tei:div[@type='inter']" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <u>
            <xsl:attribute name="who">
                <xsl:choose>
                    <xsl:when test="not(tei:u/@who)">
                        <xsl:choose>
                            <xsl:when test="tei:note[@type='speaker'] = 'LEOPOLD FRELIH:'">#FrelihLeopold</xsl:when><!-- #SSK11.FrelihLeopold -->
                            <xsl:when test="tei:note[@type='speaker'] = 'DR. JOŽE MENCINGER:'">#MencingerJoze1941</xsl:when><!-- #SSK11.MencingerJoze1941 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'BRANIMIR BRAČKO:'">#BrackoBranko</xsl:when><!-- #SSK11.BrackoBranko -->
                            <xsl:when test="tei:note[@type='speaker'] = 'BRANKO BRAČKO:'">#BrackoBranko</xsl:when><!-- #SSK11.BrackoBranko -->
                            <xsl:when test="tei:note[@type='speaker'] = 'MARTINA LIPPAI:'">#LippaiMartina</xsl:when><!-- #SSK11.LippaiMartina -->
                            <xsl:when test="tei:note[@type='speaker'] = 'NEIDENTIFICIRANI GOVORNIK:'">#unknown</xsl:when><!-- #SSK11.unknown -->
                            <xsl:when test="tei:note[@type='speaker'] = 'ALENKA MARKIČ:'">#MarkicAlenka</xsl:when><!-- #SSK11.MarkicAlenka -->
                            <xsl:when test="tei:note[@type='speaker'] = 'MILAN VOLK:'">#VovkMilan1956</xsl:when><!-- #SSK11.VovkMilan1956 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'DR. STANKO BUSER:'">#BuserStanko1932</xsl:when><!-- #SSK11.BuserStanko1932 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'ANKA OSTERMAN:'">#OstermanAnka1940</xsl:when><!-- #SSK11.OstermanAnka1940 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'FRANC ERCE:'">#ErceFranc1951</xsl:when><!-- #SSK11.ErceFranc1951 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'MIHA JAZBINŠEK:'">#JazbinšekMiha</xsl:when><!-- #SSK11.JazbinsekMiha1941 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'R. Jakič'">#JakičRoman</xsl:when><!-- #SSK11.JakicRoman1967 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'Neidentificiran govornik:'">#unknown</xsl:when><!-- #SSK11.unknown -->
                            <xsl:when test="tei:note[@type='speaker'] = 'MILOŠ SENČUR:'">#SencurMilos1957</xsl:when><!-- #SSK11.SencurMilos1957 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'FEDJA KLAVORA:'">#KlavoraFedja1940</xsl:when><!-- #SSK11.KlavoraFedja1940 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'MARCEL ŠTEFANČIČ:'">#StefancicMarcel1937</xsl:when><!-- #SSK11.StefancicMarcel1937 -->
                            <xsl:when test="tei:note[@type='speaker'] = 'MAG. JANEZ JUG:'">#JugJanez</xsl:when><!-- #SSK11.JugJanez1947 -->
                            <xsl:otherwise>
                                <xsl:message>Unknown speaker "<xsl:value-of select="tei:note[@type='speaker']"/>"  with tei:note[@type='speaker']/@xml:id <xsl:value-of select="tei:note[@type='speaker']/@xml:id"/></xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--<xsl:value-of select="concat('#',$corpus-label,'.',substring-after(tei:u[1]/@who,'#'))"/>-->
                        <xsl:variable name="whoForSpeaker" select="concat('#',$corpus-label,'.',substring-after(tei:u[1]/@who,'#'))"/>
                        <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person[tokenize(@corresp,' ') = $whoForSpeaker]">
                            <xsl:value-of select="concat('#',@xml:id)"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="ana">
                <xsl:variable name="personID" select="tei:u[1]/@xml:id"/>
                <xsl:variable name="chairperson">
                    <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson/tei:person/tokenize(@corresp,' ')">
                        <xsl:if test="substring-after(.,'#') = $personID">#chair</xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="@type='inter'">#unauthorized</xsl:when>
                    <xsl:when test="string-length($chairperson) != 0"><xsl:value-of select="$chairperson"/></xsl:when>
                    <xsl:otherwise>#regular</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="following-sibling::tei:div[1][@type='inter'] or preceding-sibling::tei:div[1][@type='inter']">
                <xsl:variable name="numLevel">
                    <xsl:number count="tei:div[@type='sp'] | tei:div[@type='inter']" level="any"/>
                </xsl:variable>
                <xsl:attribute name="xml:id">
                    <!--<xsl:value-of select="concat($corpus-label,'-',ancestor::tei:TEI/@xml:id,'.u',$numLevel)"/>-->
                    <xsl:value-of select="concat(ancestor::tei:TEI/@xml:id,'.u',$numLevel)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="pass1">
                <xsl:with-param name="corpus-label" select="$corpus-label"/>
                <xsl:with-param name="chamber" select="$chamber"/>
                <xsl:with-param name="sessionNum" select="$sessionNum"/>
                <xsl:with-param name="sessionLabel" select="$sessionLabel"/>
            </xsl:apply-templates>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="pass1">
        <xsl:param name="corpus-label"/>
        <xsl:param name="chamber"/>
        <xsl:param name="sessionNum"/>
        <xsl:param name="sessionLabel"/>
        <xsl:variable name="num">
            <xsl:number count="tei:u[@xml:id]" level="any"/>
        </xsl:variable>
        <!-- začasen ana atribut za povezave na agendo -->
        <!--<seg xml:id="{$corpus-label}-{ancestor::tei:TEI/@xml:id}.seg{$num}" ana="{@xml:id}">
            <xsl:apply-templates mode="pass1"/>
        </seg>-->
        <seg xml:id="{ancestor::tei:TEI/@xml:id}.seg{$num}" ana="{@xml:id}">
            <xsl:apply-templates mode="pass1"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="tei:note" mode="pass1">
        <note>
             <xsl:if test="@type = 'speaker' or @type = 'time'">
                 <xsl:attribute name="type">
                     <xsl:value-of select="@type"/>
                 </xsl:attribute>
             </xsl:if>
            <xsl:apply-templates mode="pass1"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:gap[@n]" mode="pass1">
        <gap reason="inaudible"/>
    </xsl:template>
    
    <xsl:template match="tei:gap[tei:desc]" mode="pass1">
        <note>
            <xsl:value-of select="tei:desc"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:vocal[tei:desc]" mode="pass1">
        <note>
            <xsl:value-of select="tei:desc"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:kinesic[tei:desc]" mode="pass1">
        <note>
            <xsl:value-of select="tei:desc"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:incident[tei:desc]" mode="pass1">
        <note>
            <xsl:value-of select="tei:desc"/>
        </note>
    </xsl:template>
    
    <xsl:template match="tei:writing[tei:desc]" mode="pass1">
        <note>
            <xsl:value-of select="tei:desc"/>
        </note>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u[@xml:id]" mode="pass2">
        <u>
            <xsl:apply-templates select="@*" mode="pass2"/>
            <xsl:if test="preceding-sibling::tei:u[1][@ana='#unauthorized'] and preceding-sibling::tei:u[2][@xml:id]">
                <xsl:attribute name="prev">
                    <xsl:value-of select="concat('#',preceding-sibling::tei:u[2]/@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="following-sibling::tei:u[1][@ana='#unauthorized'] and following-sibling::tei:u[2][@xml:id]">
                <xsl:attribute name="next">
                    <xsl:value-of select="concat('#',following-sibling::tei:u[2]/@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="pass2"/>
        </u>
    </xsl:template>
    
    <!-- prestavim uvodne podatke iz body v front -->
    <xsl:template match="tei:text" mode="pass2">
        <text>
            <xsl:if test="tei:body/tei:div/tei:head or tei:body/tei:div/tei:docDate or tei:body/tei:div/tei:note[@type='chairman']">
                <front>
                    <div type="preface">
                        <xsl:apply-templates select="tei:body/tei:div/tei:head | tei:body/tei:div/tei:docDate | tei:body/tei:div/tei:note[@type='chairman']" mode="pass2"/>
                    </div>
                </front>
            </xsl:if>
            <xsl:apply-templates mode="pass2"/>
        </text>
    </xsl:template>
    
    <xsl:template match="tei:list[@type='agenda']/tei:item" mode="pass2">
        <item xml:id="{@xml:id}">
            <xsl:apply-templates mode="pass2"/>
            <xsl:variable name="corresp">
                <xsl:for-each select="tokenize(@corresp,' ')">
                    <item>
                        <xsl:value-of select="substring-after(.,'#')"/>
                    </item>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="ancestor::tei:TEI/tei:text/tei:body/tei:div/tei:u/tei:seg[@ana = $corresp/tei:item]">
                <ptr target="#{@xml:id}"/>
            </xsl:for-each>
        </item>
    </xsl:template>
    
    <xsl:template match="tei:seg" mode="pass2">
        <seg xml:id="{@xml:id}">
            <xsl:apply-templates mode="pass2"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass3">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass3"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:body/tei:div/tei:head | tei:body/tei:div/tei:docDate | tei:body/tei:div/tei:note[@type='chairman']" mode="pass3">
        <!-- elemente, ki sem jih iz body/div dal tudi v front/div, brišem iz body/div -->
    </xsl:template>
    
    <!-- premaknem u/note[@type='speaker'] pred u in u/note[@type='time'] za dotični u -->
    <xsl:template match="tei:u" mode="pass3">
        <xsl:apply-templates select="tei:note[@type='speaker']" mode="pass3"/>
        <u who="{@who}">
            <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
            <xsl:variable name="num">
                <xsl:number count="tei:u" level="any"/>
            </xsl:variable>
            <xsl:if test="@xml:id">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <!-- povsod dodam @xml:id -->
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id">
                    <!-- brez corpus-label pred identifikatorjem -->
                    <xsl:value-of select="concat($document-name-id,'.u',$num)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@prev">
                <xsl:attribute name="prev">
                    <xsl:value-of select="@prev"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@next">
                <xsl:attribute name="next">
                    <xsl:value-of select="@next"/>
                </xsl:attribute>
            </xsl:if>
            <!--<xsl:if test="@ana = '#chair'">
                <xsl:attribute name="ana">#chair</xsl:attribute>
            </xsl:if>-->
            <xsl:attribute name="ana">
                <xsl:choose>
                    <xsl:when test="@ana = '#chair'">#chair</xsl:when>
                    <!-- tako regular kot unauthorized postanejo regular -->
                    <xsl:otherwise>#regular</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*[not(self::tei:note[@type='speaker'] or (position() = last() and self::tei:note[@type='time']))]" mode="pass3"/>
        </u>
        <xsl:apply-templates select="*[position() = last()][self::tei:note[@type='time']]" mode="pass3"/>
    </xsl:template>
    
    <!-- čisto na koncu še preštejem vse elemente -->
    <xsl:template match="@* | node()" mode="pass4">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass4"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:key name="elements" match="*[ancestor-or-self::tei:text]" use="name()"/>
    
    <xsl:template match="tei:tagsDecl" mode="pass4">
        <tagsDecl>
            <namespace name="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="//*[ancestor-or-self::tei:text][count(.|key('elements', name())[1]) = 1]">
                    <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                </xsl:for-each>
            </namespace>
        </tagsDecl>
    </xsl:template>
    
    
</xsl:stylesheet>