# This script is part of the Supporting Materials for:
# De Vleeschouwer et al. (2017), Alternating southern and northern Hemisphere Climate Response to Astronomical Forcing during the past 35 Million Years, Geology, v. XX, no. YY 
# doi:10.1130/G38663.1 

# The script uses the free stastical software R, the package 'Astrochron' (Meyers, 2014) and the package GP (Crucifix, https://github.com/mcrucifix/gp)
# to generate benthic oxygen isotope response figures, as shown in Figures 2 and 3 in the manuscript.

rm(list = ls())
require(astrochron)
require(GP)

# The packages below are used for plotting. filled.contour2.R can be downloaded from http://wiki.cbr.washington.edu/qerm/sites/qerm/images/4/44/Filled.contour2.R
source("$PATH/filled.contour2.R")
require(fields)
require(gridExtra) # also loads grid
require(lattice)
require(fields)
require(cowplot)

# Read the megasplice data. The "minimal" refers to the minimal tuning approach adopted to avoid circular reasoning. 
# This means that the agemodels of Site 1267 and Site 1218 have been modified to maximum one tie point between depth and age every 100 kyr.
Input <- read.csv('Splice_Geology_minimal.csv', sep=",",header=T)
Input <- Input[ - which(duplicated(Input[,3])), ]

# Set the boundaries of the time slice you are interested in
T_young=0
T_old=0.8

T <- Input[,1]
times <- which(T < T_old & T > T_young)

# Immediately scaling according to definition in methods.
# Scaled inputs will be scaled back afterwards for plotting purposes.
X <- data.frame(  T = (Input[times,1]-((T_young+T_old)/2))/0.2,
                  Obl = (Input[times,6]-23.25)/0.4, 
                  P = Input[times,7]/0.025, 
                  C = Input[times,8]/0.025)

Y <- cbind(Input[times,1],Input[times,2])
Ym <- mean(Y[,2])
Y <- as.numeric(Y[,2])
plot(Input[times,1],Y,type="l")

# We set all scaling lengths to 2, and optimize the nugget.
theta = c(2,2,2,2)
to_optim <- function(par)
{ lambda <- list ( theta = theta, nugget = exp ( par [1]))
  lik <- GP_C(X, Y, lambda = lambda)$log_pen_REML
  print(par)
  print(lambda)
  print(lik)
  -lik}

par=rep(0,1) 
o <- optim(par, to_optim, lower=c(-2),upper=c(3),method="Brent")

lambda <- list ( theta = theta, nugget = exp ( o$par [1]))

# We calibrate the Gaussian process, using the function GP_C, on experiment design X (containing time, obliquity, esin(w) and ecos(w)) with data Y (benthic isotope measurements) and hyperparameters lambda. 

E1 <- GP_C(X, Y, lambda)

# We set up a grid for plotting
esinw = seq(-2,2,0.1)
ecosw = seq(-2,2,0.1)
obl=seq(-2,2,0.1)

n = length(esinw)

X12 = expand.grid(obl, esinw)
X23 = expand.grid(esinw, ecosw)
XP23  = cbind(0, 0, X23)
XP12 = cbind(0, X12, 0)

# Here, we obtain the d18O predictions of the calibrated guassian process for the grid that was set up in the previous step.
out12_generic =  GP_P(x=XP12, E=E1)
out23_generic =  GP_P(x=XP23, E=E1)
out12 = matrix ( out12_generic$yp, n,n)
out23 = matrix ( out23_generic$yp, n,n)

# We obtain uncertainties (1 sigma) on the predicted values
out12_sd = sqrt ( matrix ( out12_generic$Sp_diag_nuggetfree, n,n) )
out23_sd = sqrt ( matrix ( out23_generic$Sp_diag_nuggetfree, n,n) )

# We set up the steps between colors in the final plot (in all plots, a step between two colours amounts 0.02 permil)
breaks=seq(mean(out12)-3.5*sd(out12),mean(out12)+3.5*sd(out12),0.02)

# We delete predicted values for which the combination of inputs is physically impossible (e.g. in esinw - ecosw space), or predicted values that are poorly-constrained by the input data 
plot_borderP=2 # By making this parameter a function of the variance of esin(w) in the input (e.g. 2*sd(X$P)), one can scale the radius of the esinw/ecosw plot with eccentricity configurations in the considered time slice
plot_borderO=2 # By making this parameter a function of the variance of obliquity in the input (e.g. 2*sd(X$O)), one can scale the width of the obl/esinw plot with obliquity configurations in the considered time slice
todelete=c(0)
todeleteO=c(0)
for(i in 1:1681) 
{todelete[i]=((XP23[i,3])^2 + (XP23[i,4])^2 > plot_borderP^2)
 todeleteO[i]=((abs(XP12[i,2])) > plot_borderO | abs(XP12[i,3]) > plot_borderP)
}
todelete=matrix(todelete,nrow = 41,ncol = 41)
todeleteO=matrix(todeleteO,nrow = 41,ncol = 41)

for(i in 1:41) {
  for(j in 1:41){ 
    if (todelete[i,j]==1){
      out23[i,j]=NaN
      out23_sd[i,j]=NaN}
    if (todeleteO[i,j]==1){
      out12[i,j]=NaN
      out12_sd[i,j]=NaN}}}

# Plotting ----
dev.off()

#### Figures 2 and 3 ----
# Panels A or D
plot(Input[,1],Input[,2],type="l",ylab=expression(paste(delta,"18O (‰ VPD-B)")),xlab="Age (Ma)",ylim=rev(c(0.5,4.5)),xlim=c(0,35),tck=0.01)
rect(T_young, 4.7, T_old, 0.3,border = "cornflowerblue",lwd=3)

# Panels B or E
legend <- filled.contour(obl*0.4+23.25,esinw*0.025,out12,col=rev(tim.colors(length(breaks)-1)),xlim=c(22, 24.5),ylim=c(-0.06,0.06),xlab="obliquity (?)", ylab="e sin(w)",tck=0.015,levels=breaks)
plot12 <- filled.contour2(obl*0.4+23.25,esinw*0.025,out12,col=rev(tim.colors(length(breaks)-1)),xlim=c(22, 24.5),ylim=c(-0.06,0.06),xlab="obliquity (?)", ylab="e sin(w)",tck=0.015,levels=breaks)

# Panels C or F
plot23 <- filled.contour2(esinw*0.025, ecosw*0.025,out23,levels=breaks,col=rev(tim.colors(length(breaks)-1)),xlim=c(-0.06, 0.06),ylim=c(-0.06,0.06),xlab="e sin(w)",ylab="e cos(w)",tck=0.015)
text(c(-0.055,-0.0476,-0.0275,0,0.0275,0.0476,0.055,0.0476,0.0275,0,-0.0275,-0.0476),c(0,0.0275,0.0476,0.055,0.0476,0.0275,0,-0.0275,-0.0476,-0.055,-0.0476,-0.0275),labels=c("Dec","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov"))

#### Supplementary Figures ----
breaks_sd=seq(0.02,0.15,0.005)
legend <- filled.contour(obl*0.4+23.25,esinw*0.025,out12_sd,col=topo.colors(length(breaks_sd)-1),xlim=c(22, 24.5),ylim=c(-0.06,0.06),xlab="obliquity (°)", ylab="e sin(w)",levels=breaks_sd)

plot12 <- filled.contour2(obl*0.4+23.25,esinw*0.025,out12_sd,col=topo.colors(length(breaks_sd)-1),xlim=c(22, 24.5),ylim=c(-0.06,0.06),xlab="obliquity (°)", ylab="e sin(w)",levels=breaks_sd)

plot23 <- filled.contour2(esinw*0.025, ecosw*0.025,out23_sd,levels=breaks_sd,col=topo.colors(length(breaks_sd)-1),xlim=c(-0.06, 0.06),ylim=c(-0.06,0.06),xlab="e sin(w)",ylab="e cos(w)")
text(c(-0.055,-0.0476,-0.0275,0,0.0275,0.0476,0.055,0.0476,0.0275,0,-0.0275,-0.0476),c(0,0.0275,0.0476,0.055,0.0476,0.0275,0,-0.0275,-0.0476,-0.055,-0.0476,-0.0275),labels=c("Dec","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov"))
