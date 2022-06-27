<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="xs tei"
		version="2.0">
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- vstavi ob procesiranju nove verzije -->
  <xsl:param name="edition">3.0a</xsl:param>
  <!-- vstavi CLARIN.SI Handle, kjer bo korpus shranjen v repozitoriju -->
  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1486</xsl:param>
  <!-- vstavi datum od katerega naprej se smatra, da je COVID razprava -->
  <xsl:param name="covid-date" as="xs:date">2019-11-01</xsl:param>
  
  <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
  
  <xsl:variable name="terms">
    <term n="1" start="1992-12-23" end="1996-11-28">1. mandat (1992-1996)</term>
    <term n="2" start="1996-11-28" end="2000-10-27">2. mandat (1996-2000)</term>
    <term n="3" start="2000-10-27" end="2004-10-22">3. mandat (2000-2004)</term>
    <term n="4" start="2004-10-22" end="2008-10-15">4. mandat (2004-2008)</term>
    <term n="5" start="2008-10-15" end="2011-12-15">5. mandat (2008-2011)</term>
    <term n="6" start="2011-12-16" end="2014-08-01">6. mandat (2011-2014)</term>
    <term n="7" start="2014-08-01" end="2018-06-22">7. mandat (2014-2018)</term>
    <term n="8" start="2018-06-22" end="2022-05-12">8. mandat (2018-2022)</term>
    <term n="9" start="2022-05-12">9. mandat (2022-)</term>
  </xsl:variable>
  
  <!-- Povezave to ustreznih taksonomij -->
  <xsl:param name="taxonomy-legislature">taxo-legislature.xml</xsl:param>
  <xsl:param name="taxonomy-speakers">taxo-speakers.xml</xsl:param>
  <xsl:param name="taxonomy-subcorpus">taxo-subcorpus.xml</xsl:param>

  <!-- The teiHeaders of each term -->
  <xsl:variable name="teiHeaders">
    <xsl:for-each select="mappings/source">
      <xsl:copy-of select="document(.)/tei:teiHeader"/>
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
  
  <xsl:template name="fileDesc">
    <fileDesc xmlns="http://www.tei-c.org/ns/1.0">
      <!-- For now just a copy of current ParlaMint-SI! -->
      <titleStmt>
        <title type="main" xml:lang="sl">Slovenski parlamentarni korpus ParlaMint-SI [ParlaMint]</title>
        <title type="main" xml:lang="en">Slovenian parliamentary corpus ParlaMint-SI [ParlaMint]</title>
	
        <title type="sub" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije, 7. in 8. mandat (2014 - 2020)</title>
        <title type="sub" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia, Term 7 and 8 (2014 - 2020)</title>
	
        <meeting n="7" corresp="#DZ" ana="#parla.lower #parla.term #DZ.7">7. mandat</meeting>
        <meeting n="8" corresp="#DZ" ana="#parla.lower #parla.term #DZ.8">8. mandat</meeting>

        <respStmt>
          <persName ref="https://orcid.org/0000-0001-6143-6877">Andrej Pančur</persName>
          <persName ref="https://orcid.org/0000-0002-1560-4099">Tomaž Erjavec</persName>
          <resp xml:lang="sl">Kodiranje ParlaMint TEI XML</resp>
          <resp xml:lang="en">ParlaMint TEI XML corpus encoding</resp>
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
        <edition>3.0a</edition>
      </editionStmt>
      
      <extent><!--These numbers do not reflect the size of the sample!-->
        <measure unit="speeches" quantity="75122" xml:lang="sl">75.122 govorov</measure>
        <measure unit="speeches" quantity="75122" xml:lang="en">75,122 speeches</measure>
        <measure unit="words" quantity="20190034" xml:lang="sl">20.190.034 besed</measure>
        <measure unit="words" quantity="20190034" xml:lang="en">20,190,034 words</measure>
      </extent>
      
      <publicationStmt>
        <publisher>
          <orgName xml:lang="sl">Raziskovalna infrastrukutra CLARIN</orgName>
          <orgName xml:lang="en">CLARIN research infrastructure</orgName>
          <ref target="https://www.clarin.eu/">www.clarin.eu</ref>
        </publisher>
        <idno subtype="handle" type="URI">http://hdl.handle.net/11356/1432</idno>
        <availability status="free">
          <licence>http://creativecommons.org/licenses/by/4.0/</licence>
          <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
          <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</ref>.</p>
        </availability>
	
        <date when="2021-06-11">2021-06-11</date>
	
      </publicationStmt>
      
      <sourceDesc>
        <bibl>
          <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
          <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
          <idno type="URI" subtype="parliament">https://www.dz-rs.si</idno>
          <date from="2014-08-01" to="2020-07-16">1.8.2014 - 16.7.2020</date>
        </bibl>
      </sourceDesc>
    </fileDesc>
  </xsl:template>
  
  <xsl:template name="encodingDesc">
   <encodingDesc xmlns="http://www.tei-c.org/ns/1.0">
   </encodingDesc>
  </xsl:template>
  
  <xsl:template name="profileDesc">
    <profileDesc xmlns="http://www.tei-c.org/ns/1.0">
    </profileDesc>
  </xsl:template>
  
</xsl:stylesheet>
