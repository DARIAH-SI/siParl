<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:et="http://nl.ijs.si/et" 
		xmlns="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="#all"
		version="2.0">
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Version of the produced corpus -->
  <xsl:param name="edition">3.0</xsl:param>
  <!-- CLARIN.SI handle of the finished corpus -->
  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1486</xsl:param>
  <!-- Ignore parties older than this date-->
  <xsl:param name="cutoffDate">2000-00-00</xsl:param>
  <xsl:param name="cutoffDate2">2015-00-00</xsl:param>

  <!-- Povezave to ustreznih taksonomij -->
  <!-- Ni jasno, ali res hočemo tule tako... -->
  <xsl:param name="taxonomy-legislature">taxo-legislature.xml</xsl:param>
  <xsl:param name="taxonomy-speakers">taxo-speakers.xml</xsl:param>
  <xsl:param name="taxonomy-subcorpus">taxo-subcorpus.xml</xsl:param>

  <!-- People (also) responsible for the TEI encoding of the corpus -->
  <xsl:variable name="TEI-resps" xmlns="http://www.tei-c.org/ns/1.0">
    <persName ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823">Tomaž Erjavec</persName>
    <persName ref="https://orcid.org/0000-0002-0464-9240">Katja Meden</persName>
  </xsl:variable>
  
  <xsl:variable name="today" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
  <xsl:decimal-format name="slv" decimal-separator="," grouping-separator="."/>

  <!-- The teiHeaders of each term -->
  <xsl:variable name="teiHeaders">
    <xsl:for-each select="mappings/source">
      <xsl:copy-of select="document(.)//tei:teiHeader" copy-namespaces="no"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="utterances">
    <xsl:for-each select="mappings//map/target">
      <xsl:copy-of select="document(.)//tei:teiHeader" copy-namespaces="no"/>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- The filenames of each component, starting with the year directory -->
  <xsl:variable name="components">
    <xsl:for-each select="mappings//map">
      <xsl:element name="target">
	<xsl:value-of select="replace(target, '.+?/(\d\d\d\d/)', '$1')"/>
      </xsl:element>
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
    <teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xml:lang="sl" xml:id="ParlaMint-SI.ana">
      <teiHeader>
	<xsl:call-template name="fileDesc"/>
	<xsl:call-template name="encodingDesc"/>
	<xsl:call-template name="profileDesc"/>
	<xsl:call-template name="revisionDesc"/>
      </teiHeader>
      <xsl:for-each select="$components/tei:target">
	   <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="{.}"/>
      </xsl:for-each>
    </teiCorpus>
  </xsl:template>
  
  <!-- Add <term> -->
  <xsl:template match="tei:taxonomy[not(@xml:id='NER' or @xml:id='UD-SYN')]/tei:desc">
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
  

  <!--Replace xml:id attribute values from parl. to parla. -->
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
	  <xsl:value-of select="concat('od ', $min-mandate, '. do ', $max-mandate, '. mandata ')"/>
	  <xsl:value-of select="concat('(', $min-year, ' — ', $max-year, ')')"/>
	</title>
        <title type="sub" xml:lang="en">
	  <xsl:text>Minutes of the National Assembly of the Republic of Slovenia, Terms </xsl:text>
	  <xsl:value-of select="concat($min-mandate, ' and ', $max-mandate, ' ')"/>
	  <xsl:value-of select="concat('(', $min-year, ' — ', $max-year, ')')"/>
	</title>
	<xsl:for-each select="$mandates/tei:meeting">
	  <meeting>
	    <xsl:attribute name="n">
	      <xsl:copy-of select="@n"/>
	    </xsl:attribute>
	    <xsl:attribute name="corresp">
	      <xsl:copy-of select="@corresp"/>
	    </xsl:attribute>
	    <xsl:attribute name="ana">
	      <xsl:value-of select="replace(@ana, '#parl\.', '#parla.')"/>
	      <xsl:value-of select="concat('&#32;', '#parla.lower')"/>
	    </xsl:attribute>
	    <xsl:value-of select="."/>
	  </meeting>
	</xsl:for-each>
	  <respStmt>
	    <persName ref="https://orcid.org/0000-0002-0464-9240">Katja Meden</persName>
	    <persName ref="https://orcid.org/0000-0002-1560-4099 http://viaf.org/viaf/15145066459666591823">Tomaž Erjavec</persName>
            <persName ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424">Andrej Pančur</persName>
            <resp xml:lang="sl">Kodiranje TEI</resp>
            <resp xml:lang="en">TEI corpus encoding</resp>
          </respStmt>
	<respStmt>
          <persName ref="https://orcid.org/0000-0001-6143-6877 http://viaf.org/viaf/305936424">Andrej Pančur</persName>
          <persName ref="http://viaf.org/viaf/86154440112735340300">Mihael Ojsteršek</persName>
          <resp xml:lang="sl">Urejanje seznama govornikov</resp>
          <resp xml:lang="en">Editing a list of speakers</resp>
        </respStmt>
	<respStmt>
          <persName ref="http://viaf.org/viaf/305748135">Nikola Ljubešić</persName>
          <resp xml:lang="sl">Jezikoslovno označevanje</resp>
          <resp xml:lang="en">Linguistic annotation</resp>
        </respStmt>
        <respStmt>
          <persName ref="http://viaf.org/viaf/15145066459666591823">Tomaž Erjavec</persName>
          <resp xml:lang="sl">Popravki strukture TEI</resp>
          <resp xml:lang="en">TEI encoding corrections</resp>
        </respStmt>
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
	<!-- for the words count: the value is a sum from SDZ7 + SD8 word count; this value is therefore the word count of the entire corpus-->
	<!--These numbers do not reflect the size of the sample!-->
	<xsl:variable name="words" select="sum($teiHeaders//tei:fileDesc/tei:extent/
					   tei:measure[@unit='words']/@quantity)"/>
	<xsl:variable name="texts" select="sum($teiHeaders//tei:fileDesc/tei:extent/
					   tei:measure[@unit='texts']/@quantity)"/>
	<xsl:variable name="speeches" select="sum($utterances//tei:fileDesc/tei:extent/tei:measure[@unit='speeches']/@quantity)"/>
	<measure unit="words" quantity="{format-number($words, '#')}" xml:lang="sl">
	  <xsl:value-of select="format-number($words, '###.###', 'slv')"/>
	  <xsl:text> besed</xsl:text>
	</measure>
	<measure unit="words" quantity="{format-number($words, '#')}" xml:lang="en">
	  <xsl:value-of select="format-number($words, '###,###')"/>
	  <xsl:text> words</xsl:text>
	</measure>
	<measure unit="speeches" quantity="{format-number($speeches, '#')}" xml:lang="sl">
	  <xsl:value-of select="format-number($speeches, '###.###', 'slv')"/>
	  <xsl:text> govorov</xsl:text>
	</measure>
	<measure unit="speeches" quantity="{format-number($speeches, '#')}" xml:lang="en">
	  <xsl:value-of select="format-number($speeches, '###,###')"/>
	  <xsl:text> speeches</xsl:text>
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
      <tagsDecl><!--These numbers do not reflect the size of the sample!-->
        <namespace name="http://www.tei-c.org/ns/1.0">
          <tagUsage gi="text" occurs="0"/>
          <tagUsage gi="body" occurs="0"/>
          <tagUsage gi="div" occurs="0"/>
          <tagUsage gi="note" occurs="0"/>
          <tagUsage gi="pb" occurs="0"/>
          <tagUsage gi="u" occurs="0"/>
          <tagUsage gi="seg" occurs="0"/>
          <tagUsage gi="kinesic" occurs="0"/>
          <tagUsage gi="vocal" occurs="0"/>
          <tagUsage gi="incident" occurs="0"/>
          <tagUsage gi="gap" occurs="0"/>
          <tagUsage gi="desc" occurs="0"/>
          <tagUsage gi="s" occurs="0"/>
          <tagUsage gi="name" occurs="0"/>
          <tagUsage gi="time" occurs="0"/>
          <tagUsage gi="date" occurs="0"/>
          <tagUsage gi="unit" occurs="0"/>
          <tagUsage gi="num" occurs="0"/>
          <tagUsage gi="email" occurs="0"/>
          <tagUsage gi="ref" occurs="0"/>
          <tagUsage gi="w" occurs="0"/>
          <tagUsage gi="pc" occurs="0"/>
          <tagUsage gi="linkGrp" occurs="0"/>
          <tagUsage gi="link" occurs="0"/>
        </namespace>
      </tagsDecl>
      <classDecl>
	<xsl:apply-templates select="$teiHeaders/tei:teiHeader[1]//
				     tei:encodingDesc/tei:classDecl/tei:taxonomy"/>
	<taxonomy xml:id="subcorpus">
          <desc xml:lang="sl">
            <term>Podkorpusi</term>
          </desc>
          <desc xml:lang="en">
            <term>Subcorpora</term>
          </desc>
          <category xml:id="reference">
            <catDesc xml:lang="sl">
            <term>Referenca</term>: referenčni podkorpus, do 2019-10-31</catDesc>
            <catDesc xml:lang="en">
            <term>Reference</term>: reference subcorpus, until 2019-10-31</catDesc>
          </category>
          <category xml:id="covid">
            <catDesc xml:lang="sl">
            <term>COVID</term>: COVID podkorpus, od 2019-11-01 dalje</catDesc>
            <catDesc xml:lang="en">
            <term>COVID</term>: COVID subcorpus, from 2019-11-01 onwards</catDesc>
          </category>
        </taxonomy>
      </classDecl>
      <listPrefixDef>
        <prefixDef ident="mte" matchPattern="(.+)" replacementPattern="http://nl.ijs.si/ME/V6/msd/tables/msd-fslib-sl.xml#$1">
          <p xml:lang="en">Private URIs with this prefix point to feature-structure elements defining the Slovenian MULTEXT-East Version 6 MSDs.</p>
        </prefixDef>
        <prefixDef ident="ud-syn" matchPattern="(.+)" replacementPattern="#$1">
          <p xml:lang="en">Private URIs with this prefix point to elements giving their name. In this document they are simply local references into the UD-SYN taxonomy categories in the corpus root TEI header.</p>
        </prefixDef>
      </listPrefixDef>
      <appInfo>
        <application version="1.0" ident="reldi-tokeniser">
          <label>ReLDI tokeniser</label>
          <desc xml:lang="en">Tokenisation and sentence segmentation with ReLDI tokeniser, available from <ref target="https://github.com/clarinsi/reldi-tokeniser">https://github.com/clarinsi/reldi-tokeniser</ref>.</desc>
        </application>
        <application version="1.0" ident="classla-stanfordnlp">
          <label>CLASSLA-StanfordNLP</label>
          <desc xml:lang="en">MSD tagging and lemmatisation with CLASSLA-StanfordNLP trained for Slovene, available from <ref target="https://github.com/clarinsi/classla-stanfordnlp">https://github.com/clarinsi/classla-stanfordnlp</ref>.</desc>
        </application>
        <application version="1.0" ident="janes-ner">
          <label>NER system for South Slavic languages</label>
          <desc xml:lang="en">Named entity recognition done with the Janes NER program, trained for Slovene and available at <ref target="https://github.com/clarinsi/janes-ner">https://github.com/clarinsi/janes-ner</ref>.</desc>
        </application>
      </appInfo>
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

  <!--listOrg templates-->
  
  <xsl:template name="listOrg">
    <listOrg xmlns="http://www.tei-c.org/ns/1.0">
      <!-- Need to collect all unique organisations here -->
      <xsl:apply-templates mode="unique" select="$teiHeaders//tei:org"/>
      <listRelation>
	<xsl:apply-templates select="$teiHeaders/tei:teiHeader[1]//tei:listRelation[1]//tei:relation" mode="relations"/>
	<relation name="renaming" active="#party.SMC.2" passive="#party.SMC.1"
                  when="2015-03-07"/>
	<relation name="successor" active="#party.Levica.2" passive="#party.Levica.1"
                  when="2017-06-24"/>
	<relation name="renaming" active="#party.ZaSLD" passive="#party.ZaAB"
                  when="2016-05-21"/>
	<relation name="renaming" active="#party.SAB" passive="#party.ZaSLD"
                  when="2017-10-07"/>
	<relation name="renaming" active="#party.Konkretno" passive="#party.SMC.2 #party.GAS" when="2021-12-04"/>
	<relation name="coalition"
                  mutual="#party.SMC.1 #party.SMC.2 #party.SD #party.DeSUS" from="2014-09-18"
                  to="2018-09-12" ana="#GOV.12"/>
	<relation name="opposition" active="#party.SDS.2 #party.IMNS #party.ZaAB #party.NeP #party.NP #party.NSi #party.Levica.1 #party.Levica.2" passive="#GOV" from="2014-09-18" to="2018-09-12" ana="#GOV.12"/>
	<relation name="coalition" mutual="#party.LMŠ #party.SMC.2 #party.SD #party.SAB #party.DeSUS" from="2018-09-13" to="2020-03-12" ana="#GOV.13"/>
	<relation name="opposition" active="#party.SDS.2 #party.Levica.2 #party.NSi #party.NeP #party.NP #party.IMNS #party.SNS" passive="#GOV" from="2018-09-13" to="2020-03-12" ana="#GOV.13"/>
	<relation name="coalition" mutual="#party.SDS.2 #party.SMC.2 #party.Konkretno #party.NSi #party.DeSUS" from="2020-03-13" to="2022-06-01" ana="#GOV.14"/>
	<relation name="opposition" active="#party.LMŠ #party.SD #party.SAB #party.Levica.2 #party.NeP #party.NP #party.IMNS #party.SNS" passive="#GOV" from="2020-03-13" to="2022-06-01" ana="#GOV.14"/>
      </listRelation>
    </listOrg>
  </xsl:template>

  <xsl:template match="tei:listRelation//tei:relation">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:listRelation//tei:relation" mode="relations">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="when" select="@when"/>
    <xsl:variable name="to" select="@to"/>
    <xsl:if test="$when &gt; $cutoffDate and $when &lt; $cutoffDate2 or $name = 'coalition' and $to &lt; $cutoffDate2 and $to &gt; $cutoffDate">
      <xsl:apply-templates select="."/>
    </xsl:if>
  </xsl:template>

    <xsl:template match="tei:org" mode="unique">
    <xsl:variable name="id" select="@xml:id"/>
    <xsl:variable name="to" select="tei:event[tei:label = 'existence']/@to"/>
    <xsl:if test="not(preceding::tei:org[@xml:id = $id]) and 
		  (not($to) or $to &gt; $cutoffDate)">
      <xsl:apply-templates select="."/>
    </xsl:if>
  </xsl:template>

  <!-- Add <full> if required:-->
  <xsl:template match="tei:particDesc/tei:listOrg//tei:orgName[not(@full)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="full">
	<xsl:choose>
	  <xsl:when test="@xml:lang">
	    <xsl:text>yes</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>abb</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

    <!--Change value of existing @full attribute to either "yes" or "abb"--> 
  <xsl:template match="tei:particDesc/tei:listOrg//tei:orgName[@full]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="full">
	<xsl:choose>
	  <xsl:when test="@xml:lang">
	    <xsl:text>yes</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>abb</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--Remove Chambers from the listOrg -->
  <xsl:template match="tei:particDesc//tei:listOrg[@xml:id = 'chambers']"/>
  <xsl:template match="tei:particDesc//tei:org[@ana = '#par.chamber']"/>
 
  
  <!-- Change value of @role to new, valid ones-->
  <xsl:template match="tei:particDesc//tei:listOrg//tei:org">
    <xsl:variable name="id" select="@xml:id"/>
    <xsl:variable name="role" select="@role"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="xml:id" select="$id"/>
      <xsl:attribute name="role">
	<xsl:choose>
	  <xsl:when test="@xml:id='DZ'">
	    <xsl:text>parliament</xsl:text>
	  </xsl:when>
	  <xsl:when test="@xml:id='GOV'">
	    <xsl:text>government</xsl:text>
	  </xsl:when>
	  <xsl:when test="matches(@xml:id, '^party\.(?!IMNS)', ';j' )">
	    <xsl:text>parliamentaryGroup</xsl:text>
	  </xsl:when>
	  <xsl:when test="@xml:id='party.IMNS'">
	    <xsl:text>ethnicCommunity</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@role"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

    <xsl:template match="tei:org[@xml:id = 'party.SDZ-NDS']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.DS']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.DLGV']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.Lipa']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.LS']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.SKD']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.SND']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.ZS']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.SOPS']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.Zares.1']" mode="unique"/>
  <xsl:template match="tei:org[@xml:id = 'party.Zares.2']" mode="unique"/>
  
  <xsl:template match="tei:listOrg//tei:org[not(@xml:id='DZ')]//tei:idno">
    <xsl:variable name="lang" select="@xml:lang"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="type">
	<xsl:text>URI</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="subtype">
	<xsl:text>wikimedia</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="$lang"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:listOrg//tei:org[@xml:id='DZ']//tei:idno">
    <idno type="URI" xml:lang="sl" subtype="wikimedia">https://sl.wikipedia.org/wiki/Dr%C5%BEavni_zbor_Republike_Slovenije</idno>
    <idno type="URI" xml:lang="en" subtype="wikimedia">https://en.wikipedia.org/wiki/National_Assembly_(Slovenia)</idno>
  </xsl:template>
  
  <xsl:template match="tei:listOrg//tei:org[@xml:id='DZ']//tei:listEvent">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

    <!-- listPerson templates -->
  
  <xsl:template name="listPerson">
    <listPerson xmlns="http://www.tei-c.org/ns/1.0">
      <head xml:lang="sl">Seznam govornikov</head>
      <head xml:lang="en">List of speakers</head>
      <xsl:apply-templates select="$teiHeaders//tei:person"/>
    </listPerson>
  </xsl:template>
  
  <!-- Add all unique non-anonymous speakers -->
  <xsl:template match="tei:person[contains(@xml:id, 'unknown')]"/>
  <xsl:template match="tei:person">
    <xsl:variable name="id" select="@xml:id"/>
    <xsl:if test="not(preceding::tei:person[@xml:id = $id])">
      <xsl:copy>
	<xsl:apply-templates select="@*"/>
	<xsl:apply-templates select="tei:*[not(self::tei:affiliation)]"/>
	<xsl:apply-templates select="tei:*[self::tei:affiliation]"/>
	<xsl:choose>
	  <xsl:when test="$id='PočivalšekZdravko'">
	    <affiliation role="member" ref="#GOV" from="2014-12-04" to="2022-06-01">
              <roleName>Member</roleName>
            </affiliation>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="gov-member-affiliations">
	      <xsl:apply-templates select="tei:affiliation[@ref='#GOV']" mode="member"/>
	    </xsl:variable>
	    <!--xsl:copy-of select="$gov-member-affiliations"/-->
	    <xsl:apply-templates select="$gov-member-affiliations" mode="uniq"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:affiliation" mode="member">
    <xsl:call-template name="member">
      <xsl:with-param name="this" select="."/>
      <xsl:with-param name="siblings" select="../tei:affiliation[@ref='#GOV']"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:affiliation" mode="uniq">
    <xsl:variable name="from" select="@from"/>
    <xsl:variable name="to" select="@to"/>
    <xsl:if test="not(following::tei:affiliation[@from = $from and @to = $to])">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="member">
    <xsl:param name="this"/>
    <xsl:param name="siblings"/>
    <xsl:param name="from" select="$this/@from"/>
    <xsl:param name="to" select="$this/@to"/>
    <xsl:variable name="first" select="$siblings[1]"/>
    <xsl:variable name="rest" select="$siblings[position() &gt; 1]"/>
    <xsl:message select="concat('INFO: from = ', $from, ' to = ', $to)"/>
    <xsl:choose>
      <xsl:when test="not($siblings/self::tei:affiliation)">
	<xsl:message select="concat('MEMBER: Applying member affiliation: ', $from, ' -- ', $to)"/>
	<affiliation role="member" ref="#GOV" from="{$from}" to="{$to}">
	  <roleName>Member</roleName>
	</affiliation>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="from2" select="$first/@from" as="xs:date"/>
	<xsl:variable name="to2" select="$first/@to" as="xs:date"/>
	<xsl:message select="concat('INFO: ',
			     ' from = ', $from, ' to = ', $to, 
			     ' from2 = ', $from2, ' to2 = ', $to2
			     )"/>
	<xsl:choose>
	  <!-- Identical terms -->
	  <xsl:when test="$from2 = $from and $to2 = $to">
	    <xsl:call-template name="member">
	      <xsl:with-param name="this" select="$this"/>
	      <xsl:with-param name="from" select="$from"/>
	      <xsl:with-param name="to" select="$to"/>
	      <xsl:with-param name="siblings" select="$rest"/>
	    </xsl:call-template>
	  </xsl:when>
	  <!-- Outside the scope; both lower than from-->
	  <xsl:when test="$from2 &lt; $from and $to2 &lt; $from">
	    <xsl:call-template name="member">
	      <xsl:with-param name="this" select="$this"/>
	      <xsl:with-param name="from" select="$from"/>
	      <xsl:with-param name="to" select="$to"/>
	      <xsl:with-param name="siblings" select="$rest"/>
	    </xsl:call-template>
	  </xsl:when>
	  <!-- Outside the scope: both greater than to -->
	  <xsl:when test="$from2 &gt; $to and $to2 &gt; $to">
	    <xsl:call-template name="member">
	      <xsl:with-param name="this" select="$this"/>
	      <xsl:with-param name="siblings" select="$rest"/>
	    </xsl:call-template>
	  </xsl:when>
	  <!-- Inside the term, ignore -->
	  <xsl:when test="$from2 &gt;= $from and $to2 &lt;= $to">
	    <xsl:call-template name="member">
	      <xsl:with-param name="this" select="$this"/>
	      <xsl:with-param name="from" select="$from"/>
	      <xsl:with-param name="to" select="$to"/>
	      <xsl:with-param name="siblings" select="$rest"/>
	    </xsl:call-template>
	  </xsl:when>
	  <!-- Longer than the term, output nothing! -->
	  <xsl:when test="$from2 &lt;= $from and $to2 &gt;= $to"/>
	  <!-- Overlap left, adjust date-->
	  <xsl:when test="$from2 &lt;  $from and $to2 &lt;= $to">
	    <xsl:call-template name="member">
	      <xsl:with-param name="this" select="$this"/>
	      <xsl:with-param name="from" select="$from2"/>
	      <xsl:with-param name="to" select="$to"/>
	      <xsl:with-param name="siblings" select="$rest"/>
	    </xsl:call-template>
	  </xsl:when>
	  <!-- Overlap right, output nothing! -->
	  <xsl:when test="$from2 &gt;=  $from and $to2 &gt; $to"/>
	  <xsl:otherwise>
	    <xsl:message select="concat('ERROR: weird interval ',
				 ' from = ', $from, ' to = ', $to, 
				 ' from2 = ', $from2, ' to2 = ', $to2
				 )"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <xsl:template match="tei:listPerson//tei:person//tei:idno">
    <xsl:variable name="lang" select="@xml:lang"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="type">
	<xsl:text>URI</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="subtype">
	<xsl:text>wikimedia</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="$lang"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!---Change value of attribute "role" of speakers to valid ones and add roleName -->
  <xsl:template match="tei:particDesc//tei:person//tei:affiliation">
    <xsl:variable name="role" select="@role"/>
    <xsl:variable name="ref" select="@ref"/>
    <xsl:variable name="from" select="@from"/>
    <xsl:variable name="to" select="@to"/>
    <xsl:variable name="ana" select="@ana"/>
    <xsl:variable name="person_id" select="../@xml:id"/>
    <xsl:choose>
      <xsl:when test="$to &lt; $cutoffDate"/>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:apply-templates select="@*"/>
	  <xsl:attribute name="role">
	    <xsl:choose>
	      <xsl:when test="matches(@role,'^MP')">
		<xsl:text>member</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@role"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	  <roleName xml:lang="en">
	    <xsl:choose>
	      <xsl:when test="@ref = '#DZ'">
		<xsl:text>MP</xsl:text>
	      </xsl:when>
	      <xsl:when test="@role = 'deputyHead'">
		<xsl:text>Vice Chairman</xsl:text>
	      </xsl:when>
	      <xsl:when test="@role = 'minister'">
		<xsl:text>Minister</xsl:text>
	      </xsl:when>
	      <xsl:when test="@role = 'member'">
		<xsl:text>Member</xsl:text>
	      </xsl:when>
	      <xsl:when test="@role = 'head' and @ref= '#GOV'">
		<xsl:text>Prime Minister</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:message select="concat('Warning: Setting roleName to member for role ', @role,
				     ' for person ID: ', $person_id)"/>
		<xsl:text>Member</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </roleName>
	  <xsl:apply-templates/>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:person[@xml:id='LampeAlenka']//tei:birth">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:text/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:person[@xml:id='MurgelJasna']//tei:roleName/@type"/>
  
  <!-- Is the first date between the following two? -->
  <xsl:function name="et:between-dates" as="xs:boolean">
    <xsl:param name="date" as="xs:string"/>
    <xsl:param name="from" as="xs:string?"/>
    <xsl:param name="to" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="not(normalize-space($from) or normalize-space($to))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="normalize-space($from) and normalize-space($to) and
                      xs:date(et:pad-date($date)) &gt;= xs:date(et:pad-date($from)) and
                      xs:date(et:pad-date($date)) &lt;= xs:date(et:pad-date($to))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="not(normalize-space($from)) and normalize-space($to) and
                      xs:date(et:pad-date($date)) &lt;= xs:date(et:pad-date($to))" >
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="normalize-space($from) and not(normalize-space($to)) and 
                      xs:date(et:pad-date($date)) &gt;= xs:date(et:pad-date($from))" >
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Fix too long or too short dates 
       a la "2013-10-26T14:00:00" or "2018" to xs:date e.g. 2018-01-01 -->
  <xsl:function name="et:pad-date">
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="matches($date, '^\d\d\d\d-\d\d-\d\dT.+$')">
        <xsl:value-of select="substring-before($date, 'T')"/>
      </xsl:when>
      <xsl:when test="matches($date, '^\d\d\d\d-\d\d-\d\d$')">
        <xsl:value-of select="$date"/>
      </xsl:when>
      <xsl:when test="matches($date, '^\d\d\d\d-\d\d$')">
        <xsl:message>
          <xsl:text>WARN: short date </xsl:text>
          <xsl:value-of select="$date"/>
        </xsl:message>
        <xsl:value-of select="concat($date, '-01')"/>
      </xsl:when>
      <xsl:when test="matches($date, '^\d\d\d\d$')">
        <!--xsl:message>
          <xsl:text>WARN: short date </xsl:text>
          <xsl:value-of select="$date"/>
        </xsl:message-->
        <xsl:value-of select="concat($date, '-01-01')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>ERROR: bad date </xsl:text>
          <xsl:value-of select="$date"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <xsl:template name="revisionDesc">
    <revisionDesc>
      <change when="2023-01-11">
      <name>Katja Meden</name>: Made ana sample</change>
      <change when="2023-01-10">
      <name>Tomaž Erjavec</name>: Small fixes of ParlaMint data</change>
    </revisionDesc>
  </xsl:template>

  
</xsl:stylesheet>
