<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakokratni *-speaker.xml -->
    <!-- v začasnem seznamu govornikov, kjer so imena in priimki že ločeni z vejico v persName,
         označim imena in priimke s TEI elementi ter dodam unikaten identifikator za person -->
    
    <xsl:output method="xml"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <person>
            <xsl:if test="contains(tei:persName,',')">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select=" translate(tei:persName,', ','')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </person>
    </xsl:template>
    
    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="contains(.,',')">
                <persName>
                    <xsl:for-each select="tokenize(tokenize(.,', ')[1],' ')">
                        <surname>
                            <xsl:value-of select="."/>
                        </surname>
                    </xsl:for-each>
                    <xsl:for-each select="tokenize(tokenize(.,', ')[2],' ')">
                        <forename>
                            <xsl:value-of select="."/>
                        </forename>
                    </xsl:for-each>
                </persName>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>