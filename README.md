# archaea-speare-2022
Archived upload of old code from a previous project. This repos contains code used to search for SPEARE-like proteins via psiblast and PFAM annotation.


## Description of files
Filename | Description
------------ | -------------
SPEARE.faa | Representative amino acid sequence of SPEARE protein.
annotate-genomes.R | Annotate genomes using prodigal (must be installed).
annotate-pfams.sh | Shell script to annotate select pfams from *.hmmkey files. Also runs psiblast.
parseHmmer.R | Parse HMMer output domtblout and tblout into a TSV file.
vlp.R | Look for the largest ORF in a set of genomes, & write results to file.
