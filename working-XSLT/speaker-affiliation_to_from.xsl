<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je ../speaker.xml -->
    <!-- uskladi datume v affiliation tako, da se med seboj ne prekrivajo -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:affiliation[@to = following-sibling::tei:affiliation[1]/@from]">
        <xsl:variable name="subtractDay" select="xs:date(@to) - xs:dayTimeDuration('P1D')"/>
        <affiliation role="{@role}" ref="{@ref}" from="{@from}" to="{$subtractDay}"/>
    </xsl:template>
    
</xsl:stylesheet>