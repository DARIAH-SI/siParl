<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei" version="2.0">
    
    <!--Input: speech-list.xml
    Output: siParl.xml-->  
    
    <xsl:output method="xml" indent="yes"/>
    <!-- Change for new version -->
    <xsl:param name="edition">4.0</xsl:param>
    <!-- Handle link for CLARIN.si repository entry of the corpus-->
    <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1936</xsl:param>

    <xsl:variable name="female_exception">
      <name>Astrid</name>
      <name>Dolores</name>
      <name>Iris</name>
      <name>Ines</name>
      <name>Ingrid</name>
      <name>Nives</name>
      <name>Mirjam</name>
      <name>Kim</name>
      <name>Karmen</name>
      <name>Lili</name>
      <name>Agnes</name>
      <name>Karin</name>
    </xsl:variable>

    <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
    
    <xsl:variable name="source-united-speaker-document">
        <xsl:copy-of select="document('../siParl_listPerson.xml')" copy-namespaces="no"/>
    </xsl:variable>
    
    <xsl:template match="documentsList">
        <xsl:result-document href="siParl4.0/siParl.xml">
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude" xml:lang="sl" xml:id="siParl">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title xml:lang="sl" type="main">Slovenski parlamentarni korpus siParl</title>
                            <title xml:lang="en" type="main">Slovenian parliamentary corpus siParl</title>
                            <title type="sub" xml:lang="sl">Skupščina Republike Slovenije: 11. mandat (1990-1992)</title>
                            <title type="sub" xml:lang="en">Assembly of the Republic of Slovenia: 11th legislative period 1990-1992</title>
                            <title type="sub" xml:lang="sl">Državni zbor Republik Slovenije: od 1. do 8. mandata (1992-2022)</title>
                            <title type="sub" xml:lang="en">National Assembly of the Republic of Slovenia: from the 1st to the 8th legislative period 1992-2022</title>
                            <title type="sub" xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije: od 2. do 8. mandata (1996-2022)</title>
                            <title type="sub" xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia: from the 2nd to the 8th legislative period 1996-2022</title>
                            <title type="sub" xml:lang="sl">Kolegij predsednika Državnega zbora Republike Slovenije: od 2. do 8. mandata (1996-2022)</title>
                            <title type="sub" xml:lang="en">Council of the President of the National Assembly: from the 2nd to the 8th legislative period 1996-2022</title>
                            <xsl:for-each-group select="//meeting" group-by="@n">
                                <meeting n="{current-grouping-key()}" corresp="{current-group()[1]/@corresp}" ana="{current-group()[1]/@ana}">
                                    <xsl:value-of select="current-group()[1]"/>
                                </meeting>
                            </xsl:for-each-group>
			    <respStmt>
			      <persName ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424">Andrej Pančur</persName>
			      <resp xml:lang="sl">Kodiranje TEI</resp>
			      <resp xml:lang="en">TEI corpus encoding</resp>
			    </respStmt>
			    <respStmt>
			      <persName ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424">Andrej Pančur</persName>
			      <resp xml:lang="sl">Urejanje seznama govornikov</resp>
			      <resp xml:lang="en">Editing a list of speakers</resp>
			    </respStmt>
			    <respStmt>
			      <persName ref="https://orcid.org/0000-0002-0464-9240">Katja Meden</persName>
			      <resp xml:lang="sl">Kodiranje TEI</resp>
			      <resp xml:lang="en">TEI corpus encoding</resp>
			    </respStmt>
			    <respStmt>
			      <persName ref="https://orcid.org/0000-0002-0464-9240">Katja Meden</persName>
			      <resp xml:lang="sl">Urejanje seznama govornikov</resp>
			      <resp xml:lang="en">Editing a list of speakers</resp>
			    </respStmt>
			    <respStmt>
			      <persName ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823">Tomaž Erjavec</persName>
			      <resp xml:lang="sl">Kodiranje TEI</resp>
			      <resp xml:lang="en">TEI corpus encoding</resp>
			    </respStmt>
			    <funder>
                              <orgName xml:lang="sl">Slovenska digitalna raziskovalna infrastruktura za umetnost in humanistiko DARIAH-SI</orgName>
                              <orgName xml:lang="en">Slovenian Digital Research Infrastructure for the Arts and Humanities DARIAH-SI</orgName>
                            </funder>
                            <funder>
                                <orgName xml:lang="sl">Slovenska raziskovalna infrastruktura CLARIN.SI</orgName>
                                <orgName xml:lang="en">The Slovenian research infrastructure CLARIN.SI</orgName>
                            </funder>
                            <funder>
                                <orgName xml:lang="sl">Razvoj slovenščine v digitalnem okolju RSDO</orgName>
                                <orgName xml:lang="en">Development of Slovene in a Digital Environment RSDO</orgName>
                            </funder>
                        </titleStmt>
                        <editionStmt>
                            <edition>
                                <xsl:value-of select="$edition"/>
                            </edition>
                        </editionStmt>
                        <extent>
                            <xsl:variable name="measures">
                                <xsl:for-each select="folder/teiHeader/fileDesc/extent/measure[@xml:lang='sl']">
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
                            <xsl:variable name="speeches">
                                <xsl:for-each select="folder/teiHeader/encodingDesc/tagsDecl/namespace/tagUsage[@gi='u']">
                                    <speech>
                                        <xsl:value-of select="@occurs"/>
                                    </speech>
                                </xsl:for-each>
                            </xsl:variable>
                            <measure unit="texts" quantity="{sum($measures/tei:texts)}" xml:lang="sl">
                                <xsl:value-of select="format-number(sum($measures/tei:texts),'###.###','euro')"/>
                                <xsl:text> besedil</xsl:text>
                            </measure>
                            <measure unit="texts" quantity="{sum($measures/tei:texts)}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($measures/tei:texts),'###,###')"/>
                                <xsl:text> texts</xsl:text>
                            </measure>
                            <measure unit="speeches" quantity="{sum($speeches/tei:speech)}" xml:lang="sl">
                                <xsl:value-of select="format-number(sum($speeches/tei:speech),'###.###','euro')"/>
                                <xsl:text> govorov</xsl:text>
                            </measure>
                            <measure unit="speeches" quantity="{sum($speeches/tei:speech)}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($speeches/tei:speech),'###,###')"/>
                                <xsl:text> speeches</xsl:text>
                            </measure>
                            <measure unit="words" quantity="{sum($measures/tei:words)}" xml:lang="sl">
                                <xsl:value-of select="format-number(sum($measures/tei:words),'###.###','euro')"/>
                                <xsl:text> besed</xsl:text>
                            </measure>
                            <measure unit="words" quantity="{sum($measures/tei:words)}" xml:lang="en">
                                <xsl:value-of select="format-number(sum($measures/tei:words),'###,###')"/>
                                <xsl:text> words</xsl:text>
                            </measure>
                        </extent>
                        <publicationStmt>
                            <publisher>
                                <orgName xml:lang="sl">Slovenska raziskovalna infrastruktura CLARIN.SI</orgName>
                                <orgName xml:lang="en">The Slovenian research infrastructure CLARIN.SI</orgName>
                                <ref target="http://www.clarin.si">http://www.clarin.si</ref>
                            </publisher>
                            <xsl:if test="string-length($clarinHandle) gt 0">
                                <idno type="URI" subtype="handle">
                                    <xsl:value-of select="$clarinHandle"/>
                                </idno>
                            </xsl:if>
                            <availability status="free">
                                <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                                <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</ref>.</p>
                                <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                            </availability>
			    <date>
			      <xsl:attribute name="when">
				<xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
			      </xsl:attribute>
			      <xsl:value-of select="format-date(current-date(), '[D1]. [M1]. [Y0001]')"/>
			    </date>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
                                <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
                                <idno type="URI" subtype="parliament">https://www.dz-rs.si</idno>
                                <date from="1990-05-05" to="2022-05-13"/>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <editorialDecl>
                            <correction>
                                <p xml:lang="en">No correction of source texts was performed.</p>
                            </correction>
                            <normalization>
                                <p xml:lang="en">Text has not been normalised, except for spacing.</p>
                            </normalization>
                            <hyphenation>
                                <p xml:lang="en">No end-of-line hyphens were present in the source.</p>
                            </hyphenation>
                            <quotation>
                                <p xml:lang="en">Quotation marks have been left in the text and are not explicitly marked up.</p>
                            </quotation>
                            <segmentation>
                                <p xml:lang="en">The texts are segmented into utterances (speeches) and segments (corresponding to paragraphs in the source transcription).</p>
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
			  <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="taxonomy-parla.speaker_types.xml"/>
			  <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="taxonomy-parla.legislature.xml"/>
			  <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="taxonomy-parla.content.xml"/>
                        </classDecl>
                    </encodingDesc>
                    <profileDesc>
                      <abstract>
			<p xml:lang="sl">Korpus siParl vsebuje zapisnike Skupščine Republike Slovenije za 11. mandatno obdobje 1990-1992, zapisnike Državnega zbora Republike Slovenije od 1. do 8. mandatnega obdobja 1992-2022, zapisnike delovnih teles Državnega zbora Republike Slovenije od 2. do 8. mandatnega obdobja 1996-2022 in zapisnike Kolegija predsednika Državnega zbora od 2. do 8. mandatnega obdobja 1996-2022.</p>
                        <p xml:lang="en">The siParl corpus contains minutes of the Assembly of the Republic of Slovenia for 11th legislative period 1990-1992, minutes of the National Assembly of the Republic of Slovenia from the 1st to the 8th legislative period 1992-2022, minutes of the working bodies of the National Assembly of the Republic of Slovenia from the 2nd to the 8th legislative period 1996-2022, and minutes of the the Council of the President of the National Assembly from the 2nd to the 8th legislative period 1996-2022.</p> 
                      </abstract>
                      <settingDesc>
			<setting xml:lang="sl">
                          <name type="city">Ljubljana</name>
                          <name type="country" key="YU" from="1990-05-05" to="1991-06-25">Jugoslavija</name>
                          <name type="region" from="1990-05-05" to="1991-06-25">Slovenija</name>
                          <name type="country" key="SI" from="1991-06-25" to="2022-05-13">Slovenija</name>
                          <date from="1990-05-05" to="2022-05-13"/>
                        </setting>
                        <setting xml:lang="en">
                          <name type="city">Ljubljana</name>
                          <name type="country" key="YU" from="1990-05-05" to="1991-06-25">Yugoslavia</name>
                          <name type="region" from="1990-05-05" to="1991-06-25">Slovenia</name>
                          <name type="country" key="SI" from="1991-06-25" to="2022-05-13">Slovenia</name>
                          <date from="1990-05-05" to="2022-05-13"/>
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
                            <idno type="wikimedia">https://sl.wikipedia.org/wiki/Skup%C5%A1%C4%8Dina_Socialisti%C4%8Dne_republike_Slovenije</idno>
                            <listEvent>
                              <head xml:lang="sl">Zakonodajno obdobje</head>
			      <head xml:lang="en">Legislative period</head>
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
                            <idno type="wikimedia">https://sl.wikipedia.org/wiki/Dr%C5%BEavni_zbor_Republike_Slovenije</idno>
                            <listEvent>
			      <head xml:lang="sl">Zakonodajno obdobje</head>
			      <head xml:lang="en">Legislative period</head>
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
                              <event xml:id="DZ.8" from="2018-06-22" to="2022-05-12">
                                <label xml:lang="sl">8. mandat</label>
                                <label xml:lang="en">Term 8</label>
                              </event>
                            </listEvent>
                            <listOrg xml:id="workingBodies">
                              <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                              <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                              <xsl:for-each-group select="folder[matches(@label,'SDT')]/teiHeader/profileDesc/particDesc/listOrg/org/listOrg[@xml:id='workingBodies']/org" group-by="@xml:id">
                                <xsl:sort select="current-grouping-key()"/>
<!--				<xsl:message>
				  <xsl:text>Check: </xsl:text>
				  <xsl:value-of select="current-grouping-key()"/>
				  <xsl:text> - </xsl:text>
				  <xsl:value-of select="normalize-space(current-group()[1]/orgName)"/>
				  <xsl:text> - </xsl:text>
				  <xsl:value-of select="ancestor::folder[@label][1]/@label"/>
				  

				</xsl:message>-->
                                <org xml:id="{current-grouping-key()}" ana="#parla.committee">
                                  <orgName>
                                    <xsl:value-of select="normalize-space(current-group()[1]/orgName)"/>
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
			  <person xml:id="commentator">
			    <persName>komentator</persName>
			  </person>
                          <xsl:for-each select="$source-united-speaker-document/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person">
                            <person xml:id="{@xml:id}">
                              <!--<xsl:for-each select="*">
                                  <xsl:copy-of select="." copy-namespaces="no"/>
                                  </xsl:for-each>-->
			      <xsl:copy-of select="*[not(self::tei:sex)] | @*"/>
			      <xsl:variable name="forename" select="tei:persName/tei:forename[1]"/>
			      <xsl:choose>
				<xsl:when test="$forename = $female_exception/tei:name">
				  <!-- If it matches, set sex to 'F' -->
				  <sex value="F"/>
				</xsl:when>
				<xsl:otherwise>
				  <!-- If it doesn't match, copy existing sex element if present -->
				  <xsl:if test="tei:sex">
				    <xsl:copy-of select="tei:sex"/>
				  </xsl:if>
				</xsl:otherwise>
			      </xsl:choose>
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
		    <!-- XInclude: "../" if for (current) GitHub repository, or "../speech/ if packing for whole corpus for CLARIN.SI repository. Otherwise error/no fallback."-->
		    <xsl:variable name="href">
                      <xsl:value-of select="substring-after(.,'../speech/')"/>
		    </xsl:variable>
		    <xsl:element name="xi:include">
                      <xsl:attribute name="href">
                        <xsl:value-of select="substring-after(.,'../speech/')"/>
                      </xsl:attribute>
		    </xsl:element>
		  </xsl:for-each>
		</teiCorpus>
	      </xsl:result-document>
	    </xsl:template>
	  </xsl:stylesheet>
