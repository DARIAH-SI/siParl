<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi"
    version="2.0">
    
    <!-- izhodiščna datoteka je docList.xml -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="documentsList">
        <!-- Štetje besed -->
        <xsl:variable name="counting">
            <xsl:for-each select="ref">
                <string>
                    <xsl:apply-templates select="document(.)"/>
                </string>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="compoundString" select="normalize-space(string-join($counting/string,' '))"/>
        <xsl:value-of select="count(tokenize($compoundString,'\W+')[. != ''])"/>
    </xsl:template>
    
    
    <!--<xsl:template match="fieldset">
        <xsl:apply-templates select="span[@class = 'outputText']"/>
    </xsl:template>
    
    <xsl:template match="span[@class = 'outputText']">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>-->
    
</xsl:stylesheet>