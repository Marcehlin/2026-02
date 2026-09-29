library(bootstrap)
data(law) # apenas a amostra
law
plot(law[,1],law[,2])
cor(law[,1],law[,2]) #coeficiente de correlação de Pearson

cor_obs <- cor(law[,1],law[,2])

cor_jack <- NULL

for (i in 1:nrow(law)){
  cor_jack[i] <- cor(law[-i,1],law[-i,2])
}

hist(cor_jack,breaks=20)
epb_jack <- sqrt((nrow(law)-1)*var(cor_jack))

vicio_jack <- mean(cor_jack) - cor_obs

quantile(cor_jack,c(0.025,0.975))
