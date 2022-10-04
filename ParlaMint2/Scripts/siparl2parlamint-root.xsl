<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="#all"
		version="2.0">
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Version of the produced corpus -->
  <xsl:param name="edition">3.0a</xsl:param>
  <!-- CLARIN.SI handle of the finished corpus -->
  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1486</xsl:param>
  <!-- Ignore parties older than this date-->
  <xsl:param name="cutoffDate">1995-00-00</xsl:param>

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
    <teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xml:lang="sl" xml:id="ParlaMint-SI">
      <teiHeader>
	<xsl:call-template name="fileDesc"/>
	<xsl:call-template name="encodingDesc"/>
	<xsl:call-template name="profileDesc"/>
      </teiHeader>
      <xsl:for-each select="$components/tei:target">
	   <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="{.}"/>
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
	  <xsl:value-of select="concat($min-mandate, '. in ', $max-mandate, '. mandat ')"/>
	  <xsl:value-of select="concat('(', $min-year, ' — ', $max-year, ')')"/>
	</title>
        <title type="sub" xml:lang="en">
	  <xsl:text>Minutes of the National Assembly of the Republic of Slovenia, Terms </xsl:text>
	  <xsl:value-of select="concat($min-mandate, ' and ', $max-mandate, ' ')"/>
	  <xsl:value-of select="concat('(', $min-year, ' — ', $max-year, ')')"/>
	</title>
	<xsl:for-each select="$mandates/tei:meeting">
	  <xsl:variable name="ana" select="@ana"/>
	  <meeting>
	    <xsl:attribute name="n">
	      <xsl:copy-of select="@n"/>
	    </xsl:attribute>
	    <xsl:attribute name="corresp">
	      <xsl:copy-of select="@corresp"/>
	    </xsl:attribute>
	    <xsl:attribute name="ana">
	      <xsl:value-of select="concat($ana,' ', '#parla.lower')"/>
	    </xsl:attribute>
	    <xsl:value-of select="."/>
	  </meeting>
	</xsl:for-each>
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
      <!-- Need to collect all unique organisations here -->
      <xsl:apply-templates mode="unique" select="$teiHeaders//tei:org"/>
    </listOrg>
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

  <xsl:template match="tei:particDesc//tei:listOrg[@xml:id = 'chambers']"/>
  <xsl:template match="tei:particDesc//tei:org[@ana = '#par.chamber']"/>

  <!-- Change value of @role to new, valid ones-->
  <xsl:template match="tei:particDesc//tei:org[@role]">
   <!-- Need to add conditions for ethnicCommunities value-->
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
            <xsl:attribute name="role">
	<xsl:choose>
	  <xsl:when test="matches(@xml:id,'^party\.' )">
	    <xsl:text>parliamentaryGroup</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@role"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
 

  
  <xsl:template name="listPerson">
    <listPerson xmlns="http://www.tei-c.org/ns/1.0">
      <head xml:lang="sl">Seznam govornikov</head>
      <head xml:lang="en">List of speakers</head>
      <!--Add all unique speakers-->
      <xsl:apply-templates select="$teiHeaders//tei:person[not(.=preceding::*)]"/>
    </listPerson>
  </xsl:template>

  <xsl:template match="tei:listPerson//tei:person//tei:idno">
    <xsl:variable name="lang" select="@xml:lang"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="type">
	<xsl:text>URI</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="$lang"/>
      </xsl:attribute>
      <xsl:attribute name="subtype">
	<xsl:text>wikimedia</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <!---Change value of attribute "role" of speakers to valid ones and add roleName -->
  <xsl:template match="tei:particDesc//tei:person//tei:affiliation">
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
	  <xsl:otherwise>
	    <xsl:text>Member</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </roleName>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

       <!-- roleName note: several politicians still have affiliations from 1991/1992 and @ref values for committees (e.g., Pahor, Borut:          
         <affiliation role="member"
             ref="#DruzPolZb"
             from="1990-05-08"
             to="1992-12-22"
             ana="#SK.11"> should this be removed (as ParlaMint does not include committees)?-->
  <xsl:template match="tei:person[@xml:id='LampeAlenka']//tei:birth">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:text/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:person[@xml:id='MurgelJasna']//tei:roleName/@type"/>
  
</xsl:stylesheet>


