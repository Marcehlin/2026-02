x <- c(-8.7, -8.3, -8.2, -7.2, -6.1, -6, -4.1, -2, -1.9, -1.6, -1.3, -0.2, 0.7, 1.3, 1.6, 2.1, 2.2, 4.0, 5.6, 5.9,
6.2, 6.6, 6.7, 8.1)

y <- c(-0.6, -0.8, -1.3, -1.9, -2.0, -2.1, -4.0, -4.6, -4.7, -5.5, -5.6, -6.0, 4.6, 4.4, 4.2, 3.9, 3.8, 3.5, 3.1,
2.6, 2.0, 1.2, 0.6, 0.4)

dados <- cbind(x,y)

plot(dados,main="Gráfico de dispersão",xlab="X",ylab="Y")

cor_obs <- cor(dados[,1],dados[,2])

set.seed(100)

B1 <- 100
cor_boot_B1 <-NULL
for (i in 1:B1){
	amostra<-sample(seq(1,nrow(dados),1),nrow(dados),replace=TRUE)
	cor_boot_B1[i]<-cor(dados[amostra,1],dados[amostra,2])
}
hist(cor_boot_B1,breaks=20)
quantile(cor_boot_B1,c(0.025,0.975))
epb_B1 <-sqrt(var(cor_boot_B1))


B2 <- 500
cor_boot_B2 <-NULL
for (i in 1:B2){
	amostra<-sample(seq(1,nrow(dados),1),nrow(dados),replace=TRUE)
	cor_boot_B2[i]<-cor(dados[amostra,1],dados[amostra,2])
}
hist(cor_boot_B2,breaks=20)
quantile(cor_boot_B2,c(0.025,0.975))
epb_B2 <-sqrt(var(cor_boot_B2))

B3 <- 1000
cor_boot_B3 <-NULL
for (i in 1:B3){
	amostra<-sample(seq(1,nrow(dados),1),nrow(dados),replace=TRUE)
	cor_boot_B3[i]<-cor(dados[amostra,1],dados[amostra,2])
}
hist(cor_boot_B3,breaks=20)
quantile(cor_boot_B3,c(0.025,0.975))
epb_B3 <-sqrt(var(cor_boot_B3))

B4 <- 5000
cor_boot_B4 <-NULL
for (i in 1:B4){
	amostra<-sample(seq(1,nrow(dados),1),nrow(dados),replace=TRUE)
	cor_boot_B4[i]<-cor(dados[amostra,1],dados[amostra,2])
}
hist(cor_boot_B4,breaks=20)
quantile(cor_boot_B4,c(0.025,0.975))
epb_B4 <-sqrt(var(cor_boot_B4))
