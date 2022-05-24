BiocManager::install('biodbHmdb')
## ------------------------------------- 
mybiodb <- biodb::newInst()
## ------------------------------------- 
## download all ?
conn <- mybiodb$getFactory()$createConn('hmdb.metabolites')
## ------------------------------------- 
ids <- conn$getEntryIds()
## ------------------------------------- 
entries <- conn$getEntry(ids)
## ------------------------------------- 
df <- mybiodb$entriesToDataframe(entries, compute = FALSE)

