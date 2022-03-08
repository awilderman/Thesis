echo -e "#!/bin/bash
#SBATCH --job-name=mouse_trimmomatic
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=awilderman@uchc.edu
#SBATCH -o mouse_trimmomatic_%j.out
#SBATCH -e mouse_trimmomatic_%j.err
source ~/.bashrc

cd ~/ANALYSIS/RNA-seq/HoxA_LCR_KO_mouse
export TRIMDIR=/isg/shared/apps/Trimmomatic/0.36
export ADAPTERDIR=/isg/shared/apps/Trimmomatic/0.36/adapters
export SAMPLEDIR=/home/FCAM/awilderman/DATA/RNA-seq/HoxA_LCR_KO_mouse/merged_files
module load Trimmomatic/0.36" > mouse_trimmomatic.slurm


for face in AWIL078_m1-111-WT1_S4 \
AWIL079_m2-112-WT2_S3 \
AWIL080_m3-113-WT3_S7 \
AWIL081_m4-114-Het1_S8 \
AWIL082_m5-115-Het2_S6 \
AWIL083_m6-116-Het3_S2 \
AWIL084_m7-117-KO1_S5 \
AWIL085_m8-118-KO2_S1 \
AWIL086_m9-119-KO3_S9 \
Sample1_S1_R1 \
Sample1_S1_R2 \
Sample2_S2_R1 \
Sample2_S2_R2 \
Sample3_S3_R1 \
Sample3_S3_R2 \
Sample4_S4_R1 \
Sample4_S4_R2 \
Sample5_S5_R1 \
Sample5_S5_R2 \
Sample6_S6_R1 \
Sample6_S6_R2 ;
do
   echo "java -jar \$TRIMDIR/trimmomatic-0.36.jar PE -phred33 \$SAMPLEDIR/"$face"_R1.fastq.gz \$SAMPLEDIR/"$face"_R2.fastq.gz 
"$face"_forward_paired.fq.gz "$face"_forward_unpaired.fq.gz "$face"_reverse_paired.fq.gz "$face"_reverse_unpaired.fq.gz ILLUMI
NACLIP:\$ADAPTERDIR/TruSeq2-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36" >> mouse_trimmomatic.slurm
done
