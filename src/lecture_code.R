library(kernlab)

data(spam)

set.seed(43124)
trainIndicator = rbinom(nrow(spam), size = 1, prob = 0.5)
train = spam[trainIndicator == 1,]
test = spam[trainIndicator == 0,]
plot(train$capitalAve ~ train$type)
plot(log10(train[, 1:4] + 1))
dist(t(log10(train[,1:55] + 1)))
hCluster = hclust(dist(t(log10(train[,1:55] + 1))))
plot(hCluster)
