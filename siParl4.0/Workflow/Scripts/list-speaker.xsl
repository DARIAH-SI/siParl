<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
	exclude-result-prefixes="xs xi tei" version="2.0">

	<xsl:output method="xml" indent="yes"/>
<!--Input: Mappings.xml
    Output: listPerson-list.xml--> 

	<xsl:template match="/">
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
			</teiHeader>
			<text>
				<body>
					<listPerson>
						<!-- Collect all speaker IDs from all source documents -->
						<xsl:variable name="allSpeakerIDs" as="xs:string*">
							<xsl:for-each select="mappings/map">
								<xsl:variable name="targetDoc" select="document(target)"/>
								<xsl:sequence select="$targetDoc//tei:sp[@who]/@who"/>
							</xsl:for-each>
						</xsl:variable>

						<!-- Process unique speaker IDs -->
						<xsl:for-each select="distinct-values($allSpeakerIDs)">
							<xsl:sort select="replace(., 'SDT8:', '')"/>
							<!-- Sort by speaker ID -->

							<xsl:variable name="remove_SDT8" select="replace(., 'SDT8:', '')"/>


							<!-- ANALYZE STRING TO BE USED FOR REPLACED @WHO values, that will separate the values to the 
								<surname> and <forname>!!!!
								
								<xsl:analyze-string select="$remove_SDT8"
								regex="([A-ZŽČŠĆĐ][a-zžčšćüđö0]+)(([A-ZŽČŠĆĐ,\.-]+[a-zžčšćüđö0]+)+)?">
								<xsl:matching-substring>
									<person>
										<xsl:attribute name="xml:id">
											<xsl:value-of select="$remove_SDT8"/>
										</xsl:attribute>
										<persName>
										<surname>
											<xsl:value-of select="regex-group(2)"/>
										</surname>
										<forename>
											<xsl:value-of select="regex-group(1)"/>
										</forename>
										</persName>
									</person>
								</xsl:matching-substring>
							</xsl:analyze-string>-->

							<person>
								<xsl:attribute name="xml:id">
									<xsl:value-of select="$remove_SDT8"/>
								</xsl:attribute>
							</person>
						</xsl:for-each>
					</listPerson>
				</body>
			</text>
		</TEI>
	</xsl:template>


</xsl:stylesheet>
