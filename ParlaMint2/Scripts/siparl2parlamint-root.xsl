<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
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
    
    <xsl:template match="mappings">
      <xsl:for-each select="source">
      </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
