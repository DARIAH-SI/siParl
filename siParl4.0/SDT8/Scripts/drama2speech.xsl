<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

  <!-- Input: SDTX-list.xml, output: speech/SDTX.xml and speech/SDTX/*.xml-->

  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="taxonomy_legislature" select="document('../taxonomy-parla.legislature.xml')"/>

  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1936</xsl:param>

  <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>

  <xsl:variable name="listPerson">
    <xsl:copy-of select="document('../listPerson.xml')" copy-namespaces="no"/>
  </xsl:variable>
  <xsl:variable name="listOrg">
    <xsl:copy-of select="document('../listOrg.xml')" copy-namespaces="no"/>
  </xsl:variable>

  <xsl:variable name="terms">
    <term n="1" start="1992-12-23" end="1996-11-28">1. mandat (1992-1996)</term>
    <term n="2" start="1996-11-28" end="2000-10-27">2. mandat (1996-2000)</term>
    <term n="3" start="2000-10-27" end="2004-10-22">3. mandat (2000-2004)</term>
    <term n="4" start="2004-10-22" end="2008-10-15">4. mandat (2004-2008)</term>
    <term n="5" start="2008-10-15" end="2011-12-15">5. mandat (2008-2011)</term>
    <term n="6" start="2011-12-16" end="2014-08-01">6. mandat (2011-2014)</term>
    <term n="7" start="2014-08-01" end="2018-06-22">7. mandat (2014-2018)</term>
    <term n="8" start="2018-06-22" end="2022-05-13">8. mandat (2018-2022)</term>
  </xsl:variable>

  <!-- Taxonomy: speaker types-->
  <xsl:param name="taxonomy-speakers">
    <taxonomy xml:id="speaker_types" xml:lang="mul">
      <desc xml:lang="en">Types of speakers</desc>
      <desc xml:lang="sl">Vrste govornikov</desc>
      <category xml:id="chair">
        <catDesc xml:lang="en"><term>Chairperson</term>: chairman of a meeting</catDesc>
        <catDesc xml:lang="sl"><term>Predsedujoči</term>: predsedujoči zasedanja</catDesc>
      </category>
      <category xml:id="regular">
        <catDesc xml:lang="en"><term>Regular</term>: a regular speaker at a
        meeting</catDesc>
        <catDesc xml:lang="sl"><term>Navadni</term>: navadni govorec na zasedanju</catDesc>
      </category>
    </taxonomy>
  </xsl:param>

  <xsl:variable name="persons">
    <person name="Katja Meden" ref="https://orcid.org/0000-0002-0464-9240"/>
    <person name="Tomaž Erjavec"
            ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823"/>
    <person name="Andrej Pančur"
            ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424"/>
  </xsl:variable>

  <!-- Processing the term root-->
  <xsl:template match="documentsList">
    <xsl:variable name="corpus-label" select="tokenize(ref[1], '/')[1]"/>
    <xsl:variable name="corpus-term" select="substring($corpus-label, 4, 4)"/>
    <xsl:variable name="corpus-document" select="concat('speech/', $corpus-label, '.xml')"/>
    <xsl:message select="$corpus-document"/>
    <xsl:result-document href="{$corpus-document}">
      <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude" xml:id="siParl.{$corpus-label}"
                 xml:lang="sl">
        <teiHeader>
          <fileDesc>
            <titleStmt>
              <title type="main" xml:lang="sl">Dobesedni zapis sej delovnih teles
              Državnega zbora Republike Slovenije [siParl]</title>
              <title type="main" xml:lang="en">Verbatim record of sessions of the
              working bodies of the National Assembly of the Republic of
              Slovenia [siParl]</title>
              <title type="sub" xml:lang="sl">
                <xsl:value-of select="$terms/tei:term[@n = $corpus-term]"/>
              </title>
              <meeting n="{number($corpus-term)}" corresp="#DZ"
                       ana="#parla.term #DZ.{$corpus-term}">
                <xsl:value-of select="$corpus-term"/>
                <xsl:text>. mandat</xsl:text>
              </meeting>
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
                <persName
                    ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823">Tomaž Erjavec</persName>
                <resp xml:lang="sl">Kodiranje TEI</resp>
                <resp xml:lang="en">TEI corpus encoding</resp>
              </respStmt>
              <respStmt>
                <persName
                    ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424">Andrej Pančur</persName>
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
            </titleStmt>
            <editionStmt>
              <edition>4.0</edition>
            </editionStmt>
            <extent>
              <xsl:variable name="count-files" select="count(ref)"/>
              <measure unit="texts" quantity="{$count-files}" xml:lang="sl">
                <xsl:value-of
                    select="format-number($count-files, '###.###', 'euro')"/>
                <xsl:text> besedil</xsl:text>
              </measure>
              <measure unit="texts" quantity="{$count-files}" xml:lang="en">
                <xsl:value-of select="format-number($count-files, '###,###')"/>
                <xsl:text> texts</xsl:text>
              </measure>
              <!-- Counting words -->
              <xsl:variable name="counting">
                <xsl:for-each select="ref">
                  <string>
                    <xsl:apply-templates
                        select="document(.)/tei:TEI/tei:text/tei:body"/>
                  </string>
                </xsl:for-each>
              </xsl:variable>
              <xsl:variable name="compoundString"
                            select="normalize-space(string-join($counting/tei:string, ' '))"/>
              <xsl:variable name="count-words"
                            select="count(tokenize($compoundString, '\W+')[. != ''])"/>
              <measure unit="words" quantity="{$count-words}" xml:lang="sl">
                <xsl:value-of
                    select="format-number($count-words, '###.###', 'euro')"/>
                <xsl:text> besed</xsl:text>
              </measure>
              <measure unit="words" quantity="{$count-words}" xml:lang="en">
                <xsl:value-of select="format-number($count-words, '###,###')"/>
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
                <p xml:lang="en">This work is licensed under the <ref
                target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</ref>.</p>
                <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
              </availability>
              <date>
		<xsl:attribute name="when">
		  <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
		</xsl:attribute>
                <xsl:value-of
                    select="format-date(current-date(), '[D1]. [M1]. [Y0001]')"/>
              </date>
            </publicationStmt>
            <sourceDesc>
              <bibl>
                <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
                <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
                <idno type="URI" subtype="parliament">https://www.dz-rs.si</idno>
                <date>
                  <xsl:attribute name="from">
                    <xsl:value-of
                        select="$terms/tei:term[@n = $corpus-term]/@start"/>
                  </xsl:attribute>
                  <xsl:attribute name="to">
                    <xsl:value-of
                        select="$terms/tei:term[@n = $corpus-term]/@end"/>
                  </xsl:attribute>
                </date>
              </bibl>
            </sourceDesc>
          </fileDesc>
          <encodingDesc>
            <editorialDecl>
              <correction>
                <p>No correction of source texts were performed. Only apparently typed errors were corrected.</p>
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
              <xsl:copy-of select="$taxonomy_legislature"/>
              <xsl:copy-of select="$taxonomy-speakers"/>
            </classDecl>
          </encodingDesc>
          <profileDesc>
            <settingDesc>
              <setting>
                <name type="city">Ljubljana</name>
                <name type="country" key="SI">Slovenija</name>
                <date ana="#parla.term">
                  <xsl:attribute name="from">
                    <xsl:value-of
                        select="$terms/tei:term[@n = $corpus-term]/@start"/>
                  </xsl:attribute>
                  <xsl:attribute name="to">
                    <xsl:value-of
                        select="$terms/tei:term[@n = $corpus-term]/@end"/>
                  </xsl:attribute>
                </date>
              </setting>
            </settingDesc>
            <particDesc>
              <listOrg>
                <org xml:id="SK" role="parliament"
                     ana="#parla.regional #parla.national #parla.multi">
                  <orgName from="1990-06-23" to="1992-12-23" xml:lang="sl">Skupščina Republike Slovenije</orgName>
                  <orgName from="1990-06-23" to="1992-12-23" xml:lang="en">Assembly of the Republic of Slovenia</orgName>
                  <orgName from="1963-06-24" to="1990-06-23" xml:lang="sl">Skupščina Socialistične republike Slovenije</orgName>
                  <orgName from="1963-06-24" to="1990-06-23" xml:lang="en">Assembly of Socialist Republic of Slovenia</orgName>
                  <event from="1963-06-24" to="1992-12-23">
                    <label xml:lang="en">existence</label>
                  </event>
                  <idno type="URI" subtype="wikimedia"
                        >https://sl.wikipedia.org/wiki/Skup%C5%A1%C4%8Dina_Socialisti%C4%8Dne_republike_Slovenije</idno>
                  <listEvent>
                    <head>Legislative period</head>
                    <event xml:id="SK.11" from="1990-05-08" to="1992-12-23">
                      <label xml:lang="sl">11. sklic</label>
                      <label xml:lang="en">Term 11</label>
                    </event>
                  </listEvent>
                  <listOrg xml:id="chambers">
                    <head xml:lang="sl">Zbori Skupščine Republike
                    Slovenije</head>
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
                <org xml:id="DZ" role="parliament"
                     ana="#parla.national #parla.lower">
                  <orgName xml:lang="sl">Državni zbor Republike Slovenije</orgName>
                  <orgName xml:lang="en">National Assembly of the Republic of Slovenia</orgName>
                  <event from="1992-12-23">
                    <label xml:lang="en">existence</label>
                  </event>
                  <idno type="URI" subtype="wikimedia"
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
                    <event xml:id="DZ.8" from="2018-06-22" to="2022-05-12">
                      <label xml:lang="sl">8. mandat</label>
                      <label xml:lang="en">Term 8</label>
                    </event>
                  </listEvent>
                </org>
              </listOrg>
              <listOrg xml:id="workingBodies">
                <head xml:lang="sl">Delovna telesa Državnega zbora Republike Slovenije</head>
                <head xml:lang="en">Working bodies of the National Assembly of the Republic of Slovenia</head>
                <xsl:copy-of select="$listOrg//tei:org"/>
              </listOrg>
              <listPerson>
                <head xml:lang="sl">Seznam govornikov</head>
                <head xml:lang="en">List of speakers</head>
                <xsl:for-each select="$listPerson//tei:person">
                  <xsl:copy>
                    <!-- Copy all attributes except @corresp -->
                    <xsl:for-each select="@*">
                      <xsl:if test="name() != 'corresp'">
                        <xsl:attribute name="{name()}">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </xsl:if>
                    </xsl:for-each>
                    <!-- Copy all child nodes -->
                    <xsl:copy-of select="node()"/>
                  </xsl:copy>
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
	<!--XInclude corpus components (individual speeches) to the end of term root-->
        <xsl:for-each select="ref">
          <xsl:element name="xi:include">
            <xsl:attribute name="href">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:element>
          <!--TEI documents processing-->
          <xsl:variable name="document" select="concat('speech/', .)"/>
          <xsl:message select="$document"/>
          <xsl:result-document href="{$document}">
            <xsl:apply-templates select="document(.)" mode="pass0"/>
          </xsl:result-document>
        </xsl:for-each>
      </teiCorpus>
    </xsl:result-document>
  </xsl:template>

  <!-- Processing individual corpus components (sessions)-->
  <xsl:template match="/" mode="pass0">
    <xsl:variable name="var1">
      <xsl:apply-templates mode="pass1"/>
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
    <xsl:variable name="var5">
      <xsl:apply-templates select="$var4" mode="pass5"/>
    </xsl:variable>
    <xsl:variable name="var6">
      <xsl:apply-templates select="$var5" mode="pass6"/>
    </xsl:variable>
    <xsl:variable name="var7">
      <xsl:apply-templates select="$var6" mode="pass7"/>
    </xsl:variable>
    <xsl:variable name="var8">
      <xsl:apply-templates select="$var7" mode="pass8"/>
    </xsl:variable>
    <xsl:variable name="var9">
      <xsl:apply-templates select="$var8" mode="pass9"/>
    </xsl:variable>
    <xsl:variable name="var9">
      <xsl:apply-templates select="$var8" mode="pass9"/>
    </xsl:variable>
    <xsl:variable name="var10">
      <xsl:apply-templates select="$var9" mode="pass10"/>
    </xsl:variable>
    <xsl:variable name="var11">
      <xsl:apply-templates select="$var10" mode="pass11"/>
    </xsl:variable>
    <xsl:copy-of select="$var11" copy-namespaces="no"/>
  </xsl:template>

  <xsl:template match="@* | node()" mode="pass1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass1"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:publicationStmt" mode="pass1">
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
        <xsl:value-of
            select="format-date(current-date(), '[D1]. [M1]. [Y0001]')"/>
      </date>
    </publicationStmt>
  </xsl:template>

  <xsl:template match="tei:text" mode="pass1">
    <text>
      <xsl:if
          test="tei:body/tei:div/tei:stage[@type = 'title'] or tei:body/tei:div/tei:head or tei:body/tei:div/tei:stage[@type = 'session'] or tei:body/tei:div/tei:stage[@type = 'chairman']">
        <front>
          <div type="preface">
            <xsl:apply-templates
                select="tei:body/tei:div/tei:stage[@type = 'title'] | tei:body/tei:div/tei:head | tei:body/tei:div/tei:stage[@type = 'session'] | tei:body/tei:div/tei:stage[@type = 'chairman']"
                mode="pass1"/>
          </div>
        </front>
      </xsl:if>
      <xsl:apply-templates mode="pass1"/>
    </text>
  </xsl:template>

  <xsl:template match="tei:body/tei:div" mode="pass1">
    <div>
      <xsl:apply-templates mode="pass1"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div/tei:stage[@type = 'title']" mode="pass1">
    <head>
      <xsl:value-of select="normalize-space(.)"/>
    </head>
  </xsl:template>
  <xsl:template match="tei:div/tei:head" mode="pass1">
    <head>
      <xsl:value-of select="normalize-space(.)"/>
    </head>
  </xsl:template>
  <xsl:template match="tei:stage[@type = 'session']" mode="pass1">
    <head type="session">
      <xsl:value-of select="normalize-space(.)"/>
    </head>
  </xsl:template>
  <xsl:template match="tei:stage[@type = 'date']" mode="pass1">
    <docDate>
      <xsl:value-of select="normalize-space(.)"/>
    </docDate>
  </xsl:template>
  <xsl:template match="tei:stage[@type = 'chairman']" mode="pass1">
    <note type="chairman">
      <xsl:value-of select="normalize-space(.)"/>
    </note>
  </xsl:template>

  <xsl:template match="tei:div/tei:p" mode="pass1">
    <note>
      <xsl:value-of select="normalize-space(.)"/>
    </note>
  </xsl:template>

  <xsl:template match="tei:sp" mode="pass1">
    <u>
      <xsl:attribute name="who">
        <xsl:value-of select="concat('#', @who)"/>
      </xsl:attribute>
      <xsl:apply-templates mode="pass1"/>
    </u>
  </xsl:template>

  <xsl:template match="tei:speaker" mode="pass1">
    <note type="speaker">
      <xsl:apply-templates mode="pass1"/>
    </note>
  </xsl:template>

  <xsl:template match="tei:sp/tei:p" mode="pass1">
    <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
    <xsl:variable name="num">
      <xsl:number count="tei:sp/tei:p" level="any"/>
    </xsl:variable>
    <!-- only paragraphs that are not empty-->
    <xsl:if test="string-length(normalize-space(.)) != 0">
      <seg xml:id="{$document-name-id}.p{$num}">
        <xsl:apply-templates mode="pass1"/>
      </seg>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:sp/tei:p/tei:title[1]" mode="pass1">
    <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
    <xsl:variable name="num">
      <xsl:number count="tei:sp/tei:p/tei:title[1]" level="any"/>
    </xsl:variable>
    <title xml:id="{$document-name-id}.title{$num}">
      <xsl:apply-templates mode="pass1"/>
    </title>
  </xsl:template>

  <xsl:template match="tei:TEI" mode="pass1">
    <TEI>
      <xsl:apply-templates select="@*" mode="pass1"/>
      <xsl:attribute name="xml:lang">sl</xsl:attribute>
      <xsl:attribute name="ana">#parla.sitting</xsl:attribute>
      <xsl:apply-templates mode="pass1"/>
    </TEI>
  </xsl:template>


  <xsl:template match="tei:sourceDesc/tei:bibl" mode="pass1">
    <bibl>
      <xsl:for-each
          select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting">
        <xsl:variable name="workingGroup" select="substring-after(@who, '#')"/>
        <title>
          <xsl:if
              test="ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[not(tei:orgName/@key = 'KKPD')]">
            <xsl:value-of
                select="normalize-space(ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[@xml:id = $workingGroup]/tei:orgName)"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="concat(number(@n), '. ')"/>
          <xsl:choose>
            <xsl:when test="tei:name = 'Redna'">redna seja</xsl:when>
            <xsl:when test="tei:name = 'redna'">redna seja</xsl:when>
            <xsl:when test="tei:name = 'redna seja'">redna seja</xsl:when>
            <xsl:when test="tei:name = 'Izredna'">izredna seja</xsl:when>
            <xsl:when test="tei:name = 'Izredna seja'">izredna seja</xsl:when>
            <xsl:when test="tei:name = 'Nujna'">nujna seja</xsl:when>
            <xsl:when test="tei:name = 'nujna'">nujna seja</xsl:when>
            <xsl:when test="tei:name = 'nujna seja'">nujna seja</xsl:when>
            <xsl:when test="tei:name = 'Javna predstavitev'">javna predstavitev mnenj</xsl:when>
            <xsl:when test="tei:name = 'Javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
            <xsl:when test="tei:name = 'javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
            <xsl:when test="tei:name = 'Zasedanje'">zasedanje</xsl:when>
            <xsl:when test="tei:name = 'slavnostna seja'">slavnostna seja</xsl:when>
            <xsl:when test="tei:name = 'srecanje'">srečanje</xsl:when>
            <xsl:when test="tei:name = 'Srecanje'">Srečanje</xsl:when>
            <xsl:when test="tei:name = 'posvet'">posvet</xsl:when>
            <xsl:when test="tei:name = 'seja izvršilnega odbora'">seja izvršilnega odbora</xsl:when>
            <xsl:otherwise>
              <xsl:message>Neznana vrsta seje: <xsl:value-of
              select="ancestor::tei:TEI/@xml:id"/></xsl:message>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of
              select="concat(' (', format-date(tei:date/@when, '[D1]. [M1]. [Y0001]'), ')')"
              />
        </title>
      </xsl:for-each>
      <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia [siParl]</title>
      <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije [siParl]</title>
      <xsl:choose>
        <xsl:when test="@type = 'mag'">
          <edition xml:lang="sl">Nepreverjen zapis seje</edition>
          <edition xml:lang="en">Unverified session record</edition>
        </xsl:when>
        <xsl:otherwise>
          <edition xml:lang="sl">Preverjen zapis seje</edition>
          <edition xml:lang="en">Verified session record</edition>
        </xsl:otherwise>
      </xsl:choose>
      <date
          when="{ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting[1]/tei:date/@when}">
        <xsl:value-of
            select="format-date(ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting[1]/tei:date/@when, '[D1]. [M1]. [Y0001]')"
            />
      </date>
      <xsl:for-each select="tei:idno[@type = 'URI'][matches(., 'https:')]">
        <idno type="URI" subtype="parliament">
          <xsl:value-of select="."/>
        </idno>
      </xsl:for-each>
    </bibl>
  </xsl:template>

  <xsl:template match="tei:titleStmt" mode="pass1">
    <titleStmt>
      <xsl:choose>
        <xsl:when test="tei:title[2]">
          <xsl:choose>
            <xsl:when test="tokenize(ancestor::tei:TEI/@xml:id, '-')[2] = 'KKPD'">
              <title type="main" xml:lang="sl">Dobesedni zapis seje Kolegija predsednika Državnega zbora Republike Slovenije [siParl]</title>
              <title type="main" xml:lang="en">Verbatim record of the session of the Council of the President of the National Assembly of the Republic of Slovenia [siParl]</title>
            </xsl:when>
            <xsl:otherwise>
              <title type="main" xml:lang="sl">Dobesedni zapis seje delovnih teles Državnega zbora Republike Slovenije [siParl]</title>
              <title type="main" xml:lang="en">Verbatim record of the session of the working bodies of the National Assembly of the Republic of Slovenia [siParl]</title>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <title type="main" xml:lang="sl">Dobesedni zapis seje Državnega zbora Republike Slovenije [siParl]</title>
          <title type="main" xml:lang="en">Verbatim record of the session of the National Assembly of the Republic of Slovenia [siParl]</title>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each
          select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting">
        <xsl:variable name="workingGroup" select="substring-after(@who, '#')"/>
        <title type="sub" xml:lang="sl">
          <xsl:if
              test="ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[not(tei:orgName/@key = 'KKPD')]">
            <xsl:value-of
                select="normalize-space(ancestor::tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listOrg/tei:org[@xml:id = $workingGroup]/tei:orgName)"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="concat(number(@n), '. ')"/>
          <xsl:choose>
            <xsl:when test="tei:name = 'Redna'">redna seja</xsl:when>
            <xsl:when test="tei:name = 'redna'">redna seja</xsl:when>
            <xsl:when test="tei:name = 'redna seja'">redna seja</xsl:when>
            <xsl:when test="tei:name = 'Izredna'">izredna seja</xsl:when>
            <xsl:when test="tei:name = 'Izredna seja'">izredna seja</xsl:when>
            <xsl:when test="tei:name = 'Nujna'">nujna seja</xsl:when>
            <xsl:when test="tei:name = 'nujna'">nujna seja</xsl:when>
            <xsl:when test="tei:name = 'nujna seja'">nujna seja</xsl:when>
            <xsl:when test="tei:name = 'Javna predstavitev'">javna predstavitev mnenj</xsl:when>
            <xsl:when test="tei:name = 'Javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
            <xsl:when test="tei:name = 'javna predstavitev mnenj'">javna predstavitev mnenj</xsl:when>
            <xsl:when test="tei:name = 'Zasedanje'">zasedanje</xsl:when>
            <xsl:when test="tei:name = 'slavnostna seja'">slavnostna seja</xsl:when>
            <xsl:when test="tei:name = 'srecanje'">srečanje</xsl:when>
            <xsl:when test="tei:name = 'Srecanje'">Srečanje</xsl:when>
            <xsl:when test="tei:name = 'posvet'">posvet</xsl:when>
            <xsl:when test="tei:name = 'seja izvršilnega odbora'">seja izvršilnega odbora</xsl:when>
            <xsl:otherwise>
              <xsl:message>Neznana vrsta seje: <xsl:value-of
              select="ancestor::tei:TEI/@xml:id"/></xsl:message>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of
              select="concat(' (', format-date(tei:date/@when, '[D1]. [M1]. [Y0001]'), ')')"
              />
        </title>
      </xsl:for-each>
      <xsl:for-each
          select="ancestor::tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:setting">
        <meeting n="{number(@n)}" corresp="#{tokenize(@who,'\.')[last()]}">
          <!--<xsl:message select="concat('Who:', @n)"/>-->
          <xsl:attribute name="ana">
            <xsl:choose>
              <xsl:when test="tei:name = 'Redna'">#parla.meeting.regular</xsl:when>
              <xsl:when test="tei:name = 'redna'">#parla.meeting.regular</xsl:when>
              <xsl:when test="tei:name = 'redna seja'">#parla.meeting.regular</xsl:when>
              <xsl:when test="tei:name = 'Izredna'">#parla.meeting.extraordinary</xsl:when>
              <xsl:when test="tei:name = 'Izredna seja'">#parla.meeting.extraordinary</xsl:when>
              <xsl:when test="tei:name = 'Nujna'">#parla.meeting.urgent</xsl:when>
              <xsl:when test="tei:name = 'nujna'">#parla.meeting.urgent</xsl:when>
              <xsl:when test="tei:name = 'nujna seja'">#parla.meeting.urgent</xsl:when>
              <xsl:when test="tei:name = 'Javna predstavitev'">#parla.meeting.opinions</xsl:when>
              <xsl:when test="tei:name = 'Javna predstavitev mnenj'">#parla.meeting.opinions</xsl:when>
              <xsl:when test="tei:name = 'javna predstavitev mnenj'">#parla.meeting.opinions</xsl:when>
              <xsl:when test="tei:name = 'Zasedanje'">#parla.meeting.special</xsl:when>
              <xsl:when test="tei:name = 'slavnostna seja'">#parla.meeting.ceremonial</xsl:when>
              <xsl:when test="tei:name = 'srecanje'">#parla.meeting.special</xsl:when>
              <xsl:when test="tei:name = 'Srecanje'">#parla.meeting.special</xsl:when>
              <xsl:when test="tei:name = 'posvet'">#parla.meeting.special</xsl:when>
              <xsl:when test="tei:name = 'seja izvršilnega odbora'">#parla.meeting.special</xsl:when>
              <xsl:otherwise>
                <xsl:message>Neznana vrsta seje: <xsl:value-of
                select="ancestor::tei:TEI/@xml:id"/></xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="tei:name"/>
        </meeting>
      </xsl:for-each>
      <xsl:variable name="corpus-term"
                    select="ancestor::tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listOrg/tei:org/tei:listEvent/tei:event/@n"/>
      <meeting n="{number($corpus-term)}" corresp="#DZ" ana="#parla.term #DZ.{$corpus-term}">
        <xsl:value-of select="$corpus-term"/>
        <xsl:text>. mandat</xsl:text>
      </meeting>

      <xsl:apply-templates select="tei:respStmt" mode="pass1"/>
    </titleStmt>
  </xsl:template>

  <xsl:template match="tei:settingDesc" mode="pass1">
    <settingDesc>
      <setting>
        <name type="city">Ljubljana</name>
        <name type="country" key="SI">Slovenija</name>
	<!-- processing only the first one, otherwise duplicates-->
        <date when="{tei:setting[1]/tei:date/@when}" ana="#parla.sitting">
          <xsl:value-of
              select="format-date(tei:setting[1]/tei:date/@when, '[D1]. [M1]. [Y0001]')"/>
        </date>
      </setting>
    </settingDesc>
  </xsl:template>

  <xsl:template match="tei:particDesc" mode="pass1">
    <particDesc>
      <xsl:choose>
        <xsl:when test="tei:listOrg/tei:org/tei:listOrg/tei:org">
          <xsl:for-each select="tei:listOrg/tei:org/tei:listOrg/tei:org">
            <org xml:id="{@xml:id}" ana="#parla.committee" corresp="#{tei:orgName/@key}">
              <orgName>
                <xsl:value-of select="normalize-space(tei:orgName)"/>
              </orgName>
            </org>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="tei:listOrg/tei:org">
            <org xml:id="{@xml:id}" ana="#parla.lower" corresp="#DZ">
              <orgName>
                <xsl:value-of select="normalize-space(tei:orgName)"/>
              </orgName>
            </org>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </particDesc>
  </xsl:template>

  <xsl:template match="@* | node()" mode="pass2">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass2"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template
      match="tei:body/tei:div/tei:head | tei:body/tei:div/tei:docDate | tei:body/tei:div/tei:note[@type = 'chairman']"
      mode="pass2">
    <!-- Deleting elements from body/div (that were present both in body/div and front/div)-->
  </xsl:template>

  <xsl:template match="tei:profileDesc" mode="pass2">
    <profileDesc>
      <abstract>
        <list type="agenda">
          <item xml:id="{ancestor::tei:TEI/@xml:id}.toc-item0">
            <title>Pred dnevnim redom</title>
          </item>
          <xsl:for-each select="//tei:title[@xml:id]">
            <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
            <xsl:variable name="num">
              <xsl:number count="tei:title[@xml:id]" level="any"/>
            </xsl:variable>
            <item xml:id="{$document-name-id}.toc-item{$num}" corresp="{@xml:id}">
              <title>
                <xsl:value-of select="normalize-space(.)"/>
              </title>
              <xsl:for-each select="parent::tei:p/tei:title[not(@xml:id)]">
                <title>
                  <xsl:value-of select="normalize-space(.)"/>
                </title>
              </xsl:for-each>
            </item>
          </xsl:for-each>
        </list>
      </abstract>
      <xsl:apply-templates mode="pass2"/>
    </profileDesc>
  </xsl:template>

  <xsl:template match="tei:seg" mode="pass2">
    <seg>
      <xsl:apply-templates select="@*" mode="pass2"/>
      <xsl:attribute name="ana">
        <xsl:choose>
          <xsl:when test="tei:title[@xml:id]">
            <xsl:value-of select="tei:title[@xml:id]/@xml:id"/>
          </xsl:when>
          <xsl:when test="preceding::tei:title[@xml:id]">
            <xsl:value-of select="preceding::tei:title[@xml:id][1]/@xml:id"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(ancestor::tei:TEI/@xml:id, '.toc-item0')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates mode="pass2"/>
    </seg>
  </xsl:template>

  <xsl:template match="@* | node()" mode="pass3">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass3"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:list[@type = 'agenda']/tei:item[tei:title[2]]" mode="pass3">
    <item>
      <xsl:apply-templates select="@*" mode="pass3"/>
      <title>
        <xsl:value-of select="string-join(tei:title, ' ')"/>
      </title>
    </item>
  </xsl:template>

  <!-- Removing title labels-->
  <xsl:template match="tei:u/tei:seg/tei:title" mode="pass3">
    <xsl:apply-templates mode="pass3"/>
  </xsl:template>

  <!--Removing q element (quotes and other citations)-->
  <xsl:template match="tei:q" mode="pass3">
    <xsl:message select="concat('Quotes: ', .)"/>
    <xsl:apply-templates mode="pass3"/>
  </xsl:template>

  <xsl:template match="tei:stage" mode="pass3">
    <xsl:choose>
      <!-- siParl: stage to note -->
      <xsl:when test="not(@type) and matches(., 'nerazumljiv', 'i')">
        <gap reason="editorial">
          <desc>
            <xsl:apply-templates mode="pass3"/>
          </desc>
        </gap>
      </xsl:when>
      <xsl:when test="not(@type)">
        <note>
          <xsl:apply-templates select="@*" mode="pass3"/>
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <!-- Changing stage types to appropriate intteruption encodings (note)-->
      <xsl:when test="@type = 'answer'">
        <note type="answer">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'description'">
        <note type="description">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'error'">
        <note type="error">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'vote'">
        <note type="vote">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'vote-ayes'">
        <note type="vote-ayes">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'vote-noes'">
        <note type="vote-noes">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'vote-no'">
        <note type="vote-noes">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'time'">
        <note type="time">
          <xsl:apply-templates mode="pass3"/>
        </note>
      </xsl:when>
      <xsl:when test="@type = 'inaudible'">
        <gap reason="inaudible">
          <xsl:apply-templates mode="pass3"/>
        </gap>
      </xsl:when>
      <xsl:when test="@type = 'editorial'">
        <gap reason="editorial">
          <xsl:apply-templates mode="pass3"/>
        </gap>
      </xsl:when>
      <xsl:when test="@type = 'action'">
        <incident type="action">
          <xsl:apply-templates mode="pass3"/>
        </incident>
      </xsl:when>
      <xsl:when test="@type = 'sound'">
        <incident type="sound">
          <xsl:apply-templates mode="pass3"/>
        </incident>
      </xsl:when>
      <xsl:when test="@type = 'applause'">
        <kinesic type="applause">
          <xsl:apply-templates mode="pass3"/>
        </kinesic>
      </xsl:when>
      <xsl:when test="@type = 'signal'">
        <kinesic type="signal">
          <xsl:apply-templates mode="pass3"/>
        </kinesic>
      </xsl:when>
      <xsl:when test="@type = 'playback'">
        <kinesic type="playback">
          <xsl:apply-templates mode="pass3"/>
        </kinesic>
      </xsl:when>
      <xsl:when test="@type = 'snapping'">
        <kinesic type="snapping">
          <xsl:apply-templates mode="pass3"/>
        </kinesic>
      </xsl:when>
      <xsl:when test="@type = 'gesture'">
        <kinesic type="gesture">
          <xsl:apply-templates mode="pass3"/>
        </kinesic>
      </xsl:when>
      <xsl:when test="@type = 'interruption'">
        <vocal type="interruption">
          <xsl:apply-templates mode="pass3"/>
        </vocal>
      </xsl:when>
      <xsl:when test="@type = 'laughter'">
        <vocal type="laughter">
          <xsl:apply-templates mode="pass3"/>
        </vocal>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Unknown stage/@type value: <xsl:value-of select="@type"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Rearranging former p elements (current u/seg) -->
  <xsl:template match="@* | node()" mode="pass4">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass4"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/*" mode="pass4">
    <TEI>
      <xsl:apply-templates select="@*" mode="pass4"/>
      <xsl:apply-templates mode="pass4"/>
    </TEI>
  </xsl:template>

  <xsl:template
      match="tei:u/tei:seg[tei:note or tei:gap or tei:incident or tei:kinesic or tei:vocal]/text()"
      mode="pass4">
    <seg>
      <xsl:copy-of select="."/>
    </seg>
  </xsl:template>

  <!-- Cleaning rearranged elements -->
  <xsl:template match="@* | node()" mode="pass5">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass5"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:u/tei:seg[not(tei:seg)]" mode="pass5">
    <seg>
      <xsl:apply-templates select="@*" mode="pass5"/>
      <xsl:value-of select="normalize-space(.)"/>
    </seg>
  </xsl:template>

  <xsl:template match="tei:u/tei:seg[tei:seg]" mode="pass5">
    <seg>
      <xsl:apply-templates select="@*" mode="pass5"/>
      <xsl:for-each-group select="*"
			  group-adjacent="boolean(self::tei:note or self::tei:incident or self::tei:kinesic or self::tei:vocal)">
        <xsl:choose>
          <xsl:when test="current-grouping-key()">
            <xsl:apply-templates select="." mode="pass5"/>
          </xsl:when>
          <xsl:otherwise>
            <seg>
              <xsl:for-each select="current-group()">
                <xsl:choose>
                  <xsl:when test="self::tei:gap">
                    <xsl:apply-templates select="." mode="pass5"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space(.)) = 0">
			<!--Not processing segments, that only have spaces/are empty-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="." mode="pass5"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </seg>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </seg>
  </xsl:template>

  <xsl:template match="@* | node()" mode="pass6">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass6"/>
    </xsl:copy>
  </xsl:template>

  <!-- Removing extra parent seg elements -->
  <xsl:template match="tei:u/tei:seg[tei:seg]" mode="pass6">
    <xsl:apply-templates mode="pass6"/>
  </xsl:template>

  <xsl:template match="tei:u/tei:seg/tei:seg[tei:gap or tei:seg]" mode="pass6">
    <xsl:choose>
      <xsl:when test="tei:gap and not(tei:seg)">
        <xsl:choose>
          <xsl:when test="tei:gap/@n">
            <gap n="{tei:gap/@n}"/>
          </xsl:when>
          <xsl:otherwise>
            <gap reason="{tei:gap/@reason}">
              <xsl:value-of select="tei:gap"/>
            </gap>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="not(tei:gap) and tei:seg">
        <seg ana="{parent::tei:seg/@ana}">
          <xsl:value-of select="normalize-space(.)"/>
        </seg>
      </xsl:when>
      <xsl:when test="tei:gap and tei:seg">
        <seg ana="{parent::tei:seg/@ana}">
          <xsl:for-each select="tei:*">
            <xsl:choose>
              <xsl:when test="self::tei:gap[@reason]">
                <xsl:text> </xsl:text>
                <xsl:copy-of select="."/>
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:when
                  test="self::tei:gap[@n][following-sibling::tei:gap[@reason = 'inaudible'] or preceding-sibling::tei:gap[@reason = 'inaudible']]">
                <!-- removing -->
              </xsl:when>
              <xsl:when
                  test="self::tei:gap[@n][not(following-sibling::tei:gap[@reason = 'inaudible'] or preceding-sibling::tei:gap[@reason = 'inaudible'])]">
		<!-- if gap follows immediatelly preceding gap element, do not process-->
                <xsl:if test="not(preceding-sibling::tei:*[1][self::tei:gap])">
                  <xsl:choose>
                    <xsl:when test="position() = 1">
                      <xsl:copy-of select="."/>
                      <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:when test="position() = last()">
                      <xsl:text> </xsl:text>
                      <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text> </xsl:text>
                      <xsl:copy-of select="."/>
                      <xsl:text> </xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </seg>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Pass 6: tei:u/tei:seg/tei:seg[tei:gap or tei:seg]: unknown combination
        of elements (file id <xsl:value-of select="ancestor::tei:TEI/@xml:id"
        />)</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@* | node()" mode="pass7">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass7"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:u/tei:seg" mode="pass7">
    <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
    <xsl:variable name="num">
      <xsl:number count="tei:u/tei:seg" level="any"/>
    </xsl:variable>
    <!-- only seg that are not empty-->
    <xsl:if test="string-length(normalize-space(.)) != 0">
      <seg xml:id="{$document-name-id}.seg{$num}" ana="{@ana}">
        <xsl:apply-templates mode="pass7"/>
      </seg>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:u" mode="pass7">
    <xsl:variable name="speaker" select="tokenize(tei:note[@type = 'speaker'], ' ')[1]"/>
    <xsl:variable name="chair">
      <item>P0DPREDSEDNIK</item>
      <item>PEDSEDNICA</item>
      <item>PEDSEDNIK</item>
      <item>PERDSEDNICA</item>
      <item>PERDSEDNIK</item>
      <item>POD</item>
      <item>PODOPREDSEDNIK</item>
      <item>PODOPRESEDNIK</item>
      <item>PODOREDSEDNIK</item>
      <item>PODPDREDSEDNICA</item>
      <item>PODPEDSEDNIK</item>
      <item>PODPPREDSEDNIK</item>
      <item>PODPPREDSENIK</item>
      <item>PODPRDESEDNICA</item>
      <item>PODPRDESENIK</item>
      <item>PODPRDSEDNICA</item>
      <item>PODPRDSEDNIK</item>
      <item>PODPREDEDNICA</item>
      <item>PODPREDEDNIK</item>
      <item>PODPREDESEDNIK</item>
      <item>PODPREDSDEDNIK</item>
      <item>PODPREDSDENIK</item>
      <item>PODPREDSDNIK</item>
      <item>PODPREDSEDENIK</item>
      <item>PODPREDSEDICA</item>
      <item>PODPREDSEDIK</item>
      <item>PODPREDSEDNCA</item>
      <item>PODPREDSEDNI</item>
      <item>PODPREDSEDNIA</item>
      <item>PODPREDSEDNIC</item>
      <item>PODPREDSEDNICA</item>
      <item>PODPREDSEDNIDA</item>
      <item>PODPREDSEDNIK</item>
      <item>PODPREDSEDNIKA</item>
      <item>PODPREDSEDNIKCA</item>
      <item>PODPREDSEDNIKI</item>
      <item>PODPREDSEDNIKMAG.</item>
      <item>PODPREDSEDNIKN</item>
      <item>PODPREDSEDNK</item>
      <item>PODPREDSEDNNIK</item>
      <item>PODPREDSEEDNIK</item>
      <item>PODPREDSENDICA</item>
      <item>PODPREDSENDIK</item>
      <item>PODPREDSENICA</item>
      <item>PODPREDSENIK</item>
      <item>PODPREDSETNIK</item>
      <item>PODPREDSEVNIK</item>
      <item>PODPRESDEDNIK</item>
      <item>PODPRESEDNICA</item>
      <item>PODPRESEDNIK</item>
      <item>PODPRESENICA</item>
      <item>PODPRREDSEDNICA</item>
      <item>PODREDSEDNICA</item>
      <item>PODREDSEDNIK</item>
      <item>PODRPEDSEDNIK</item>
      <item>PODRPREDSEDNICA</item>
      <item>PODRPREDSEDNIK</item>
      <item>POPDPREDSEDNICA</item>
      <item>POPDPREDSEDNIK</item>
      <item>POPDREDSEDNICA</item>
      <item>POPDREDSEDNIK</item>
      <item>POPPREDSEDNICA</item>
      <item>POPREDSEDNICA</item>
      <item>POPREDSEDNIK</item>
      <item>POREDSDNICA</item>
      <item>PPRDSEDNIK</item>
      <item>PPREDSEDNIK</item>
      <item>PRDEDSEDNIK</item>
      <item>PRDSEDNICA</item>
      <item>PRDSEDNIK</item>
      <item>PRDSENIK</item>
      <item>PRE</item>
      <item>PREDDSEDNIK</item>
      <item>PREDEDNIK</item>
      <item>PREDESEDNICA</item>
      <item>PREDESEDNIK</item>
      <item>PREDESENIK</item>
      <item>PREDNICA</item>
      <item>PREDPREDSEDNICA</item>
      <item>PREDPREDSEDNIK</item>
      <item>PREDSDEDNIK</item>
      <item>PREDSDENIK</item>
      <item>PREDSDNIK</item>
      <item>PREDSEBNIK</item>
      <item>PREDSECNICA</item>
      <item>PREDSEDDNIK</item>
      <item>PREDSEDEDNIK</item>
      <item>PREDSEDENIK</item>
      <item>PREDSEDICA</item>
      <item>PREDSEDIK</item>
      <item>PREDSEDINK</item>
      <item>PREDSEDN</item>
      <item>PREDSEDNCA</item>
      <item>PREDSEDNDIK</item>
      <item>PREDSEDNI</item>
      <item>PREDSEDNIAC</item>
      <item>PREDSEDNIC</item>
      <item>PREDSEDNICA</item>
      <item>PREDSEDNICA.</item>
      <item>PREDSEDNICA:</item>
      <item>PREDSEDNICa</item>
      <item>PREDSEDNIDK</item>
      <item>PREDSEDNIIK</item>
      <item>PREDSEDNIK</item>
      <item>PREDSEDNIK.</item>
      <item>PREDSEDNIK:</item>
      <item>PREDSEDNIKA</item>
      <item>PREDSEDNIKCA</item>
      <item>PREDSEDNIKDR</item>
      <item>PREDSEDNIKI</item>
      <item>PREDSEDNIKJAKOB</item>
      <item>PREDSEDNIVA</item>
      <item>PREDSEDNIk</item>
      <item>PREDSEDNK</item>
      <item>PREDSEDNKIK</item>
      <item>PREDSEDNNIK</item>
      <item>PREDSEDNUK</item>
      <item>PREDSEDSEDNICA</item>
      <item>PREDSEDSEDNIK</item>
      <item>PREDSEDSEDNIKA</item>
      <item>PREDSEDSENIK</item>
      <item>PREDSEDSNIK</item>
      <item>PREDSEDUJOČA</item>
      <item>PREDSEDUJOČI</item>
      <item>PREDSEDUJOČI:</item>
      <item>PREDSEDUJOČI____________:</item>
      <item>PREDSEEDNIK</item>
      <item>PREDSENDIK</item>
      <item>PREDSENICA</item>
      <item>PREDSENIK</item>
      <item>PREDSESDNIK</item>
      <item>PREEDSEDNICA</item>
      <item>PREEDSEDNIK</item>
      <item>PREESEDNIK</item>
      <item>PRERSEDNIK</item>
      <item>PRESDEDNICA</item>
      <item>PRESDEDNIK</item>
      <item>PRESDSEDNICA</item>
      <item>PRESEDNICA</item>
      <item>PRESEDNIK</item>
      <item>PRESEDNK</item>
      <item>PRESEDSEDNIK</item>
      <item>PREdSEDNIK</item>
      <item>PRFEDSEDNICA</item>
      <item>PRFEDSEDNIK</item>
      <item>PRREDSEDNIK</item>
      <item>PODPREDSEDNIK_____</item>
      <item>PODPREDSEDNIK______</item>
      <item>PODREDSEDNIK</item>
      <item>PRDSEDNIK</item>
      <item>PREDEDNICA</item>
      <item>PREDEDNIK</item>
      <item>PREDESDNIK</item>
      <item>PREDESEDNIK</item>
      <item>PREEDSEDNIK</item>
      <item>PRESDEDNIK</item>
      <item>PRESEDNICA</item>
    </xsl:variable>
    <u>
      <xsl:variable name="whoForSpeaker" select="replace(@who, '#', '')"/>
      <xsl:attribute name="who">
        <xsl:for-each
            select="$listPerson/tei:TEI/tei:text/tei:body/tei:listPerson/tei:person[@xml:id = $whoForSpeaker]">
          <!-- <xsl:message select="concat('Matching speakers:', @xml:id)"/>-->
          <xsl:value-of select="concat('#', @xml:id)"/>

        </xsl:for-each>
      </xsl:attribute>
      <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
      <xsl:variable name="num">
        <xsl:number count="tei:u" level="any"/>
      </xsl:variable>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="concat($document-name-id, '.u', $num)"/>
      </xsl:attribute>
      <xsl:attribute name="ana">
        <xsl:choose>
          <xsl:when test="$speaker = $chair/tei:item">#chair</xsl:when>
          <xsl:otherwise>#regular</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$speaker = $chair/tei:item">
        <xsl:attribute name="ana">#chair</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="pass7"/>
    </u>
  </xsl:template>
  
  <!-- adding missing desc -->
  <xsl:template match="tei:gap[@reason] | tei:incident | tei:kinesic | tei:vocal" mode="pass7">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*" mode="pass7"/>
      <desc>
        <xsl:apply-templates mode="pass7"/>
      </desc>
    </xsl:element>
  </xsl:template>
  
  <!-- handling links to the agenda list -->
  <xsl:template match="@* | node()" mode="pass8">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass8"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- linking list agenda items to tei:seg/@xml:id -->
  <xsl:template match="tei:abstract/tei:list[@type='agenda']/tei:item" mode="pass8">
    <item xml:id="{@xml:id}">
      <xsl:variable name="connection" select="@corresp"/>
      <xsl:variable name="id" select="@xml:id"/>
      <xsl:apply-templates mode="pass8"/>
      <!-- additional ptr elements -->
      <xsl:choose>
        <xsl:when test="string-length($connection) = 0">
          <xsl:for-each select="//tei:seg[@ana = $id]">
            <ptr target="{concat('#',@xml:id)}"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="//tei:seg[@ana = $connection]">
            <ptr target="{concat('#',@xml:id)}"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </item>
  </xsl:template>
  
  <!-- removing temporary @ana attribute -->
  <xsl:template match="tei:seg" mode="pass8">
    <seg xml:id="{@xml:id}">
      <xsl:apply-templates mode="pass8"/>
    </seg>
  </xsl:template>
  
  <xsl:template match="@* | node()" mode="pass9">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass9"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:note" mode="pass9">
    <note>
      <xsl:apply-templates select="@*" mode="pass9"/>
      <xsl:analyze-string select="normalize-space(.)" regex="^(\(|/)(.*)(\)|/)$">
        <xsl:matching-substring>
          <xsl:value-of select="normalize-space(regex-group(2))"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </note>
  </xsl:template>
  <xsl:template match="tei:desc" mode="pass9">
    <desc>
      <xsl:apply-templates select="@*" mode="pass9"/>
      <xsl:analyze-string select="normalize-space(.)" regex="^(\(|/)(.*)(\)|/)$">
        <xsl:matching-substring>
          <xsl:value-of select="normalize-space(regex-group(2))"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </desc>
  </xsl:template>
  
  <xsl:template match="tei:gap[@n]" mode="pass9">
    <gap reason="inaudible"><desc><xsl:value-of select="@n"/></desc></gap>
  </xsl:template>
  
  <!-- Removing agenda items that do not have corresp links -->
  <xsl:template match="tei:abstract/tei:list[@type='agenda']/tei:item[not(tei:ptr)]" mode="pass9">
    <!-- Not processing -->
  </xsl:template>
  <!-- Removing empty agenda items -->
  <xsl:template match="tei:abstract[tei:list[@type='agenda']/tei:item[not(tei:ptr)]][not(tei:list[@type='agenda']/tei:item[2])]" mode="pass9">
    <!-- Not processing -->
  </xsl:template>
  
  <xsl:template match="@* | node()" mode="pass10">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass10"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- moving u/note[@type='speaker'] before u and u/note[@type='time'] for a specific u -->
  <xsl:template match="tei:u" mode="pass10">
    <xsl:apply-templates select="tei:note[@type='speaker']" mode="pass10"/>
    <u>
      <xsl:apply-templates select="@*" mode="pass10"/>
      <xsl:apply-templates select="*[not(self::tei:note[@type='speaker'] or (position() = last() and self::tei:note[@type='time']))]" mode="pass10"/>
    </u>
    <xsl:apply-templates select="*[position() = last()][self::tei:note[@type='time']]" mode="pass10"/>
  </xsl:template>
  
  <xsl:template match="@* | node()" mode="pass11">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="pass11"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:key name="elements" match="*[ancestor-or-self::tei:text]" use="name()"/>
  
  <!-- Counting all elements -->
  <xsl:template match="tei:fileDesc" mode="pass11">
    <fileDesc>
      <xsl:apply-templates mode="pass11"/>
    </fileDesc>
    <encodingDesc>
      <tagsDecl>
        <namespace name="http://www.tei-c.org/ns/1.0">
          <xsl:for-each select="//*[ancestor-or-self::tei:text][count(.|key('elements', name())[1]) = 1]">
            <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
          </xsl:for-each>
        </namespace>
      </tagsDecl>
    </encodingDesc>
  </xsl:template>
  
  
  
</xsl:stylesheet>
