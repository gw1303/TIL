a <- 1  # a에 1할당
a
b <- 2

(a+b)/2

# 벡터 만들기
v1 <- c(1,2,3)
v1

v2 <- c(1:5)
v2

v3 <- seq(1,5)
v3

v4 <- seq(1,10,by = 3)
v4

s1 <- 'a'
s2 <- 'text'
s3 <- 'hi'

s4<-c(s1,s2,s3)
#s4 + 1 # error

mean(v1)
max(v1)
min(v1)

s4
paste(s4, collapse = ',')

install.packages('ggplot2')
library(ggplot2)

x <- c('a','a','b','c')
# 빈도 그래프
qplot(x)

mpg
qplot(data = mpg, x = hwy)

qplot(data=mpg, x = drv, y = hwy)

qplot(data=mpg, x = drv, y = hwy, geom = 'line')
qplot(data=mpg, x = drv, y = hwy, geom = 'boxplot')
qplot(data=mpg, x = drv, y = hwy, geom = 'boxplot', color=drv)

?qplot

eng <- c(90,80,60,70)
math <- c(50,10,20,90)

df_mid <- data.frame(eng,math)
df_mid

# info같은
str(df_mid)
class <- c(1,1,2,2)
df_mid <- data.frame(eng,math,class)
df_mid

df_mid$eng

df <- data.frame(
eng = c(90,80,60,70),
math = c(50,10,20,90),
class = c(1,1,2,2)
)
df

# 엑셀파일 열기
install.packages('readxl')
library(readxl)


df = read_excel('Data/excel_exam.xlsx')
df

df$english

read_excel('Data/excel_exam_novar.xlsx', col_names = c('a','b','c','d','e'))

# 헤더가 없는 데이터 불러오기 
read_excel('Data/excel_exam_novar.xlsx', col_names = F)

# csv파일열기 

df <- read.csv('Data/csv_exam.csv')
df

str(df)

write.csv(df, file = 'mydf.csv')

exam <- read.csv('Data/csv_exam.csv')
head(exam, 2)
tail(exam, 3)

View(exam)
# python의 shape과 유사
dim(exam)
str(exam)

# discribe 기술통계 
summary(exam)

str(mpg)
head(mpg)
View(mpg)
summary(mpg)

df <-data.frame(v1=c(1,2,1),
           v2=c(2,3,2))
df

install.packages("dplyr")
library(dplyr)
?rename
df <- rename(df, var1=v1)
df

df$v_sum <- df$var1 + df$v2
df


# 토탈컬럼 추가 hwy + cty의 평균 
mpg$total <- (mpg$hwy + mpg$cty)/2
mpg

summary(mpg$total)

mpg <- as.data.frame(mpg)
mpg
mpg$test <- ifelse(mpg$total>=20, 'pass','fail')
head(mpg,20)
# 데이터가 각 각 몇개씩 있는지 조사해주는 함수
table(mpg$test)
qplot(mpg$test)

# A,B,C
mpg$grade <- ifelse(mpg$total>=30,'A',ifelse(mpg$total>=20,'B','C'))
mpg
qplot(mpg$grade)

exam <- read.csv('Data/csv_exam.csv')
exam

# 파이프라인 ctrl shift m
exam %>% filter(class!=1) %>%  filter(math>=50)

# 2반이면서 영어점수가 80점 이상인 데이터 추출
exam %>% filter(class == 2) %>% filter(english >=80)

exam %>% filter(class==2 & english>=80)

exam %>% filter(class==2 | english>=80)

# 같은 구문
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1,3,5))

# 특정 컬럼만 추출 
str(exam %>% select(math))  # 데이터프레임

# 특정 컬럼을 제외하고 추출 
exam %>% select(-math,-class)

exam %>% filter(class ==1) %>% select(english)

exam %>% select(id, math) %>% head(6)

# math를 기준으로 오름차순 정렬을 해라 
exam %>% arrange(math)
# 내림차순
exam %>% arrange(desc(math))

exam %>% arrange(class, math)

# 파생변수
exam %>% mutate(total=math + english + science) %>% head()

exam %>% mutate(test = ifelse(science>=60, 'pass', 'fail')) %>% head()

# total열 추가 
exam %>% mutate(total=math + english + science)  %>% arrange(total) %>% head(10)












