<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- zaradi seznama vseh izrazov za predsedujočega, naredim seznam vseh speaker (samo prvo besedo) v korpusu -->
    <!-- izhodišče je teiCorpus -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:result-document href="speaker/{tokenize(tei:teiCorpus/tei:TEI[1]/@xml:id,'-')[1]}-predsedujoci.xml">
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
                            <xsl:for-each-group select="//tei:speaker" group-by="tokenize(normalize-space(.),' ')[1]">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:if test="matches(current-grouping-key(),'^P|p')">
                                    <item>
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </item>
                                </xsl:if>
                            </xsl:for-each-group>
                        </list>
                        
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>