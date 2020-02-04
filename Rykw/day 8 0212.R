# 텍스트 분석, r함수
myvector <- c(1:6, 'a')
myvector

mylist <- list(1:6,'a')
mylist

obj1 <- 1:4
obj2 <- 6:10

obj3 <- list(obj1,obj2)
obj3

mylist <- list(obj1,obj2, obj3)
mylist

# [] :  벡터 , [[]] : 리스트

# 리스트에서 자료 추출시, [1]를 사용해서 리스트 추출 [[1]]로는 벡터 추출 
class(mylist[[3]][1])
class(mylist[[3]][[1]])

# unlist : 리스트를 벡터형식으로 리턴
mylist <- list(1:6,'a')

unlist(mylist) # 동일한 타입으로 변경되어 리턴

myvector == unlist(mylist)

mean(mylist[[1]][1:6])
mean(unlist(mylist)[1:6])  # error

name1 <- 'Donald'
myspace <- ' '
name2 <- 'Trump'

list(name1, myspace, name2)  # list

unlist(list(name1, myspace, name2))
## unlist : 하나의 문자 형태의 객체로 합치고자 할 때

name <- c('갑','을 ','병','정')
gender <- c(2,1,1,2)

mydata <- data.frame(name, gender)

## attr() : 속성값을 저장하거나 추출할 때 사용 
# metadata : 데이터의 데이터(부가 설명)
# ex) gender의 메타데이터 : 성별을 의미함
#                   메타데이터의 속성          메타데이터의 값 
attr(mydata$name, 'what the variable means') <- '응답자 이름'
attr(mydata$gender, 'what the variable means') <- '응답자 성별'

myvalues <- gender
for (i in 1 : length(gender)){
  myvalues[i] <- ifelse(gender[i]==1, '남성', '여성')
}
# 메타데이터 저장
attr(mydata$gender,'what the value means') <- myvalues
# 메타데이터 추출 
attr(mydata$gender,'what the value means')

mydata$gender.character <- attr(mydata$gender,'what the value means')

# 리스트 -> lapply 
mylist <- list(1:4, 6:10, list(1:4, 6:10))

lapply(mylist[[3]], mean)

# tapply는 텍스트 데이터에 대해 사용
wordlist <- c('the','is','a','the')
df1 <- c(3,4,2,4)
df2 <- rep(1,4)

# 
tapply(df1, wordlist, sum)
tapply(df2, wordlist, sum)

# 알파벳 출력 함수
letters[26]
LETTERS[26]
letters[1:26]
LETTERS[1:26]

# nchar(): 문자수를 세는 함수
nchar('korea')  # 5
nchar('한국')   # 2
nchar('korea',type = 'bytes')  # 5
nchar('한국',type = 'bytes')  # 4
nchar('  ')  # 2
nchar('korea\t')  # 6
nchar('korea\t', type = 'bytes')  # 6
nchar('korea, Republic of')  # 18
nchar('korea, 
      Republic of')  # 25
nchar('korea, \nRepublic of') # 19

## strsplit() : 문장을 단어로 분리
mysenctence <- 'Learning R is so interesting'
strsplit(mysenctence, split = ' ')

## 단어를 문자로 분리
mywords <- strsplit(mysenctence, split = ' ')
strsplit(mywords[[1]][5], split = '')

# 초기화
myletters <- list(rep(NA, 5))

for(i in 1:5){
  myletters[i] <- strsplit(mywords[[1]][i], split = '')
} 

# 분자를 합쳐서 단어로 구성
paste(1,2,3)

paste(myletters[[1]], collapse = '')

mywords2 <- list(rep(NA, 5))
# 리스트 요소 합치기
for(i in 1:5){
  mywords2[i] <- paste(myletters[[i]], collapse = '')
}
mywords2
# 리스트 요소들끼리 합치기
paste(mywords2, collapse = ' ')

##
rwiki <- "R is a programming language and software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, surveys of data miners, and studies of scholarly literature databases show that R's popularity has increased substantially in recent years.
R is a GNU package. The source code for the R software environment is written primarily in C, Fortran, and R. R is freely available under the GNU General Public License, and pre-compiled binary versions are provided for various operating systems. While R has a command line interface, there are several graphical front-ends available."

# 문단 단위로 구분
rwikipara <- strsplit(rwiki, split = '\n')
# 문장 단위로 구분
rwikisent <- strsplit(rwikipara[[1]], split = '\\. ')


rwikiword <- list(NA,NA)
for(i in 1:2){
  rwikiword[[i]] <- strsplit(rwikisent[[i]], split = ' ')
}
rwikiword

rwikiword[[1]][[2]][3]

## regexpr() : 정규표현식, 처음 등장하는 텍스트 위치 출력
mysenctence <- 'Learning R is so interesting'

# 패턴 시작 위치
loc.begin <- as.vector(regexpr('ing', mysenctence))  # 6
# match length
loc.length <- attr(regexpr('ing', mysenctence), "match.length")  # 3
# 패턴 끝 위치 
loc.end <- loc.begin + loc.length - 1  # 8

## gregexpr() : 패턴이 등장하는 모든 텍스트 위치 출력 
gregexpr('ing', mysenctence)

length(gregexpr('ing', mysenctence)[[1]])  # 2 // 패턴이 2번 발견 됐다


loc.begin <- as.vector(gregexpr('ing', mysenctence)[[1]])

loc.length <- attr(gregexpr('ing', mysenctence)[[1]], "match.length")

loc.end <- loc.begin + loc.length - 1

## regexec() :  
regexpr('interesting', mysenctence)

regexec('interestin(g)', mysenctence)
# so interesting, interesting, g의 패턴에 대해 출력
regexec('so (interestin(g))', mysenctence)

mysenctences <- unlist(rwikisent)
regexpr('software', mysenctences)  # 없는 경우 -1 출력

gregexpr('software', mysenctences) # 각 문장에대해 여러개로 출력

## 문자 치환 ing 를 ING로 변경
sub('ing','ING', mysenctence)
## 전체 문자 치환 모든 ing 를 ING로 변경
gsub('ing','ING', mysenctence)

mytemp <- regexpr('software', mysenctences)

my.begin <- as.vector(mytemp)
my.begin[my.begin == -1] <- NA
my.begin

attr(mytemp, 'match.length')

my.end <- my.begin + attr(mytemp, 'match.length') - 1
my.begin
my.end

length(my.begin)
mylocs <- matrix(NA, nrow = length(my.begin), ncol = 2)

# 열 이름 주기
colnames(mylocs) <- c('begin','end')
mylocs

paste('hi',1:3,sep = '.')
paste('hi','hello')
# 행 이름 주기 (접두어)
rownames(mylocs) <- paste('sentence',1:length(my.begin), sep='.')

for(i in 1:length(my.begin)){
  mylocs[i,] <- cbind(my.begin[i], my.end[i])
}

## grep(), grepl() : 특정 표현이 텍스트에 있는지 확인
grep('software', mysenctences)  # 1 2 5
grepl('software', mysenctences) # TRUE TRUE FALSE FALSE TRUE FALSE FALSE


## 고유명사 처리
# 'Donald Trump' => 'Donald_Trump' 

sent1 <- rwikisent[[1]][1]
new.sent1 <- gsub('R Foundation for Statistical Computing',
     'R_Foundation_for_Statistical_Computing',
     sent1)

# 단어 수 세기
sum(table(strsplit(sent1, split = ' ')))     # 21
sum(table(strsplit(new.sent1, split = ' '))) # 17


# 불필요한 단어 제거 : and, by, for 제거
drop.sent1 <- gsub('and | by | for | the','',new.sent1)

sum(table(strsplit(drop.sent1, split = ' '))) # 11

## rematches로 패턴 추출
mypattern <- regexpr('ing', mysenctence)
regmatches(mysenctence, mypattern)

mypattern <- gregexpr('ing', mysenctence)
regmatches(mysenctence, mypattern)

## invert 옵션 : 반대 표현
# 패턴을 제외하고 추출 
mypattern <- regexpr('ing', mysenctence)
regmatches(mysenctence, mypattern, invert = T)
#"Learn"                " R is so interesting"

mypattern <- gregexpr('ing', mysenctence)
regmatches(mysenctence, mypattern, invert = T)
# "Learn"             " R is so interest" ""   

strsplit(mysenctence, split = 'ing') # "Learn"   " R is so interest"

gsub('ing', '', mysenctence) # "Learn R is so interest"

# 문자열 부분 추출
substr(mysenctence, 1, 20)
substr(mysenctences, 1, 20)

my2senctence <- c('Learning R is so interresting ',
                  'He is a fascinating singer')

# ing로 끝나는 단어만 모두 추출
mypattern0 <- gregexpr('ing', my2senctence)
regmatches(my2senctence, mypattern0)

# ing앞에 오는 알바벳 표현 확인 [[:alpha:]]
mypattern1 <- gregexpr('[[:alpha:]]+(ing)', my2senctence)
regmatches(my2senctence, mypattern1)

# \\b : 해당 패턴으로 끝나는 것 출력
mypattern2 <- gregexpr('[[:alpha:]]+(ing)\\b', my2senctence)
regmatches(my2senctence, mypattern2)

# 7개 문장 모두에 대해 ing로 끝나는 단어 추출 
mypattern3 <- gregexpr('[[:alpha:]]+(ing)\\b', mysenctences)
myings <- regmatches(mysenctences, mypattern3)

# 문서 전체에서 ing로 끝나는 영어단어 모두 추출하고 빈도수 조사
table(unlist(myings))

# 대소문자 처리후 추출하기
mypattern <- gregexpr('[[:alpha:]]+(ing)\\b', tolower(mysenctences))
myings <- regmatches(tolower(mysenctences), mypattern)
table(unlist(myings))

# 대소문자 구분 없이 stat로 시작하는 단어 모두 추출 

pat <- gregexpr('(stat)[[:alpha:]]+', tolower(mysenctences))
stat <- regmatches(tolower(mysenctences), pat)
table(unlist(stat))

mypattern <- gregexpr('[[:upper:]]', mysenctences)
my.upper <- regmatches(mysenctences, mypattern)
table(unlist(my.upper))


mypattern <- gregexpr('[[:lower:]]', mysenctences)
my.lower <- regmatches(mysenctences, mypattern)
table(unlist(my.lower))

mypattern <- gregexpr('[[:upper:]]', toupper(mysenctences))
my.alphas <- regmatches(toupper(mysenctences), mypattern)
mytable <- table(unlist(my.alphas))

mytable[mytable == max(mytable)]
sum(mytable)

## 등장 빈도 시각화
library(ggplot2)

class(mytable)  # table
# ggplot할 때 dataframe로 변환하고 시각화

mydata <- data.frame(mytable)

ggplot(mydata, aes(x=Var1 , y = Freq, fill=Var1)) +
  geom_bar(stat='identity') +
  #guides(fill = F) +
  geom_hline(aes(yintercept = median(mydata$Freq))) +
  xlab('알파벳') +
  ylab('빈도수')

############################################################
# 1. 베이지안 필터기 제작
# 2. POS, NEG 별 알파벳 문자 빈도 
# 3. 감성분석 (예정)

movie_rep <- read.csv('movie-pang02.csv', stringsAsFactors = F)

# 데이터셋 순서 섞기
movie_rep <- movie_rep[sample(2000,2000),]
movie_rep$class <- factor(movie_rep$class)

str(movie_rep)  # class, text
dim(movie_rep)  # 2000, 2
table(movie_rep$class)  # 1000 1000

# 문자열 집합 생성 
library(tm)
movie_corpus <- VCorpus(VectorSource(movie_rep$text))

# 문자열 집합으로 메트릭스 생성
movie_dtm <- DocumentTermMatrix(movie_corpus,
                   control = list(tolower = T,
                                  removeNumbers = T,
                                  stemming = T,
                                  removePunctuation = TRUE,
                                  stopwords = TRUE))

movie_dtm


# 데이터셋 나누기
train <- movie_dtm[1:1400,]
test <- movie_dtm[1401:2000,]

train[1:5,1:5]
test[1:5,1:5]

train_label <- movie_rep$class[1:1400] 
test_label <- movie_rep$class[1401:2000]

# 최소 5번 이상 나온 단어 추출
freq_terms <- findFreqTerms(train, lowfreq = 5)

# 5번 이상 나온 단어들로만 매트릭스 재정의
train <- train[,freq_terms]

# 값들을 범주형으로 변경 
yes_or_no <- function(x){
  x <- ifelse(x>0, 'yes', 'no')  
}

train_yon <- apply(train, MARGIN = 2, FUN =  yes_or_no)
test_yon <- apply(test, MARGIN = 2, FUN =  yes_or_no)

train_yon[1:5,1:5]
test_yon[1:5,1:5]

# 우도표 생성
library(e1071)

movie_classfier <- naiveBayes(train_yon, train_label, laplace = 1)

test_pred <- predict(movie_classfier, test_yon)

library(gmodels)
CrossTable(test_label, test_pred,
           prop.t = F, prop.r = F, dnn = c('actual','predicted'))

#  0
'| predicted 
actual |       Neg |       Pos | Row Total | 
  -------------|-----------|-----------|-----------|
  Neg |       245 |        54 |       299 | 
  |    44.536 |    51.585 |           | 
  |     0.761 |     0.194 |           | 
  -------------|-----------|-----------|-----------|
  Pos |        77 |       224 |       301 | 
  |    44.240 |    51.242 |           | 
  |     0.239 |     0.806 |           | 
  -------------|-----------|-----------|-----------|
  Column Total |       322 |       278 |       600 | 
  |     0.537 |     0.463 |           | 
  -------------|-----------|-----------|-----------|'
  
# 6
'| predicted 
actual |       Neg |       Pos | Row Total | 
  -------------|-----------|-----------|-----------|
  Neg |       266 |        33 |       299 | 
  |    31.992 |    54.474 |           | 
  |     0.704 |     0.149 |           | 
  -------------|-----------|-----------|-----------|
  Pos |       112 |       189 |       301 | 
  |    31.780 |    54.112 |           | 
  |     0.296 |     0.851 |           | 
  -------------|-----------|-----------|-----------|
  Column Total |       378 |       222 |       600 | 
  |     0.630 |     0.370 |           | 
  -------------|-----------|-----------|-----------|'

# 1
'| predicted 
actual |       Neg |       Pos | Row Total | 
  -------------|-----------|-----------|-----------|
  Neg |       248 |        51 |       299 | 
  |    41.192 |    51.029 |           | 
  |     0.747 |     0.190 |           | 
  -------------|-----------|-----------|-----------|
  Pos |        84 |       217 |       301 | 
  |    40.918 |    50.690 |           | 
  |     0.253 |     0.810 |           | 
  -------------|-----------|-----------|-----------|
  Column Total |       332 |       268 |       600 | 
  |     0.553 |     0.447 |           | 
  -------------|-----------|-----------|-----------|'

##########################################################
2
##########################################################
# pos / neg별 데이터프레임 분할
pos <- movie_rep[movie_rep$class == 'Pos',]
neg <- movie_rep[movie_rep$class == 'Neg',]

# 대문자로 변경 후 대문자를 찾는 패턴 생성
pos.pat <- gregexpr('[[:upper:]]', toupper(pos$text))
neg.pat <- gregexpr('[[:upper:]]', toupper(neg$text))

# 패턴에 매치되는 문자 찾기
pos.alpha <- regmatches(toupper(pos$text), pos.pat)
neg.alpha <- regmatches(toupper(neg$text), neg.pat)

# 찾은 문자열 리스트를 벡터로 변경 후 요소별 개수 구하기
pos.table <- table(unlist(pos.alpha))
neg.table <- table(unlist(neg.alpha))

# 최빈 알파벳 찾기
pos.table[pos.table == max(pos.table)]  # E
neg.table[neg.table == max(neg.table) ]  # E

## 시각화
# 테이블을 데이터프레임으로 
pos.data <- data.frame(pos.table)
neg.data <- data.frame(neg.table)
library(ggplot2)
# POS 그래프
ggplot(data = pos.data, aes(x = Var1, y = Freq, fill = Var1)) +
  geom_bar(stat='identity') +
  xlab('알파벳') +
  ylab('빈도수') +
  geom_hline(aes(yintercept = mean(pos.data$Freq))) +
  ggtitle('POS')

# NEG 그래프
ggplot(data = neg.data, aes(x = Var1, y = Freq, fill = Var1)) +
  geom_bar(stat='identity') +
  xlab('알파벳') +
  ylab('빈도수') +
  geom_hline(aes(yintercept = mean(neg.data$Freq))) +
  ggtitle('NEG')


























