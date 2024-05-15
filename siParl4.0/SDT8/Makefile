# -*- coding: utf-8 -*-
# -xi to include XInclude processing!


#------------------ PREPARING NEW TERM SUBCORPUS (SDT8, Steps 1 - 8; Last updated: april 2024) -----------------------

#Step 1: Run ../Selenium/Selenium_scrap_full.ipynb  to scrap the HTML files from the webpage. Instead, ../Selenium/Selenium_from_X_page_forward.ipynb can be used to start scraping from specific page, or ../Selenium/Selenium_scrap_Kolegij to scrap debates for the Kolegij, that is on a different part of the page with different structure).


#Step 2: Convert HTML to XML, F/R function to produce valid document and document differences (diff between documents).



#------------------ PREPARATION OF THE INPUT DATA (Steps 2.1 - 2.3): ------------------------------------------------

#Step 2.1: Convert HTML to XML (shell):
# Navigate to the directory containing the HTML files
# Rename files from .html to .xml
#for file in *.html; do
#    mv -- "$file" "${file%.html}.xml"
#done

#Step 2.2:  use Find and replace functions within chosen editor (e.g. Sublime Text, XML Oxygen editor) to fix the HTML format to make it valid and ready for XSLT transformations.

#Step 2.3. Run ../Selenium/diffs.py (shell), document changes made to the source files (diff_output.txt).


#--------------------------------------------------------------------------------------------------------------------

#Step 3: Generate list of all files and their target locations
prep-files:
	 Scripts/map-files.pl 'SDT8' '../sources' 'SDT8'> Mappings.xml


#Step 4: Full conversion to drama + Parla-CLARIN validation
drama:
	$s -xsl:Scripts/data2drama.xsl Mappings.xml	
	$j Schema/parla-clarin.rng drama/SDT8/*.xml



#------------------ SPEAKER processing (Steps 4.1 - 4.4):-------------------------------------------------------------

#Reminder: 7th pass of the data2drama.xsl (instructions also added as comments within the XSLT script): First run-through, run conversion on copy-of select="$var7" option, to generate <sp @who=""> elements with correct grouping, then:

#Step 4.1: Output the @who attributes (from target in Mappings):
sp2csv:
	$s Scripts/sp_dump.xsl Mappings.xml

#Step 4.2: Run "Speaker_who/Who_mappings.ipynb" from command line to produce the output.tsv

#Step 4.3: Manually check and correct the "correct_string" columns (check within transcriptions for speaker disambiguations)

#Step 4.4: Run "Speaker_who/Insert_who.ipynb" from command line to produce listPerson-list.xml, that is needed to run the last pass of the data2drama.xsl conversion

#---------------------------------------------------------------------------------------------------------------------

#Step 5: Produce list of all of the corpus components within the drama folder from Mappings.xml
drama-list:
	$s -xsl:Scripts/drama_list.xsl Mappings.xml


#Step 5.1: Generate a term root (SDT8.xml) within drama folder (optional, not needed for the workflow)
drama-root:
	$s -xsl:Scripts/drama_root.xsl Mappings.xml


#Step 6: From the list of drama corpus components produce a list or organisations (for newer versions, manual addition of new political parties/parliamentary groups will be needed).
list-org:
	$s -xsl:Scripts/list-org.xsl drama/SDT8-list.xml > listOrg.xml


#Step 7: Produce list of speakers (listPerson) by running the transformation on the listPerson-list.xml, produced within the drama conversion to transform it into the main listPerson.xml
list-person:
	$s -xsl:Scripts/listPerson.xsl listPerson-list.xml > listPerson.xml


#Step 8: With listPerson.xml and listOrg.xml ready, run the conversion to speech module and validate with Parla-CLARIN.
speech:
	$s -xi -xsl:Scripts/drama2speech.xsl drama/SDT8-list.xml
	$j Schema/parla-clarin.rng speech/SDT8/*.xml


#---------------- MERGING NEW SUBCORPUS TO THE ENTIRE CORPUS (siParl4.0, Steps 9 - 13) -----------------------------------


# Step 9: Update speaker.xml (list of all speakers of the entire corpus) with the tei:person from the new term:
add_listPerson-term:
	$s -xsl:Scripts/add_corresp.xsl speaker.xml > siParl_listPerson.xml


#Step 10: Run siParl-termList.py to produce speech/*-list.xml for individual SDT/SDZ terms, which includes a list of all files in the chosen directory. Copy the list to the the speech-list.xml (and edit the path to include "../speech/") (in command line)


#Step 11: Update the existing term roots (previous version, 3.0) - correcting handle, date of availablity, misgendered speakers...[Run update_SSK11_root after, as it is a bit different to other SDT/SDZ documents]:
update_term_roots:
	$s -xsl:Scripts/siParl-termRoot-update.xsl siParl_root_files.xml

update_SSK11_root:
	$s -xsl:Scripts/SSK11_term_update.xsl siParl_root_files.xml

#Step 12: Update the existing components roots (previous version, 3.0) - correcting handle, date of availablity, misgendered speakers...:
update_component_roots:
	$s -xi -xsl:Scripts/siParl-componentRoot-update.xsl speech/SSK11_list.xml


#Step 13: Run conversion to get new siParl.xml corpus root and with this, new (updated) siParl {version} corpus.
siParl_root:
	$s -xi -xsl:Scripts/siParl.xsl speech-list.xml



#--------------- VALIDATION (Step 14) ----------------------------------------------------------------------------------

#Step 14: Validate the entire corpus with Parla-CLARIN (first copy with -xi to define xi:include elements and for validation not to produce errors "xi:include not allowed"):
val:
	$s -xi -xsl:Scripts/copy.xsl siParl4.0/siParl.xml | $j Schema/parla-clarin.rng

check-list:
	$s meta=../siParl4.0/siParl.xml -xsl:Scripts/check-links.xsl  siParl4.0/SSK11/DruzPolZb-Seja-020-1991-06-12.xml

lnk:
	ls siParl4.0/SSK11/*.xml | $P --jobs 20 '$s meta=../siParl4.0/siParl.xml ${vlink} {}'

#--------------- LINGUISTIC ANNOTAION ----------------------------------------------------------------------------------

#Linguistic annotation: The script "siParl_classla.py" assumes that the files, ready for annotation are all in a folder titled "siParl" (target directory and path can be changed in the script).
#Use of GPU is recommended

classla:
	time python3 siParl_classla.py

################################################
META = katja/siParl/siParl/siParl4.0/SDT8/siParl4.0/siParl.xml
vlink = -xsl:Scripts/check-links.xsl
s = java -Xmx240g -jar /usr/share/java/saxon.jar
j = java -jar /usr/share/java/jing.jar
P = parallel --gnu --halt 2


