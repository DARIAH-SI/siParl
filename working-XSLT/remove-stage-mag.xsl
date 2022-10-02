<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- odstranim vse stage, s katerimi sem označil menjavo magnetogramskih trakov -->
    <!-- izhodiščni dokument je vsakokratni *-list.xml -->
    
    <xsl:template match="documentsList">
        <xsl:for-each select="ref">
            <xsl:variable name="document" select="concat('rezultat/',.)"/>
            <xsl:result-document href="{$document}">
                <xsl:apply-templates select="document(.)"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:stage[@type='mag']">
        <!-- ne procesiram / odstranim -->
    </xsl:template>
    
    <xsl:template match="tei:stage[preceding-sibling::tei:stage[@type='mag']][matches(.,'[Nn]adaljevanje')]">
        <!-- ne procesiram / odstranim -->
    </xsl:template>
    
    <xsl:template match="tei:bibl">
        <bibl type="mag">
            <xsl:apply-templates/>
        </bibl>
    </xsl:template>
    
</xsl:stylesheet>