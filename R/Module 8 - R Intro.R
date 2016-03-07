x <- c(1, "A")

xmat <- matrix(c(1:9), ncol=3)
xmat

# Define the data frame from a matrix object
xmat.df <- as.data.frame(xmat)
xmat.df

# extract 3rd col of the data.frame
xmat.df$V3
xmat.df[, 3] # works with matrix & df both

# extracting the objects/variable names
# in a data-frame
names(xmat.df)

# Insert a new row at the end
rbind(xmat,c(4, 5, 8)) # matrix
rbind(xmat.df, c(1,1,1)) #data frame

# Create another matrix of zeros
# and rbind it with xmat
xmat
xmat2 <- matrix((rep(0, 9)), ncol=3)
xmat2  

xmat <- rbind(xmat, xmat2)
xmat

xmat <- xmat[1:3, ]
xmat  

# extract the odd rows
xmat <- xmat[c(1, 3, 5), ]
xmat  

# matrix multiplication
xmat %*% xmat2

# A = 3 by 3 matrix
A <- matrix(1:9, ncol=3)

# B= 2 by 3 matrix
B <- matrix(1:6, ncol=3)

A
B

A %*% B

A %*% t(B)

# Insert a new column
cbind(xmat, c(0,0,0))
cbind(xmat.df, c(1, 1, 1))
cbind(xmat.df, V4=c(1, 1, 1))

# Replace the third row
xmat[3, ] <- c(0,0,0)
xmat

# Replace second column of xmat
xmat[, 2]<- c(1,1,1)
xmat


# Matrix multiplication, transpose

xmat <- matrix(c(1, 2, 3, 2, 5, 6, 3, 7, 6), ncol=3)
xmat
solve(xmat)

A %*% B
A %*% t(B)

A <- matrix(1:9, ncol=3)
B <- A*.5


# For loop example
x <- 0
for (i in 1:10)
{
	x<-x+1
}
x

# Generating random numbers:
rnorm(how many?, mean = ?, sd = ?)


# Generate 30 numbers from st normal

set.seed(1)
n30 <- rnorm(30)
mean(n30)
sd(n30)

# 50 obs from normal 
# with mean=5, sd = 5

set.seed(13)
n50 <- rnorm(50, mean = 5, sd = 5)
mean(n50)
sd(n50)





# Use for loop to generate 5 random samples
# of size 10 from a standard normal distribution

store <- matrix(0, ncol = 5, nrow = 10)
for (i in 1:5)
{
 store[, i] <- rnorm(10)
}
store

# Calculate the means/sd of all the samples
# saved in the objec "store"

apply(store, 2, mean)

apply(store, 2, sd)


# Graphics with R

dta <- cars # save cars data to object "dta"
dim(dta) # inspect dimension of dta
names(dta) # listing the variable names
head(dta) # print first 6 obs from dta

plot(dta) # plots (x,y) 

# plot dist vs speed

plot(dta$dist, dta$speed, 
     xlab = "Distance",
     #ylab = expression(beta),
     ylab = "Speed")


pairs(dta)

names(faithful)

# Histogram
hist(faithful$waiting)

# Boxplot
boxplot(faithful)

# Graphic panels
par(mfrow=c(2,2))

hist(faithful$waiting, main="Plot 1")
hist(faithful$waiting, main="Plot 2")
hist(faithful$waiting, main="Plot 3")
hist(faithful$waiting, main="Plot 4")


# Activity
n <- 5
R <- 1000
xmean<- matrix(rnorm(R * n), ncol=n)

head(xmean)
dim(xmean)

apply(xmean, 2, mean)
hist(apply(xmean, 2, mean))

# Simple function to plot the histogram
# of sample means 

mean.sim <- function(n=30, R=1000)
{
  xmean<- matrix(rnorm(R * n), ncol = R)
  apply(xmean, 2, mean)
  hist(apply(xmean, 2, mean), main = paste(expression(n), "=", n),
       xlim=c(-1, 1),
       xlab = "", ylab = "Frequency")
}


par(mfrow=c(3,3))
mean.sim(n = 10)
mean.sim(n = 20)
mean.sim(n = 30)
mean.sim(n = 50)
mean.sim(n = 60)
mean.sim(n = 70)
mean.sim(n = 80)
mean.sim(n = 90)
mean.sim(n = 100)



sim <- function(n = c(), R = 1000)
{
  par(mfrow=c(2,2))
  for(j in 1:length(n))
  {
    xmean <- matrix(rnorm(R * n[j]), ncol = n[j])
    hist(apply(xmean, 2, mean))
  }
  
}

sim(n=c(10, 30, 100, 500), R= 500)


# If statement

x <- 10 

if (x==10) {y = x-1} else { y = x}


if(1==0) {
  print(1) 
} else { 
  print(2) 
}

# ifelse
ifelse((x==10), "Yup", "Nope")



## Linear regression
?longley
is.data.frame(longley)

# fitting linear model

fit <- lm(Employed ~., data =  longley)
fit

summary(fit)
plot(fit, which=1:4)
plot(fit)

# Plotting 1:3 and 6th graph
par(mfrow=c(2,2))
plot(fit, which=c(1:3, 6))

# Activity 2
# ############
names(fit)
y <- longley$Employed
yhat <- fit$fitted.values
ehat <- y - yhat
res <- fit$residuals

out <- cbind(y, yhat, ehat, res)

is.data.frame(out)

out <- as.data.frame(out)

is.data.frame(out)

# Another way to this:

out2 <- data.frame(y = longley$Employed, 
                   yhat = fit$fitted.values,
                   ehat = (y-yhat),
                   res = fit$residuals)
out2

is.data.frame(out2)

# Activity 3
# Use longley data

head(longley)
# Copy longley data to a new data set
# so that Employed is the first column

longley2 <- cbind(Employed = longley$Employed, 
                  longley[, 1:6])


# Another example of linear regression 
## Analysis of the life-cycle savings data
## given in Belsley, Kuh and Welsch.

?LifeCycleSavings
head(LifeCycleSavings)

lm.SR <- lm(sr ~ pop15 + pop75 + dpi + ddpi, data = LifeCycleSavings)
plot(lm.SR)

## 4 plots on 1 page;
## allow room for printing model formula in outer margin:
par(mfrow = c(2, 2), oma = c(0, 0, 2, 0))
plot(lm.SR)
plot(lm.SR, id.n = NULL)                 # no id's



# Extracting values from fitted object
names(fit)

fit$coefficients
fit$res


# Activity 3

# Creating a list object

{
  results <- list(name1 = name1, name2 = name2)
  results
}


# function

reg.fun <- function(data)
{
#   !is.data.frame(data) 
#   {
#     data = as.data.frame(data)
#   }
    fit <- lm(data[,1] ~ ., data = data[,-1])
    result <- list(call = match.call(), 
                   betas = fit$coefficients,
                   res = fit$residuals)
    result
}

is.matrix(xmat)
reg.fun(xmat)

!is.data.frame(xmat)

reg.fun <- function(data)
{
  if(!is.data.frame(data))
  {
    data = as.data.frame(data)
  }
fit <- lm(data[,1] ~ ., data = data[,-1])
result <- list(call = match.call(), 
               betas = fit$coefficients,
               res = fit$residuals)
result
}

reg.fun(xmat)

reg.fun(longley2)

reg.fun(longley)



# 

x <- 1
is.numeric(x)
!is.numeric(x)

test <- function(x)
{
  if(is.numeric(x))
  {
    print("Numeric")  
  }
  if(!is.numeric(x))
  {
    print("Not numeric")
  }
}

test(x)
# Resampling

# Knowing the sample() function first.
# Run ?sample  to view the help file

# Try these

# generate a sequence of numbers from 1 to 20
x <- seq(20)

# a random permutation 
sample(x, 5)
table(sample(x, 10))

# Sampling with replacement
sample(x, 5, replace = TRUE)

# Frequency table
table(sample(x, 5, replace = TRUE))

# Also works
sample(20, 5)


# Activity 4
# Repeat the SAS HW2 using R (for Exponential dist only)

# Geneate a population of numbers from exponential distribution
# with rate = 5

r1 <- rexp(1000, rate = 5)
hist(r1)

# Partial code for activity 4

# function exp.sim()
# pop: the population object where 
# the data will be sampled from

# n: sample size
# R: number of repeatitions

exp.sim <- function(pop, n, R = 1000)
{
  store <- matrix(0, nrow = n, ncol = R)
  for(i in 1:R)
  {
    store[, i] <- sample(pop, n, replace=T)
  }
  store
}

# Testing
system.time(out<- exp.sim(pop = r1, n = 5, R = 10000))

dim(out)

# sample 10 observations each


# Activity 5

lm.LC <- lm(sr ~ pop15 + pop75 + dpi + ddpi, data = LifeCycleSavings)
summary(lm.LC)


# Draw a sample of size 5 from LC data

sample(50, 5, replace=T)

sample(nrow(LifeCycleSavings), 5, replace=T)

# Extract 8th row from the data

LifeCycleSavings[8, ]

# Extract 8th and 34th row
LifeCycleSavings[sample(nrow(LifeCycleSavings), 5, replace=T), ]


# Sample code to start with
reg.sim <- function(R = 1000)
{
  betas <- matrix(0, ncol = R, nrow = 4)
  for (i in 1:R)
  {
    lm.LC <- lm(sr ~ pop15 + pop75 + dpi + ddpi, 
                data = LifeCycleSavings[sample(nrow(LifeCycleSavings), 50, replace=T), ])
    betas[, i] <- coef(lm.LC)[-1]  
  }
  betas
}

out <- reg.sim(R=999)
class(out)

dim(out)

# Drawing histogram of the betas
par(mfrow=c(2,2))
hist(out[1,])
hist(out[2,])
hist(out[3,])
hist(out[4,])


apply(out, 2, sd)

# 
# store <- NULL
# for (i in 1: 2^33)
# {
#   store[i] <- i
# }
# 
# store
