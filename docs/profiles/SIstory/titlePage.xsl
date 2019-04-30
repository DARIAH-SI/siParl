<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
        <xsldoc:desc> NASLOVNA STRAN </xsldoc:desc>
    </xsldoc:doc>
    <xsl:template match="tei:titlePage">
        <!-- avtor -->
        <p  class="naslovnicaAvtor">
            <xsl:for-each select="tei:docAuthor">
                <xsl:choose>
                    <xsl:when test="tei:forename or tei:surname">
                        <xsl:for-each select="tei:forename">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() ne last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="tei:surname">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:for-each select="tei:surname">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() ne last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="position() ne last()">
                    <br/>
                </xsl:if>
            </xsl:for-each>
        </p>
        <!-- naslov -->
        <xsl:for-each select="tei:docTitle/tei:titlePart[1]">
            <h1 class="text-center"><xsl:value-of select="."/></h1>
            <xsl:for-each select="following-sibling::tei:titlePart">
                <h1 class="subheader podnaslov"><xsl:value-of select="."/></h1>
            </xsl:for-each>
        </xsl:for-each>
        <br/>
        <xsl:if test="tei:figure">
            <div class="text-center">
                <p>
                    <img src="{tei:figure/tei:graphic/@url}" alt="naslovna slika"/>
                </p>
            </div>
        </xsl:if>
        <xsl:if test="tei:graphic">
            <div class="text-center">
                <p>
                    <img src="{tei:graphic/@url}" alt="naslovna slika"/>
                </p>
            </div>
        </xsl:if>
        <br/>
        <p class="text-center">
            <!-- založnik -->
            <xsl:for-each select="tei:docImprint/tei:publisher">
                <xsl:value-of select="."/>
                <br/>
            </xsl:for-each>
            <!-- kraj izdaje -->
            <xsl:for-each select="tei:docImprint/tei:pubPlace">
                <xsl:value-of select="."/>
                <br/>
            </xsl:for-each>
            <!-- leto izdaje -->
            <xsl:for-each select="tei:docImprint/tei:docDate">
                <xsl:value-of select="."/>
                <br/>
            </xsl:for-each>
        </p>
    </xsl:template>
    
    
</xsl:stylesheet>