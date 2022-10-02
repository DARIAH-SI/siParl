<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- naredim seznam vseh sp/p/title v korpusu -->
    <!-- izhodišče je teiCorpus -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:result-document href="{tokenize(tei:teiCorpus/tei:TEI[1]/@xml:id,'-')[1]}-part2-list/list-title.xml">
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Title</title>
                        </titleStmt>
                        <publicationStmt>
                            <p>Publication Information</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Information about the source</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <list>
                            <xsl:for-each-group select="//tei:title[@xml:id]" group-by="normalize-space(.)">
                                <xsl:sort select="current-grouping-key()"/>
                                <item>
                                    <title><xsl:value-of select="current-grouping-key()"/></title>
                                    <idno>
                                        <xsl:for-each select="current-group()">
                                            <xsl:value-of select="@xml:id"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </idno>
                                </item>
                            </xsl:for-each-group>
                        </list>
                        
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>