# Identify any craniofacial-specific SEs in gene deserts
# 1 # Make gene desert bed: 
# Find regions that are not covered by protein coding regions (This includes introns to be more strict)
module load bedtools
module load htslib

bedtools complement -i gencode.v25lift37.annotation.noGL0_lv_1_2_protien_coding_only_sorted.bed -g hg19.chrom.sizes.sort > hg19_not_protien_coding.bed

# Find regions within the not protein coding that are >500kb
cat  hg19_not_protien_coding.bed | awk '{if(($3-$2) >= 500000) {print $0}}'  > hg19_gene_desert.bed

# 2 # intersect the gene desert bed with list of CF-specific SE that do not overlap a TSS

bedtools intersect -wa -wb -F 1 -a hg19_gene_desert.bed -b CF-specific_no_TSS_regions.bed > hg19_gene_desert_intersect_with_CF-specific_noTSS.bed

# check that the ends of the gene desert are outside the ends of the SE
cat hg19_gene_desert_intersect_with_CF-specific_noTSS.bed | awk '{print $2-$5"\t"$6-$3}' | more 
cut -f 1-3 hg19_gene_desert_intersect_with_CF-specific_noTSS.bed > gene_deserts_with_CF-specific_noTSS_SEs.bed
cut -f 4-6 hg19_gene_desert_intersect_with_CF-specific_noTSS.bed > CF-specific_noTSS_SEs_in_gene_deserts.bed

# result is 77 CF-specific SEs with no TSS overlap that are contained within gene deserts

# 3 # intersect those 77 regions with in vivo validated enhancers (from VISTA enhancer browser)
# can also intersect the wider gene desert with VISTA enhancers

bedtools intersect -wa -wb -names CF Other -a CF-specific_noTSS_SEs_in_gene_deserts.bed -b /home/FCAM/awilderman/ANALYSIS/VISTA/hg19_cf_enhancer_track.bed -b /home/FCAM/awilderman/ANALYSIS/VISTA/hg19_other_enhancer_track.bed > CF-specific_SEs_in_Gene_deserts_VISTA_intersect.txt

bedtools intersect -wa -wb -names CF Other -a gene_deserts_with_CF-specific_noTSS_SEs.bed -b /home/FCAM/awilderman/ANALYSIS/VISTA/hg19_cf_enhancer_track.bed -b /home/FCAM/awilderman/ANALYSIS/VISTA/hg19_other_enhancer_track.bed > Gene_deserts_with_CF-specific_SEs_VISTA_intersect.txt

# note that the VISTA lists were made from human enhancers with positive activity in cf tissue or any other tissue and mouse enhancers (positive activity, CF or any other tissue) reciprocally lifted to hg19.

 
