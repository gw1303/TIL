#   x     : 데이터
#  f(x)   : 정답
#  _
#  f(x)   : 예측값 
#  E[ ]   : 기대값(평균)
# E[f(x)] : 예측값들의 평균
#           _ 
# 편향 : (E[f(x)] - f(x))^2
#        _        _
# 분산 :[f(x) - E[f(x)]]^2

# Error(x) = 편향 + 분산 + e(근본적인 오류)

#  과적합(over fitting)   : 편향 낮음 / 분산 높음 -> 훈련이 너무 과하게 된 상태  
# 과소적합(under fitting) : 편향 높음 / 분산 낮음 -> 훈련이 덜 된 상태

#####################
## 연관규칙분석 !! ##
# - 연관성 찾기, 거래 data 특성 찾기 // 패턴 찾기

# 데이터 = {빵, 버터, 우유, 껌} .. 
#     |
# 연관규칙 (Apriori 알고리즘) // 암 data(DNA패턴, 단백질 서열), 사기성 신용카드 사용, 부당 의료비청구 패턴
#     |                       // 통신사 고객 변심 패턴, 시간 흐름에 따른 구매 패턴
#    LHS         RHS
# {버터, 빵} -> {우유}
#     x           y 
# 지지도 (support) : 항목집합이 나타나는 트랜잭션 비율
#                    x,y 지지도 = x,y를 모두 포함하고 있는 거래의 수 / 전체 거래 수
# 신뢰도 (confidence) : 항목집합 x를 포함하는 거래 중에서, 항목집합 y도 포함하는 거래 비율(조건부확률)
#                    x,y 신뢰도 = x,y를 모두 포함하고 있는 거래의 수 / x가 포함된 거래 수
# 향상도 (lift) : 항목집합 x가 주어지지 않을 때, 항목집합 y의 활률 대비 
#                 항목집합 x가 주어졌을 때, 항목집합 y의 확률 증가 비율
#                    x,y 향상도 = 신뢰도 / y의 지지도

# 아이템 수 별 연관규칙의 수 : 3^k - 2^(k+1) +1  // k는 아이템의 수

# pruning (가지치기) : 더이상 해(연관규칙)가 될 가능성이 없다면 제거 // 항목집합 수를 줄임 

# 빈발항목 집합 : 최소 지지도 이상을 갖는 집합
# 아뜨리오알고리즘 : 최소 지지도를 정하고 빈발항목 집합만을 찾아서 연관규칙을 찾음
#   1. 빈발집합의 모든 부분집합은 빈발집합
#   2. 한 항목집합이 비빈발집합이라면 이 항목집합을 포함하는 모든 집합은 비빈발항목

install.packages("arules")
library(arules)

groceries <- read.transactions('dataset_for_ml/groceries.csv', sep=',', header = F)
summary(groceries)
# 9835 rows (구매항목) / 169 columns (items의 종류)
# most frequent items: whole milk (2513) 0.255 지지도
# sizes : 한 거래당 구매 상품의 개수

# transactions의 내용을 보기위한 함수 inspect
inspect(groceries[1:5])

# 아이템이 포함된 거래의 비율
itemFrequency(groceries[,1:169])
# 시각화 (지지도 0.1이상인 항목 출력)
itemFrequencyPlot(groceries, support=0.1)
# 상위항목 출력
itemFrequencyPlot(groceries, top=10)

image(groceries[1:50])

image(sample(groceries, 100))

# apriori(data, parameter = NULL,
#          appearance = NULL, control = NULL)
groceriesRules <- apriori(groceries,
                          parameter = list(supp = 0.006, conf = 0.25, minlen = 2))
# min = 2는 최소 포함 아이템의 수

summary(groceriesRules)
# item 출력
inspect(groceriesRules[190:200])
# lift 가 높은 순으로 정렬해서 출력
inspect(sort(groceriesRules, by='lift')[1:5])
# {herbs}  => {root vegetables} lift : 3.95
# 허브를 산 사람들이 채소를 살 가능성이 채소를 산 일반고객보다 4배가 더 높다.

# 특정 item이 들어간 규칙 찾기
berryRules <- subset(groceriesRules, items %in% c('berries','yogurt'))
inspect(berryRules)

# 파일로 내보내기
write(groceriesRules, file = 'groceryRules.csv', sep=',')

grdf <- as(groceriesRules, 'data.frame')
grdf

#####################################################################################
#####################################################################################
#####################################################################################

data(Epub)
help(Epub)

# 트랜잭션의 요약 보기
summary(Epub) # 15729 rows / 936 columns (items)

# Epub트랜잭션의 내용 보기
inspect(Epub)

# 행별 빌린 아이템을 이미지로 출력
image(Epub[1:150,1:500])
image(sample(Epub, 5000))

# item의 빈도수 보기 
itemFrequency(Epub[,1:8])*100

# 지지도가 제일 높은 것 10개 출력
itemFrequencyPlot(Epub, top=10)
# 지지도가 0.01이 넘는 아이템 출력
itemFrequencyPlot(Epub, support = 0.005)

# apriori알고리즘으로 연관성 분석
apriori(Epub, parameter = list(supp = 0.005, conf = 0.001, minlen = 3))
EpubRules <- apriori(Epub, parameter = list(supp = 0.002, conf = 0.01, minlen = 2))
inspect(EpubRules)

# 연관규칙별 상위 5개 룰 찾기 
EpubRules_top_support <- sort(EpubRules, by='support')[1:5]
EpubRules_top_support <- sort(EpubRules, by='confidence')[1:5]
EpubRules_top_support <- sort(EpubRules, by='lift')[1:5]

# 상위 5개의 값을 출력
inspect(EpubRules_top_support)  # 0.0027  [1] {doc_4ac} => {doc_16e}
inspect(EpubRules_top_support)  # 0.43    [1] {doc_4ac} => {doc_16e}
inspect(EpubRules_top_support)  # 53      [1] {doc_4ac} => {doc_16e}

# 특정 item이 들어있는 rule 출력
inspect(subset(EpubRules, items %in% 'doc_4ac'))
inspect(subset(EpubRules, items %in% c('doc_4ac','doc_972')))

# rules 시각화
install.packages('arulesViz')
library(arulesViz)

plot(EpubRules) 
plot(EpubRules,interactive = TRUE) #2
plot(EpubRules,measure=c("support","lift"),shading="confidence",interactive = TRUE) #3

EpubRules_sub1<-EpubRules[quality(EpubRules)$confidence>0.001]
EpubRules_sub1  #output : set of 113 rules


plot(EpubRules_sub1, method="matrix", measure=c("lift", "confidence")) #4
plot(EpubRules_sub1, method="matrix3D", measure="lift") #5

plot(EpubRules_sub1, method="grouped") #6
plot(EpubRules_sub1, method="paracoord") #7

(G_arulesViz_sub2 <- head(sort(EpubRules, by="lift"),10))
plot(G_arulesViz_sub2, method="graph", control=list(type="items")) #8




















































































































































































