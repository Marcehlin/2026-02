library(bootstrap)

z <- c(7,5,12,-3,-5,2,14,18,19,21,-1)

set.seed(0925)
B <- 5000

boot_T1 <- NULL

boot_T1 <-bootstrap(z,B,function(x,i) mean(x[i]))

hist(boot_T1$thetastar,breaks=20)

epb<-sqrt(var(boot_T1$thetastar))

T1_corrigido <- 2*mean(z)-mean(boot_T1$thetastar)

IC_95 <- quantile(boot_T1$thetastar,c(0.025,0.975))

IC_95_corrigido <- c(T1_corrigido-1.96*epb,T1_corrigido+1.96*epb)

z_trans <- z-mean(z)

reamostras <- bootstrap(z_trans,B,function(x,i) mean(x[i]))

valor_p <- sum(abs(reamostras$thetastar)>=abs(mean(z)))/B
