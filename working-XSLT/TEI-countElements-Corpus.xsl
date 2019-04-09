<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">
    
    <!-- Po pretvorbi v nov TEI modul za CLARIN.SI, dodam za celoten korpus še tagsDecl -->
    <!-- izhodiščni dokument je kar korpus, rezultat shranim na roko takoj za tei:projectDesc -->

    <xsl:output method="xml" indent="yes"/>
    
    <!--<xsl:key name="elements" match="*" use="name()"/>-->
    <!-- če je potrebno šteti samo elemente v besedilu (brez teiHeader) -->
    <xsl:key name="elements" match="*[ancestor-or-self::tei:text]" use="name()"/>
    
    <xsl:template match="/">
        <tagsDecl>
            <namespace name="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="//*[ancestor-or-self::tei:text][count(.|key('elements', name())[1]) = 1]">
                    <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                </xsl:for-each>
            </namespace>
        </tagsDecl>
    </xsl:template>
    
    <!--<xsl:template match="/">
        <tagsDecl>
            <namespace name="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="//*[generate-id(.) = generate-id(key('elements', name())[1])]">
                    <xsl:sort select="name()"/>
                    <tagUsage gi="{name()}" occurs="{count(key('elements', name()))}"/>
                </xsl:for-each>
            </namespace>
        </tagsDecl>
    </xsl:template>-->
    
</xsl:stylesheet>
