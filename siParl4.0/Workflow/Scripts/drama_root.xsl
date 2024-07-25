<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0"
	xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xs tei" version="2.0">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:variable name="term_label" select="tokenize(mappings/map[1]/target, '/')[1]"/>
		<xsl:variable name="term_root" select="concat($term_label, '.xml')"/>
		<xsl:message select="$term_root"/>
		<xsl:result-document href="{concat('drama/', $term_root)}">
		<teiCorpus>
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title>title of corpus</title>
						<author>author</author>
					</titleStmt>
					<publicationStmt>
						<p>Publication Information</p>
					</publicationStmt>
					<sourceDesc>
						<p>Information about the source</p>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<xsl:for-each select="mappings//map/target">
				<xsl:element name="xi:include">
					<xsl:attribute name="href">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</teiCorpus>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>
