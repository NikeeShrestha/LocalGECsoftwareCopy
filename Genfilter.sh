#!/bin/sh
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=30G
#SBATCH --time=100:00:00
#SBATCH --partition=jclarke,batch,guest
#SBATCH --output=/work/schnablelab/nikees/SAP_351/%x_%a.out
#SBATCH --error=/work/schnablelab/nikees/SAP_351/%x_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nshrestha5@unl.edu

cd /work/schnablelab/nikees/SAP_351/

ml vcftools

vcftools --vcf SAP_imputed_biallelic_snpsonly_bcftools.reheader.vcf --out SAP_reheader_filter1_351 --keep LinesinPheno_351.txt --recode

vcftools --vcf SAP_reheader_filter1_351.recode.vcf --out SAP_reheader_filter2_351 --maf 0.05 --recode

ml bcftools

bcftools filter SAP_reheader_filter2_351.recode.vcf --exclude 'F_PASS(GT=="het") > 0.05' -o SAP_reheader_filter3_351.recode.vcf

ml plink

plink --vcf SAP_reheader_filter3_351.recode.vcf --make-bed --out SAP_reheader_351

ml java/19

java -Xmx100g -jar /work/schnablelab/nikees/Softwares/gec/gec.jar --effect-number --plink-binary SAP_reheader_351 --genome --out SAP_gec_351


