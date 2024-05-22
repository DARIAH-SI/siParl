<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <!-- Input: speaker.xml, output: speaker_corresp.xml-->

    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="listPerson" select="document('../listPerson.xml')"/>

    <xsl:template match="/">
        <xsl:variable name="var1">
            <xsl:apply-templates mode="pass1"/>
        </xsl:variable>
        <xsl:variable name="var2">
            <xsl:apply-templates select="$var1" mode="pass2"/>
        </xsl:variable>
        <xsl:variable name="var3">
            <xsl:apply-templates select="$var2" mode="pass3"/>
        </xsl:variable>
        <xsl:variable name="var4">
            <xsl:apply-templates select="$var3" mode="pass4"/>
        </xsl:variable>
        <xsl:copy-of select="$var4"/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="pass1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass1"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:listPerson" mode="pass1">
        <listPerson>
            <xsl:variable name="listPerson_person" select="$listPerson//tei:person"/>
            <xsl:copy>
                <xsl:apply-templates select="@*" mode="pass1"/>
                <xsl:apply-templates mode="pass1"/>
            </xsl:copy>
            <xsl:for-each select="$listPerson_person">
                <person xml:id="{@xml:id}">
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="concat('#SDT8.', @xml:id)"/>
                    </xsl:attribute>
                    <xsl:apply-templates mode="pass1"/>
                </person>
            </xsl:for-each>
        </listPerson>
    </xsl:template>

    <xsl:template match="@* | node()" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass2"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:listPerson[@type]" mode="pass2">
        <xsl:apply-templates mode="pass2"/>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="pass3">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass3"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:listPerson" mode="pass3">
        <listPerson type="speaker">
            <xsl:for-each-group select="tei:person" group-by="@xml:id">
                <person xml:id="{current-grouping-key()}">
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="string-join(current-group()/@corresp, ' ')"/>
                        <!--<xsl:message select="concat('Merging:', current-group()/@corresp)"></xsl:message>-->
                    </xsl:attribute>
                    <xsl:for-each select="current-group()[1]">
                        <xsl:apply-templates mode="pass3"/>
                    </xsl:for-each>   
                </person>
            </xsl:for-each-group>
        </listPerson>
    </xsl:template>
  
    <xsl:template match="@* | node()" mode="pass4">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="pass4">
                <xsl:sort select="@xml:id"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
  
    <xsl:template match="tei:person/@corresp" mode="pass4"/>
</xsl:stylesheet>
