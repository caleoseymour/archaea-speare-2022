library('data.table')
library('magrittr')

prodigal = function(contig, gff, faa = NULL, cds = NULL)
{
    flag_gff = paste('-o', gff)
    flag_faa = ifelse(is.null(faa), '', paste('-a', faa))
    flag_cds = ifelse(is.null(cds), '', paste('-d', cds))
    flag_contig = paste('-i', contig)
    cmd = paste('prodigal', flag_gff, flag_contig, flag_faa, flag_cds, '-q')
    message(cmd)
    system(cmd)
}

contigs = list.files('genome/', '.fna$')

dir.create('faa')
dir.create('cds')
dir.create('gff')

for (cf in contigs)
{
    contig = paste0('genome/', cf)
    gn = gsub('\\.fna$', '', cf)
    
    faa = paste0('./faa/', gn, '.faa')
    cds = paste0('./cds/', gn, '.fca')
    gff = paste0('./gff/', gn, '.gff')
    if (file.exists(contig)) prodigal(contig, gff, faa, cds)
}