

## Create an environment to cache the full speices table
rfishbase <- new.env(hash = TRUE)


#' load_taxa
#' 
#' Load or update the taxa list
#' @param update logical, should we query the API to update the available list? 
#' @param cache should we cache the updated version throughout this session? 
#' (default TRUE, leave as is)
#' @inheritParams species_info
#' @return the taxa list
#' @export
load_taxa <- function(update = FALSE, cache = TRUE, server = SERVER){
  
  # First, try to load from cache
  all_taxa <- mget('all_taxa', 
                   envir = rfishbase, 
                   ifnotfound = list(NULL))$all_taxa
  
  if(is.null(all_taxa)){
    
    if(update){
      resp <- GET(paste0(server, "/taxa"), 
                  query = list(family='', limit=40000), 
                  user_agent(make_ua()))
      all_taxa <- check_and_parse(resp)
      drop <- match(c("Author", "Remark"), names(all_taxa))
      all_taxa <- all_taxa[-drop]
      
      if(cache) 
        assign("all_taxa", all_taxa, envir=rfishbase)  
      
    } else {
      
      data("all_taxa", package="rfishbase", envir = environment())
      
    }
  }
    
  all_taxa
}

#' A table of all the the species found in FishBase, including taxonomic
#' classification and the Species Code (SpecCode) by which the species is
#' identified in FishBase.
#'
#' @name all_taxa
#' @docType data
#' @author Carl Boettiger \email{carl@@ropensci.org}
#' @references \url{FishBase.org}
#' @keywords data
NULL

## Code to update the package cache:
# all_taxa <- load_taxa(update = TRUE)
# save("all_taxa", file = "data/all_taxa.rda", compress = "xz")

