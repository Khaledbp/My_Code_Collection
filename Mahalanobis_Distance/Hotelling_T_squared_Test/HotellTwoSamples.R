# 14/12/2015
# This program performs a Hoteling two sample T-square test for 
# the equality of two population mean vectors assuming a common 
# covariance matrix. 
# It also gives the Garthwaite-Koch partition which evaluates 
# the contibutions of individual variables to the test statistic,
# both as the actual value and a percentage.

# The program requires two data matrices as input, one for each sample. 
# The next few lines must be modified to give the addresses of the two input 
# files (.txt files) that contain the data.
# Each file should have a header line naming the variables. Names must differ 
# in the two files (e.g a variable might be called "weight" in one file and 
# "weight2" in the other.) A name must not include spaces. Each subsequent 
# line gives the values of the variables for one datum, separated by spaces. 

# Reading in the data:
rawdataA <- read.table("P:/WebPages/FemaleAthletes.txt",header=TRUE)
rawdataB <- read.table("P:/WebPages/MaleAthletes.txt",header=TRUE)

attach(rawdataA)
attach(rawdataB)
namesA <- names(rawdataA)
datamatA <- cbind(rawdataA)
datamatB <- cbind(rawdataB)

# The last seven lines are just one way of reading in the data.
# They can be replaced by any method that gives matrices datamatA 
# and datamatB (containing the two sets of sample data) and a vector 
# namesA that gives the names of the variables. (The names in rawdataB 
# are not used.)

# If only a subset of the varibles are to be used in the analysis, then
# the "datamatA" and "datamatB" statements should be modified to include 
# just the required variables. 
# e.g  datamatA <- cbind(length,heightL,diagnl) and
# datamatB <- cbind(length2,heightL2,diagnl2)


# Next determine dimensions of matrices. ncA and ncB must be equal
nrA=nrow(datamatA)
nrA
nrB=nrow(datamatB)
nrB
ncA=ncol(datamatA)
ncA
ncB=ncol(datamatB)
ncB

# Next obtain means and common variance
meanA<-colMeans(datamatA)
meanB<-colMeans(datamatB)
diff <- meanA -meanB

varA <- var(datamatA)
varB <- var(datamatB)
poolvar <- (((nrA-1)*varA) + ((nrB-1)*varB))/(nrA+nrB-2)
poolinv <- solve(poolvar)

# poolinv contains the inverse of the pooled estimate of the 
# common variance-covariance matrix and diff contains the 
# difference between the two sample means.

# Next perform Hotelling's two sample T-square test
Qform <- t(diff) %*% poolinv %*% diff
dfAB <- (nrA + nrB - ncA) - 1
Tsquare <- ((nrA*nrB)/(nrA+nrB)) * Qform[1,1]
Fval <- round(dfAB * Tsquare / (ncA*(nrA+nrB-1)),digit=4)
pval <- pf(Fval, df1=ncA, df2=dfAB,lower.tail = FALSE)

# Next prepare result of test for printing, though printing is all done at the end.
pval2<- round(pval,digits=5)
Tval <- round(Tsquare, digits=4)
txt1 <- c(" "," ","RESULT FROM THE TWO-SAMPLE HOTELLING T-SQUARED TEST2",
"THAT THE TWO POPULATION MEANS ARE EQUAL.",
paste("The value of Hotelling's T-squared is: ",Tval,"   (F-value = ",Fval,")"),
paste("Comparing F-value with an F-distribution on",ncA," and ",dfAB,"degrees of freedom"),
paste("gives a p-value of",pval2," (",pval,")"))


# Start of Garthwaite-Koch partition
InvSD <- rep(0,ncA)
for(i in 1:ncA){InvSD[i] <- 1/sqrt(poolvar[i,i])}
Dmat<-diag(InvSD)
DSD <- Dmat %*% poolvar %*% Dmat

# We next calculate the inverse of the symmetric square-root of DSD
eig <- eigen(DSD)
InvRootEig <- rep(0,ncA)
for(i in 1:ncA){InvRootEig[i] <- 1/sqrt(eig$val[i])}
InvDSDhalf <-  eig$vec %*% diag(InvRootEig) %*% t(eig$vec)

# Next obtain the contibutions to Qform
W <- InvDSDhalf %*% Dmat %*% diff
Wsquared <- diag(W %*% t(W))
# the elements of Wsquared are the contributions of individual 
# variables to Qform

# Next get the Garthwaite-Koch contributions of individual variables
# to the test statistic and also convert them to percentages.
GKcontrib <- ((nrA*nrB)/(nrA+nrB)) * Wsquared
# the elements of GKcontrib are the contributions of individual variables
# to Hotelling's T-square.

Percentage <- round(100 * GKcontrib /sum(diag(GKcontrib)), digits=3)
# Percentage holds the percentage contributions of 
# individual variables to Hotelling's T-square.

# We next obtain the correlations betwen each variable and its surrogate
# They are the diagonal elements of DSDhalf:
Correlation <- round(diag(solve(InvDSDhalf)),digits=4)


# We now prepare reults from the partition for printing.
Contribution <- as.numeric(round(GKcontrib, digits=3))
GKframe <- data.frame(cbind(Contribution, Percentage, Correlation))
GKpartition <- cbind("Variable"=namesA, GKframe)
txt2 <- c(" "," ","The following table gives the contribution of each variable", 
"to Hotelling's T-squared statistic as evaluated by the Garthwaite-Koch partition;",
"the perentage contribution of each variable; and the correlation between",
"each variable and the orthogonal variable with which it is paired.")

# Now print results
writeLines(txt1)
writeLines(txt2)
GKpartition


# end of program































