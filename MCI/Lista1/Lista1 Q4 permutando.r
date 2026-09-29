droga <- c(3.2, 2.1, 2.3, 1.2, 1.5)
placebo <- c(3.4, 3.5, 4.1, 1.7, 2.1)

dif <- droga - placebo

estat_obs <- mean(dif)

estat <- NULL

for (i1 in c(1,-1)){
	for (i2 in c(1,-1)){
		for (i3 in c(1,-1)){
			for (i4 in c(1,-1)){
				for (i5 in c(1,-1)){	
									estat<-c(estat,mean(dif*c(i1,i2,i3,i4,i5)))}}}}}

hist(estat)

quantile(estat,c(0.025,0.975)) # quantis da região crítica

valor_p <- sum(estat<=estat_obs)/length(estat) # valor-p

valor_p

