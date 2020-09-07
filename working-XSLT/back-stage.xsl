<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- predhodno urejene in pregledane stage (dodatno klasificirane glede na note gap, incident, kinesic, vocal) dam nazaj v dokumente in hkrati odstrani ukinatne identifikatorje -->
    <!-- izhodiščni dokument je vsakokratni *-list.xml -->
    
    <!-- ustrezno popravi parameter -->
    <xsl:param name="mandat">SDZ8</xsl:param>
    
    <xsl:output method="xml"/>
    
    <xsl:variable name="doc-stage" select="concat('../drama/',$mandat,'-list/list-stage.xml')"/>
    
    <xsl:variable name="stage">
        <xsl:if test="doc-available($doc-stage)">
            <xsl:for-each select="document($doc-stage)//tei:idno">
                <xsl:variable name="idno-type" select="ancestor::tei:list/@type"/>
                <xsl:for-each select="tokenize(.,' ')">
                    <idno type="{$idno-type}">
                        <xsl:value-of select="."/>
                    </idno>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
    
    <!-- /documentsList/ref[1062] -->
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
    
    
    <xsl:template match="tei:stage[@xml:id]">
        <xsl:variable name="stage-id" select="@xml:id"/>
        <stage type="{$stage/tei:idno[. = $stage-id]/@type}">
            <xsl:apply-templates/>
        </stage>
    </xsl:template>
    
</xsl:stylesheet>