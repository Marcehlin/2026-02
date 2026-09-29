#
# Exemplo escore de Fisher - Distribuição gama com beta conhecido
#
V_func<-function(y,beta,alfa_ant){
	n<-length(y)
	sc<-n*log(beta)-n*digamma(alfa_ant)+sum(log(y))
	return(sc)}
#
I_func<-function(n,alfa_ant){
	I<-n*trigamma(alfa_ant)
	return(I)}
#
set.seed(10)
n<-100
bc<-2
x<-rgamma(100,1,bc) # trocar depois para alfa=10 e beta=1
mean(x)
var(x)
#
alfa<-0.1 # mudar o valor inicial para 10
m<-2
alfa[m]<-alfa[m-1]+solve(I_func(n,alfa[m-1]))%*%V_func(x,beta=bc,alfa[m-1])
while (abs(alfa[m]-alfa[m-1])>0.000001){
	alfa[m+1]<-alfa[m]+solve(I_func(n,alfa[m]))%*%V_func(x,beta=bc,alfa[m])
	m<-m+1}
#
# Exemplo escore de Fisher - Distribuição gama com alfa e beta desconhecidos
#
V_func_2<-function(y,beta_ant,alfa_ant){
	n<-length(y)
	sc1<-n*log(beta_ant)-n*digamma(alfa_ant)+sum(log(y))
	sc2<-n*alfa_ant/beta_ant - sum(y)
	return(matrix(c(sc1,sc2),ncol=1))}
#
I_func_2<-function(n,alfa_ant,beta_ant){
	I11<-n*trigamma(alfa_ant)
	I21<-I12<--n/beta_ant
	I22<-n*alfa_ant/(beta_ant^2)
	return(matrix(c(I11,I12,I21,I22),2,2,byrow=TRUE))}
#
set.seed(10)
n<-100
bc<-2
x<-rgamma(100,1,bc) # trocar depois para alfa=5 e beta=5 
mean(x)
var(x)
#
theta<-matrix(c(1,1),ncol=1) # depois troca para 10
m<-2
theta<-cbind(theta,theta[,m-1]+solve(I_func_2(n,theta[1,m-1],theta[2,m-1]))%*%V_func_2(x,theta[2,m-1],theta[1,m-1]))
while (sqrt((theta[1,m]-theta[1,m-1])^2+(theta[2,m]-theta[2,m-1])^2)>0.00001){
	theta<-cbind(theta,theta[,m]+solve(I_func_2(n,theta[1,m],theta[2,m]))%*%V_func_2(x,theta[2,m],theta[1,m]))
	m<-m+1}
#
# Exemplo algoritmo EM - modelo de mistura
#
# Simulando dados
#
n<-1000
x<-rep(0, n)
w_true<-c(0.2, 0.3, 0.5) 
mu_true<-c(1, 2, 3)
sigma2_true<-(c(0.1, 0.2, 0.3))^2
set.seed(100)
S_verd<-NULL
for (i in 1:n){
  u<-runif(1)
  if (u < w_true[1]){
    x[i]<-rnorm(1, mean = mu_true[1], sd = sqrt(sigma2_true[1]))
    S_verd[i]<-1
  }else{
    if (u < w_true[1] + w_true[2]){
      x[i]<-rnorm(1, mean = mu_true[2], sd = sqrt(sigma2_true[2]))
      S_verd[i]<-2
    }else{
      x[i]<-rnorm(1, mean = mu_true[3], sd = sqrt(sigma2_true[3]))
      S_verd[i]<-3
    }
  }
}
hist(x, breaks = 30, freq = FALSE)
#
# Implementacao do algoritmo EM
#
w_init<-c(0.33, 0.33, 0.34) 
mu_init<-c(-1, 0, 1)
sigma2_init<-c(1, 1, 1)
#
# valores iniciais
#
n_iter<-200 # aqui eu fixei um número de iterações, mas o ideal é verificar o critério de parada
w_mat<-matrix(0, ncol = 3, nrow = n_iter)
mu_mat<-matrix(0, ncol = 3, nrow = n_iter)
sigma2_mat<-matrix(0, ncol = 3, nrow = n_iter)
#
w_mat[1, ]<-w_init
mu_mat[1, ]<-mu_init
sigma2_mat[1, ]<-sigma2_init
#
w<-w_init
mu<-mu_init
sigma2<-sigma2_init
K<-3
#
for (iter in 2:n_iter){
#  
  # Calculo de pik_t - passo E
  pik_t<-matrix(0, ncol = K, nrow = n)
  for(i in 1:n){
    pik_t[i, ]<-w*dnorm(x[i],mean=mu,sd=sqrt(sigma2))/sum(w*dnorm(x[i],mean=mu, sd=sqrt(sigma2)))}
  # 
  # atualiza mu
  #
  for (k in 1:K){
    mu[k]<-sum(x*pik_t[,k])/sum(pik_t[,k])}
  #
  # atualiza sigma^2
  #
  for (k in 1:K){
    sigma2[k]<-sum(((x-mu[k])^2)*pik_t[,k])/sum(pik_t[,k])}
  #
  # atualiza w
  #
  for (k in 1:K){
    w[k]<-sum(pik_t[,k])/n}
  #
  # armazena parametros por iteracao
  #
  w_mat[iter,]<-w
  mu_mat[iter,]<-mu
  sigma2_mat[iter,]<-sigma2}
#
# estimativas
#
w
mu
sigma2
#
par(mfrow=c(3,1))
plot(w_mat[,1],type='l')
plot(w_mat[,2],type='l')
plot(w_mat[,3],type='l')
#
par(mfrow=c(3,1))
plot(mu_mat[,1],type='l')
plot(mu_mat[,2],type='l')
plot(mu_mat[,3],type='l')
#
par(mfrow=c(3,1))
plot(sigma2_mat[,1],type='l')
plot(sigma2_mat[,2],type='l')
plot(sigma2_mat[,3],type='l')
#
x<-seq(0,5,0.01)
plot(x,w[1]*dnorm(x,mu[1],sqrt(sigma2[1]))+ 
         +w[2]*dnorm(x,mu[2],sqrt(sigma2[2])) + 
         +w[3]*dnorm(x,mu[3],sqrt(sigma2[3])),type='l')
#
round(pik_t,3)
Grupo<-NULL
for (i in 1:n) Grupo[i]<-which(pik_t[i,]==max(pik_t[i,]))
table(Grupo,S_verd)
#
# troque os parâmetros da simulação de maneira que vc tenha o exemplo das alturas discutido nos slides e veja o desempenho do algoritmo
#