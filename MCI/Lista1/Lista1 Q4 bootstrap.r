droga <- c(3.2, 2.1, 2.3, 1.2, 1.5)
placebo <- c(3.4, 3.5, 4.1, 1.7, 2.1)

library(bootstrap)

dif <- droga - placebo

set.seed(0925)
B <- 5000

boot_T1 <- NULL

boot_T1 <-bootstrap(dif,B,function(x,i) mean(x[i]))

T1_corrigido <- 2*mean(dif)-mean(boot_T1$thetastar)

epb <- sqrt(var(boot_T1$thetastar))

IC_95 <- quantile(boot_T1$thetastar,c(0.025,0.975))

IC_95_corrigido <- c(mean(dif) - 1.96*epb, mean(dif) + 1.96*epb)

dif_trans <- dif - mean(dif)

reamostras <- bootstrap(dif_trans,B,function(x,i) mean(x[i]))

valor_p <- sum(abs(reamostras$thetastar)>=abs(mean(dif)))/B

t.test(droga,placebo,paired=TRUE)
