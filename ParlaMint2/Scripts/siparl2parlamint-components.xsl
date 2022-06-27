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
      <xsl:attribute name="xml:id" select="replace(base-uri(), '.+/', '')"/>
      <xsl:attribute name="xml:lang" select="@xml:lang"/>
      <xsl:attribute name="ana">
	<xsl:value-of select="@ana"/>
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
	  <xsl:value-of select="ancestor::tei:teiHeader//tei:sourceDesc//tei:date/@when"/>
	  <xsl:text>)</xsl:text>
	</xsl:when>
      </xsl:choose>
      <xsl:text> [ParlaMint]</xsl:text>
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
