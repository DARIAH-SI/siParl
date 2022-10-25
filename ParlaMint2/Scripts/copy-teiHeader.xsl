<?xml version='1.0' encoding='UTF-8'?>
<!-- Copy input teiHeader to output -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="fn tei">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="no" omit-xml-declaration="no"/>
  <xsl:template match="tei:teiCorpus">
    <xsl:copy-of select="tei:teiHeader"/>
  </xsl:template>
</xsl:stylesheet>
