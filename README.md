# Slovenian parliamentary corpus siParl                                                                                                                                                                    
## Minutes of the Slovenian Parliament in TEI


The minutes of the session are encoded in the TEI Module for Performance texts (Drama), which is located in the folder [drama](drama).
The meeting minutes are grouped in subfolders according to legislative period.
The minutes of the meetings of the National Assembly (SDZ) and the working bodies of the National Assembly (SDT) are separate.
Each legislative period which brings together the minutes of the SDZn or the SDTn is a separate teiCorpus containing the minutes of each day's session in a subfolder of the same name.
The lists of speakers are contained in a separate *-speaker.xml file.                                                                                                                        
                                                                                                                                                       
The minutes of the meetings are converted to XSLT [drama2speech.xsl](drama2speech.xsl) from the TEI module for drama texts to TEI speech transcription module, located in the folder [speech](speech).
The conversion is based on the drama/*-list.xml file list each time of each mandate/corpus.

The new version of the corpus, siParl 4.0, is available together with its data and workflow in the [siParl4.0](siParl4.0) folder.
Full corpus is also available on the [CLARIN.SI repository](http://hdl.handle.net/11356/1936) and on the [NoSketch Engine](https://www.clarin.si/ske/#dashboard?corpname=siparl40) concordancer.

## Citation

If you use siParl corpus in your work, please cite:

```
@article{meden2024slovenian,
  title={Slovenian parliamentary corpus siParl},
  author={Meden, Katja and Erjavec, Toma{\v{z}} and Pan{\v{c}}ur, Andrej},
  journal={Language Resources and Evaluation},
  pages={1--21},
  year={2024},
  publisher={Springer}
}
```

--------         

# Slovenski parlamentarni korpus siParl

## Zapisniki sej slovenskega parlamenta v TEI

Zapisnike sej se ureja v TEI modulu za dramska besedila, ki se nahajajo v mapi [drama](drama).
Zapisniki sej so glede na mandatna obdobja združeni v podmape. Pri tem se posebej loči zapisnike Sej Državnega zbora (SDZ) in zapisnike Sej delovnih teles (SDT) Državnega zbora.
Vsako mandatno obdobje, ki združuje zapisnike SDZn ali SDTn je samostojni teiCorpus, ki vključuje
zapisnike sej posameznega dne v istoimenski podmapi.
Seznami govornikov se nahajajo v ločeni *-speaker.xml datoteki.

Zapisnike sej se z pretvorbo XSLT [drama2speech.xsl](drama2speech.xsl) iz TEI modula za dramska besedila pretvori v TEI modul za prepis govorov, ki se nahaja v mapi [speech](speech). 
Pri pretvorbi se izhaja iz vsakokratnega drama/*-list.xml seznama datotek posameznega mandata/korpusa.

Nova različica korpusa, siParl 4.0, je skupaj z podatki in delotokom na voljo v mapi [siParl4.0](siParl4.0).
Celoten korpus je na voljo tudi v [repozitoriju CLARIN.SI](http://hdl.handle.net/11356/1936) in na konkordančniku [NoSketch Engine](https://www.clarin.si/ske/#dashboard?corpname=siparl40).

## Citiranje

Če v svojem delu uporabite korpus siParl, prosimo, citirajte naslednji članek:

```
@article{meden2024slovenian,
  title={Slovenian parliamentary corpus siParl},
  author={Meden, Katja and Erjavec, Toma{\v{z}} and Pan{\v{c}}ur, Andrej},
  journal={Language Resources and Evaluation},
  pages={1--21},
  year={2024},
  publisher={Springer}
}
```
