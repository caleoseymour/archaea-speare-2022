PFAM_REF_DIR="/mnt/d/Ubuntu/science/reference/pfam35/"
PFAM_REF_FILE="$PFAM_REF_DIR/Pfam-A.hmm"

## Build hmm db
hmmfetch -f $PFAM_REF_FILE P-loopNTPase-clan.hmmkey > P-loopNTPase-clan.hmm
hmmfetch -f $PFAM_REF_FILE peptidase-clan.hmmkey > peptidase-clan.hmm
hmmfetch -f $PFAM_REF_FILE adhesin-clan.hmmkey > adhesin-clan.hmm
hmmfetch -f $PFAM_REF_FILE immunoglobulin-clan.hmmkey > immunoglobulin-clan.hmm

## move annotations into a single file.
if [ -f all.faa ];
then
    rm all.faa
fi

for faa in faa/*.faa;
do
    gn=$(basename -s .faa $faa )
    echo $gn
    sed -e "s/>/>$gn|/g" $faa >> all.faa
done

## Hmmsearch for peptidases (SP)
hmmsearch \
    --cut_nc \
    --noali \
    -o peptidase-clan.out \
    --tblout peptidase-clan.tblout \
    --domtblout peptidase-clan.domtblout \
    --pfamtblout peptidase-clan.pfamtblout \
    --acc \
    --cpu 2 peptidase-clan.hmm all.faa
Rscript parseHmmer.R peptidase-clan.domtblout domtblout
Rscript parseHmmer.R peptidase-clan.tblout tblout

## Hmmsearch for adhesin/immunoglobulin folds (EA?)
hmmsearch \
    --cut_nc \
    --noali \
    -o immunoglobulin-clan.out \
    --tblout immunoglobulin-clan.tblout \
    --domtblout immunoglobulin-clan.domtblout \
    --pfamtblout immunoglobulin-clan.pfamtblout \
    --acc \
    --cpu 2 immunoglobulin-clan.hmm all.faa
Rscript parseHmmer.R immunoglobulin-clan.domtblout domtblout
Rscript parseHmmer.R immunoglobulin-clan.tblout tblout
hmmsearch \
    --cut_nc \
    --noali \
    -o adhesin-clan.out \
    --tblout adhesin-clan.tblout \
    --domtblout adhesin-clan.domtblout \
    --pfamtblout adhesin-clan.pfamtblout \
    --acc \
    --cpu 2 adhesin-clan.hmm all.faa
Rscript parseHmmer.R adhesin-clan.domtblout domtblout
Rscript parseHmmer.R adhesin-clan.tblout tblout


## Hmmsearch for P-loop NTPase clan members (RE)
hmmsearch \
    --cut_nc \
    --noali \
    -o P-loopNTPase-clan.out \
    --tblout P-loopNTPase-clan.tblout \
    --domtblout P-loopNTPase-clan.domtblout \
    --pfamtblout P-loopNTPase-clan.pfamtblout \
    --acc \
    --cpu 2 P-loopNTPase-clan.hmm all.faa
Rscript parseHmmer.R P-loopNTPase-clan.domtblout domtblout
Rscript parseHmmer.R P-loopNTPase-clan.tblout tblout




## Run BLAST.
psiblast -query all.faa -subject SPEARE.faa -outfmt 6 -evalue 1e-5 > SPEARE-blast.txt