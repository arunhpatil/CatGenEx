# CatGenEx

<strong><h1>Categorization of Genes based on Expression</h1></strong> 

This repository is a Command line interface bash script for Linux and Mac. This program allows classification of genes accross different tissues similar to the method followd in Uhlen et. al., &#34; <a href="https://science.sciencemag.org/content/347/6220/1260419.figures-only" target="_blank">Tissue-based map of the human proteome </a> &#34; and Want et. al., &#34; <a href="http://m.msb.embopress.org/content/15/2/e8503.full.pdf " target="_blank"> A deep proteome and transcriptome abundance atlas of 29 healthy human tissues </a>&#34;. <br>

<strong>Input data format:</strong><br>
A text file with expression values of all genes (in rows) accross all tissues (columns) should be provided. The first column should be Gene, followed by tissue names. Only retain these information - sinice all other information in the matrix will be considered as expression values by the script. Also, remove all genes which show zero expression across tissues - It is categorized as "Not detected".  

Assuming there are 32 tissues in the matrix, the categories are defined as follows:
(1) “Tissue enriched” – at least a 5-fold higher expression in one tissue compared to all other tissues; 
(2) “Group enriched” – 5-fold higher average expression in a group of 2-7 tissues compared to all other tissues; 
(3) “Expressed in all tissues” – detected in all 32 tissues; 
(4) “Tissue enhanced” – at least a 5-fold higher expression level in one tissue compared to the average value of all 32 tissues; 
(5) “Mixed” – the remaining genes detected in 1-31 tissues and in none of the above categories. 
The categories are modified slightly and the users can tweak the code to include cut-off at FPKM or iBAQ or any other quantification means as mentioned in Uhlen et. al., and Want et. al.

NOTE: CatGenEx 
      - should be used for an expression matrix containing multiple tissues; 
      - Can't be used as a validation means;
      - The code can be appled for raw and normalized data, however, the data should not be scaled between 1 & 10 or similar scaling method. 

<strong>HOW TO USE:</strong><br>
Clone or Download the repository.<br><br>
  <strong>Usage:</strong> <br>
user@userGitHub<strong>$</strong> perl CatGenEx.pl \<input_file_name.txt> \<output_file_name.txt> <br>
  Example: perl CatGenEx.pl input_file_name.txt output_file_name.txt<br><br>
  
<strong>Sample:</strong><br>  
A sample file will be provided soon. 
