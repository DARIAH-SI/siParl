<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- Potem, ko sem uredil stage[@type='time'] (id-stage-title.xsl, list-stage.xsl, list-title.xsl, back-stage-title.xsl)
         še dodatno razvrstim stage v skupine. Zato najprej:
          - z id-stage.xsl spet dodam unikatne identifikatorje
          - potem naredim nov seznam z list-stage.xsl
          - naposled z back-stage.xsl v skupine ravrščene stage vstavim nazaj in izbrišem začasne unikatne identifikatorje
    -->
    <!-- izhodiščni dokument je vsakokratni *-list.xml -->
    <!-- Skupine:
          - note:
               - answer
               - correction
               - comment
               - unknown
               - vote
               - vote-ayes
               - vote-noes
               - time
          - gap:
               - inaudible
               - foreign
               - performance
          - incident
               - sound
               - stop_sound
          - kinesic
               - applause
               - snapping
               - gesture
               - silence
          - vocal
               - interruption
               - cough
               - laughter
               - murmuring
               
    -->
    
    <xsl:template match="documentsList">
        <xsl:for-each select="ref">
            <xsl:variable name="document" select="concat('rezultat/',.)"/>
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
    
    <xsl:template match="tei:sp//tei:stage[not(@type)]">
        <xsl:variable name="document-name-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="num">
            <xsl:number count="tei:stage" level="any"/>
        </xsl:variable>
        <stage xml:id="{$document-name-id}.stage{$num}">
            <xsl:apply-templates/>
        </stage>
    </xsl:template>
    
    
</xsl:stylesheet>