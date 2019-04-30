<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <!-- pobrano iz Stylesheets-master/common/functions.xsl  -->
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>[localisation] dummy template for overriding in a local system<param name="word">the word(s) to translate</param>
        </desc>
    </doc>
    <xsl:variable name="myi18n" select="document('../myi18n.xml',document(''))"/>
    <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
        <xsldoc:desc/>
        <xsldoc:param name="word"/>
    </xsldoc:doc>
    <xsl:template name="myi18n">
        <xsl:param name="word"/>
        <xsl:variable name="Word">
            <xsl:value-of select="normalize-space($word)"/>
        </xsl:variable>
        <xsl:for-each select="$myi18n">
            <xsl:choose>
                <xsl:when test="key('KEYS',$Word)/text[@xml:lang=$documentationLanguage]">
                    <xsl:value-of select="key('KEYS',$Word)/text[@xml:lang=$documentationLanguage]"/>
                </xsl:when>
                <xsl:when test="key('KEYS',$Word)/text[@lang3=$documentationLanguage]">
                    <xsl:value-of select="key('KEYS',$Word)/text[lang3=$documentationLanguage]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="key('KEYS',$Word)/text[@xml:lang='sl']"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Dodaten template za i18n, ki upošteva tudi predhodno določeni jezik</desc>
        <param name="word"/>
        <param name="thisLanguage"/>
    </doc>
    <xsl:template name="myi18n-lang">
        <xsl:param name="word"/>
        <xsl:param name="thisLanguage"/>
        <xsl:variable name="Word">
            <xsl:value-of select="normalize-space($word)"/>
        </xsl:variable>
        <xsl:for-each select="$myi18n">
            <xsl:choose>
                <xsl:when test="key('KEYS',$Word)/text[@xml:lang=$thisLanguage]">
                    <xsl:value-of select="key('KEYS',$Word)/text[@xml:lang=$thisLanguage]"/>
                </xsl:when>
                <xsl:when test="key('KEYS',$Word)/text[@lang3=$thisLanguage]">
                    <xsl:value-of select="key('KEYS',$Word)/text[lang3=$thisLanguage]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="key('KEYS',$Word)/text[@xml:lang='sl']"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>