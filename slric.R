library("jsonlite")
#library("curl")

corpora <- "rus"

## Downloading names of plays
#list_of_names <- fromJSON(paste0("https://dracor.org/api/corpora/", corpora))
#sorted_ids <- list_of_names$dramas$id[sort.list(list_of_names$dramas$id)]
#write.csv(sorted_ids, file="rus_listofnames144.csv")
df_sorted_ids <- read.csv(file="rus_listofnames144.csv", stringsAsFactors = F)
sorted_ids <- df_sorted_ids$x

#metadata <- read.csv(paste0("https://dracor.org/api/corpora/", corpora, "/metadata.csv"), stringsAsFactors = F)
#metadata <- metadata[order(metadata$name),]
#write.csv(metadata, file="rus_metadata144.csv")
metadata <- read.csv(file="rus_metadata144.csv", stringsAsFactors = F)
metadata$X <- NULL

plays <- lapply(sorted_ids, function(x) read.csv2(paste0("measures/SLRIC_", x, ".csv"), stringsAsFactors = F))
names(plays) <- metadata$name

concat <- function (x){
  x$Metric <- paste0(x$Quota, "_", x$Centrality)
  x$Quota <- NULL
  x$Centrality <- NULL
  x[order(x$Element),]
  return (x)
}

plays <- lapply(plays, concat)

metrics <- plays[[1]]$Metric[!duplicated(plays[[1]]$Metric)]

reorganisation <- function(x){
  df <- data.frame(x$Element[!duplicated(x$Element)], stringsAsFactors = F)
  for (m in metrics){
    df$t <- x[x$Metric==m, 2]
    #names(df$t) <- m
    names(df)[names(df) == 't'] <- m
  }
  return (df)
}

slric_df <- lapply(plays, reorganisation)


