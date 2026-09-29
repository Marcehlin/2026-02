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

