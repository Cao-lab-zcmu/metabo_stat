
## codes
test <- mcn_5features

## set specific candidate
## ------------------------------------- 
## from chemical structure
test1 <- filter_structure(test)
test1 <- create_reference(test1)
## see results
specific_candidate(test1)
## or
reference(test1)$specific_candidate
## or
reference(mcn_dataset(test1))$specific_candidate
## 'create_reference(test1)' equals to
test1 <- create_reference(test1, from = "structure", fill = T)
e1 <- specific_candidate(test1)

## the above equals to following:
data <- latest(filter_structure(test1))
test1 <- create_reference(test1, data = data, fill = T)
e2 <- specific_candidate(test1)
identical(e1, e2)

## the 'specific_candidate' data used for filtering
test1 <- filter_formula(test1, by_reference = T)

## ------------------------------------- 
## from chemical formula
test1 <- filter_formula(test1)
test1 <- create_reference(test1, from = "formula")

## ------------------------------------- 
## from chemical classes
## A complex example:
## suppose there were some classes we were interested in
all_classes <- latest(test1, "project_dataset", ".canopus")$class.name
set.seed(1)
classes <- sample(all_classes, 50)
classes
test1 <- filter_ppcp(test1,
  dplyr::filter,
  class.name %in% classes,
  pp.value > 0.5,
  by_reference = F
)
data <- latest(test1)
data
## 'feature' have a plural number of candidates.
ids <- data$.features_id
id <- unique(ids[duplicated(ids)])
## get the candidate of top chemical structural score.
`%>%` <- magrittr::`%>%`
candidates <- filter_structure(test1, dplyr::filter, .features_id %in% id) %>% 
  latest() %>% 
  dplyr::filter(.candidates_id %in% data$.candidates_id) %>% 
  dplyr::arrange(.features_id, dplyr::desc(csi.score)) %>% 
  dplyr::distinct(.features_id, .keep_all = T)
## for refecrence
data <- data %>%
  dplyr::filter(
    .features_id != candidates$.features_id |
      (.features_id == candidates$.features_id &
        .candidates_id == candidates$.candidates_id)
  )
test1 <- create_reference(test1, data = data, fill = T)
specific_candidate(test1)

