x <- c(0,1,1,0,-2)
y <- c(6,7,7,4,-3,9,14)

t.test(x,y,alternative="two.sided",var.equal=TRUE)

amostra_comb<-c(x,y)
boxplot(amostra_comb~c(rep(1,5),rep(2,7)))

N <- length(amostra_comb)
n <- length(x)
m <- length(y)
T1obs <- sum(x)

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

sort(T1)
dist_T1_H0<-round(table(T1)/length(T1),3)
dist_T1_H0
barplot(dist_T1_H0)

quantis_T1 <- quantile(T1,c(0.025,0.975)) # quantis da região crítica
valp_T1 <- sum(T1<=T1obs)/length(T1)*2 # valor-p
valp_T1


T2obs <- median(x)

T2<-NULL
for (i in 1:(N-n+1)){
    for (j in (i+1):(N-n+2)){
        for (l in (j+1):(N-n+3)){
            for (k in (l+1):(N-n+4)){
                for (v in (k+1):12){
                    T2<-c(T2,median(amostra_comb[c(i,j,l,k,v)]))
                }
            }
        }
    }
}

sort(T2)
dist_T2_H0<-round(table(T2)/length(T2),3)
dist_T2_H0
barplot(dist_T2_H0)

quantis_T2 <- quantile(T2,c(0.025,0.975)) # quantis da região crítica
valp_T2 <- sum(T2<=T2obs)/length(T2)*2 # valor-p
valp_T2

T3obs <- sum(y)
T3 <- NULL
opa <- sum(amostra_comb) - T1obs
T3 <- sum(amostra_comb) - T1

sort(T3)
dist_T3_H0<-round(table(T3)/length(T3),3)
dist_T3_H0
barplot(dist_T3_H0)

quantis_T3 <- quantile(T3,c(0.025,0.975))

valp_T3 <- 2*sum(T3>=T3obs)/length(T3)
valp_T3


T4obs <- mean(x) - mean(y)
T4 <- NULL
for (i in 1:(N-n+1)){
    for (j in (i+1):(N-n+2)){
        for (l in (j+1):(N-n+3)){
            for (k in (l+1):(N-n+4)){
                for (v in (k+1):12){
                    T4<-c(T4,mean(amostra_comb[c(i,j,l,k,v)]) - mean(amostra_comb[-c(i,j,l,k,v)]))
                }
            }
        }
    }
}

sort(T4)
dist_T4_H0<-round(table(T4)/length(T4),3)
dist_T4_H0
barplot(dist_T4_H0)

quantis_T4 <- quantile(T4,c(0.025,0.975))

valp_T4 <- 2*sum(T4<=T4obs)/length(T4)
valp_T4
