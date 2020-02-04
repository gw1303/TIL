iris
str(iris)
head(iris)
colSums(is.na(iris)) # <- False=0,True=1로 계산
is.na(iris)
panel.fun<-function(x,y,...){
  horizontal<-(par("usr")[1]+
                 par("usr")[2])/2;
  vertical<-(par("usr")[3]+
               par("usr")[4])/2;
  text(horizontal,vertical,
       format(abs(cor(x,y)),digits=2))
}
pairs(iris[1:4],
      pch=21,
      bg=c("red","green","blue")[unclass(iris$Species)],
      upper.panel = panel.fun,
      main="Scatter")
#개념:ggplot2패키지의 geom_point():변수 1개의 산점도 그리기
#corrplot패키지: 상관계수 행렬 그리기
airquality
str(airquality)
airquality_1<-airquality[,c(1:4)]
airquality[,c(1:4)]
airquality_1
colSums(is.na(airquality_1))    # <- 한번에 NA 확인할 때
sum(is.na(airquality_1$Ozone))  # <- 따로 NA확인할 때
cor(airquality_1)   # <- NA가 있어서 상관계수에 NA가 생김(처리)
# 결측값있는 행을 제거해보기
airquality_2<-na.omit(airquality_1)
str(airquality_2)
colSums(is.na(airquality_2)) #<- 결측값없는지 확인해보기



#pairs에 밑에 있는 코드 그대로 긁어서 
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
pairs(USJudgeRatings, lower.panel = panel.smooth, upper.panel = panel.cor,
      gap=0, row1attop=FALSE)

pairs(iris[-5], log = "xy") # plot all variables on log scale
pairs(iris, log = 1:4, # log the first four
      main = "Lengths and Widths in [log]", line.main=1.5, oma=c(2,2,3,2))



pairs(airquality_2,pch="*",   #<- pch: 점의 모양
      main="scatter plot",    # <- main: 제목
      lower.panel = panel.lm,
      upper.panel = panel.cor,
      diag.panel = panel.hist)    

#help에 panelhist를 그대로 긁어서 실행
panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}
#help에 panel.cor를 그대로 긁어서 실행
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
# panel.lm은 없으니 직접 치기
panel.lm<-function(x,y,col=par("col"),bg=NA,
                   pch=par("pch"),
                   cex=1,col.smooth="black",...){
  points(x,y,pch=,col=col,
         bg=bg,cex=cex)   #points는 점에관해
  abline(stats::lm(y~x),
         col=col.smooth,...)
}
# pairs의 example : iris
pairs(iris[1:4],
      main = "Anderson's Iris Data -- 3 species",
      pch = 21,
      bg = c("red", "green3", "blue")[unclass(iris$Species)])
# pch가 바뀔 때마다 다른 종류의 점으로 찍힘
unclass(iris$Species) # <- unclass: factor->integer vector로 변환환
iris$Species

library(ggplot2)
iris_plot<-ggplot(data=iris,
                  aes(x=Petal.Length,
                      y=Petal.Width,
                      colour=Species))+
  geom_point(shape=19,size=4)
iris_plot2<-iris_plot+
  annotate("text",x=1.5,y=0.7,label='Setosa')+
  annotate("text",x=3.5,y=1.5,label='Veriscolour')+
  annotate("text",x=6,y=2.7,label='Virginica')

iris_plot2+
  annotate("rect",xmin=0,xmax=2.6,ymin=0,ymax=0.8,
           alpha=0.4,fill="red")+   #alpha:불투명도
  annotate("rect",xmin=2.6,xmax=4.9,ymin=0.8,ymax=1.5,
           alpha=0.4,fill="green")+
  annotate("rect",xmin=4.8,xmax=7.2,ymin=1.5,ymax=2.7,
           alpha=0.4,fill="blue")

iris_kmeans <- kmeans(iris[,c('Petal.Length','Petal.Width')],3)
iris_kmeans

names(iris_kmeans)
iris_kmeans$size
table(iris_kmeans$cluster)

###################################################################
############## 의사결정 트리
# 엔트로피 (복잡도) : -x*log2(x)-(1-x)*log2(1-x)
# 엔트로피 함수 그래프
curve(-x*log2(x)-(1-x)*log2(1-x), 
      col = 'red', xlab = 'x', ylab = 'entropy', lwd = 4)

-(9/14)*log2((9/14))-(1-(9/14))*log2(1-(9/14))  # 0.94 
-(5/14)*log2((5/14))-(1-(5/14))*log2(1-(5/14))  # 0.94

x=(9/14)
-x*log2(x)-(1-x)*log2(1-x)  # 0.94 

# IG (Information Gain) : Entropy Before - Entropy After


credit <- read.csv('dataset_for_ml/credit.csv')
str(credit)
summary(credit)
# 채무불이행 no or yes
table(credit$default)

x=(7/10)
-x*log2(x)-(1-x)*log2(1-x)  # 0.88 
# 테스트와 트레인 데이터 나누기
set.seed(1004)
train_sample <- sample(1000,900)
str(train_sample)

credit_train <- credit[train_sample,]  # 900건
credit_test <- credit[-train_sample,]  # 100건

table(credit_train$default)  # 635 265
table(credit_test$default)   # 65  35
prop.table(table(credit_train$default))
prop.table(table(credit_test$default))

# 의사결정트리 패키지
install.packages('C50')
library(C50)
credit_model <- C5.0(credit_train[-17] ,credit_train$default )
credit_model

summary(credit_model)

credit_pred <- predict(credit_model, credit_test[-17])


library(gmodels)

CrossTable(credit_test$default, credit_pred, 
           prop.c = F, prop.r = F, dnn = c('actual','predicted'))

str(mushrooms)

# 부스팅 : 의사결정 트리를 여러개 작성하고 나온 결과에 대해 투표
#         ( 성능이 약한 모델을 모아서 성능 개선 )
#                                             트리의 개수 (best. 10개)
credit_boost10 <- C5.0(credit_train[-17], credit_train$default, trials = 10)

credit_boost10  # boosting iterations: 10 
summary(credit_boost10)

credit_boost_pred10 <- predict(credit_boost10, credit_test[-17])

CrossTable(credit_test$default, credit_boost_pred10,
           prop.c = F, prop.r = F, dnn = c('actual','predicted'))

###########################################################################
########################### 타이타닉 분석 ##
train <- read.csv('titanic/train.csv')
str(train)

test <- read.csv('titanic/test.csv')
str(test)

install.packages('readr')
install.packages('rpart')
install.packages('rpart.plot')
library(readr)
library(rpart)
library(rpart.plot)
library(dplyr)
library(ggplot2)

Survived <- train$Survived
train$Survived <- NULL
Survived

dataset <- bind_rows(train,test)
str(dataset)
summary(dataset)

dataset$PassengerId[is.na(dataset$Age) == T]

# dataset의 fare 에 NA가 있는가 ? 
dataset$PassengerId[is.na(dataset$Fare) == T]  # 1044

# fare의 NA값을 중앙값으로 대체
dataset$Fare[dataset$PassengerId==1044] <- median(dataset$Fare, na.rm = T)  # 14.45
dataset$Fare[dataset$PassengerId==1044]

# sapply 를 이용해 age의 NA값 대체
summary(dataset$Age)  # NA : 263개 

dataset$Age <- sapply(dataset$Age, FUN = function(x){
  ifelse(is.na(x), median(dataset$Age, na.rm = T) , x)
})

table(dataset$Embarked)
table(dataset$Embarked)/sum(dataset$Embarked != '')

# dataset$Embarked가 ''인 승객의 id 추출 
dataset$PassengerId[dataset$Embarked=='']  # 62,830
dataset$Embarked[c(62,830)] <- 'S'

# row의 개수
nrow(dataset) # 1309
dim(dataset)  # 1309 11 

sum(dataset$Cabin != '')  # 295
sum(dataset$Cabin != '') / nrow(dataset)  # 0.22 : 내용이 안 들어간 행의 비율 

#           첫번째 글자부터 한 글자 추출 
dataset$Cabin <- substr(dataset$Cabin, 1, 1)
table(dataset$Cabin)
#         A    B    C    D    E    F    G    T 
# 1014   22   65   94   46   41   21    5    1 


dataset$Cabin[dataset$Cabin == ''] <- 'H'
table(dataset$Cabin)
#  A    B    C    D    E    F    G    H    T 
# 22   65   94   46   41   21    5 1014    1 

str(dataset)

# PassengerId, Pclass, Sex, Embarked, Cabin 를 팩터로
factor_vars <- c('PassengerId', 'Pclass', 'Sex', 'Embarked', 'Cabin')

dataset[factor_vars] <- lapply(dataset[factor_vars], FUN = function(x){
  as.factor(x)
})
str(dataset)

# 트레인, 테스트 데이터 나누기 
train_cleaned <- dataset[1:891,]
test_cleaned <- dataset[892:1309,]
train_cleaned$Survived <- Survived

DT <- rpart(Survived ~ Pclass + Sex + Embarked + Cabin, train_cleaned, method = 'class')
summary(DT)

predict_dt <- predict(DT, test_cleaned, type = 'class')
res <- data.frame(PassengerID = test_cleaned$PassengerId, Survived = predict_dt)

write.csv(res, file = 'result.csv', row.names = F)

#########################################################################################
########################## 의사결정트리 실습 ############################################

mushrooms <- read.csv('dataset_for_ml/mushrooms.csv')

summary(mushrooms)

# veil_type이 모두 partial이므로 제거
names(mushrooms)  # veil_type = 17
mushrooms <- mushrooms[-17]

str(mushrooms)
dim(mushrooms)  # 8124 23

# NA 확인
sum(is.na(mushrooms))  # 0

# train, test 나누기
set.seed(1004)
8127*0.7  # 5689

sample_rows <- sample(8124, 5689)

mushrooms_train <- mushrooms[sample_rows,]  # 5689
mushrooms_test <- mushrooms[-sample_rows,]  # 2435
# label 데이터 
mushrooms_test_label <- mushrooms_test$type

### 1. C5.0을 이용한 DT
library(C50)
# 모델 생성
model_C50 <- C5.0(mushrooms_train[,-1], mushrooms_train$type)

model_C50
summary(model_C50)
# 예측값 생성 
mushrooms_test_pred <- predict(model_C50, mushrooms_test[,-1])
# 실제값과 비교 
library(gmodels)
CrossTable(mushrooms_test_label, mushrooms_test_pred)  # 100%

#                       | mushrooms_test_pred 
#  mushrooms_test_label |    edible | poisonous | Row Total | 
#  ---------------------|-----------|-----------|-----------|
#                edible |      1249 |         0 |      1249 | 
#                       |   577.657 |   608.343 |           | 
#                       |     1.000 |     0.000 |     0.513 | 
#                       |     1.000 |     0.000 |           | 
#                       |     0.513 |     0.000 |           | 
#  ---------------------|-----------|-----------|-----------|
#             poisonous |         0 |      1186 |      1186 | 
#                       |   608.343 |   640.657 |           | 
#                       |     0.000 |     1.000 |     0.487 | 
#                       |     0.000 |     1.000 |           | 
#                       |     0.000 |     0.487 |           | 
#  ---------------------|-----------|-----------|-----------|
#          Column Total |      1249 |      1186 |      2435 | 
#                       |     0.513 |     0.487 |           | 
#  ---------------------|-----------|-----------|-----------|


### 2. rpart를 이용한 DT
library(rpart)

# 모델 생성 
mushrooms_DT <- rpart(type ~ cap_shape+cap_surface+cap_color+bruises+odor+gill_attachment+gill_spacing+
        +gill_size+gill_color+stalk_shape+stalk_root+stalk_surface_above_ring+stalk_root+
        +stalk_surface_below_ring+stalk_color_above_ring+stalk_color_below_ring+veil_color+
        +ring_number+ring_type+spore_print_color+population+habitat, mushrooms_train, method = 'class')
summary(mushrooms_DT)

# 예측값 생성 
mushrooms_test_pred_rpart <- predict(mushrooms_DT, mushrooms_test, type = 'class')

# 실제값과 비교
CrossTable(mushrooms_test_label, mushrooms_test_pred_rpart)

#                       | mushrooms_test_pred_rpart 
#  mushrooms_test_label |    edible | poisonous | Row Total | 
#  ---------------------|-----------|-----------|-----------|
#                edible |      1249 |         0 |      1249 | 
#                       |   559.242 |   601.674 |           | 
#                       |     1.000 |     0.000 |     0.513 | 
#                       |     0.990 |     0.000 |           | 
#                       |     0.513 |     0.000 |           | 
#  ---------------------|-----------|-----------|-----------|
#             poisonous |        13 |      1173 |      1186 | 
#                       |   588.949 |   633.635 |           | 
#                       |     0.011 |     0.989 |     0.487 | 
#                       |     0.010 |     1.000 |           | 
#                       |     0.005 |     0.482 |           | 
#  ---------------------|-----------|-----------|-----------|
#          Column Total |      1262 |      1173 |      2435 | 
#                       |     0.518 |     0.482 |           | 
#  ---------------------|-----------|-----------|-----------|
































