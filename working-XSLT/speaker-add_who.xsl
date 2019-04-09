<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- povežem TEI dokuemente zapisnikov sej in seznam na način, da dodam sp/@who -->
    <!-- izhodiščni dokument je vsakokratni *-list.xml -->
    
    <!-- ustrezno popravi parameter -->
    <xsl:param name="mandat">SDT7</xsl:param>
    
    <xsl:variable name="doc-speaker" select="concat('../drama/',$mandat,'-speaker-1.xml')"/>
    
    <xsl:variable name="speaker">
        <xsl:for-each select="document($doc-speaker)//tei:idno">
            <xsl:variable name="id" select="parent::tei:person/@xml:id"/>
            <xsl:for-each select="tokenize(normalize-space(.),' ')">
                <idno n="{$id}">
                    <xsl:value-of select="."/>
                </idno>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
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
    
    <xsl:template match="tei:sp">
        <xsl:variable name="spID" select="@xml:id"/>
        <xsl:variable name="whoID" select="$speaker/tei:idno[. = $spID][1]/@n"/>
        <sp>
            <xsl:if test="string-length($whoID) gt 0">
                <xsl:attribute name="who">
                    <xsl:value-of select="concat($mandat,':',$whoID)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </sp>
    </xsl:template>
    
</xsl:stylesheet>