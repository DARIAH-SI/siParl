<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="xs tei"
		version="2.0">

  <!--To-do, 15.07.2022 (after successful validation; diff notes): -->

  <!--fix the xml:id: concatenated the ParlaMint-SI_; 
      change the <note type="chairman">...</note> to <head>
      
      idno[@type]: which form of the date?
      
      What to do with tagUsage?

-->
    
  <xsl:output method="xml" indent="yes"/>
  
  <!-- vstavi ob procesiranju nove verzije -->
  <xsl:param name="edition">3.0a</xsl:param>
  <!-- vstavi CLARIN.SI Handle, kjer bo korpus shranjen v repozitoriju -->
  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1486</xsl:param>
  <!-- vstavi datum od katerega naprej se smatra, da je COVID razprava -->
  <xsl:param name="covid-date" as="xs:date">2019-11-01</xsl:param>

  
  <xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
  
  <!-- Not sure if we need this, leaving it here for now: -->
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
  
  <xsl:template match="mappings">
    <!-- Process each file in turn -->
    <xsl:for-each select="map">
      <xsl:message select="concat('INFO: Converting ', source, ' to ', target)"/>
      <xsl:result-document href="{target}">
	<xsl:apply-templates select="document(source)"/>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>  

  <xsl:template match="tei:TEI">
    <xsl:copy>
      <xsl:variable name="base" select="(replace(base-uri(), '.+/(.+)\.xml', '$1'))"/>
       <xsl:variable name="type_of_session" select="tokenize($base,'-')[1]"/>
       <xsl:variable name="no_of_session" select="tokenize($base,'-')[2]"/>
       <xsl:variable name="year" select="tokenize($base,'-')[3]"/>
       <xsl:variable name="month" select="tokenize($base,'-')[4]"/>
       <xsl:variable name="day" select="tokenize($base,'-')[5]"/>
       <xsl:variable name="mandat_no" select="tei:teiHeader//tei:meeting[2]/@n"/>
      <xsl:attribute name="xml:id" select="concat('ParlaMint-SI_',$year,'-',$month,'-',$day, '-','SDZ', $mandat_no, '-', $type_of_session, '-', $no_of_session )"/>
      <xsl:attribute name="xml:lang" select="@xml:lang"/>
      <xsl:attribute name="ana">
	<xsl:text>#parla.sitting</xsl:text>
	<xsl:text>&#32;</xsl:text>
	<xsl:choose>
	  <xsl:when test="xs:date(tei:teiHeader//tei:sourceDesc//tei:date/@when) 
			  &lt; xs:date($covid-date)">#reference</xsl:when>
          <xsl:otherwise>#covid</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

<!--
  <xsl:template match="tei:TEI[@xml:id]">
    <xsl:variable name="front" select="tokenize(.,'_')[1]"/>
    <xsl:variable name="back" select="tokenize(.,'_')[2]"/>
    <xsl:variable name="type_of_session" select="tokenize($back,'-')[1]"/>
    <xsl:variable name="no_of_session" select="tokenize($back,'-')[2]"/>
    <xsl:variable name="year" select="tokenize($back,'-')[3]"/>
    <xsl:variable name="month" select="tokenize($back,'-')[4]"/>
    <xsl:variable name="day" select="tokenize($back,'-')[5]"/>
    <xsl:attribute name="xml:id">
      <xsl:value-of select="concat($front,'_',$year,'-',$month,'-',$day,'-',$type_of_session,'-',$no_of_session"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:template>
-->
  
   <xsl:template match="tei:titleStmt">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
      <funder>
	<orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
	<orgName xml:lang="en">The CLARIN research infrastructure</orgName>
      </funder>
    </xsl:copy>
    <editionStmt>
      <edition>
	<xsl:value-of select="$edition"/>
      </edition>
    </editionStmt>
    <extent><!--These numbers do not reflect the size of the sample!-->
      <measure unit="speeches" quantity="0" xml:lang="sl">0 govorov</measure>
      <measure unit="speeches" quantity="0" xml:lang="en">0 speeches</measure>
      <measure unit="words" quantity="0" xml:lang="sl">0 besed</measure>
      <measure unit="words" quantity="0" xml:lang="en">0 words</measure>
    </extent>
  </xsl:template>
  
  <xsl:template match="tei:titleStmt/tei:title[@type = 'main']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
	<xsl:when test="@xml:lang = 'sl'">
	  <xsl:text>Slovenski parlamentarni korpus ParlaMint-SI, </xsl:text>
	  <xsl:value-of select="../tei:title[@type = 'sub' and @xml:lang = 'sl']"/>
	</xsl:when>
	<xsl:when test="@xml:lang = 'en'">
	  <xsl:text>Slovenian parliamentary corpus ParlaMint-SI, </xsl:text>
          <xsl:choose>
            <xsl:when test="../tei:meeting[contains(@ana, '#parl.meeting.regular')]">
              <xsl:text>Regular Session </xsl:text>
              <xsl:value-of select="../tei:meeting[contains(@ana, '#parl.meeting.regular')]/@n"/>
            </xsl:when>
            <xsl:when test="../tei:meeting[contains(@ana, '#parl.meeting.extraordinary')]">
              <xsl:text>Extraordinary Session </xsl:text>
              <xsl:value-of select="../tei:meeting[contains(@ana, '#parl.meeting.extraordinary')]/@n"/>
            </xsl:when>
	    <xsl:otherwise>
	      <xsl:message terminate="yes">
		<xsl:text>Bad session type: </xsl:text>
		<xsl:value-of select="../tei:meeting/@ana"/>
	      </xsl:message>
	    </xsl:otherwise>
          </xsl:choose>
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="format-date(
				ancestor::tei:teiHeader//tei:sourceDesc//tei:date/@when, 
				'[MNn] [D01], [Y0001]')"/>
	  <xsl:text>)</xsl:text>
	</xsl:when>
      </xsl:choose>
      <xsl:text> [ParlaMint]</xsl:text>
    </xsl:copy>
  </xsl:template>



  <xsl:template match="tei:titleStmt/tei:title[@type = 'sub']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:text>Zapisi sej Državnega zbora Republike Slovenije, </xsl:text>
      <xsl:value-of select="../tei:meeting[@n]"/>
      <xsl:text>,&#32;</xsl:text>
      <xsl:value-of select="../tei:title[@type = 'sub' and @xml:lang = 'sl']"/>
    </xsl:copy>
    <xsl:element name="title">
      <xsl:attribute name="type" select="../tei:title[@type= 'sub']/@type"/>
      <xsl:attribute name="xml:lang" select="../tei:title[@xml:lang = 'en']/@xml:lang"/>
      <xsl:text>Minutes of the National Assembly of the Republic of Slovenia, Term </xsl:text>
      <xsl:value-of select="../tei:meeting[contains(@ana, '#parl.term')]/@n"/>
      <xsl:text>, </xsl:text>
      <xsl:choose>
	<xsl:when test="../tei:meeting[contains(@ana, '#parl.meeting.regular')]">
	  <xsl:text>Regular Session </xsl:text>
          <xsl:value-of select="../tei:meeting[contains(@ana, '#parl.meeting.regular')]/@n"/>
        </xsl:when>
        <xsl:when test="../tei:meeting[contains(@ana, '#parl.meeting.extraordinary')]">
          <xsl:text>Extraordinary Session </xsl:text>
          <xsl:value-of select="../tei:meeting[contains(@ana, '#parl.meeting.extraordinary')]/@n"/>
        </xsl:when>
	<xsl:otherwise>
	  <xsl:message terminate="yes">
	    <xsl:text>Bad session type: </xsl:text>
	    <xsl:value-of select="../tei:meeting/@ana"/>
	  </xsl:message>
	    </xsl:otherwise>
      </xsl:choose>
      <xsl:text>, (</xsl:text>
      <xsl:value-of select="format-date(
			    ancestor::tei:teiHeader//tei:sourceDesc//tei:date/@when, 
			    '[D01]. [M01]. [Y0001]')"/>
      <!-- What kind of date format should actually be here? 25.8.2014 like in DataOK, 25. 8. 2014 (so, with spaces) or August 25, 2014? -->
      <xsl:text>)</xsl:text>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="tei:publicationStmt/tei:publisher/tei:email"/>
  <xsl:template match="tei:publicationStmt/tei:distributor"/>
  <xsl:template match="tei:publicationStmt/tei:publisher/tei:orgName"/>
  <xsl:template match="tei:publicationStmt/tei:publisher/tei:ref"/>
  <xsl:template match="tei:publicationStmt/tei:pubPlace"/>

  
  <xsl:template match="tei:publicationStmt/tei:publisher">
    <xsl:copy>
      <orgName xml:lang="sl">Raziskovalna infrastruktura CLARIN</orgName>
      <orgName xml:lang="en">CLARIN research infrastructure</orgName>
      <ref target="https://www.clarin.eu/">www.clarin.eu</ref>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
    <idno subtype="handle" type="URI">
      <xsl:value-of select="$clarinHandle"/>
    </idno>
  </xsl:template>

    <xsl:template match="tei:publicationStmt//tei:date[@when]">
    <xsl:element name="date">
      <xsl:attribute name="when">
	<xsl:value-of select="format-date(current-date(), 
			      '[Y0001]-[M01]-[D01]')"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:sourceDesc/tei:bibl/tei:title[not(@*)]"/>
  
  <xsl:template match="tei:sourceDesc/tei:bibl">
    <xsl:copy>
      <title type="main" xml:lang="en">Minutes of the National Assembly of the Republic of Slovenia</title>
      <title type="main" xml:lang="sl">Zapisi sej Državnega zbora Republike Slovenije</title>
      <xsl:apply-templates select="tei:edition"/>
      <xsl:apply-templates select="tei:idno"/>
      <!--For the tei:idno, how do I add the subtype attribute and its value? -->
      <xsl:apply-templates select="tei:date"/> 
    </xsl:copy>
  </xsl:template>

  <!-- This is a new comment!!!-->

  <xsl:template match="tei:encodingDesc">
    <xsl:copy>
      <projectDesc>
	<p xml:lang="sl">
          <ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref>
	</p>
	<p xml:lang="en">
          <ref target="https://www.clarin.eu/content/parlamint">ParlaMint</ref>
      </p>
      </projectDesc>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:profileDesc/tei:abstract"/>

  <xsl:template match="tei:profileDesc">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
    <revisionDesc>
      <!-- Do we need to add any new changes/revisions? Also, weird indentation -->
      <change when="2021-06-11">
      <name>Tomaž Erjavec</name>: Made sample.</change>
      <change when="2021-03-20">
      <name>Tomaž Erjavec</name>: Fixes for Version 2.</change>
      <change when="2020-10-06">
      <name>Tomaž Erjavec</name>: Small fixes for ParlaMint.</change>
    </revisionDesc>
  </xsl:template>
  
  <xsl:template match="tei:text/tei:body[.//tei:div]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:text/tei:body/tei:div[.//tei:note]">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:text//tei:div[.//tei:head]">
    <xsl:apply-templates/>
  </xsl:template>
    
  <xsl:template match="tei:front[.//tei:div]">
    <xsl:apply-templates/>
  </xsl:template>
  

  <xsl:template match="tei:text">
    <xsl:copy>
      <xsl:attribute name="ana">
	<xsl:choose>
	  <xsl:when test="xs:date(/tei:TEI/tei:teiHeader//tei:sourceDesc//tei:date/@when) 
			  &lt; xs:date($covid-date)">#reference</xsl:when>
          <xsl:otherwise>#covid</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <body>
	<div type="debateSection">
	  <xsl:apply-templates/>
	</div>
      </body>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:text//tei:note[@type = 'chairman']">
    <xsl:element name = "head">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
    
 <!-- In this session, all of the gap element are empty, with only an attribute to explain the type of gap. But this might not be the case for all other sessions.-->
  <xsl:template match="//tei:gap">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <desc>
	<xsl:attribute name="xml:lang">
	  <xsl:value-of select="/tei:TEI/@xml:lang"/>
	</xsl:attribute>
	<xsl:apply-templates/>
      </desc>
    </xsl:copy>
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

</xsl:stylesheet>
