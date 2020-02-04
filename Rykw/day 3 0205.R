# 텍스트 마이닝 : text mining 
# 문장 -> 형태소분석 -> 명사, 동사, .. -> 빈도표 -> 시각화

# R에서 텍스트마이닝 하려면 java 필수 (www.oracle.com / www.java.com)

install.packages('rJava')
install.packages('memoise')
install.packages('KoNLP')

library(rJava)
library(memoise)
library(koNLP)

# 지도 시각화 패키지 
install.packages('ggiraphExtra')
library(ggiraphExtra)

str(USArrests)
head(USArrests)

library(tibble)

# 열 이름을 컬럼으로 바꿔주는 함수 
crime <- rownames_to_column(USArrests, var = 'state')
crime
# 지도 데이터와 대소문자를 맞춰주기 위해 소문자로 변경 
crime$state <- tolower(crime$state)
crime

str(crime)

# 미국 지도 데이터 준비
library(ggplot2)
install.packages('maps')
install.packages('mapproj')
library(maps)
library(mapproj)

states_map <- map_data('state')

ggChoropleth(data = crime,  # 지도에 표시할 데이터
             aes(fill = Murder,  # 색으로 표시할 열
                 map_id = state),
             map=states_map)

ggChoropleth(data = crime,  # 지도에 표시할 데이터
             aes(fill = Murder,   # 색으로 표시할 열
                 map_id = state), # 기준 
             map=states_map,   # 지도 데이터
             interactive = T)  # 상호작용 추가 

# 한국 지도 데이터 시각화 
install.packages('stringi')
install.packages('devtools')
# library(stringi)
library(devtools)
# github에 있는 자료 다운
devtools::install_github('cardiomoon/kormaps2014')

library(kormaps2014)
str(changeCode(kormap1))
head(changeCode(korpop1))
str(changeCode(korpop3))

library(dplyr)
korpop1 <- rename(korpop1, pop = '총인구_명', name='행정구역별_읍면동')
str(changeCode(korpop1))
korpop1<-changeCode(korpop1)
ggChoropleth(data = korpop1,      # 지도에 표시할 데이터
             aes(fill = pop,      # 색깔로 나타낼 변수 
                 map_id = code,   # 지역 기준 변수 
                 tooltip = name), # 지도위에표시할 지역명 
             map = kormap1,
             interactive = T
             )

ggplot(korpop1,
       aes(map_id = code, fill = 'pop'),) +
  geom_map(map = kormap1, colour ='black') +
  expand_limits(x = kormap1$long, y = kormap1$lat) +
  #scale_fill_gradientn(colours = c('white','orange','red')) +
  ggtitle('2015년 인구 분포도') +
  coord_map()

devtools::install_github('cariomoon/moonBook2')
library(moonBook)
ggChoropleth(korpop2, kormap2,fillvar='남자_명' )


############# ##### 머신러닝 ########### ####### 
# 통계적 기법, 연산능력, 빅데이터 
# 데이터마이닝 

groceries <- read.csv('dataset_for_ml/groceries.csv')

# 벡터 : 순서가 있는 리스트
subject_name <- c('John','Jane','Steve')
temp <- c(37,35,33)
flu_status <- c(T,F,F)
flu_status

temp[2:3]
temp[-2]
temp[c(T,F,T)]

# 팩터 : 명목형 데이터를 표현 
gender <- factor(c('M','F','M'))
gender

blood <- factor(c('O','AB','A'), levels = c('O','AB','A','B'))
blood

factor(c('A','F','C'),
       levels = c('A','B','C','D','F'),
       ordered = T) # levels의 순서를 줄 경우

subject_name

# 리스트 : 순서 X, 타입이 다양
sb1 <- list(fn=subject_name[1],
     temp=temp[1],
     flu=flu_status[1])
# 리스트 요소 추출
class(sb1$fn)   # character
class(sb1[1])   # list
class(sb1[[1]]) # character
# 리스트 열 추출 
sb1[c('temp','flu')]

df <- data.frame(sb1, stringsAsFactors = F)  # 팩터형으로 문자열을 읽을것인가 ? 
df
str(df)

###################################################

# apply계열 함수 : 함수 연산을 특정단위로 쉽게 할 수 있도록 지원
# for, while(소규모 데이터 반복연산) -> 대규모는 느림 
# apply (대규모 데이터 반복 연산)

iris<-iris
class(iris)
str(iris)

# for문 이용
iris_num <- NULL

ncol(iris)

for (x in 1:ncol(iris)){
  if (is.numeric(iris[,x])){
    iris_num <- cbind(iris_num,iris[,x])
  }
}
print(iris_num)
class(iris_num)  # matrix
iris_num <- data.frame(iris_num)  # data frame

# sapply 사용
iris_num <- iris[,sapply(iris, is.numeric)]
iris_num  # data frame

iris_num <- iris[1:10, 1:4]

set.seed(123)
idx_r <- sample(1:10,2)  # 1~10사이의 난수 2개 
idx_c <- sample(1:4,2)

idx_r
idx_c
for(i in 1:2){
  iris_num[idx_r[i],idx_c[i]] <- NA
}
iris_num

# apply : 행(1) 또는 열(2) 단위 연산 (MARGIN = )
# 입력 : 배열, 매트릭스(같은 데이터 타입)
# 출력 : 매트릭스 또는 벡터

apply(iris_num, MARGIN = 1, FUN = mean, na.rm=T)
apply(iris_num, MARGIN = 2, FUN = mean, na.rm=T)
# 사용자 정의 함수 사용 
apply(iris_num, MARGIN = 2, FUN = function(x){x*2+1})

apply(iris_num, MARGIN = 2, FUN = function(x){mean(x*2+1, na.rm=T)})

## lapply :list + apply  => 실행결과가 list로 출력 (다른 데이터 타입 가능)
# 데이터 프레임 : 모든 변수가 벡터(같은 데이터 타입)를 가져야 함 
# 리스트 : 벡터, 매트릭스 , 데이터프레임

apply(iris_num, 2, mean, na.rm=T)  # numeric 숫자 벡터
lapply(iris_num, mean, na.rm=T)  # list

## sapply : lapply와 비슷, 간단하게 기술
# 연산결과 : 벡터 or 리스트(길이가 다른 경우)

sapply(iris_num, mean, na.rm=T)  # numeric
sapply(iris_num, mean, na.rm=T, simplify = F)  # list

## vapply : sapply + 템플릿 지정 // 보기 편하게 지정 가능
sapply(iris_num, fivenum) # 최소값 , 1사분위, 중위수, 3사분위, 최대값 출력

vapply(iris_num, fivenum, FUN.VALUE = c('mean.'= 0,'1st.'= 0,'med'= 0,'3st.'= 0,'max'= 0))

###############################################################################################

## ML / KNN기법 
usedcars <- read.csv('dataset_for_ml/usedcars.csv', stringsAsFactors=F)
str(usedcars)

summary(usedcars)
# 범위
range(usedcars$price)
# 차 
diff(range(usedcars$price))
# 사분위수 (3분위 - 1분위)
IQR(range(usedcars$price))
# 사분위범위
quantile(usedcars$price)
# 특정 범위의 사분위 수 
quantile(usedcars$price, seq(from=0, to=1,by=0.1))

boxplot(usedcars$price, main='Car Prices', ylab ='price($)')

boxplot(usedcars$mileage, main='Car Prices', ylab ='odometer')

hist(usedcars$price, main='Car Prices', xlab ='price($)')
hist(usedcars$mileage, main='Car Prices', xlab ='odometer')
# 분산  
# (각 데이터 - 평균)^2 합들의 평균 (n-1)
var(usedcars$price)
# 표준편차 
# 분산의 제곱근
sd(usedcars$price)

table(usedcars$year)
table(usedcars$model)

c_table <-table(usedcars$color)
c_table
# 몇 퍼센트 속해있는가 
round(prop.table(c_table)*100,1)
 
# 일변량 통계
# 이변량 통계 ( 두 변수의 관계 )  : 산포도 
# 다변량 통계 ( 두 개 이상의 변수 관계 )

# 산포도 나타내기
plot(x= usedcars$mileage,
     y=usedcars$price,
     main = 'price & mileage',
     xlab = '주행거리',
     ylab = '가격')

usedcars$conservative <- usedcars$color %in% c("Black","Gray","Silver","White")
usedcars

table(usedcars$conservative)

install.packages('gmodels')
library(gmodels)
# 백분율로 나타내기
CrossTable(x=usedcars$model, y = usedcars$conservative)

################################wisc_bc_data.csv######################
wbcd <- read.csv('dataset_for_ml/wisc_bc_data.csv', stringsAsFactors = F)
str(wbcd)

# 필요없는 열 날리기
wbcd <- wbcd[-1]
str(wbcd)

###################### KNN #############################
# 얼굴인식, 숫자인식, 추천시스템, 유전자 데이터패턴 인식

# 표준화() , 더미코딩(명목변수)

str(wbcd)
table(wbcd$diagnosis)

# factor의 인자값 변경
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c('B','M'), labels=c('Benign','Malignant'))
wbcd$diagnosis
table(wbcd$diagnosis)
# 비율 구하는 함수 
round(prop.table(table(wbcd$diagnosis))*100, 1)

summary(wbcd[c('radius_mean','area_mean','smoothness_mean')])

# 정규화 함수 만들기
normalize <- function(x){
  return ((x-min(x))/(max(x)-min(x)))
}
normalize(c(1,2,3,4,5))

wbcd_n <- as.data.frame(lapply(wbcd[-1], normalize))
summary(awbcd_n$area_mean)

wbcd_train <- wbcd_n[1:469,]
wbcd_test <- wbcd_n[470:569,]

wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels <- wbcd[470:569,1]

# knn 모델 불러오기
library(class)
#    트레인      테스트     트레인 정답      이웃 수(짝수면 동률이 나올 수 있음)
wbcd_test_pred <- knn(wbcd_train, wbcd_test, wbcd_train_labels, k=21)

# 모델 검증
library(gmodels)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = F,)

#####################################################################
#######################표준화 후 정규화##############################
#####################################################################

# 표준화
wbcd_scale <- as.data.frame(scale(wbcd[-1]))

# 정규화
wbcd_scale_n <- as.data.frame(lapply(wbcd_scale[-1], normalize))
class(wbcd_scale_n)

# 데이터셋 나누기 
wbcd_scale_train <- wbcd_scale_n[1:469,]
wbcd_scale_test <- wbcd_scale_n[470:569,]

wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels <- wbcd[470:569,1]

wbcd_scale_test_pred <- knn(wbcd_scale_train, wbcd_scale_test, wbcd_train_labels, k= 1  )

# 모델 검증
library(gmodels)
CrossTable(x = wbcd_test_labels, y = wbcd_scale_test_pred, prop.chisq = F)

########################################################################
#######################iris knn#########################################
########################################################################

# iris(1:35, 51:85, 101:135) => train
# iris(36:50, 86:100, 136:150) => test

iris <- iris

# 표준화
iris[-5]<-as.data.frame(scale(iris[-5]))
iris
# 정규화
as.data.frame(lapply(iris[-5], normalize))

# 트레인, 테스트 데이터 나누기
iris_train <- iris[-5][c(1:35, 51:85, 101:135),]
iris_test <- iris[-5][c(36:50, 86:100, 136:150),]

# 레이블 데이터 나누기 
iris_train_label <- iris[5][c(1:35, 51:85, 101:135),]
iris_test_label <- iris[5][c(36:50, 86:100, 136:150),]

# knn 모델 만들고 예측
iris_pred <- knn(train = iris_train, test = iris_test, cl = iris_train_label, k = 15) # 13,15,17 -> 100%

# 예측값 검증
CrossTable(x = iris_test_label, y = iris_pred,chisq = F)

