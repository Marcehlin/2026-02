x<-c(1.83,0.5,1.62,2.48,1.68,1.88,1.55,3.06,1.30)
y<-c(0.878,0.647,0.598,2.05,1.06,1.29,1.06,3.14,1.29)

dif<-y-x

estat_alt_1<-median(dif)
estat_alt_1

medianas_rearranjos<-NULL

for (i1 in c(1,-1)){
	for (i2 in c(1,-1)){
		for (i3 in c(1,-1)){
			for (i4 in c(1,-1)){
				for (i5 in c(1,-1)){	
					for (i6 in c(1,-1)){
						for (i7 in c(1,-1)){
							for (i8 in c(1,-1)){	
								for (i9 in c(1,-1)){
									medianas_rearranjos<-c(medianas_rearranjos,median(dif*c(i1,i2,i3,i4,i5,i6,i7,i8,i9)))}}}}}}}}}
hist(medianas_rearranjos)


quantile(medianas_rearranjos,0.05) # quantil da região crítica
valor_p_1<-sum(medianas_rearranjos<=estat_alt_1)/length(medianas_rearranjos) # valor-p
valor_p_1

