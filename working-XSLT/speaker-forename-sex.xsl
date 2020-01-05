<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je vsakokratni *-speaker.xml -->
    <!-- avtomatsko jim dodam spol -->
    <!-- Pravilo: vsa imena, ki se končajo z a so ženska, razen izjeme iz variable $mosko_ime_konca_na_a, ki so privzeto moški spol -->
    <!-- TODO: Ročno popravi neidentificirane govornice in govornike -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="document-uri" select="document-uri(.)"/>
    <xsl:variable name="filename" select="(tokenize($document-uri,'/'))[last()]"/>
    <xsl:variable name="document" select="concat(substring-before($filename,'.xml'),'-sex.xml')"/>
    
    <xsl:variable name="mosko_ime_konca_na_a">
        <ime>Aljoša</ime>
        <ime>Andrija</ime>
        <ime type="unisex">Andrea</ime>
        <ime>Dragiša</ime>
        <ime>Elija</ime>
        <ime>Geza</ime>
        <ime>Grega</ime>
        <ime type="unisex">Ivica</ime>
        <ime>Jaka</ime>
        <ime>Jaša</ime>
        <ime>Jeremija</ime>
        <ime>Jona</ime>
        <ime>Kosta</ime>
        <ime>Kostja</ime>
        <ime>Kolja</ime>
        <ime>Luka</ime>
        <ime>Matija</ime>
        <ime>Miha</ime>
        <ime>Mitja</ime>
        <ime type="unisex">Nastja</ime>
        <ime>Nebojša</ime>
        <ime>Nemanja</ime>
        <ime type="unisex">Nikita</ime>
        <ime>Nikola</ime>
        <ime>Petja</ime>
        <ime type="unisex">Saša</ime>
        <ime>Siniša</ime>
        <ime>Slaviša</ime>
        <ime>Staniša</ime>
        <ime>Tosja</ime>
        <ime type="unisex">Vanja</ime>
        <ime>Vasja</ime>
        <ime>Žiga</ime>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="{$document}">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <xsl:variable name="firstForename" select="tei:persName/tei:forename[1]"/>
        <person>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
            <sex>
                <xsl:attribute name="value">
                    <xsl:choose>
                        <xsl:when test="matches($firstForename,'a$') and not($firstForename = $mosko_ime_konca_na_a/tei:ime)">F</xsl:when>
                        <xsl:otherwise>M</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:if test="$firstForename = $mosko_ime_konca_na_a/tei:ime[@type = 'unisex']">
                    <xsl:attribute name="cert">medium</xsl:attribute>
                </xsl:if>
            </sex>
        </person>
    </xsl:template>
    
</xsl:stylesheet>