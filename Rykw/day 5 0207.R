install.packages("arules")
library(arules)

help(Epub)
data(Epub)

summary(Epub)

inspect(Epub[1:10])

itemFrequency(Epub[,1:10])
itemFrequencyPlot(Epub, supp=0.01, main = 'item frequency')

itemFrequencyPlot(Epub, topN = 20)

image(sample(Epub,500))

epub_rule <- apriori(data = Epub, parameter = list(supp=0.001, conf = 0.2, minlen = 2))

summary(epub_rule)
class(epub_rule)

inspect(epub_rule)

inspect(sort(epub_rule, by='lift')[1:20])

rule_ins <- subset(epub_rule, items %in% c('doc_72f','doc_4ac'))

inspect(rule_ins)
#                            왼쪽 아이템에 있는것만
rule_ins <- subset(epub_rule, lhs %in% c('doc_72f','doc_4ac'))

inspect(rule_ins)

#                                 해당 문자열이 포함된 item 출력
rule_ins <- subset(epub_rule, items %pin% c('60') & confidence > 0.25)
inspect(rule_ins)

#                                 해당 문자열이 온전하게 일치해야 출력 
rule_ins <- subset(epub_rule, items %ain% c('doc_6e8', 'doc_6e9'))
inspect(rule_ins)

# 연관규칙 시각화 툴
library(arulesViz)

plot(epub_rule)
plot(sort(epub_rule, by = 'support')[1:20], method = 'grouped')
# 
plot(epub_rule, method = 'graph', control = list(type='items'))

# 원 크기 : 지지도, 원 색: 향상도, 화살표 : lhs -> rhs
plot(epub_rule, method = 'graph',
     control = list(type='items'),
     vertex.label.cex=0.7,  # 점의 크기 (default = 1)
     edge.arrow.size = 0.3,
     edge.arrow.width = 2
     )


###################################################################
#########################클러스터링
###################################################################
# (Kmeans, ..)
# 타겟 마케팅, 고객 data
# 무단 네트워크 침입

teens <- read.csv('dataset_for_ml/snsdata.csv')

str(teens)

# 결측치 제거
library(tibble)
table(teens$gender, useNA = 'ifany')

sum(is.na(teens$gender))
summary(teens$age)

teens$age <- ifelse(teens$age>=13 & teens$age<20, teens$age, NA)
summary(teens$age)

teens$female <- ifelse(teens$gender == 'F' & !is.na(teens$gender), 1, 0)
teens$male <-  ifelse(teens$gender == 'M' & !is.na(teens$gender), 1, 0)

teens$no_gender <- ifelse(!is.na(teens$gender),1,0)
table(teens$no_gender)

table(teens$gender, useNA = 'ifany')
table(teens$female, useNA = 'ifany')
table(teens$no_gender, useNA = 'ifany')

mean(teens$age, na.rm = T)

# 그룹(졸업연도) 에 대한 통계(평균) 계산
#                        값   그룹
myagg <- aggregate(data = teens, age~gradyear, mean)
class(aggregate(data = teens, age~gradyear, mean))

avg_age <- ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm=T))
avg_age
class(avg_age)

teens$age <- ifelse(is.na(teens$age), avg_age ,teens$age )
summary(teens$age)
table(teens$age, useNA = 'ifany')

# 표준화
interests <- teens[5:40]  #수치가 저장된 열
set.seed(2345)

# scale 함수로 표준화 한 후 데이터프래임 형태로 저장 
interests_z <- as.data.frame(lapply(interests, FUN = scale))
head(interests_z)

# K-Means Clustering 
library(stats)

teen_clusters <- kmeans(interests_z, 5)
teen_clusters$size
teen_clusters$centers

teens$cluster <- teen_clusters$cluster
teens[1:5,]
teens[1:5,c('cluster','gender','age','friends')]

# 클러스터 단위로 나이 평균
aggregate(data=teens, age~cluster, mean)
aggregate(data=teens, female~cluster, mean)

mean(teens$age)


###################################################################
#########################iris 데이터
###################################################################

data(iris)
str(iris)  # 5 * 150
summary(iris)

# setosa=1, versicolor=2, virginica=3
#iris$Species <- ifelse(iris$Species == 'setosa', 1, ifelse(iris$Species == 'versicolor', 2, 3))

# iris데이터 표준화
iris[1:4]
iris[1:4] <- as.data.frame(lapply(iris[1:4], scale))

head(iris)

# iris 데이터로 클러스터링 
iris_cluster <- kmeans(iris[1:4], centers = 3)

iris_cluster$centers
#   Sepal.Length Sepal.Width Petal.Length Petal.Width
# 1   -1.3232208  -0.3718921   -1.1334386  -1.1111395
# 2    0.5690971  -0.3705265    0.6888118   0.6609378
# 3   -0.8135055   1.3145538   -1.2825372  -1.2156393

# 클러스터링 된 값들 저장
iris_pred <- iris_cluster$cluster

# iris 종의 정답 데이터 
iris_label <- iris[,5]
iris_label 

length(iris_label)

library(gmodels)
CrossTable(iris_label,iris_pred)










