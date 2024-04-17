<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0"
	xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xs tei xi" version="2.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="clarinHandle">http://hdl.handle.net/11356/1936</xsl:param>

  <xsl:template match="documentsList">
    <xsl:for-each select="ref">
      <!-- Create a new result document with href as the value of ref element -->
<!--      <xsl:variable name="term" select="replace(., 'speech', 'roots')"/>--> <!-- If processing term roots, use variable components if updating component roots-->
      <xsl:variable name="components" select="concat('siParl4.0/', .)"/>
      <xsl:result-document href="{$components}">
        <!-- Copy the content of the referenced document -->
        <xsl:apply-templates select="document(.)"/>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title[@type='main'][@xml:lang='sl']">
    <title type="main" xml:lang="sl">
    <xsl:choose>
      <xsl:when test="matches(., '\[siParl\]$')">
	<xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat(., '[siParl]')"/>
      </xsl:otherwise>
    </xsl:choose>
    </title>
  </xsl:template>


  <xsl:template match="tei:titleStmt/tei:title[@type='main'][@xml:lang='en']">
    <title type="main" xml:lang="en">
      <xsl:choose>
	<xsl:when test="matches(., '\[siParl\]$')">
	  <xsl:value-of select="."/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat(., '[siParl]')"/>
	</xsl:otherwise>
      </xsl:choose>
    </title>
  </xsl:template>

  <xsl:template match="tei:publicationStmt/tei:date[@when]">
    <date>
      <xsl:attribute name="when">
	<xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
      </xsl:attribute>
      <xsl:value-of select="format-date(current-date(), '[D1]. [M1]. [Y0001]')"/>
    </date>
  </xsl:template>

  <xsl:template match="tei:availability[@status='free']">
    <availability status="free">
      <licence>http://creativecommons.org/licenses/by/4.0/</licence>
      <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</ref>.</p>
      <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
    </availability>
  </xsl:template>


  <xsl:template match="tei:publicationStmt/tei:idno[@subtype='handle']">
    <idno type="URI" subtype="handle">
      <xsl:value-of select="$clarinHandle"/>
    </idno>
  </xsl:template>


  </xsl:stylesheet>

  
