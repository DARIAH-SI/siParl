<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="#all"
		version="2.0">
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Version of the produced corpus -->
  <xsl:param name="edition">3.0a</xsl:param>
  <!-- CLARIN.SI handle of the finished corpus -->
  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1486</xsl:param>
  
  <!-- Povezave to ustreznih taksonomij -->
  <!-- Ni jasno, ali res hočemo tule tako... -->
  <xsl:param name="taxonomy-legislature">taxo-legislature.xml</xsl:param>
  <xsl:param name="taxonomy-speakers">taxo-speakers.xml</xsl:param>
  <xsl:param name="taxonomy-subcorpus">taxo-subcorpus.xml</xsl:param>

  <!-- People (also) responsible for the TEI encoding of the corpus -->
  <xsl:variable name="TEI-resps" xmlns="http://www.tei-c.org/ns/1.0">
    <persName ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823">Tomaž Erjavec</persName>
    <persName>Katja Meden</persName>
  </xsl:variable>
  
  <xsl:variable name="today" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
  <xsl:decimal-format name="slv" decimal-separator="," grouping-separator="."/>

  <!-- The teiHeaders of each term -->
  <xsl:variable name="teiHeaders">
    <xsl:for-each select="mappings/source">
      <xsl:copy-of select="document(.)//tei:teiHeader"/>
    </xsl:for-each>
  </xsl:variable>
  <!-- The filenames of each component, starting with the year directory -->
  <xsl:variable name="components">
    <xsl:for-each select="/mappings/map">
      <component>
	<xsl:copy-of select="replace(target, '.+?/(\d\d\d\d/)', '$1')"/>
      </component>
    </xsl:for-each>
  </xsl:variable>

  <!-- The list of meeting elements giving also the mandates -->
  <xsl:variable name="mandates">
    <xsl:for-each select="$teiHeaders//tei:titleStmt/tei:meeting">
      <xsl:sort select="@n" data-type="number"/>
      <xsl:copy-of select="."/>
    </xsl:for-each>
  </xsl:variable>
  <!-- The number of the first mandate in the corpus -->
  <xsl:variable name="min-mandate" select="$mandates/tei:meeting[1]/@n"/>
  <!-- The number of the last mandate in the corpus -->
  <xsl:variable name="max-mandate" select="$mandates/tei:meeting[last()]/@n"/>
  <!-- The earliest date (element) of a session in the corpus -->
  <xsl:variable name="min-date">
    <xsl:variable name="from-dates">
      <xsl:for-each select="$teiHeaders//tei:sourceDesc/tei:bibl/tei:date">
	<xsl:sort select="@from" data-type="number"/>
	<date xmlns="http://www.tei-c.org/ns/1.0">
	  <xsl:value-of select="replace(@from, 'T.+', '')"/>
	</date>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$from-dates/tei:date[1]"/>
  </xsl:variable>
  <!-- The most recent date (element) of a session in the corpus -->
  <xsl:variable name="max-date">
    <xsl:variable name="to-dates">
      <xsl:for-each select="$teiHeaders//tei:sourceDesc/tei:bibl/tei:date">
	<xsl:sort select="@to" data-type="number"/>
	<xsl:if test="@to">
	  <date xmlns="http://www.tei-c.org/ns/1.0">
	    <xsl:value-of select="replace(@to, 'T.+', '')"/>
	  </date>
	</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$to-dates/tei:date[last()]"/>
  </xsl:variable>
  <!-- A date element with the date span of the corpus, formatted to slv rules -->
  <xsl:variable name="date-range" xmlns="http://www.tei-c.org/ns/1.0">
    <date from="{$min-date}" to="{$max-date}">
      <xsl:value-of select="format-date($min-date, '[D1].[M1].[Y0001]')"/>
      <xsl:text> — </xsl:text>
      <xsl:value-of select="format-date($max-date, '[D1].[M1].[Y0001]')"/>
    </date>
  </xsl:variable>
  
  <!-- Processing -->
  <xsl:template match="/">
    <teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xml:lang="sl" xml:id="ParlaMint-SI">
      <teiHeader>
	<xsl:call-template name="fileDesc"/>
	<xsl:call-template name="encodingDesc"/>
	<xsl:call-template name="profileDesc"/>
      </teiHeader>
      <xsl:for-each select="$components/component">
	<xi:include xmlns:xi="http://www.w3.org/2001/XInclude"
		    href="{.}"/>
      </xsl:for-each>
    </teiCorpus>
  </xsl:template>
  
  <!-- Add <term> -->
  <xsl:template match="tei:taxonomy/tei:desc">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <term>
	<xsl:apply-templates/>
      </term>
    </xsl:copy>
  </xsl:template>
  <!-- Rename and add <term> -->
  <xsl:template match="tei:category/tei:desc">
    <catDesc>
      <xsl:apply-templates select="@*"/>
      <term>
	<xsl:apply-templates/>
      </term>
    </catDesc>
  </xsl:template>
  <!-- Add <term> if missing -->
  <xsl:template match="tei:catDesc">
    <catDesc>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
	<xsl:when test="tei:term">
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	  <term>
	    <xsl:apply-templates/>
	  </term>
	</xsl:otherwise>
      </xsl:choose>
    </catDesc>
  </xsl:template>
  
  <xsl:template match="@xml:id">
    <xsl:attribute name="xml:id">
      <xsl:choose>
	<xsl:when test="starts-with(., 'parl.')">
	  <xsl:value-of select="replace(., '^parl\.', 'parla.')"/>
	</xsl:when>
	<xsl:when test="starts-with(., 'par.')">
	  <xsl:value-of select="replace(., '^par\.', 'parla.')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
 <!-- Copy rest to output -->
 <xsl:template match="tei:*">
   <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <!-- Named templates -->
  <xsl:template name="fileDesc">
    <fileDesc xmlns="http://www.tei-c.org/ns/1.0">
      <titleStmt>
        <title type="main" xml:lang="sl">Slovenski parlamentarni korpus ParlaMint-SI [ParlaMint]</title>
        <title type="main" xml:lang="en">Slovenian parliamentary corpus ParlaMint-SI [ParlaMint]</title>
	<xsl:variable name="min-year" select="replace($min-date, '-.+', '')"/>
	<xsl:variable name="max-year" select="replace($max-date, '-.+', '')"/>
        <title type="sub" xml:lang="sl">
	  <xsl:text>Zapisi sej Državnega zbora Republike Slovenije, </xsl:text>
	  <xsl:value-of select="concat($min-mandate, '.—', $max-mandate, '. mandat ')"/>
	  <xsl:value-of select="concat('(', $min-year, '—', $max-year, ')')"/>
	</title>
        <title type="sub" xml:lang="en">
	  <xsl:text>Minutes of the National Assembly of the Republic of Slovenia, Terms </xsl:text>
	  <xsl:value-of select="concat($min-mandate, '—', $max-mandate, ' ')"/>
	  <xsl:value-of select="concat('(', $min-year, '—', $max-year, ')')"/>
	</title>
	<xsl:copy-of select="$mandates"/>
        <xsl:for-each-group select="$teiHeaders//tei:titleStmt/tei:respStmt"
			    group-by="tei:resp[@xml:lang = 'sl']">
          <respStmt>
	    <xsl:for-each select="distinct-values(current-group()/tei:persName)">
	      <xsl:variable name="this" select="."/>
	      <xsl:copy-of select="$teiHeaders//tei:titleStmt/tei:respStmt/tei:persName[.=$this]
				   [not(preceding::tei:persName[.=$this])]"/>
	    </xsl:for-each>
	    <xsl:if test="current-grouping-key() = 'Kodiranje TEI'">
	      <xsl:copy-of select="$TEI-resps"/>
	    </xsl:if>
	    <xsl:copy-of select="current-group()[1]/tei:resp"/>
          </respStmt>
	</xsl:for-each-group>
        <funder>
          <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
          <orgName xml:lang="en">The CLARIN research infrastructure</orgName>
        </funder>
        <funder>
          <orgName xml:lang="sl">Slovenska raziskovalna infrastruktura CLARIN.SI</orgName>
          <orgName xml:lang="en">The Slovenian research infrastructure CLARIN.SI</orgName>
        </funder>
        <funder>
          <orgName xml:lang="sl">Raziskovalni program ARRS P6-0411 "Jezikovni viri in tehnologije za slovenski jezik"</orgName>
          <orgName xml:lang="en">Slovenian Research Agency Programme P6-0411 "Language Resources and Technologies for Slovene"</orgName>
        </funder>
      </titleStmt>
      <editionStmt>
        <edition>
	  <xsl:value-of select="$edition"/>
	</edition>
      </editionStmt>
      <extent>
	<xsl:variable name="words" select="sum($teiHeaders//tei:fileDesc/tei:extent/
					   tei:measure[@unit='words']/@quantity)"/>
	<!-- Note that ParlaMint expects speeches (and words from .ana) -->
        <!-- measure unit="texts" quantity="{$texts}">
	  <xsl:value-of select="format-number($texts,'###.###', 'slv')"/>
	  <xsl:text> besedil</xsl:text>
	</measure>
        <measure unit="texts" quantity="{$texts}" xml:lang="en">
	  <xsl:value-of select="format-number($texts, '###,###')"/>
	  <xsl:text> texts</xsl:text>
	</measure-->
        <measure unit="words" quantity="{format-number($words, '#')}">
	  <xsl:value-of select="format-number($words, '###.###', 'slv')"/>
	  <xsl:text> besed</xsl:text>
	</measure>
        <measure unit="words" quantity="{format-number($words, '#')}" xml:lang="en">
	  <xsl:value-of select="format-number($words, '###,###')"/>
	  <xsl:text> words</xsl:text>
	</measure>
      </extent>
      <publicationStmt>
        <publisher>
          <orgName xml:lang="sl">Raziskovalna infrastrukutra CLARIN</orgName>
          <orgName xml:lang="en">CLARIN research infrastructure</orgName>
          <ref target="https://www.clarin.eu/">www.clarin.eu</ref>
        </publisher>
        <idno subtype="handle" type="URI">
	  <xsl:value-of select="$clarinHandle"/>
	</idno>
        <availability status="free">
          <licence>http://creativecommons.org/licenses/by/4.0/</licence>
          <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
          <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</ref>.</p>
        </availability>
        <date when="{$today}">
	  <xsl:value-of select="$today"/>
	</date>
      </publicationStmt>
      <sourceDesc>
        <bibl>
          <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
          <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
          <idno type="URI" subtype="parliament">https://www.dz-rs.si</idno>
	  <xsl:copy-of select="$date-range"/>
        </bibl>
      </sourceDesc>
    </fileDesc>
  </xsl:template>
  
  <xsl:template name="encodingDesc">
    <encodingDesc xmlns="http://www.tei-c.org/ns/1.0">
      <projectDesc>
        <p xml:lang="sl">
          <ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref>
        </p>
        <p xml:lang="en">
        <ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref> is a project that aims to (1) create a multilingual set of comparable corpora of parliamentary proceedings uniformly encoded according to the <ref target="https://github.com/clarin-eric/parla-clarin">Parla-CLARIN recommendations</ref> and covering the COVID-19 pandemic from November 2019 as well as the earlier period from 2015 to serve as a reference corpus; (2) process the corpora linguistically to add Universal Dependencies syntactic structures and Named Entity annotation; (3) make the corpora available through concordancers and Parlameter; and (4) build use cases in Political Sciences and Digital Humanities based on the corpus data.</p>
      </projectDesc>
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
      <!-- tagsDecl removed, we need to compute these numbers on the basis of the converted components -->
      <!--  As with the corpus components conversion: tagsDecl is left in as a placeholder, so that validation is successful (replaced after we compute the numbers) -->
      <tagsDecl><!--These numbers do not reflect the size of the sample!-->
        <namespace name="http://www.tei-c.org/ns/1.0">
          <tagUsage gi="body" occurs="0"/>
          <tagUsage gi="desc" occurs="0"/>
          <tagUsage gi="div" occurs="0"/>
          <tagUsage gi="gap" occurs="0"/>
          <tagUsage gi="head" occurs="0"/>
          <tagUsage gi="incident" occurs="0"/>
          <tagUsage gi="kinesic" occurs="0"/>
	</namespace>
      </tagsDecl>
      <classDecl>
	<!-- Not quite clear what to do with taxonomies -->
	<!-- For now take them from siParl teiHeader and process -->
	<xsl:apply-templates select="$teiHeaders/tei:teiHeader[1]//
				     tei:encodingDesc/tei:classDecl/tei:taxonomy"/>
      </classDecl>
    </encodingDesc>
  </xsl:template>
  
  <xsl:template name="profileDesc">
    <profileDesc xmlns="http://www.tei-c.org/ns/1.0">
      <settingDesc>
        <setting>
	  <xsl:copy-of select="$teiHeaders/tei:teiHeader[1]/tei:profileDesc/
			       tei:settingDesc/tei:setting/tei:*[not(self::tei:date)]"/>
	  <xsl:copy-of select="$date-range"/>
	</setting>
      </settingDesc>
      <particDesc>
	<xsl:call-template name="listOrg"/>
	<xsl:call-template name="listPerson"/>
      </particDesc>
      <langUsage>
        <language ident="sl" xml:lang="sl">slovenski</language>
        <language ident="en" xml:lang="sl">angleški</language>
        <language ident="sl" xml:lang="en">Slovenian</language>
        <language ident="en" xml:lang="en">English</language>
      </langUsage>
    </profileDesc>
  </xsl:template>
  
  <xsl:template name="listOrg">
    <listOrg xmlns="http://www.tei-c.org/ns/1.0">
      <!-- Need to collect all organisations here -->
        <org xml:id="DZ" role="parliament" ana="#parla.national #parla.lower">
          <orgName xml:lang="sl" full="yes">Državni zbor Republike Slovenije</orgName>
          <orgName xml:lang="en" full="yes">National Assembly of the Republic of Slovenia</orgName>
          <event from="1992-12-23">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Dr%C5%BEavni_zbor_Republike_Slovenije</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/National_Assembly_(Slovenia)</idno>
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
          <orgName xml:lang="sl" full="yes">Vlada Republike Slovenije</orgName>
          <orgName xml:lang="en" full="yes">Government of the Republic of Slovenia</orgName>
          <event from="1990-05-16">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Vlada_Republike_Slovenije</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Government_of_Slovenia</idno>
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
        <org xml:id="party.PS" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Pozitivna Slovenija</orgName>
          <orgName full="yes" xml:lang="en">Positive Slovenia</orgName>
          <orgName full="abb">PS</orgName>
          <event from="2011-10-22">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Pozitivna_Slovenija</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Positive_Slovenia</idno>
        </org>
        <org xml:id="party.DL" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Državljanska lista</orgName>
          <orgName full="yes" xml:lang="en">Civic List</orgName>
          <orgName full="abb">DL</orgName>
          <event from="2012-04-24">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Dr%C5%BEavljanska_lista</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Civic_List_(Slovenia)</idno>
        </org>
        <org xml:id="party.DeSUS" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Demokratična stranka upokojencev Slovenije</orgName>
          <orgName full="yes" xml:lang="en">Democratic Party of Pensioners of Slovenia</orgName>
          <orgName full="abb">DeSUS</orgName>
          <event from="1991-05-30">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Demokrati%C4%8Dna_stranka_upokojencev_Slovenije</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Democratic_Party_of_Pensioners_of_Slovenia</idno>
        </org>
        <org xml:id="party.Levica.1" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Združena levica</orgName>
          <orgName full="yes" xml:lang="en">United Left</orgName>
          <orgName full="abb">Levica</orgName>
          <event from="2014-03-01" to="2017-06-24">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/United_Left_(Slovenia)</idno>
        </org>
        <org xml:id="party.Levica.2" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Levica</orgName>
          <orgName full="yes" xml:lang="en">The Left</orgName>
          <orgName full="abb">Levica</orgName>
          <event from="2017-06-24">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Levica_(politi%C4%8Dna_stranka)</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/The_Left_(Slovenia)</idno>
        </org>
        <org xml:id="party.LMŠ" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Lista Marjana Šarca</orgName>
          <orgName full="yes" xml:lang="en">The List of Marjan Šarec</orgName>
          <orgName full="abb">LMŠ</orgName>
          <event from="2014-05-31">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Lista_Marjana_%C5%A0arca</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/List_of_Marjan_%C5%A0arec</idno>
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
        <org xml:id="party.NSi" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Nova Slovenija – Krščanski demokrati</orgName>
          <orgName full="yes" xml:lang="en">New Slovenia – Christian Democrats</orgName>
          <orgName full="abb">NSi</orgName>
          <event from="2000-08-04">
                     <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Nova_Slovenija</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/New_Slovenia</idno>
        </org>
        <org xml:id="party.SD" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Socialni demokrati</orgName>
          <orgName full="yes" xml:lang="en">Social Democrats</orgName>
          <orgName full="abb">SD</orgName>
          <event from="2005-04-02">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Socialni_demokrati</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Social_Democrats_(Slovenia)</idno>
        </org>
        <org xml:id="party.SDS.2" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Slovenska demokratska stranka</orgName>
          <orgName full="yes" xml:lang="en">Slovenian Democratic Party</orgName>
          <orgName full="abb">SDS</orgName>
          <event from="2003-09-19">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Slovenska_demokratska_stranka</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Slovenian_Democratic_Party</idno>
        </org>
        <org xml:id="party.SMC.1" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Stranka Mira Cerarja</orgName>
          <orgName full="yes" xml:lang="en">Party of Miro Cerar</orgName>
          <orgName full="abb">SMC</orgName>
          <event from="2014-06-02" to="2015-03-07">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
        </org>
        <org xml:id="party.SMC.2" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Stranka modernega centra</orgName>
          <orgName full="yes" xml:lang="en">Modern Centre Party</orgName>
          <orgName full="abb">SMC</orgName>
          <event from="2015-03-07">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_modernega_centra</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Modern_Centre_Party</idno>
        </org>
        <org xml:id="party.SNS" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Slovenska nacionalna stranka</orgName>
          <orgName full="yes" xml:lang="en">Slovenian National Party</orgName>
          <orgName full="abb">SNS</orgName>
          <event from="1991-03-17">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Slovenska_nacionalna_stranka</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Slovenian_National_Party</idno>
        </org>
        <org xml:id="party.ZaAB" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Zavezništvo Alenke Bratušek</orgName>
          <orgName full="yes" xml:lang="en">Alliance of Alenka Bratušek</orgName>
          <orgName full="abb">ZaAB</orgName>
          <event from="2014-05-31" to="2016-05-21">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
        </org>
        <org xml:id="party.ZaSLD" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Zavezništvo socialno-liberalnih demokratov</orgName>
          <orgName full="yes" xml:lang="en">Alliance of Social Liberal Democrats</orgName>
          <event from="2016-05-21" to="2017-10-07">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
        </org>
        <org xml:id="party.SAB" role="parliamentaryGroup">
          <orgName full="yes" xml:lang="sl">Stranka Alenke Bratušek</orgName>
          <orgName full="yes" xml:lang="en">Party of Alenka Bratušek</orgName>
          <orgName full="abb">SAB</orgName>
          <event from="2017-10-07">
            <label xml:lang="en">existence</label>
          </event>
          <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Stranka_Alenke_Bratu%C5%A1ek</idno>
          <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek</idno>
        </org>
        <listRelation>
          <relation name="renaming"
                    active="#party.SMC.2"
                    passive="#party.SMC.1"
                    when="2015-03-07"/>
          <relation name="successor"
                    active="#party.Levica.2"
                    passive="#party.Levica.1"
                    when="2017-06-24"/>
          <relation name="renaming"
                    active="#party.ZaSLD"
                    passive="#party.ZaAB"
                    when="2016-05-21"/>
          <relation name="renaming"
                    active="#party.SAB"
                    passive="#party.ZaSLD"
                    when="2017-10-07"/>
          <relation name="coalition"
                    mutual="#party.SMC.1 #party.DeSUS #party.SD"
                    from="2014-09-18"
                    to="2018-03-14"
                    ana="#DZ.7"/>
          <relation name="opposition"
                    active="#party.SDS.2 #party.NSi #party.ZaAB #party.Levica.1"
                    passive="#GOV"
                    from="2014-09-18"
                    to="2018-03-14"
                    ana="#DZ.7"/>
          <relation name="coalition"
                    mutual="#party.LMŠ #party.SD #party.SMC.2 #party.SAB #party.DeSUS"
                    from="2018-09-13"
                    to="2020-01-29"
                    ana="#DZ.8"/>
          <relation name="opposition"
                    active="#party.SDS.2 #party.SNS #party.NSi #party.Levica.2"
                    passive="#GOV"
                    from="2018-09-13"
                    to="2020-01-29"
                    ana="#DZ.8"/>
          <relation name="coalition"
                    mutual="#party.SDS.2 #party.SMC.2 #party.NSi #party.DeSUS"
                    from="2020-03-13"
                    to="2020-12-17"
                    ana="#DZ.8"/>
          <relation name="opposition"
                    active="#party.LMŠ #party.SD #party.SAB #party.Levica.2"
                    passive="#GOV"
                    from="2020-03-13"
                    to="2020-12-17"
                    ana="#DZ.8"/>
          <relation name="coalition"
                    mutual="#party.SDS.2 #party.SMC.2 #party.NSi"
                    from="2020-12-18"
                    ana="#DZ.8"/>
          <relation name="opposition"
                    active="#party.DeSUS #party.LMŠ #party.SD #party.SMC.2 #party.SAB #party.Levica.2"
                    passive="#GOV"
                    from="2020-12-18"
                    ana="#DZ.8"/>
        </listRelation>
      </listOrg>
  </xsl:template>
  
  <xsl:template name="listPerson">
    <listPerson xmlns="http://www.tei-c.org/ns/1.0">
      <!-- Need to collect all persons here -->
    </listPerson>
  </xsl:template>
</xsl:stylesheet>
