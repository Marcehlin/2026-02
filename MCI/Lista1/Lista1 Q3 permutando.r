z <- c(7,5,12,-3,-5,2,14,18,19,21,-1)

T1obs <- sum(z)

T1<-NULL

for (i1 in c(1,-1)){
	for (i2 in c(1,-1)){
		for (i3 in c(1,-1)){
			for (i4 in c(1,-1)){
				for (i5 in c(1,-1)){	
					for (i6 in c(1,-1)){
						for (i7 in c(1,-1)){
							for (i8 in c(1,-1)){	
								for (i9 in c(1,-1)){
									T1<-c(T1,sum(z*c(i1,i2,i3,i4,i5,i6,i7,i8,i9)))}}}}}}}}}
hist(T1)

quantis_T1 <- quantile(T1,c(0.025,0.975)) # quantis da região crítica
valp_T1 <- sum(T1>=T1obs)/length(T1)*2 #
