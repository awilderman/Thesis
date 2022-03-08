# This step creates the sample_list.txt that gets used by the script
cd ~/ANALYSIS/RNA-seq/HoxA_LCR_KO_mouse
ls -1 *_forward_paired.fq.gz | sed 's/_forward_paired.fq.gz//g' > ~/ANALYSIS/RNA-seq/HoxA_LCR_KO_mouse/STAR/sample_list.txt

# This part writes the slurm script
cd /home/FCAM/awilderman/ANALYSIS/RNA-seq/HoxA_LCR_KO_mouse/STAR

echo "#!/bin/bash
#SBATCH --job-name=star_align_run
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem=64G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=awilderman@uchc.edu
#SBATCH -o star_align_run_%j.out
#SBATCH -e star_align_run_%j.err

export FASTQDIR=/home/FCAM/awilderman/ANALYSIS/RNA-seq/HoxA_LCR_KO_mouse
export ANALYSISDIR=/home/FCAM/awilderman/ANALYSIS/RNA-seq/HoxA_LCR_KO_mouse/STAR
export GENOMEDIR=/home/FCAM/jcotney/GENOME/Mus_musculus/UCSC/mm10/Sequence/STARIndex
export GTFFILE=/home/FCAM/awilderman/GENOME/Mmusculus/mm10/gencode.vM25.annotation.gtf
module load STAR/2.7.1a
cd /home/FCAM/awilderman/ANALYSIS/RNA-seq/CNCC_RNA-seq/STAR" > Mouse_star_align.slurm
cat sample_list.txt | awk '{ \
print "\nSTAR --runThreadN 8 --outTmpDir ~/STARtemp --genomeDir $GENOMEDIR \
--readFilesIn $FASTQDIR/"$1"_forward_paired.fq.gz $FASTQDIR/"$1"_reverse_paired.fq.gz \
--outFileNamePrefix $ANALYSISDIR/"$1"_"$2" --readFilesCommand zcat --sjdbGTFfile $GTFFILE \
--outSAMprimaryFlag OneBestScore --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
--alignSJDBoverhangMin 2 --outFilterMismatchNoverReadLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax
 1000000 \
--outSAMtype BAM SortedByCoordinate --outSAMattributes Standard \
--outWigType bedGraph --outWigStrand Stranded --outWigNorm RPM \nrm -r ~/STARtemp" \
}' >> Mouse_star_align.slurm
