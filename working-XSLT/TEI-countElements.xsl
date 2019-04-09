<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- Po pretvorbi v nov TEI modul za CLARIN.SI, dodam posameznim TEI dokumentom še tagsDecl -->
    <!-- izhodiščni dokument je listDoc.xml -->

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="documentsList">
        <xsl:for-each select="ref">
            <xsl:variable name="document" select="concat('/Users/administrator/Documents/moje/clarin/SlovParl/temp/rezultat/',.)"/>
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
    
    <!--<xsl:key name="elements" match="*" use="name()"/>-->
    <!-- če je potrebno šteti samo elemente v besedilu (brez teiHeader) -->
    <xsl:key name="elements" match="*[ancestor-or-self::tei:text]" use="name()"/>
    
    <xsl:template match="tei:projectDesc">
        <xsl:copy-of select="."/>
        <tagsDecl>
            <namespace name="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="//*[ancestor-or-self::tei:text][count(.|key('elements', name())[1]) = 1]">
                    <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                </xsl:for-each>
            </namespace>
        </tagsDecl>
    </xsl:template>
    
    <!--<xsl:template match="/">
        <tagsDecl>
            <namespace name="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="//*[generate-id(.) = generate-id(key('elements', name())[1])]">
                    <xsl:sort select="name()"/>
                    <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                </xsl:for-each>
            </namespace>
        </tagsDecl>
    </xsl:template>-->
    
</xsl:stylesheet>
