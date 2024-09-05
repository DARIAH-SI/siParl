<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0"
	xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xs tei xi" version="2.0">

  <xsl:output method="xml" indent="yes"/>
  
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

  <xsl:template match="documentsList">
    <xsl:for-each select="ref">
      <!-- Create a new result document with href as the value of ref element -->
      <xsl:variable name="term" select="replace(., 'speech', 'siParl4.0')"/>
      <!-- If processing term roots, use variable components if updating component roots-->
<!--      <xsl:variable name="components" select="concat('siParl4.0/', .)"/>-->
      <xsl:result-document href="{$term}">
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

    <xsl:template match="tei:TEI//@ana">
   <xsl:attribute name="{name()}">
     <xsl:choose>
       <xsl:when test="contains(., '#parl.')">
         <xsl:value-of select="replace(., '#parl\.', '#parla.')"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="."/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:attribute>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title[@type='main'][@xml:lang='sl']">
    <title type="main" xml:lang="sl">
    <xsl:choose>
      <xsl:when test="matches(., '\[siParl\]$')">
	<xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat(., ' [siParl]')"/>
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
	  <xsl:value-of select="concat(., ' [siParl]')"/>
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

  <xsl:template match="tei:taxonomy"/>

  
  <xsl:template match="tei:classDecl">
    <classDecl>
      <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="taxonomy-parla.speaker_types.xml"/>
      <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="taxonomy-parla.legislature.xml"/>
    </classDecl>
  </xsl:template>

  <xsl:template match="tei:settingDesc/tei:setting">
    <xsl:copy>
      <xsl:attribute name="xml:lang">sl</xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <setting xml:lang="en">
      <name type="city">Ljubljana</name>
      <name type="country" key="SI">Slovenia</name>
      <!-- Copy the date element from the existing English version -->
      <xsl:copy-of select="tei:date"/>
    </setting>
  </xsl:template>

  <xsl:template match="tei:org[@xml:id='SK']/tei:listEvent">
    <listEvent>
      <head xml:lang="sl">Zakonodajno obdobje</head>
      <head xml:lang="en">Legislative period</head>
      <event xml:id="SK.11" from="1990-05-08" to="1992-12-23">
        <label xml:lang="sl">11. sklic</label>
        <label xml:lang="en">Term 11</label>
      </event>
    </listEvent>
  </xsl:template>

  <xsl:template match="tei:org[@xml:id='DZ']/tei:listEvent">
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
  </xsl:template>
  <xsl:template match="tei:person[tei:persName/tei:forename[1] = $female_exception/tei:name]//tei:sex">
    <xsl:message>
      <xsl:text>Female exception:</xsl:text>
      <xsl:value-of select="../@xml:id"/> <!-- Include person's xml:id -->
      <xsl:text>, First forename: </xsl:text>
      <xsl:value-of select="../tei:persName/tei:forename[1]"/> <!-- Include first forename -->
      <xsl:text>, Sex value: </xsl:text>
      <xsl:value-of select="@value"/> <!-- Include sex value -->
    </xsl:message>
    <sex>
      <xsl:attribute name="value">F</xsl:attribute>
    </sex>
  </xsl:template>
  
  <xsl:template match="tei:listPerson/tei:head[2]">
    <xsl:copy-of select="."/>
    <person xml:id="commentator">
      <persName>komentator</persName>
    </person>
  </xsl:template>
  </xsl:stylesheet>

  
