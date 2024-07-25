<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>

    <!-- Input: Mappings.xml, output: list of documents SDTX-list.xml)-->
    <xsl:template match="/">
        <xsl:variable name="term_label" select="tokenize(mappings/map[1]/target, '/')[1]"/>
        <xsl:variable name="term_root" select="concat('drama/',$term_label, '-list.xml')"/>
        <xsl:message select="$term_root"/>
        <xsl:result-document href="{$term_root}">
        <documentsList>
            <xsl:for-each select="mappings//map/target">
                <xsl:element name="ref">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </documentsList>
        </xsl:result-document>
    </xsl:template>
    
    
</xsl:stylesheet>
