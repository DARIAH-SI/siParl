<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Preimenujem imena datotek, ki vsebujejo Č, Š, Ž -->
    <!-- izhodiščni dokument je vsakokratni SDT*-list.xml -->
    
    <xsl:param name="rename">
        <string>KZPTZČPIEM</string>
        <string>OZIZKŠIM</string>
        <string>OZIZŠIM</string>
        <string>OZKŠIŠ</string>
        <string>OZKŠMZIŠ</string>
        <string>OZKŠŠIM</string>
        <string>OZVŠZITR</string>
    </xsl:param>
    
    <xsl:template match="documentsList">
        <xsl:for-each select="ref">
            <xsl:variable name="document" select="concat('rezultat/',if (matches(.,'Č|Š|Ž')) then (translate(.,'ČŠŽ','CSZ')) else (.))"/>
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
    
    
</xsl:stylesheet>