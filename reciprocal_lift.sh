# This is the start of make_mm10_reciprocal_lift.sh
echo "#!/bin/bash
#SBATCH --job-name=hg19_ROSE_liftOver
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem=32G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=awilderman@uchc.edu
#SBATCH -o liftover_%j.out
#SBATCH -e liftover_%j.err

module load kent-tools/1.04.00  
module load libpng/12-1.2.50-10

cd /home/FCAM/ahardy/ANALYSIS/ChIP/ChromHMM_all_tissues/CHROMHMM_OUTPUT_FILES/18State" > ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues/mm10_reciprocal_lift.slurm

## run this interactive
cd /home/FCAM/ahardy/ANALYSIS/ChIP/ChromHMM_all_tissues/CHROMHMM_OUTPUT_FILES/18State
echo -e "for F in \\" >> ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues/make_mm10_reciprocal_lift.sh

ls -1 *.bigBed | sed -e 's/.bigBed/ \\/g' - >> ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues/make_mm10_reciprocal_lift.sh
echo -e ";
do
    echo \"bigBedToBed \"\$F\".bigBed ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues/\"\$F\".bed
    cd ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues
    liftOver \"\$F\".bed /home/FCAM/awilderman/GENOME/liftOver/mm10ToHg19.over.chain  \"\$F\".mm10_to_hg19.bed \"\$F\".mm10_to_hg19.unmapped -minMatch=0.25
    liftOver \"\$F\".mm10_to_hg19.bed /home/FCAM/awilderman/GENOME/liftOver/hg19ToMm10.over.chain \"\$F\".mm10_to_hg19_to_mm10.bed \"\$F\".mm10_to_hg19_to_mm10.unmapped -minMatch=0.1
	liftOver \"\$F\".mm10_to_hg19_to_mm10.bed /home/FCAM/awilderman/GENOME/liftOver/mm10ToHg19.over.chain \"\$F\".reciprocal_to_hg19.bed \"\$F\".reciprocal_to_hg19.unmapped -minMatch=0.1\" >> ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues/mm10_reciprocal_lift.slurm
done" >> ~/ANALYSIS/Mouse_18_state_Liftover/All_Tissues/make_mm10_reciprocal_lift.sh

# note: mm10 to hg19 done with initial minmatch=0.25, hg19 to mm10 is initial minmatch=0.1, slightly more stringent going to human from mouse, doesn't change enhancers as much as it changes active transcription states

# afterwards can clean up intermediate files:
# rm *.mm10_to_hg19.* 
# or
# rm *.hg19_to_mm10.*
# in order to keep the files that represent segments that made it back from the lift (the true reciprocal)
