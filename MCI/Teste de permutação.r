#
#### Teste de permutação para 2 populações pareadas
#
x<-c(1.83,0.5,1.62,2.48,1.68,1.88,1.55,3.06,1.30)
y<-c(0.878,0.647,0.598,2.05,1.06,1.29,1.06,3.14,1.29)
dif<-y-x
boxplot(dif)
#
est_obs<-mean(dif)
est_obs
#
mean_rearr<-NULL
#
# temos 2^9=512 combinações diferentes com dif negativas e positivas. Aqui faremos todas, mas em um cenário que tem milhares de combinações, podemos fazer uma amostra aleatória delas e não todas exatamente
for (i1 in c(1,-1)){
	for (i2 in c(1,-1)){
		for (i3 in c(1,-1)){
			for (i4 in c(1,-1)){
				for (i5 in c(1,-1)){	
					for (i6 in c(1,-1)){
						for (i7 in c(1,-1)){
							for (i8 in c(1,-1)){	
								for (i9 in c(1,-1)){
									mean_rearr<-c(mean_rearr,mean(dif*c(i1,i2,i3,i4,i5,i6,i7,i8,i9)))}}}}}}}}}
hist(mean_rearr)
quantile(mean_rearr,0.05) # quantil da região crítica
valor_p<-sum(mean_rearr<=est_obs)/length(mean_rearr) # valor-p
valor_p
#
#### Teste de permutação para 2 populações independentes
#
x<-c(0,1,1,0,-2)
y<-c(6,7,7,4,-3,9,14)
#
amostra_comb<-c(x,y)
#
boxplot(amostra_comb~c(rep(1,5),rep(2,7)))
#
N<-length(amostra_comb)
n<-length(x)
m<-length(y)
T1obs<-sum(x)
T1<-NULL
for (i in 1:(N-n+1)){
	for (j in (i+1):(N-n+2)){
		for (l in (j+1):(N-n+3)){
			for (k in (l+1):(N-n+4)){
				for (v in (k+1):12){
					T1<-c(T1,sum(amostra_comb[c(i,j,l,k,v)]))
#					cat(i,j,l,k,v,"\n")
				}
			}
		}
	}
}
#
sort(T1)
dist_T1_H0<-round(table(T1)/length(T1),3)
dist_T1_H0
barplot(dist_T1_H0)
quantis<-quantile(T1,c(0.025,0.975)) # quantis da região crítica
valp<-sum(T1<=T1obs)/length(T1)*2 # valor-p
valp