<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhaja iz ParlaMint-list.xml -->
    <!-- naredi korpus datoteko, ki vključuje vse TEI dokumente iz ParlaMint/ -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- vstavi ob procesiranju nove verzije -->
    <xsl:param name="edition">1.0</xsl:param>
    <!-- vstavim CLARIN.SI Handle, kjer bo korpus shranjen v repozitoriju -->
    <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1345</xsl:param>
    
    <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
    
    <xsl:variable name="source-united-speaker-document">
        <xsl:copy-of select="document('../speaker.xml')" copy-namespaces="no"/>
    </xsl:variable>
    
    <xsl:param name="taxonomy-legislature">
        <taxonomy xml:id="parla.legislature">
            <desc xml:lang="sl"><term>Zakonodajna oblast</term></desc>
            <desc xml:lang="en"><term>Legislature</term></desc>
            <category xml:id="parla.geo-political">
                <catDesc xml:lang="sl"><term>Geopolitične ali upravne enote</term></catDesc>
                <catDesc xml:lang="en"><term>Geo-political or administrative units</term></catDesc>
                <category xml:id="parla.supranational">
                    <catDesc xml:lang="sl"><term>Nadnacionalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>Supranational legislature</term></catDesc>
                </category>
                <category xml:id="parla.national">
                    <catDesc xml:lang="sl"><term>Nacionalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>National legislature</term></catDesc>
                </category>
                <category xml:id="parla.regional">
                    <catDesc xml:lang="sl"><term>Regionalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>Regional legislature</term></catDesc>
                </category>
                <category xml:id="parla.local">
                    <catDesc xml:lang="sl"><term>Lokalna zakonodajna oblast</term></catDesc>
                    <catDesc xml:lang="en"><term>Local legislature</term></catDesc>
                </category>
            </category>
            <category xml:id="parla.organization">
                <catDesc xml:lang="sl"><term>Organiziranost</term></catDesc>
                <catDesc xml:lang="en"><term>Organization</term></catDesc>
                <category xml:id="parla.chambers">
                    <catDesc xml:lang="sl"><term>Zbori</term></catDesc>
                    <catDesc xml:lang="en"><term>Chambers</term></catDesc>
                    <category xml:id="parla.uni">
                        <catDesc xml:lang="sl"><term>Enodomen</term></catDesc>
                        <catDesc xml:lang="en"><term>Unicameralism</term></catDesc>
                    </category>
                    <category xml:id="parla.bi">
                        <catDesc xml:lang="sl"><term>Dvodomen</term></catDesc>
                        <catDesc xml:lang="en"><term>Bicameralism</term></catDesc>
                        <category xml:id="parla.upper">
                            <catDesc xml:lang="sl"><term>Zgornji dom</term></catDesc>
                            <catDesc xml:lang="en"><term>Upper house</term></catDesc>
                        </category>
                        <category xml:id="parla.lower">
                            <catDesc xml:lang="sl"><term>Spodnji dom</term></catDesc>
                            <catDesc xml:lang="en"><term>Lower house</term></catDesc>
                        </category>
                    </category>
                    <category xml:id="parla.multi">
                        <catDesc xml:lang="sl"><term>Večdomen</term></catDesc>
                        <catDesc xml:lang="en"><term>Multicameralism</term></catDesc>
                        <category xml:id="parla.chamber">
                            <catDesc xml:lang="sl"><term>Zbor</term></catDesc>
                            <catDesc xml:lang="en"><term>Chamber</term></catDesc>
                        </category>
                    </category>
                </category>
                <category xml:id="parla.committee">
                    <catDesc xml:lang="sl"><term>Delovno telo</term></catDesc>
                    <catDesc xml:lang="en"><term>Committee</term></catDesc>
                    <category xml:id="parla.committee.standing">
                        <catDesc xml:lang="sl"><term>Stalno delovno telo</term></catDesc>
                        <catDesc xml:lang="en"><term>Standing committee</term></catDesc>
                    </category>
                    <category xml:id="parla.committee.special">
                        <catDesc xml:lang="sl"><term>Začasno delovno telo</term></catDesc>
                        <catDesc xml:lang="en"><term>Special committee</term></catDesc>
                    </category>
                    <category xml:id="parla.committee.inquiry">
                        <catDesc xml:lang="sl"><term>Preiskovalna komisija</term></catDesc>
                        <catDesc xml:lang="en"><term>Committee of inquiry </term></catDesc>
                    </category>
                </category>
            </category>
            <category xml:id="parla.term">
                <catDesc xml:lang="sl"><term>Zakonodajno obdobje</term></catDesc>
                <catDesc xml:lang="en"><term>Legislative period</term>: term of the parliament between
                    general elections.</catDesc>
                <category xml:id="parla.session">
                    <catDesc xml:lang="sl"><term>Parlamentaro zasedanje</term></catDesc>
                    <catDesc xml:lang="en"><term>Legislative session</term>: the period of time in which
                        a legislature is convened for purpose of lawmaking, usually being
                        one of two or more smaller divisions of the entire time between two
                        elections. A session is a meeting or series of connected meetings
                        devoted to a single order of business, program, agenda, or announced
                        purpose.</catDesc>
                    <category xml:id="parla.meeting">
                        <catDesc xml:lang="sl"><term>Seja</term></catDesc>
                        <catDesc xml:lang="en"><term>Meeting</term>: Each meeting may be a
                            separate session or part of a group of meetings constituting a
                            session. The session/meeting may take one or more
                            days.</catDesc>
                        <category xml:id="parla.meeting-types">
                            <catDesc xml:lang="sl"><term>Vrste sej</term></catDesc>
                            <catDesc xml:lang="en"><term>Types of meetings</term></catDesc>
                            <category xml:id="parla.meeting.regular">
                                <catDesc xml:lang="sl"><term>Redna seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Regular meeting</term></catDesc>
                            </category>
                            <category xml:id="parla.meeting.special">
                                <catDesc xml:lang="sl"><term>Posebna seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Special meeting</term></catDesc>
                                <category xml:id="parla.meeting.extraordinary">
                                    <catDesc xml:lang="sl"><term>Izredna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Extraordinary meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.urgent">
                                    <catDesc xml:lang="sl"><term>Nujna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Urgent meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.ceremonial">
                                    <catDesc xml:lang="sl"><term>Slavnostna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Ceremonial meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.commemorative">
                                    <catDesc xml:lang="sl"><term>Žalna seja</term></catDesc>
                                    <catDesc xml:lang="en"><term>Commemorative meeting</term></catDesc>
                                </category>
                                <category xml:id="parla.meeting.opinions">
                                    <catDesc xml:lang="sl"><term>Javna predstavitev mnenj</term></catDesc>
                                    <catDesc xml:lang="en"><term>Public presentation of opinions</term></catDesc>
                                </category>
                            </category>
                            <category xml:id="parla.meeting.continued">
                                <catDesc xml:lang="sl"><term>Ponovni sestanek</term></catDesc>
                                <catDesc xml:lang="en"><term>Continued meeting</term></catDesc>
                            </category>
                            <category xml:id="parla.meeting.public">
                                <catDesc xml:lang="sl"><term>Javna seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Public meeting</term></catDesc>
                            </category>
                            <category xml:id="parla.meeting.executive">
                                <catDesc xml:lang="sl"><term>Zaprta seja</term></catDesc>
                                <catDesc xml:lang="en"><term>Executive meeting</term></catDesc>
                            </category>
                        </category>
                        <category xml:id="parla.sitting">
                            <catDesc xml:lang="sl"><term>Dan seje</term></catDesc>
                            <catDesc xml:lang="en"><term>Sitting</term>: sitting day</catDesc>
                        </category>
                    </category>
                </category>
            </category>
        </taxonomy>
    </xsl:param>
    <xsl:param name="taxonomy-speakers">
        <taxonomy xml:id="speaker_types">
            <desc xml:lang="sl"><term>Vrste govornikov</term></desc>
            <desc xml:lang="en"><term>Types of speakers</term></desc>
            <category xml:id="chair">
                <catDesc xml:lang="sl"><term>Predsedujoči</term>: predsedujoči zasedanja</catDesc>
                <catDesc xml:lang="en"><term>Chairperson</term>: chairman of a meeting</catDesc>
            </category>
            <category xml:id="regular">
                <catDesc xml:lang="sl"><term>Navadni</term>: navadni govorec na zasedanju</catDesc>
                <catDesc xml:lang="en"><term>Regular</term>: a regular speaker at a meeting</catDesc>
            </category>
        </taxonomy>
    </xsl:param>
    <xsl:param name="taxonomy-subcorpus">
        <taxonomy xml:id="subcorpus">
            <desc xml:lang="sl"><term>Podkorpusi</term></desc>
            <desc xml:lang="en"><term>Subcorpora</term></desc>
            <category xml:id="reference">
                <catDesc xml:lang="sl"><term>Referenca</term>: referenčni podkorpus, do 2019-10-31</catDesc>
                <catDesc xml:lang="en"><term>Reference</term>: reference subcorpus, until 2019-10-31</catDesc>
            </category>
            <category xml:id="covid">
                <catDesc xml:lang="sl"><term>COVID</term>: COVID podkorpus, od 2019-11-01 dalje</catDesc>
                <catDesc xml:lang="en"><term>COVID</term>: COVID subcorpus, from 2019-11-01 onwards</catDesc>
            </category>
        </taxonomy>
    </xsl:param>
    
    
    <xsl:template match="documentsList">
        <xsl:result-document href="../ParlaMint/ParlaMint-sl.xml">
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude" xml:lang="sl" xml:id="ParlaMint-sl">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title type="main" xml:lang="hr">Slovenski parlamentarni korpus ParlaMint-sl [ParlaMint]</title>
                            <title type="main" xml:lang="en">Slovenian parliamentary corpus ParlaMint-sl [ParlaMint]</title>
                            <title type="sub" xml:lang="hr">Zapisi sej Državnega zbora Republike Slovenije, 7. in 8. mandat (2014 - 2020)</title>
                            <title type="sub" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia, 7th and 8th Mandate (2014 - 2020)</title>
                            
                            <xsl:for-each-group select="//meeting" group-by="@n">
                                <meeting n="{current-grouping-key()}" corresp="{current-group()[1]/@corresp}" ana="{current-group()[1]/@ana}">
                                    <xsl:value-of select="current-group()[1]"/>
                                </meeting>
                            </xsl:for-each-group>
                            <respStmt>
                                <persName>Andrej Pančur</persName>
                                <resp xml:lang="sl">Kodiranje Parla-CLARIN TEI XML</resp>
                                <resp xml:lang="en">Parla-CLARIN TEI XML corpus encoding</resp>
                            </respStmt>
                            <funder>
                                <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
                                <orgName xml:lang="en">The CLARIN research infrastructure</orgName>
                            </funder>
                        </titleStmt>
                        <editionStmt>
                            <edition>
                                <xsl:value-of select="$edition"/>
                            </edition>
                        </editionStmt>
                        <extent>
                            <xsl:variable name="speeches">
                                <xsl:for-each select="folder/teiHeader/encodingDesc/tagsDecl/namespace/tagUsage[@gi='u']">
                                    <speech>
                                        <xsl:value-of select="@occurs"/>
                                    </speech>
                                </xsl:for-each>
                            </xsl:variable>
                            <measure unit="speeches" quantity="{format-number(sum($speeches/tei:speech),'#')}" xml:lang="sl">
                                <xsl:value-of select="format-number(sum($speeches/tei:speech),'#.###','euro')"/>
                                <xsl:text> govorov</xsl:text>
                            </measure>
                            <measure unit="speeches" quantity="{format-number(sum($speeches/tei:speech),'#')}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($speeches/tei:speech),'#,###')"/>
                                <xsl:text> speeches</xsl:text>
                            </measure>
                            
                            <xsl:variable name="measures">
                                <xsl:for-each select="folder/teiHeader/fileDesc/extent/measure[1]">
                                    <words>
                                        <xsl:value-of select="@quantity"/>
                                    </words>
                                </xsl:for-each>
                            </xsl:variable>
                            <measure unit="words" quantity="{format-number(sum($measures/tei:words),'#')}" xml:lang="sl">
                                <xsl:value-of select="format-number(sum($measures/tei:words),'#.###','euro')"/>
                                <xsl:text> besed</xsl:text>
                            </measure><measure unit="words" quantity="{format-number(sum($measures/tei:words),'#')}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($measures/tei:words),'#,###')"/>
                                <xsl:text> words</xsl:text>
                            </measure>
                        </extent>
                        <publicationStmt>
                            <publisher>
                                <orgName xml:lang="sl">Raziskovalna infrastrukutra CLARIN</orgName>
                                <orgName xml:lang="en">CLARIN research infrastructure</orgName>
                                <ref target="https://www.clarin.eu/">www.clarin.eu</ref>
                            </publisher>
                            <idno type="handle">http://hdl.handle.net/11356/1345</idno>
                            <pubPlace><ref target="http://hdl.handle.net/11356/1345">http://hdl.handle.net/11356/1345</ref></pubPlace>
                            <availability status="free">
                                <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                                <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                    Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                                <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                    Attribution 4.0 International License</ref>.</p>
                            </availability>
                            <date when="{current-date()}">
                                <xsl:value-of select="format-date(current-date(),'[D1]. [M1]. [Y0001]')"/>
                            </date>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
                                <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
                                <idno type="URI">https://www.dz-rs.si</idno>
                                <date from="2014-08-01" to="2020-07-16"/>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <projectDesc>
                            <p xml:lang="sl"><ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref></p>
                            <p xml:lang="en"><ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref> is a project that aims to (1) create a multilingual set of comparable corpora of parliamentary proceedings uniformly encoded according to the <ref target="https://github.com/clarin-eric/parla-clarin">Parla-CLARIN recommendations</ref> and covering the COVID-19 pandemic from November 2019 as well as the earlier period from 2015 to serve as a reference corpus; (2) process the corpora linguistically to add Universal Dependencies syntactic structures and Named Entity annotation; (3) make the corpora available through concordancers and Parlameter; and (4) build use cases in Political Sciences and Digital Humanities based on the corpus data.</p>
                        </projectDesc>
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
                        <tagsDecl>
                            <namespace name="http://www.tei-c.org/ns/1.0">
                                <xsl:for-each-group select="//tagUsage" group-by="@gi">
                                    <tagUsage gi="{current-grouping-key()}" occurs="{format-number(sum(for $n in current-group() return $n/@occurs),'#')}"/>
                                </xsl:for-each-group>
                            </namespace>
                        </tagsDecl>
                        <classDecl>
                            <xsl:copy-of select="$taxonomy-legislature"/>
                            <xsl:copy-of select="$taxonomy-speakers"/>
                            <xsl:copy-of select="$taxonomy-subcorpus"/>
                        </classDecl>
                    </encodingDesc>
                    <profileDesc>
                        <settingDesc>
                            <setting>
                                <name type="address">Šubičeva ulica 4</name>
                                <name type="city">Ljubljana</name>
                                <name type="country" key="SI">Slovenia</name>
                                <date from="2014-08-01" to="2020-07-16"/>
                            </setting>
                        </settingDesc>
                        <particDesc>
                            <listOrg>
                                <org xml:id="DZ" role="parliament" ana="#parla.national #parla.lower">
                                    <orgName xml:lang="sl">Državni zbor Republike Slovenije</orgName>
                                    <orgName xml:lang="en">National Assembly of the Republic of Slovenia</orgName>
                                    <event from="1992-12-23">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl">https://sl.wikipedia.org/wiki/Dr%C5%BEavni_zbor_Republike_Slovenije</idno>
                                    <idno type="wikimedia" xml:lang="en">https://en.wikipedia.org/wiki/National_Assembly_(Slovenia)</idno>
                                    <listEvent>
                                        <head xml:lang="sl">Mandatno obdobje</head>
                                        <head xml:lang="en">Legislative period</head>
                                        <event xml:id="DZ.7" from="2014-08-01" to="2018-06-21">
                                            <label xml:lang="sl">7. mandat</label>
                                            <label xml:lang="en">Term 7</label>
                                        </event>
                                        <event xml:id="DZ.8" from="2018-06-22">
                                            <label xml:lang="sl">8. mandat</label>
                                            <label xml:lang="en">Term 8</label>
                                        </event>
                                    </listEvent>
                                </org>
                                <org xml:id="GOV" role="government">
                                    <orgName xml:lang="sl">Vlada Republike Slovenije</orgName>
                                    <orgName xml:lang="en">Government of the Republic of Slovenia</orgName>
                                    <event from="1990-05-16">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl">https://sl.wikipedia.org/wiki/Vlada_Republike_Slovenije</idno>
                                    <idno type="wikimedia" xml:lang="en">https://en.wikipedia.org/wiki/Government_of_Slovenia</idno>
                                    <listEvent>
                                        <event xml:id="GOV.11" from="2013-03-20" to="2014-09-18">
                                            <label xml:lang="sl">11. vlada Republike Slovenije (20. marec 2013 - 18. september 2014)</label>
                                            <label xml:lang="en">11th Government of the Republic of Slovenia (20 March 2013 - 18 September 2014)</label>
                                        </event>
                                        <event xml:id="GOV.12" from="2014-09-18" to="2018-09-13">
                                            <label xml:lang="sl">12. vlada Republike Slovenije (18. september 2014 - 13. september 2018)</label>
                                            <label xml:lang="en">12th Government of the Republic of Slovenia (18 September 2014 - 13 September 2018)</label>
                                        </event>
                                        <event xml:id="GOV.13" from="2018-09-13" to="2018-03-13">
                                            <label xml:lang="sl">13. vlada Republike Slovenije (13. september 2018 - 13. marec 2020)</label>
                                            <label xml:lang="en">13th Government of the Republic of Slovenia (13 September 2018 - 13 March 2020)</label>
                                        </event>
                                        <event xml:id="GOV.14" from="2018-03-13">
                                            <label xml:lang="sl">14. vlada Republike Slovenije (13. marec 2020 - danes)</label>
                                            <label xml:lang="en">14th Government of the Republic of Slovenia (March 13, 2020 - today)</label>
                                        </event>
                                    </listEvent>
                                </org>
                                <org xml:id="party.PS" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Pozitivna Slovenija</orgName>
                                    <orgName full="yes" xml:lang="en">Positive Slovenia</orgName>
                                    <orgName full="init">PS</orgName>
                                    <event from="2011-10-22">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Pozitivna_Slovenija</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Positive_Slovenia</idno>
                                </org>
                                <org xml:id="party.DL" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Državljanska lista</orgName>
                                    <orgName full="yes" xml:lang="en">Civic List</orgName>
                                    <orgName full="init">DL</orgName>
                                    <event from="2012-04-24">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Dr%C5%BEavljanska_lista</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Civic_List_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.DeSUS" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Demokratična stranka upokojencev
                                        Slovenije</orgName>
                                    <orgName full="yes" xml:lang="en">Democratic Party of Pensioners of
                                        Slovenia</orgName>
                                    <orgName full="init">DeSUS</orgName>
                                    <event from="1991-05-30">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Demokrati%C4%8Dna_stranka_upokojencev_Slovenije</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Democratic_Party_of_Pensioners_of_Slovenia</idno>
                                </org>
                                <org xml:id="party.Levica.1" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Združena levica</orgName>
                                    <orgName full="yes" xml:lang="en">United Left</orgName>
                                    <orgName full="init">Levica</orgName>
                                    <event from="2014-03-01" to="2017-06-24">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/United_Left_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.Levica.2" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Levica</orgName>
                                    <orgName full="yes" xml:lang="en">The Left</orgName>
                                    <orgName full="init">Levica</orgName>
                                    <event from="2017-06-24">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/The_Left_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.LMŠ" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Lista Marjana Šarca</orgName>
                                    <orgName full="yes" xml:lang="en">The List of Marjan Šarec</orgName>
                                    <orgName full="init">LMŠ</orgName>
                                    <event from="2014-05-31">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Lista_Marjana_%C5%A0arca</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/List_of_Marjan_%C5%A0arec</idno>
                                </org>
                                <org xml:id="party.NeP" role="independet">
                                    <orgName full="yes" xml:lang="sl">Nepovezani poslanci</orgName>
                                    <orgName full="yes" xml:lang="en">Unrelated members of parliament</orgName>
                                    <orgName full="init">NeP</orgName>
                                </org>
                                <org xml:id="party.NP" role="independet">
                                    <orgName full="yes" xml:lang="sl">Poslanska skupina nepovezanih
                                        poslancev</orgName>
                                    <orgName full="yes" xml:lang="en">Parliamentary group of unrelated members of
                                        parliament</orgName>
                                    <orgName full="init">NP</orgName>
                                </org>
                                <org xml:id="party.IMNS" role="ethnic_communities">
                                    <orgName full="yes" xml:lang="sl">Poslanci italijanske in madžarske narodne
                                        skupnosti</orgName>
                                    <orgName full="yes" xml:lang="en">Members of the Italian and Hungarian national
                                        communities</orgName>
                                    <orgName full="init">IMNS</orgName>
                                </org>
                                <org xml:id="party.NSi" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Nova Slovenija – Krščanski demokrati</orgName>
                                    <orgName full="yes" xml:lang="en">New Slovenia – Christian Democrats</orgName>
                                    <orgName full="init">NSi</orgName>
                                    <event from="2000-08-04">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Nova_Slovenija</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/New_Slovenia</idno>
                                </org>
                                <org xml:id="party.SD" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Socialni demokrati</orgName>
                                    <orgName full="yes" xml:lang="en">Social Democrats</orgName>
                                    <orgName full="init">SD</orgName>
                                    <event from="2005-04-02">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Socialni_demokrati</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Social_Democrats_(Slovenia)</idno>
                                </org>
                                <org xml:id="party.SDS.2" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Slovenska demokratska stranka</orgName>
                                    <orgName full="yes" xml:lang="en">Slovenian Democratic Party</orgName>
                                    <orgName full="init">SDS</orgName>
                                    <event from="2003-09-19">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Slovenska_demokratska_stranka</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Slovenian_Democratic_Party</idno>
                                </org>
                                <org xml:id="party.SMC.1" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Stranka Mira Cerarja</orgName>
                                    <orgName full="yes" xml:lang="en">Party of Miro Cerar</orgName>
                                    <orgName full="init">SMC</orgName>
                                    <event from="2014-06-02" to="2015-03-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
                                </org>
                                <org xml:id="party.SMC.2" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Stranka modernega centra</orgName>
                                    <orgName full="yes" xml:lang="en">Modern Centre Party</orgName>
                                    <orgName full="init">SMC</orgName>
                                    <event from="2015-03-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
                                </org>
                                <org xml:id="party.SNS" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Slovenska nacionalna stranka</orgName>
                                    <orgName full="yes" xml:lang="en">Slovenian National Party</orgName>
                                    <orgName full="init">SNS</orgName>
                                    <event from="1991-03-17">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Slovenska_nacionalna_stranka</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Slovenian_National_Party</idno>
                                </org>
                                <org xml:id="party.ZaAB" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Zavezništvo Alenke Bratušek</orgName>
                                    <orgName full="yes" xml:lang="en">Alliance of Alenka Bratušek</orgName>
                                    <orgName full="init">ZaAB</orgName>
                                    <event from="2014-05-31" to="2016-05-21">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                                </org>
                                <org xml:id="party.ZaSLD" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Zavezništvo socialno-liberalnih
                                        demokratov</orgName>
                                    <orgName full="yes" xml:lang="en">Alliance of Social Liberal Democrats</orgName>
                                    <event from="2016-05-21" to="2017-10-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                                </org>
                                <org xml:id="party.SAB" role="political_party">
                                    <orgName full="yes" xml:lang="sl">Stranka Alenke Bratušek</orgName>
                                    <orgName full="yes" xml:lang="en">Party of Alenka Bratušek</orgName>
                                    <orgName full="init">SAB</orgName>
                                    <event from="2017-10-07">
                                        <label xml:lang="en">existence</label>
                                    </event>
                                    <idno type="wikimedia" xml:lang="sl"
                                        >https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
                                    <idno type="wikimedia" xml:lang="en"
                                        >https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
                                </org>
                                <listRelation>
                                    <relation name="renaming" active="#party.SMC.2" passive="#party.SMC.1"
                                        when="2015-03-07"/>
                                    <relation name="successor" active="#party.Levica.2" passive="#party.Levica.1"
                                        when="2017-06-24"/>
                                    <relation name="renaming" active="#party.ZaSLD" passive="#party.ZaAB"
                                        when="2016-05-21"/>
                                    <relation name="renaming" active="#party.SAB" passive="#party.ZaSLD"
                                        when="2017-10-07"/>
                                    <relation name="coalition" mutual="#party.PS #party.SD #party.DL #party.DeSUS"
                                        from="2013-03-20" to="2014-09-18" ana="#GOV.11"/>
                                    <relation name="coalition"
                                        mutual="#party.SMC.1 #party.SMC.2 #party.SD #party.DeSUS" from="2014-09-18"
                                        to="2018-09-12" ana="#GOV.12"/>
                                    <relation name="coalition" mutual="#party.LMŠ #party.SMC.2 #party.SD #party.SAB #party.DeSUS"
                                        from="2018-09-13" to="2020-03-12" ana="#GOV.13"/>
                                    <relation name="coalition" mutual="#party.SDS.2 #party.SMC.2 #party.NSi #party.DeSUS"
                                        from="2020-03-13" ana="#GOV.14"/>
                                </listRelation>
                            </listOrg>
                            <listPerson>
                                <head xml:lang="sl">Seznam govornikov</head>
                                <head xml:lang="en">List of speakers</head>
                                <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person[matches(@corresp,'#SDZ7|8')]">
                                    <person xml:id="{@xml:id}">
                                        <xsl:for-each select="tei:persName">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="tei:sex">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="tei:birth">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <!-- pazi, da daš pravilno vrednost za @ana -->
                                        <xsl:for-each select="tei:affiliation[@ana=('#DZ.7','#DZ.8')]">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="tei:idno">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                    </person>
                                </xsl:for-each>
                            </listPerson>
                        </particDesc>
                        <langUsage>
                            <language ident="sl" xml:lang="sl">slovenski</language>
                            <language ident="en" xml:lang="sl">angleški</language>
                            <language ident="sl" xml:lang="en">Slovenian</language>
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
                            <xsl:value-of select="substring-after(.,'../ParlaMint/')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </teiCorpus>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>