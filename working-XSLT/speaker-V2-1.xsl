<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakokratni *-speaker-ostali-1.xml, ki sem jih naredil z speaker-V2-names.xsl -->
    <!-- v porpavljenem seznamu govornikov, kjer so imena in priimki že ločeni z vejico v persName,
         označim imena in priimke s TEI elementi ter dodam unikaten identifikator za person -->
    
    <xsl:output method="xml"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <person>
            <xsl:attribute name="xml:id">
                <xsl:choose>
                    <xsl:when test="tei:persName/tei:name">
                        <xsl:for-each select="tei:persName/tei:name">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="tei:persName/tei:forename">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:persName/tei:surname">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="tei:persName/tei:forename">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </person>
    </xsl:template>
    
    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="tei:name">
                <persName>
                    <xsl:for-each select="tei:name">
                        <surname>
                            <xsl:value-of select="."/>
                        </surname>
                    </xsl:for-each>
                    <xsl:for-each select="tei:forename">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </persName>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>