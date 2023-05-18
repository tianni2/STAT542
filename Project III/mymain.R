#####################################
# Load your vocabulary and training data
#####################################
myvocab <- scan(file = "myvocab.txt", what = character())
train = read.table("train.tsv",
                   stringsAsFactors = FALSE,
                   header = TRUE)
#####################################
train$review <- gsub('<.*?>', ' ', train$review)
it_train = itoken(train$review,
                  preprocessor = tolower, 
                  tokenizer = word_tokenizer)
vectorizer = vocab_vectorizer(create_vocabulary(myvocab, 
                                                ngram = c(1L, 2L)))
dtm_train = create_dtm(it_train, vectorizer)
set.seed(542)
ridge=cv.glmnet(x = dtm_train, 
                y = train$sentiment, 
                alpha = 1,
                family='binomial')
#####################################

test <- read.table("test.tsv", stringsAsFactors = FALSE,
                   header = TRUE)
test$review <- gsub('<.*?>', ' ', test$review)
it_test = itoken(test$review,
                 preprocessor = tolower, 
                 tokenizer = word_tokenizer)
vectorizer = vocab_vectorizer(create_vocabulary(myvocab, 
                                                ngram = c(1L, 2L)))
dtm_test = create_dtm(it_test, vectorizer)
#####################################
# Compute prediction 
# Store your prediction for test data in a data frame
# "output": col 1 is test$id
#           col 2 is the predicted probabilities
#####################################
pred.ridge=predict(ridge,newx=data.matrix(dtm_test),type = "response",lambda=ridge$lambda.min)
output=as.data.frame(cbind(test$id,pred.ridge))
colnames(output)=c("id","prob")
write.table(output, file = "mysubmission.txt", 
            row.names = FALSE, sep='\t')