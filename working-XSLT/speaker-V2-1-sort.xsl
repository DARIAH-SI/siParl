<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakokratni *-speaker-ostali-2.xml in *-speaker-1.xml, ki sem jih združil v skupni dokument -->
    <!-- zaradi lažjega urejanja jih sortiram -->
    
    <xsl:output method="xml"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:listPerson">
        <listPerson>
            <xsl:for-each select="tei:person">
                <xsl:sort select="@xml:id"/>
                <person xml:id="{@xml:id}">
                    <xsl:apply-templates/>
                </person>
            </xsl:for-each>
        </listPerson>
    </xsl:template>
    
</xsl:stylesheet>