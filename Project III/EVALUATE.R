library(pROC)
j = 1
#setwd(paste("split_", j, sep=""))
setwd(paste("~/Library/Mobile Documents/com~apple~CloudDocs/Documents/UIUC/STAT 542/Project III/split_", j, sep = ""))
#source("mymain.R")
# move test_y.tsv to this directory
test.y <- read.table("test_y.tsv", header = TRUE)
pred <- read.table("mysubmission.txt", header = TRUE)
test <- read.table("test.tsv", stringsAsFactors = FALSE,
                   header = TRUE)
pred <- merge(pred, test.y, by="id")
roc_obj <- roc(pred$sentiment, pred$prob)
pROC::auc(roc_obj)


