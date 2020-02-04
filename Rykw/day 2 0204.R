library(dplyr)
library(ggplot2)

exam <- read.csv('Data/csv_exam.csv')

# mean, sum, iqr, ..
exam %>% summarise(mean_math = mean(math))

# 반별 수학 평균 구하기
exam %>% group_by(class) %>% summarise(mean_math = mean(math))

# n() : 그룹에 속한 맴버의 개수 구하는 함수 
exam %>% group_by(class) %>% summarise(mm = mean(math), sm = sum(math), md = median(math), cnt = n())

mpg %>% group_by(manufacturer,drv) %>% summarise(mc = mean(cty), cnt=n()) %>%  head(10) 

mpg %>% group_by(manufacturer) %>% filter(class == 'suv') %>% 
  mutate(tot = (cty + hwy)/2) %>% summarise(mt = mean(tot)) %>% arrange(desc(mt)) %>% head(5)

# 데이터프레임 병합 
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm = c(60,80,70,90,55))
test2 <- data.frame(id=c(1,2,3,4,5),
                    final = c(75,55,80,95,60))
test1
test2

total = left_join(test1,test2, by='id')
total

name = data.frame(class=c(1,2,3,4,5),
                  teacher=c('kim','park','choi','lee','cho'))

exam_new = left_join(exam, name, by = 'class')
exam_new

test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm = c(60,80,70,90,55))
test2 <- data.frame(id=c(6,7,8,9,10),
                    final = c(75,55,80,95,60))

# 데이터 프래임 위 아래로 합치기 
ta = bind_rows(test1,test2)
ta

exam %>% filter(english>=80)
exam %>% filter(class == 1 & math >= 50)
# class가 1이거나 3이거나 5인것 출력 
exam %>% filter(class %in% c(1,3,5))

exam %>% select(id,math)

# test 컬럼 추가
exam %>% mutate(test = ifelse(english >= 60, 'pass', 'fail')) %>% arrange(english)

test1
test2

left_join(test1, test2, by='id')

df <- data.frame(sex = c('M','F',NA,'M','F'),
           score = c(5,4,3,5,NA))

# 결측치 확인 
is.na(df)
table(is.na(df))
table(is.na(df$sex))
table(is.na(df$score))
mean(df$score, na.rm = TRUE)
sum(df$score, na.rm = TRUE)

# score가 NA인 데이터만 출력 
df %>% filter(is.na(score))
# score가 N가 아닌 데이터만 출력 
df_nomiss <- df %>% filter(!is.na(score))

mean(df_nomiss$score)
sum(df_nomiss$score)

df_nomiss <- df %>% filter(!is.na(sex) & !is.na(score))
df_nomiss

df
df_nomiss2 <- na.omit(df)
df_nomiss2

mean(df$score, na.rm = T)

exam <- read.csv('Data/csv_exam.csv')

exam[c(3,8,15),'math'] <- NA

exam %>% summarise(mm = mean(math))  # NA
exam %>% summarise(mm = mean(math, na.rm = T),
                   sm = sum(math, na.rm = T),
                   med = median(math, na.rm = T))  # 55.23529

# 결측치 대체 
exam$math <- ifelse(is.na(exam$math), 55, exam$math)
exam
table(is.na(exam$math))
mean(exam$math)


# 아웃라이어 확인 
df <- data.frame(sex = c(1,2,1,3,2,1),
                 score = c(5,4,3,4,2,6))

table(df$score)

# 아웃라이어 제거
df$sex <- ifelse(df$sex==3 , NA, df$sex)
df$score <- ifelse(df$score>5 , NA, df$score)
df
df %>% filter(!is.na(sex) & !is.na(score)) %>% group_by(sex) %>% summarise(ms = mean(score))

boxplot(mpg$hwy)
# 사분위 범위 화긴
boxplot(mpg$hwy)$stats

mpg$hwy <- ifelse(mpg$hwy<12 | mpg$hwy>37, NA, mpg$hwy)
mpg$hwy

boxplot(mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% group_by(drv) %>% mutate(mean_hwy = mean(hwy, na.rm = T))

table(is.na(df$score))

# 시각화 

ggplot(data = mpg, aes(x=displ, y=hwy))

# 산점도 그래프  // 배경 + 표시방식
ggplot(data = mpg, aes(x=displ, y=hwy)) + geom_point()
ggplot(data = mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(3,6)
ggplot(data = mpg, aes(x=displ, y=hwy)) +
  geom_point() +
  ylim(0,30)

df_mpg <- mpg %>% group_by(drv) %>% summarise(mean_hway = mean(hwy, na.rm = F))
df_mpg

ggplot(data = df_mpg, aes(x=drv, y=mean_hway)) + geom_col()

economics
ggplot(data = economics, aes(x=date, y=unemploy)) +
  geom_line()

# spss(.sav) 파일을 읽어오기 위한 패키지 
install.packages('foreign')
library(foreign)  # SPSS파일 로드
library(dplyr)    # 전처리 
library(ggplot2)  # 시각화 
library(readxl)   # 엑셀파일 열기

raw_welfare <- read.spss(file = 'Data/Koweps_hpc10_2015_beta1.sav', to.data.frame = T)

welfare <- raw_welfare

# 1. 데이터를 처음 불러오면 확인 할 것 
str(welfare) # 
dim(welfare) # 행 열 수 
summary(welfare) # 기술통계 요약

# 컬럼 이름 변경
welfare <- rename(welfare,
       sex = h10_g3,
       birth = h10_g4,
       marriage = h10_g10,
       religion = h10_g11,
       code_job = h10_eco9,
       income = p1002_8aq1,
       code_region = h10_reg7
       )

welfare %>% select(sex, birth, marriage, religion, code_job, income, code_region)

class(welfare$sex)
table(welfare$sex)

# 결측치 개수 확인
table(is.na(welfare$sex))
# 이상치 제거 
welfare$sex <- ifelse(welfare$sex == 9, NA, welfare$sex)
welfare$sex

welfare$sex <- ifelse(welfare$sex == 1, 'male', 'female')
table(welfare$sex)

qplot(welfare$sex)

class(welfare$income)
summary(welfare$income)

qplot(welfare$income) +
  xlim(0,1000)

# 이상치 결측값 처리 // 0 or 9999
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

table(is.na(welfare$income))

sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mi = mean(income))

ggplot(data = sex_income) +
  aes(x=sex, y=mi) +
  geom_col()

summary(welfare$birth)
table(is.na(welfare$birth))

welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)

welfare$age <- 2015- welfare$birth +1
welfare$age
qplot(welfare$age)

# 나이별 평균 임금 요약 
age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(im = mean(income))

head(age_income)
ggplot(age_income) +
  aes(x=age, y = im) +
  geom_line()

welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30,'young', 
                       ifelse(age <= 59, 'middle', 'old')) )

welfare$ageg

ageg_income <- welfare %>% 
  filter(!is.na(income))%>% 
  group_by(ageg) %>% 
  summarise(im = mean(income))

ageg_income

ggplot(ageg_income) +
  aes(x = ageg , y = im) +
  geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))  # x축 정렬 

# 성별 월급 차이는 연령대별로 다를까 ? 
# 연령대, 성별, 월급 
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg,sex) %>% 
  summarise(im = mean(income))

sex_income

# 한 줄에 나눠서 출력
ggplot(sex_income) +
  aes(x = ageg , y = im, fill = sex) +
  geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

# female, male 따로 출력 
ggplot(sex_income) +
  aes(x = ageg , y = im, fill = sex) +
  geom_col(position = 'dodge') +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

# 성별, 연령별 월급에 대한 평균 
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex, age) %>% 
  summarise(im = mean(income))
sex_income

# 꺾은선 그래프에서는 fill아니고 col속성 사용 
ggplot(sex_income) +
  aes(x = age , y = im, col = sex) +
  geom_line(show.legend = T,position = 'dodge')

# 직종별 급여 평균 찾기
table(welfare$code_job)

jobcode <- read_xlsx('Data/Koweps_Codebook.xlsx', sheet = 2)
jobcode
welfare <- left_join(welfare, jobcode, by='code_job')

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job,job) %>% 
  head(20)

job_income <- welfare %>%
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(im = mean(income))
job_income

top10<-job_income %>% 
  arrange(desc(im)) %>% 
  head(10)
top10

ggplot(data = top10) +
  aes(x = reorder(job,im), y = im) +
  geom_col() +
  coord_flip()   # x축과 y축 전치


# 성별 직업을 그룹화해 카운팅 
job_cnt <- welfare %>% 
  filter(!is.na(job)) %>% 
  group_by(sex, job) %>%
  summarise(cnt = n())

# 여성 직업 top5
female_top5 <- job_cnt %>% 
  filter(sex == 'female') %>% 
  arrange(desc(cnt)) %>% 
  head(5)
female_top5

# 남성 직업 top5
male_top5 <- job_cnt %>% 
  filter(sex == 'male') %>% 
  arrange(desc(cnt)) %>% 
  head(5)
male_top5

