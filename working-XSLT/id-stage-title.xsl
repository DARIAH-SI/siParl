<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- zaradi naknadnega ugotavljanja napačno označenih title in stage elementov, jim najprej v tem koraku dodam identifikatorje -->
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
    
    <xsl:template match="tei:sp/tei:p/tei:title">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:sp/tei:p/tei:title" level="any"/>
        </xsl:variable>
        <title xml:id="{$document-name-id}.title{$num}">
            <xsl:apply-templates/>
        </title>
    </xsl:template>
    
    <xsl:template match="tei:sp//tei:stage[not(@type)]">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:stage" level="any"/>
        </xsl:variable>
        <stage xml:id="{$document-name-id}.stage{$num}">
            <xsl:apply-templates/>
        </stage>
    </xsl:template>
    
    
</xsl:stylesheet>