
# rating
myurl= "https://liangfgithub.github.io/MovieData/"
ratings = read.csv(paste0(myurl, 'ratings.dat?raw=true'), 
                   sep = ':',
                   colClasses = c('integer', 'NULL'), 
                   header = FALSE)
colnames(ratings) = c('UserID', 'MovieID', 'Rating', 'Timestamp')

ratings$Timestamp = NULL

# movies
movies = readLines(paste0(myurl, 'movies.dat?raw=true'))
movies = strsplit(movies, split = "::", fixed = TRUE, useBytes = TRUE)
movies = matrix(unlist(movies), ncol = 3, byrow = TRUE)
movies = data.frame(movies, stringsAsFactors = FALSE)
colnames(movies) = c('MovieID', 'Title', 'Genres')
movies$MovieID = as.integer(movies$MovieID)

# convert accented characters
movies$Title[73]
movies$Title = iconv(movies$Title, "latin1", "UTF-8")
movies$Title[73]

# extract year
movies$Year = as.numeric(unlist(
  lapply(movies$Title, function(x) substr(x, nchar(x)-4, nchar(x)-1))))



# First create the utility matrix of rating which stored as a sparse matrix
i = paste0('u', ratings$UserID)
j = paste0('m', ratings$MovieID)
x = ratings$Rating
tmp = data.frame(i, j, x, stringsAsFactors = T)
Rmat = sparseMatrix(as.integer(tmp$i), as.integer(tmp$j), x = tmp$x)
rownames(Rmat) = levels(tmp$i)
colnames(Rmat) = levels(tmp$j)
Rmat = as(Rmat,'realRatingMatrix')


recommender.UBCF <- Recommender(Rmat, method = "UBCF",
                                parameter = list(normalize = 'Z-score', 
                                                 method = 'Cosine', 
                                                 nn = 10, weighted=FALSE))
pred.UBCF=function(rating) {
  movieIDs = colnames(Rmat)
  n.item = ncol(Rmat)
  # length(unique(ratings$MovieID)) # as as n.item
  new.ratings = rep(NA, n.item)
  for(i in 1:length(rating$MovieID)){
    new.ratings[which(movies$MovieID==rating$MovieID[i])] = rating$Rating[i]
  }
  new.user = matrix(new.ratings, 
                    nrow=1, ncol=n.item,
                    dimnames = list(
                      user=paste('new_user'),
                      item=movieIDs
                    ))
  new.Rmat = as(new.user, 'realRatingMatrix')
  
  
  rec=predict(recommender.UBCF, new.Rmat, 
                     type="topN")
  
  return(rec)
}


