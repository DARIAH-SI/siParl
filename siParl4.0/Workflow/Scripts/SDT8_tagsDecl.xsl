<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">

  <!--Input: SDT8_list.xml, Output: SDT8_tags.xml-->
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:key name="tagUsageKey" match="tei:tagUsage" use="@gi" />

  <xsl:template match="documentsList">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>List of speakers</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Base for construction of listPerson</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                        <p>
                            <xsl:value-of select="document-uri(.)"/>
                        </p>
                    </sourceDesc>
                </fileDesc>
		<encodingDesc>
		  <xsl:variable name="allTags">
		    <xsl:for-each select="ref">
		      <xsl:variable name="targetDoc" select="document(.)"/>
		      <xsl:copy-of select="$targetDoc//tei:tagsDecl"/>
		      <xsl:message select="concat('CHECK:', .)"/>
		    </xsl:for-each>
		  </xsl:variable>
		  <tagsDecl>
		    <namespace name="http://www.tei-c.org/ns/1.0">
		      <xsl:for-each select="distinct-values($allTags//tei:tagUsage/@gi)">
			<tagUsage gi="{.}">
			  <xsl:attribute name="occurs">
			    <xsl:value-of select="sum($allTags//tei:tagUsage[@gi = current()]//@occurs)"/>
			  </xsl:attribute>
			</tagUsage>
		      </xsl:for-each>
		    </namespace>
		  </tagsDecl>
		</encodingDesc>
	    </teiHeader>
	</TEI>
  </xsl:template>
  
  
</xsl:stylesheet>
