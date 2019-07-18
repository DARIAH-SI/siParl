<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument speaker.xml -->
    <!-- združim vse govornike z istim xml:id (brez oznake mandata) -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:listPerson">
        <listPerson type="speaker">
            <xsl:for-each-group select="tei:person" group-by="tokenize(@xml:id,'\.')[2]">
                <person xml:id="{current-grouping-key()}">
                    <xsl:attribute name="corresp">
                        <xsl:for-each select="current-group()">
                            <xsl:value-of select="concat('#',@xml:id)"/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:attribute>
                    <xsl:for-each select="current-group()[1]">
                        <xsl:apply-templates/>
                    </xsl:for-each>
                    <xsl:for-each select="current-group()">
                        <idno type="assembly">
                            <xsl:value-of select="tokenize(@xml:id,'\.')[1]"/>
                        </idno>
                    </xsl:for-each>
                </person>
            </xsl:for-each-group>
        </listPerson>
    </xsl:template>
    
</xsl:stylesheet>