# Module 

############################
##### Cross Validation #####
############################

head(LifeCycleSavings)
dim(LifeCycleSavings)

y <- LifeCycleSavings$sr
x <- LifeCycleSavings[, -1]
head(x)


K <- 10

# rep()
rep(1, 10)
rep(2, 10)

rep(1:10, 2)

rep(1:10, length=12)




MSE <- NULL
set.seed(2)
kfolds <- split(sample(1:n), rep(1:K, length = n)) ## splitting data into all.folds
kfolds

for (i in seq(K)) {
     i = 1
  #   i = 2
  tseti <- kfolds[[i]] ## selecting the indices for the test set
  
  trainx <- x[- tseti, ] ## training data
  trainy <- y[- tseti]
  testx <- as.data.frame(x[tseti,]) ## test data
  testy <- as.data.frame(y[tseti])
  
  # Data matrix for fitting models
  data.internal <- as.data.frame(cbind(trainx, trainy = trainy))
    # dim(data.internal)
  
  fit <- lm(trainy ~ ., data = data.internal)
  predict(fit, testx)
  MSE[i] <- sum((testy- predict(fit, testx))^2)
}

MSE


# Try this:
library(boot) # load the boot library
edit(cv.glm) 



# Activity 1  Module 9 ###
############################

K <- 10
n <- nrow(LifeCycleSavings)

x <- LifeCycleSavings[,-1]
y <- LifeCycleSavings[,1]

kfolds <- split(sample(1:n), rep(1:K, length = n)) ## splitting data into all.folds
kfolds


reg.sim <- function(R = 10, K = 10)
{
  out <- NULL
  MSE <- NULL
  #set.seed(2)
    
  for(j in seq(R)) 
  {
    kfolds <- split(sample(1:n), rep(1:K, length = n)) ## splitting data into all.folds
    
    for (i in seq(K)) {
      # i = 1
      # i = 2
      tseti <- kfolds[[i]] ## selecting the indices for the test set
      
      trainx <- x[- tseti, ] ## training data
      trainy <- y[- tseti]
      testx <- as.data.frame(x[tseti,]) ## test data
      testy <- as.data.frame(y[tseti])
      
      # Data matrix for fitting models
      data.internal <- as.data.frame(cbind(trainx, trainy = trainy))
      # dim(data.internal)
      
      fit <- lm(trainy ~ ., data = data.internal)
      predict(fit, testx)
      MSE[i] <- sum((testy- predict(fit, testx))^2)
    } # end of inner loop
    
    out[j] <- mean(MSE)
    
  } # end of outer loop
  
  out
} # end of function

# Output for K=5
res5 <- reg.sim(R= 500, K = 5)
res7 <- reg.sim(R = 500, K = 7)
res10 <- reg.sim(R= 500, K = 10)

# Plotting
plot(res5, type="l", col="red")

plot(res10, type="l", col="blue")


summary(res5)
summary(res10)


# Plotting both on the same graph
plot(res5, type="l", col="red", 
     ylim = c(70, 300))

lines(res10, type="l", col="blue")
lines(res7, type="l", col="black")


legend("topleft", 
       legend = c("K=10", "K=7", "K=5"),
       lty = c(1,1, 1),
       col = c("blue", "black", "red")
       )

