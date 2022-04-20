## via pubchem, fill with name in witch compound
## idenfication table is 'null'
## ------------------------------------- 
dir.create("iupac_name")
pubchem_curl_inchikey(unique(export.class.cano$inchikey2D),
                      dir = "iupac_name",
                      get = "IUPACName",
                      curl_cl = 8)

