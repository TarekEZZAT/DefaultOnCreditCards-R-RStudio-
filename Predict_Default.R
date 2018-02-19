# Initialize Variables and environment
# lockBinding("constant_name", globalenv())
# RUN initialize.R first

# lockBinding("constant_name", globalenv())
# Use sampled data to avoid usage of large dataframes

DATA_PATH_CSV = "./DATA/UCI_Credit_Card_Sampled.csv"
lockBinding("DATA_PATH_CSV", globalenv())
DATA_PATH_CSV

library('readr')
library('glue')
library('dplyr')
library('rlang')
library('ggplot2')
library('ggthemes')
library('randomForest')
library('magrittr')
library('mfx')
library('devtools')
library('Amelia')

# Set the seed of R‘s random number generator, 
# to create simulations or random objects that can be reproduced.

set.seed(123)

#Load data in UCI_ Credit_Card

UCI_Credit_Card <- read.csv(DATA_PATH_CSV)
View(UCI_Credit_Card)


# Missingness Map
# Plot a missingness map showing where missingness occurs 
# in the dataset passed to Amelia.

missmap(UCI_Credit_Card,main="Miss vs Obs")
UCI_Credit_Card <- read.csv(DATA_PATH_CSV, na.strings=c(""))


# Select numerical columns in the dataframe

numc<-UCI_Credit_Card[,-c(1)] %>%                         
  sapply( is.numeric) %>%     
  which() %>%                 
  names()                     
numc

# Renplae NA values 

# na.roughfix is used to impute missing values by the random forest model.
# There are two ways in which it works.
# 1/ If the data is numeric,na’s are replaced by median values
# 2/ If the variable is categorical,the most frequently occurring value is taken.
# To apply it use the option na.action = na.roughfix inside randomForest function.

UCI_Credit_Card[,numc] %<>% na.roughfix()     
UCI_Credit_Card[,-c(1)] %>%  is.na() %>% sum()  

# Explore the dataframe

# Default / education level
# very few for values 0, 4, 5, 6

ggplot(UCI_Credit_Card, aes(x=default.payment.next.month))+geom_bar()+facet_grid(EDUCATION ~ .)

# Default / marital status
# very few for values 0, 3

ggplot(UCI_Credit_Card, aes(x=default.payment.next.month))+geom_bar()+facet_grid(MARRIAGE ~ .)

# For presentation :
# Modify numerical value of SEX to non mumerical values M/F
# Modify numerical value of EDUCATION to non mumerical values Master, Licence, HighSchool
# Modify numerical value of MARIAGE to non mumerical values Maried/Single
# Modify numerical value of default.payment.next.month to non mumerical values YES/NO

# remove :
#   0, 4, 5 , 6  from education level
#   0, 3 from marital status


UCI_Credit_Card_mod <- UCI_Credit_Card %>% mutate(SEX = factor(ifelse(SEX ==1,"M","F"))) %>% 
  filter(EDUCATION !=0 & EDUCATION != 4 & EDUCATION != 5 & EDUCATION != 6) %>% 
  mutate(EDUCATION = factor( ifelse(EDUCATION==1,"Master",ifelse(EDUCATION==2,"Licence","HighSchool")))) %>% 
  filter(MARRIAGE == 1 | MARRIAGE == 2 ) %>% 
  mutate(MARRIAGE = factor( ifelse(MARRIAGE == 1,"Maried","Maried"))) %>% 
  mutate( Default = factor(ifelse(default.payment.next.month==1,"YES","NO"))) %>% 
  mutate_at(.cols = grep(names(UCI_Credit_Card), pattern = "PAY_\\d"), .funs =  factor) 
UCI_Credit_Card_mod

# Present defaults / EDUCATION
# HighSchool do not behave well

ggplot(UCI_Credit_Card_mod, aes(x=Default))+geom_bar(stat="count")+facet_grid(EDUCATION ~ .)

# Present Dafaults / SEX
# No important correlation

ggplot(UCI_Credit_Card_mod, aes(x=Default))+geom_bar(stat="count")+facet_grid(SEX ~.)

# Present Dafaults / MARIAGE
# No important correlation

ggplot(UCI_Credit_Card_mod, aes(x=Default))+geom_bar(stat="count")+facet_grid(MARRIAGE ~.)


# Present Dafaults / AGE
# Small correlation


ggplot(UCI_Credit_Card_mod, aes(x=AGE, fill=Default))+geom_density()


# Present Dafaults / Credit Limit
# Important correlation

ggplot(UCI_Credit_Card_mod, aes(x=LIMIT_BAL, fill=Default))+geom_density()

# Present Defaults / Amout to settle at a certain month
# Small correlation
# May be correlated to credit limit

ggplot(UCI_Credit_Card_mod, aes(x=BILL_AMT1, fill=Default))+geom_density()+xlim(-5000,200000)
ggplot(UCI_Credit_Card_mod, aes(x=BILL_AMT2, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=BILL_AMT3, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=BILL_AMT4, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=BILL_AMT5, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=BILL_AMT6, fill=Default))+geom_density()


# Present Default / Amount settled at a certain month
# Small correlation

ggplot(UCI_Credit_Card_mod, aes(x=PAY_AMT1, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=PAY_AMT2, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=PAY_AMT3, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=PAY_AMT4, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=PAY_AMT5, fill=Default))+geom_density()
ggplot(UCI_Credit_Card_mod, aes(x=PAY_AMT6, fill=Default))+geom_density()

# Present Deafult / Status at a certain month
# Important correlation

ggplot(UCI_Credit_Card_mod, aes(Default)) + geom_bar(stat="count")+facet_grid(. ~ PAY_0)
ggplot(UCI_Credit_Card_mod, aes(Default)) + geom_bar(stat="count")+facet_grid(. ~ PAY_2)
ggplot(UCI_Credit_Card_mod, aes(Default)) + geom_bar(stat="count")+facet_grid(. ~ PAY_3)
ggplot(UCI_Credit_Card_mod, aes(Default)) + geom_bar(stat="count")+facet_grid(. ~ PAY_4)
ggplot(UCI_Credit_Card_mod, aes(Default)) + geom_bar(stat="count")+facet_grid(. ~ PAY_5)
ggplot(UCI_Credit_Card_mod, aes(Default)) + geom_bar(stat="count")+facet_grid(. ~ PAY_6)

# Back to original names 

UCI_Credit_Card_mod <- UCI_Credit_Card %>%filter(EDUCATION !=0 & EDUCATION != 5 & EDUCATION != 5 & EDUCATION != 6) %>% 
  filter(MARRIAGE == 1 | MARRIAGE == 2 ) %>%
  mutate_at(.cols = grep(names(UCI_Credit_Card),pattern = "PAY_\\d"), .funs =  factor) 

# Training sample (80% of total)

training_data_size <- floor(0.80 * nrow(UCI_Credit_Card_mod))
creditcard_train_index <- sample(1:nrow(UCI_Credit_Card_mod), training_data_size)
creditcard_train <- UCI_Credit_Card_mod[creditcard_train_index, ]

# Test sample (remaining 20%)
creditcard_test <- UCI_Credit_Card_mod[-creditcard_train_index, ]

# Logistic régression 

model <-glm(default.payment.next.month ~ LIMIT_BAL +EDUCATION + SEX+ MARRIAGE + 
              PAY_0 + PAY_2 + PAY_3 + PAY_4 + BILL_AMT1 +
              PAY_AMT1 + PAY_AMT2 + PAY_AMT3 + PAY_AMT4, family=binomial(link="logit"),data=creditcard_train)

mfx <- logitmfx(formula = default.payment.next.month ~ LIMIT_BAL + SEX + EDUCATION + MARRIAGE + 
                  PAY_0 + PAY_2 + PAY_3 + PAY_4+BILL_AMT1 +
                  PAY_AMT1 + PAY_AMT2+ PAY_AMT3 + PAY_AMT4, data=creditcard_train)

# Apply model to test sample

predicted <- predict(model, type = "response", newdata = creditcard_test)
creditcard_test$predicted <- predicted
creditcard_test$prediction <- creditcard_test$predicted > 0.5
creditcard_test$prediction <- as.numeric(creditcard_test$prediction)

# Success rate 82%
dep <- creditcard_test$default.payment.next.month 
ind <- c$prediction
t <- addmargins(table(dep, ind))
(t[1]+t[5])/t[9]
View(creditcard_test)


