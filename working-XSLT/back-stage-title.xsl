<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- predhodno urejene in pregledane stage in title dam nazaj v dokumente in hkrati odstrani ukinatne identifikatorje -->
    <!-- izhodiščni dokument je vsakokratni *-list.xml -->
    
    <!-- ustrezno popravi parameter -->
    <xsl:param name="mandat">SDZ8-part2</xsl:param>
    
    <xsl:output method="xml"/>
    
    <xsl:variable name="doc-stage2time" select="concat('../drama/',$mandat,'-list/list-stage2time.xml')"/>
    <xsl:variable name="doc-title2time" select="concat('../drama/',$mandat,'-list/list-title2time.xml')"/>
    <xsl:variable name="doc-title2stage" select="concat('../drama/',$mandat,'-list/list-title2stage.xml')"/>
    
    <xsl:variable name="stage2time">
        <xsl:if test="doc-available($doc-stage2time)">
            <xsl:for-each select="document($doc-stage2time)//tei:idno">
                <xsl:for-each select="tokenize(.,' ')">
                    <idno>
                        <xsl:value-of select="."/>
                    </idno>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="title2time">
        <xsl:if test="doc-available($doc-title2time)">
            <xsl:for-each select="document($doc-title2time)//tei:idno">
                <xsl:for-each select="tokenize(.,' ')">
                    <idno>
                        <xsl:value-of select="."/>
                    </idno>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="title2stage">
        <xsl:if test="doc-available($doc-title2stage)">
            <xsl:for-each select="document($doc-title2stage)//tei:idno">
                <xsl:for-each select="tokenize(.,' ')">
                    <idno>
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
        <stage>
            <xsl:if test="$stage2time/tei:idno = $stage-id">
                <xsl:attribute name="type">
                    <xsl:text>time</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </stage>
    </xsl:template>
    
    <xsl:template match="tei:title[@xml:id]">
        <xsl:variable name="title-id" select="@xml:id"/>
        <xsl:choose>
            <xsl:when test="$title2time/tei:idno = $title-id">
                <stage type="time">
                    <xsl:apply-templates/>
                </stage>
            </xsl:when>
            <xsl:when test="$title2stage/tei:idno = $title-id">
                <stage>
                    <xsl:apply-templates/>
                </stage>
            </xsl:when>
            <xsl:otherwise>
                <title>
                    <xsl:apply-templates/>
                </title>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>