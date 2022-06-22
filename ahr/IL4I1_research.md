# IL4I1 analysis route

## A Pan-tissue Signature

+ gene data (table S1)
+ NLP (intersect with gene data, table S2)
+ GO enrichment show thier main function
    1. qRT-PCR: AHR signature detects AHR activity

## IL4I1 Associates more with AHR Activity than IDO1 or TDO2

+ Median separation of ROAST test (R package) for IDO1 and TDO2... (32 TCGA tumor types)
    + Enzyme expression: TDO2, IDO1
    + AHR signature level
+ weighted gene co-expression network analysis (WGCNA) (R packages)
+ WGCNA Test another 7 Trp-catabolic enzymes (TCEs) in KEGG database

## IL4I1 Activates the AHR

+ human GBM **(Positive and negative arguments)**
    + AHR-proficient with low endo. IL4I1
        + IL4I1 induced AHR signature
    + AHR-deficient with high endo. IL4I1
        + reversed by AHR knockdown
    + treated GBM cells with supernatants... (IL4I1 metabolites)
        + increased nuclear AHR localization
    1. IL4I1 (brown) and HE staining for select model
    2. WB validate expression of AHR and IL4I1
    3. IL4I1 activity as determined by Phe-dependent H2O2 production in cell lysates
    4. Immunoblot (left) and quantification (right) of the nuclear to cytoplasmic ratio of AHR protein expression
+ CAS-1 cells (slightly more TDO2 than IL4I1)
    + downregulate AHR reduced IL4I1 level
    + compared the expression of TIPARP after **silencing of IL4I1** and TDO2

## IL4I1 Promotes Tumor Cell Motility, Suppresses T Cell Proliferation

+ IL4I1 increased the motility of AHR-proficient cells
    + reversed by SR1
    1. wound healing assay (cell motility)
+ reduced T cell proliferation
    + peripheral blood mononuclear cells (PBMC)
    + isolated CD8+ T cells
+ IL4I1 with overall survival probability in glioma patients.
    + GBM
    + LGG
    1. Kaplan Meier curves of the overall survival of TCGA GBM patients

## Indole-3-Pyruvic Acid Is the Key Metabolite

+ **pre.** IL4I1 reduced the levels of Phe, tyrosine (Tyr), and Trp in cell supernatants
    + Phe to PP
    + Tyr to hydroxyphenylpyruvic acid
    + Trp to indole-3-pyruvic acid (I3P)
+ AHR-proficient cells to above meta (**I3P** is sig.).
    + up. AHR target genes,
    + AHR nuclear translocation
    + XRE-driven luciferase activity
    1. Images of GFP-AHR-expressing tao BpRc1 hepatoma cells
+ I3P compare with Kyn and KynA
    + I3P induced XRE-luciferase activity at lower conc.
    + Gene set testing: most pathways were AHR-dependent
    + I3P enhanced GBM cell motility
    + reduced CD8+ Tcells proliferation

## I3P to Kynurenic Acid and Indole-3-Aldehyde

+ I3P non-detectable in the supernatants of IL4I1...
+ its deritives increased level
    + indole-3-acetic acid (IAA)
    + indole-3-aldehyde (I3A)
    + and indole-3-lactic acid (ILA)
+ increased KynA
    + Regulation of KynA by IL4I1 in **spleen tissue from Il4i1-/- mice**
    + Exposure of GBM cells to I3P resulted in a dose-dependent increase in IAA, I3A, and KynA levels
    + KynA formed spontaneously from I3P under cell-free conditions
    + IL4I1-derived H2O2 promotes I3P’s conversion to the AHR agonist KynA
+ I3A induced TIPARP and upregulated the pan-tissue AHR signature

## IL4I1 Expression increased in Cancer and Metastasis

+ IL4I1 expression was enhanced in primary cancer tissues
+ IL4I1 expression was higher than IDO1 or TDO2
+ L4I1 can activate AHR also in a hypoxic tumor microenvironment (TME)
+ IL4I1 levels and AHR activity higher in metastatic melanoma than primary melanoma
+ immune modulation was most enriched in AAMs

## IL4I1 Promoting chronic lymphocytic leukemia (CLL) Progression

+ IL4I1-expressing tumors showed an enrichment of suppressive immune cells
    + modules containing IL4I1 associate with MDSCs and Tregs **(multi-omics factor analysis (MOFA))**.
+ MDSCs and Tregs also is a feature of CLL
    + pacents with IL4I1 expression associated with AHR activity

[annotation]: ----------------------------------------- 

---------------- **IL4I1 in mouse with CLL** ----------------

+ in transplantable Eu-TCL1 mouse model (TCL1 AT)
    + the most upregulated genes in tumor-supportive monocytes
    + increase in AHR activity
    + elevated IL4I1 serum levels

---------------- **IL4I1-deficient mouse** ----------------

+ bone marrow chimeric mice of Il4i1-/- with Eu-TCL1
    + reduced tumor load in peripheral blood
    + higher percentage of classical dendritic cells (cDCs) in the absence of IL4I1
+ **pre.** CD8+ effector T cells (Teff) control tumor development in TCL1 AT mice
    + lose effector function and acquire an exhausted phenotype
+ Lack of IL4I1 mitigated Teff exhaustion in TCL1 AT mice
    + higher expression of KLRG1, short-lived Teff
    + lower expression of exhaustion-related immunomodulatory receptors
    + higher frequency of CD8+ T cells with intermediate PD1 expression
    1. fluorescence minus...normalized median fluorescence intensity (DMFI) for proteins with unimodal signals
+ **transcriptome analysis** of sorted Teff and CD8+ memory T cells from tumor-bearing WT and Il4i1-/- chimeras
    + downregulation of the exhaustion-related immunomodulatory receptors and Ahr
    + increased expression of Teff genes in Il4i1-/- chimeras
+ **Gene set enrichment analysis (GSEA)**
    + similar

## IL4I1 Expression Is Induced by Immune Checkpoint Blockade

+ IL4I1 could circumvent responses to ICB
    + nivolumab induced IL4I1 and IDO1 in advanced melanoma
    + nivolumab treatment resulted in AHR activation
+ RNA sequencing (RNA-seq) data from 41 patients.
    + significant IL4I1 increase in response to nivolumab in the ipilimumab-naive patients

---------------- **end** ----------------
+ IL4I1 could constitute a resistance mechanism against IDO1 inhibition.
+ IL4I1 represents a metabolic resistance mechanism against ICB and/or IDO1 inhibitors
