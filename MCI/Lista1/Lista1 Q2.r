x <- c(0,1,1,0,-2)
y <- c(6,7,7,4,-3,9,14)

amostra_comb<-c(x,y)
boxplot(amostra_comb~c(rep(1,5),rep(2,7)))

N <- length(amostra_comb)
n <- length(x)
m <- length(y)
T1obs <- var(x)/var(y)

T1<-NULL
for (i in 1:(N-n+1)){
	for (j in (i+1):(N-n+2)){
		for (l in (j+1):(N-n+3)){
			for (k in (l+1):(N-n+4)){
				for (v in (k+1):12){
					T1<-c(T1,var(amostra_comb[c(i,j,l,k,v)])/var(amostra_comb[-c(i,j,l,k,v)]))
#					cat(i,j,l,k,v,"\n")
				}
			}
		}
	}
}

quantis_T1 <- quantile(T1,c(0.025,0.975))

valp_T1 <- 2 * sum(T1<=T1obs)/length(T1)
valp_T1
