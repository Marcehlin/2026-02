x <- c(0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5)
y <- c(0, 0, 20, 0, 40, 60, 40, 80, 100, 100)

#1
plot(x,y,main="Gráfico de dispersão",xlab="X",ylab="Y")

#2
modelo <- lm(y~x)
plot(x,y,main="Gráfico de dispersão",xlab="X",ylab="Y")
abline(lm(y~x), col="red")

#3
y_0 <- predict(modelo, newdata=data.frame(x=0.5))
y_0

#4

set.seed(0929)

X <- cbind(1,x)
Y <- matrix(y,ncol=1)

betac <- solve(t(X)%*%X)%*%t(X)%*%Y
predito <- X%*%betac
residuos <- Y-predito

#reamostragem de resíduos
B <- 5000
beta0_boot <- NULL
beta1_boot <- NULL

for(i in 1:B){
  amostra <- sample(seq(1,nrow(residuos),1),nrow(residuos),replace=TRUE)
  Y_star <- predito + residuos[amostra,]
  betac_star <- solve(t(X)%*%X)%*%t(X)%*%Y_star
  beta0_boot[i] <- betac_star[1,]
  beta1_boot[i] <- betac_star[2,]
}

par(mfrow=c(2,2))
hist(beta0_boot,breaks=25,main="Ream. dos residuos")
hist(beta1_boot,breaks=25,main="Ream. dos residuos")
#
### Intervalos de confiança 95% para alfa e beta
quantile(beta0_boot,c(0.025,0.975))
quantile(beta1_boot,c(0.025,0.975))

mean(beta0_boot)
mean(beta1_boot)


###### bootstrap nos pares (X,Y)
B <- 5000
beta0_boot_par <- NULL
beta1_boot_par <- NULL

for(i in 1:B){
  amostra <- sample(seq(1,nrow(X),1),nrow(X),replace = TRUE)
  X_star <- X[amostra,]
  betac_star <- solve(t(X_star)%*%X_star)%*%t(X_star)%*%Y[amostra,]
  beta0_boot_par[i] <- betac_star[1,]
  beta1_boot_par[i] <- betac_star[2,]
}

par(mfrow=c(2,2))
hist(beta0_boot_par,breaks=25,main="Ream. dos pares")
hist(beta1_boot_par,breaks=25,main="Ream. dos pares")

### Intervalos de confiança 95% para alfa e beta
quantile(beta0_boot_par,c(0.025,0.975))
quantile(beta1_boot_par,c(0.025,0.975))

mean(beta0_boot_par)
mean(beta1_boot_par)
