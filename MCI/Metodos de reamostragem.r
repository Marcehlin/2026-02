# O exemplo a seguir se trata de uma amostra aleatória de tamanho n=15 retirada de uma população de
# N=82 escolas de direito. Duas medidas foram feitas em turmas inteiras de cada universidade:
# LSAT= nota média da classe no exame nacional de direito e
# GPA= nota média da classe na graduação.
# O interesse é verificar se existe associação entre LSAT e GPA e qual a acurácia dessa estimativa.
# Como para esses dados temos a população toda, também queremos comparar a distribuição da estimativa
# encontrada via método bootstrap com a distribuição obtida via amostras iid da população.
#
library(bootstrap)
data(law) # apenas a amostra
law
plot(law[,1],law[,2])
cor(law[,1],law[,2]) #coeficiente de correlação de Pearson
#
#
B<-3200
cor_boot<-NULL
set.seed(100)
for (i in 1:B){
	amostra<-sample(seq(1,nrow(law),1),nrow(law),replace=TRUE)
	cor_boot[i]<-cor(law[amostra,1],law[amostra,2])
}
hist(cor_boot,breaks=20)
epb<-sqrt(var(cor_boot))

vicio_boot<-mean(cor_boot)-cor(law[,1],law[,2])
quantile(cor_boot,c(0.025,0.975))
#
########## amostras iid da população 
#
data(law82) # população toda
law82
plot(law82[,2],law82[,3])
cor(law82[,2],law82[,3]) # valor do coeficiente de correlação na população (valor do parâmetro)
#
B<-3200
cor_amostras<-NULL
set.seed(100)
for (i in 1:B){
	amostra<-sample(seq(1,nrow(law82),1),nrow(law),replace=TRUE)
	cor_amostras[i]<-cor(law82[amostra,2],law82[amostra,3])
}
#
######## comparando a distribuição exata do coeficiente de correlação de Pearson (via amostras iid da
# população) com a distribuição aproximada desse estimador via bootstrap da amostra de n=15
#
par(mfrow=c(1,2))
hist(cor_boot,breaks=20)
hist(cor_amostras,breaks=20)
#
###### corrigindo o vício do estimador de uma uniforme(0,theta)
#
set.seed(10)
n<-15 ## depois mudar para 100
x<-runif(n,0,100)
x
theta_ch<-max(x)
theta_ch
#
#### vício bootstrap
#
B<-5000
thet_boot<-NULL
set.seed(100)
for (i in 1:B){
	amostra<-sample(seq(1,length(x),1),length(x),replace=TRUE)
	thet_boot[i]<-max(x[amostra])
}
thet_star<-mean(thet_boot)
thet_corr<-2*theta_ch-thet_star
theta_ch
thet_corr
#
########## Intervalos de confiança
#
library(bootstrap)
data(law) # apenas a amostra
plot(law[,1],law[,2])
ro_chapeu<-cor(law[,1],law[,2])
#
#
B<-3200
cor_boot<-NULL
set.seed(100)
for (i in 1:B){
	amostra<-sample(seq(1,nrow(law),1),nrow(law),replace=TRUE)
	cor_boot[i]<-cor(law[amostra,1],law[amostra,2])
}
epb<-sqrt(var(cor_boot))
#
### IC supondo normalidade - 95% de confiança
#
LIN<-ro_chapeu-1.96*epb
LSN<-ro_chapeu+1.96*epb
#
### IC percentil - 95% de confiança
#
LIP<-quantile(cor_boot,0.025)
LSP<-quantile(cor_boot,0.975)
#
hist(cor_boot,breaks=20, main='',xlim=c(0,1.2))
abline(v=LIN)
abline(v=LSN)
abline(v=LIP,col='red')
abline(v=LSP,col='red')
ro_verd<-0.76
abline(v=ro_verd,col='blue')
#
###### Intervalo de confiança para diferença de duas médias
#
set.seed(100)
x<-rgamma(20,1,1) # depois trocar n para 100
y<-rgamma(20,1,2)
mean(x)
mean(y)
#
B<-5000
dif_boot<-NULL
set.seed(100)
for (i in 1:B){
	amostra1<-sample(seq(1,length(x),1),length(x),replace=TRUE)
	amostra2<-sample(seq(1,length(y),1),length(y),replace=TRUE)	
	dif_boot[i]<-mean(x[amostra1])-mean(y[amostra2])
}
hist(dif_boot)
IC<-quantile(dif_boot,c(0.025,0.975))
IC
#
########## Teste de hipóteses
#
y<-c(94,197,16,38,99,141,23)
ytrans<-y-mean(y)+129
#
set.seed(100)
B<-5000
estT<-NULL
for (b in 1:B){
	amostra<-sample(seq(1,length(ytrans),1),length(ytrans),replace=TRUE)
	estT[b]<-(mean(ytrans[amostra])-129)/(sd(ytrans[amostra])/sqrt(7))
}
hist(estT,breaks=50)
valorp<-sum(estT<=-1.67)/B
valorp
#
########## Boostrap na regressão
#
#
# Considere um experimento em que se analisa a octanagem da gasolina (Y) em função da adição de um novo aditivo (x). Para isso, foram realizados ensaios com os percentuais de 1, 2, 3, 4, 5 e 6% de aditivo. Os estão disponíveis abaixo:
#
x<-c(1,2,3,4,5,6)
y<-c(80.5,81.6,82.1,83.7,83.9,85.0)
plot(x,y,pch=16,ylab="Octanagem",xlab="Conc. de aditivo")
#
X<-cbind(1,x)
X
Y<-matrix(y,ncol=1)
Y
betac<-solve(t(X)%*%X)%*%t(X)%*%Y
predito<-X%*%betac
residuos<-Y-predito
#
###### bootstrap nos resíduos
#
B<-3000
alpha_boot<-NULL
beta_boot<-NULL
A<-solve(t(X)%*%X)%*%t(X)
set.seed(100)
for (i in 1:B){
	amostra<-sample(seq(1,nrow(residuos),1),nrow(residuos),replace=TRUE)
	Y_star<-predito+residuos[amostra,]
	betac_star<-A%*%Y_star
	alpha_boot[i]<-betac_star[1,]
	beta_boot[i]<-betac_star[2,]	
}
par(mfrow=c(2,2))
hist(alpha_boot,breaks=25,xlim=c(76,83),main="Ream. dos residuos")
hist(beta_boot,breaks=25,xlim=c(0.2,1.6),main="Ream. dos residuos")
#
### Intervalos de confiança 95% para alfa e beta
quantile(alpha_boot,c(0.025,0.975))
quantile(beta_boot,c(0.025,0.975))
#
###### bootstrap nos pares (X,Y)
#
B<-3000
alpha_boot<-NULL
beta_boot<-NULL
set.seed(100)
for (i in 1:B){
	amostra<-sample(seq(1,nrow(X),1),nrow(X),replace=TRUE)
	X_star<-X[amostra,]
	betac_star<-solve(t(X_star)%*%X_star)%*%t(X_star)%*%Y[amostra,]
	alpha_boot[i]<-betac_star[1,]
	beta_boot[i]<-betac_star[2,]	
}
#par(mfrow=c(1,2))
hist(alpha_boot,breaks=25,xlim=c(76,83), main="Ream. dos pares")
hist(beta_boot,breaks=25,xlim=c(0.2,1.6), main="Ream. dos pares")
#
### Intervalos de confiança 95% para alfa e beta
quantile(alpha_boot,c(0.025,0.975))
quantile(beta_boot,c(0.025,0.975))



