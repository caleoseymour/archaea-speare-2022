## Search genomes for megaproteins.
## Calculate OGT.
library('magrittr')
library('data.table')
source('io.align.R')

## Return the size of the largest ORF
largest_ORF = function(seqs) unlist(seqs) %>% nchar() %>% max()

## List the FAA files to run OGT on.
faas = list.files('faa/', '.faa$')
## Iterate to run OGT calculation.
vlps = faas %>% lapply(.,
    function(fa)
    {
        faa = paste0('faa/', fa)
        gn = gsub('\\.faa$', '', fa)
        
        seqs = read.align(faa, truncate_at = -1)

        
        data.table(genome = gn, largest.aa = largest_ORF(seqs))
    }) %>% do.call('rbind', .)
    
fwrite(vlps, 'largest-orf.tsv.xls', sep='\t')