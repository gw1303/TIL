# 조건부 확률 
# 머신러닝 : 데이터가 주어졌을 때, ~~가 발생할 확률

# P(A|B)
# B가 주어졌을 때 A의 조건부 확률 
# B확률 대비 A의 확률
# = P(A교집합B) / P(B)


# 베이즈 정리 
# < 조건 >
# 1. 모든 사건이 배반사건
# 2. 모든 사건지의 합집합이 전체집합

# P(Ai교집합B) / P(B)
# = P(Ai교집합B) / (P(a1 교집합 B) + .. + P(A4 교집합 B))
# = P(Ai)P(B|Ai) / P(A1)P(B|A1) + .. + P(A4)P(B|A4)

# 라플라스 추정량 : 부분확률이 0일 때의 문제를 해결

sms_raw<- read.csv('sms_spam_ansi.txt', stringsAsFactors = F)

class(sms_raw)
str(sms_raw)

# chr로 읽은 데이터 타입을 factor로 변경 
sms_raw$type <- factor(sms_raw$type)

table(sms_raw$type) #ham spam 4812  747 

### 텍스트 데이터 정리, 표준화 ###

# tm패키지 : 텍스트 마이닝 패키지 
#install.packages('tm')
library(tm)

# 코퍼스(단어집합) 생성 -> VCorpus()
# 데이터 소스 객체 생성 -> VectorSource()

sms_corpus <- VCorpus(VectorSource(sms_raw$text))
sms_corpus

inspect(sms_corpus[1:2])  # 코퍼스 객체 안의 내용 
sms_corpus[1]             # <<VCorpus>>
sms_corpus[[1]]           # <<PlainTextDocument>>

# corpus객체에서 원본 데이터 출력 
as.character(sms_corpus[[1]])
# 여러개를 리스트 형식으로 출력 
lapply(sms_corpus[1:5], FUN = as.character)
class(sms_corpus[1])   # "VCorpus" "Corpus" 
class(sms_corpus[[1]]) # "PlainTextDocument" "TextDocument"  

sms_corpus_clean <- tm_map(sms_corpus, FUN = content_transformer(tolower))
as.character(sms_corpus_clean[[1]])
class(sms_corpus_clean)      # "VCorpus" "Corpus" 
class(sms_corpus_clean[[1]]) # "character"
# content_transformer를 적용해야 "PlainTextDocument" "TextDocument"   
class(as.character(sms_corpus_clean[[1]])) # "character"

## 숫자 제거
sms_corpus_clean <- tm_map(sms_corpus_clean, FUN = removeNumbers)
# tolower먹인 corpus는 inspect로 텍스트 출력
inspect(sms_corpus_clean[1:5])

## 구두점 제거
removePunctuation('hi...hello.,,h')

sms_corpus_clean <- tm_map(sms_corpus_clean, FUN = removePunctuation)
inspect(sms_corpus_clean[1:5])

## 불용어 설정 : stopwords()
stopwords(kind = 'en')
?stopwords

sms_corpus_clean <- tm_map(sms_corpus_clean, FUN = removeWords, stopwords())
inspect(sms_corpus_clean[1:5])

# ?Regular Expressions as used in R
# x에 전달된 문자열에 대해 puctuation은 ' '로 대체
replacePunctuation<- function(x){
  gsub('[[:punct:]]+', replacement = ' ', x)
}
replacePunctuation('Hi *--/ + sdf +')

gsub('대한민국', '코리아', '대한민국 대한 민국 만세')

## 형태소 분석
#install.packages('SnowballC')
library(SnowballC)

# 단어의 어근 추출 함수 : wordStem()
wordStem(c('learn','learned','learning','learns'))

# wordStem을 텍스트 문서의 전체 코퍼스에 적용 : stemDocument()
sms_corpus_clean <- tm_map(sms_corpus_clean, FUN = stemDocument)
inspect(sms_corpus_clean[1:10])

# 추가 여백 제거
sms_corpus_clean <- tm_map(sms_corpus_clean, FUN = stripWhitespace)
inspect(sms_corpus_clean[1:10])

lapply(sms_corpus[1:10], as.character)

inspect(sms_corpus_clean[1:10])

## 토큰화 (단어) : DocumentTermMatrix()
# DocumentTermMatrix() : sms 메시지 코퍼스 
#  < DTM 행렬 >
# 행 : sms 메시지
# 열 : 단어

sms_dtm2 <- DocumentTermMatrix(sms_corpus, 
                   control = list(tolower = T,
                                  removeNumbers = T,
                                  stemming = T,
                                  removePunctuation = TRUE,
                                              stopwords = TRUE))

# sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

# 트레인, 테스트 데이터 나누기
sms_dtm_train <- sms_dtm2[1:4169,]
sms_dtm_test <- sms_dtm2[4170:5559,]

sms_train_labels <- sms_raw[1:4169,]$type
sms_test_labels <- sms_raw[4170:5559,]$type

## word cloud
# install.packages('wordcloud')
library(wordcloud)

wordcloud(sms_corpus_clean,
          scale = c(5,0.2),
          min.freq = 50,
          max.words = 100,
          random.order = F,
          random.color = T,
          colors = brewer.pal(10,'Paired'))

spam <- subset(sms_raw, type=='spam')
class(spam)
ham <- subset(sms_raw, type=='ham')

wordcloud(spam$text, max.words = 40, scale = c(3,0.5),random.order = F)
wordcloud(ham$text, max.words = 40, scale = c(3,0.5),random.order = F)

class(sms_dtm_train)  # "DocumentTermMatrix"    "simple_triplet_matrix"
# 최소 5번 등장한 단어들만 솎아내기 
sms_freq_words <- findFreqTerms(sms_dtm_train, lowfreq = 5)
str(sms_freq_words)  # chr [1:1145]

sms_dtm_freq_train<- sms_dtm_train[ , sms_freq_words]
sms_dtm_freq_test<- sms_dtm_test[ , sms_freq_words]

# 범주형으로 변환
convert_counts <- function(x){
  x <- ifelse(x > 0, 'Yes', 'No')
}

# 행렬의 열 단위로 전달 : apply(MARGIN = 2)
# 행단위는 MARGIN = 1
sms_train<- apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)
sms_test<- apply(sms_dtm_freq_test, MARGIN = 2, convert_counts)

dim(sms_train)  # 4169 1145

## 나이브 베이지안 필터기 생성 (모델 생성)
# install.packages('e1071')
library(e1071)

# 우도표 생성 
sms_classifier <-naiveBayes(sms_train, sms_train_labels)

# 예측
sms_test_pred <- predict(sms_classifier, sms_test)
sms_test_pred

# 값 비교
library(gmodels)
CrossTable(sms_test_labels, sms_test_pred, prop.t = F,
           prop.r = F, dnn = c('actual','predicted'))

## 라플라스 정리 적용 버전 
sms_classifier2 <-naiveBayes(sms_train, sms_train_labels, laplace = 1)

sms_test_pred2 <- predict(sms_classifier2, sms_test)

CrossTable(sms_test_labels, sms_test_pred2,
           prop.t = F, prop.r = F, dnn = c('actual','predicted'))

##################################################################
################# 독버섯 데이터 베이즈기반 분류 ##################

mushrooms <- read.csv('dataset_for_ml/mushrooms.csv', stringsAsFactors = F)
mushrooms$ type <- factor(mushrooms$ type)


dim(mushrooms)  # 8124   23
str(mushrooms)

812*7
train <- mushrooms[1:5684,-1]
test <- mushrooms[5685:8124,-1] 

train_labels <- mushrooms[1:5684,1]
test_labels <- mushrooms[5685:8124,1] 

model <- naiveBayes(train,train_labels, laplace = 6)
model

ms_pred <- predict(model, test)

CrossTable(test_labels,ms_pred,
           prop.t = F, prop.r = F, dnn = c('actual','predicted'))























































