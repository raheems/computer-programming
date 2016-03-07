# Module 10

############################
##### Data Generation  #####
############################

# Random number generation:

# Random numbers froma  normal distribution 
# qith mean 0 and variance 4
set.seed(1)
rnorm(10, mean = 0, sd = 2)


data1 <- matrix(rnorm(20*5), ncol=5)
dim(data1)

head(data1)

# MV normal data generation
library(MASS)

?mvrnorm

# Generate MVN data from a population with 
# mean vector (0,0), and covariance matrix
# as shown below

Mu <- c(0,0)
Sig <- diag(2)
Mu
Sig

set.seed(1)
mvrnorm(10, mu = Mu, Sigma = Sig)

out <- mvrnorm(10, mu = Mu, Sigma = Sig)
apply(out, 2, mean)
cov(out)


# Function to create the covariance matrix

sig.gen <- function(cc = .5, dim = 3)
{
  sig <- matrix(rep(cc, dim*dim), ncol=dim)
  #sig
  diag(sig) <- 1
  sig
}

sig.gen()
sig.gen(cc = .2, dim = 4)
















corgen <- function (cc = .5, sig)
{
  # cc  : correlation coefficient
  m <- length(sig) # number of elements in sigma
  VC <-diag(m)
  for (i in seq(m)) {
    for (j in seq(m)) {
      VC[i,j] <- cc * sqrt(sig[i] * sig[j])
    }
  }
  diag(VC) <- sig
  VC
}

# Testing the corgen() function
Sigma <- corgen(cc = .2, sig = rep(1,10) )
Sigma


cc <- .3
Sigma <- corgen(cc = cc, sig = rep(1, 10))
X <- mvrnorm(n = n, mu = rep(0, p), Sigma)


# The paste() function and its use

paste("x", 1:3)
paste("x", 1:3, sep = "")

# Use of paste()
mat3 <- matrix(1:9, ncol=3)
paste("x", 1:3, sep = "")

colnames(mat3) <- paste("x", 1:3, sep = "")
mat3


# Giving column names without assigning them to
# the environment
class(mat3)
mat3$x1
mat3[, 1]

x1 

# The assign() function
# Assigns a value to a name

x <- "A"
assign(x, 4)
A

xmat <- matrix(1:9, ncol=3)
xmat

#We can give column names 
colnames(xmat) <- c("x1", "x2", "x3")

v <- paste("x", 1:2, sep="")

out <- mvrnorm(5, mu = Mu, Sigma = Sig)
vname <- NULL
for(i in 1:2){
  vname[i] <- paste("x", i, sep = "")
  assign(vname[i],out[,i])
}
out
x1
x2

colnames(out) <- vname


# #######################################
# attach() and assign() function compared
# #######################################

names(faithful) # there are two variables

# Summary of original variable
summary(faithful$waiting)

attach(faithful)

summary(waiting) # same as the original, as it should be

# Modify the waiting variable
waiting <- waiting * 10 # its now a NEW variable

summary(waiting) # the NEW variable
summary(faithful$waiting) # the original variable

# remove the NEW waiting variable
rm(waiting)
summary(waiting) # you get the original variable

waiting <<- waiting * 20 # creates a COPY of the original
summary(waiting) # modifies the copied variable

detach(faithful)
summary(faithful$waiting)  # original variable


# #######################################
# Activity 4
# #######################################



