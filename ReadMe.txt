Credit default risk analysis 

Method 
1 / The file is in CSV format, change it to a dataframe in R 
2 / Examine the dataframe to determine the relevant data that will be represented 
3 / Study the variations of the data relative to each other according to various parameters, to reveal the correlations between them 
4 / Try different models of representation, to determine which is the best suited. (This is the most delicate part) 
5 / Set up the data flow to manage the new events of the Dataframe, relaunch the statistical models and improve the accuracy of the model. 
Description of the dataset 
ID	customer identity 
LIMIT_BAL 	Credit limit granted 
SEX 	1-man, 2-woman 
EDUCATTION	1-school, 2-high studies 
AGE 
PAY- 	repayment of credit in September 2005 
              -1 	has paid 
              1 	delay 1 month 
              ... 
              8 	delay 8 months 

BILL-AMT 
              1 	invoices to be paid in September 2005 
              2 	invoices to be paid in August 2005 
              3 	bills to pay in July               2005 
              4 	invoices to be paid in June 2005 
              5 	bills to be paid in May 2005 
              6 	bills to be paid in April 2005 
PAY-AMT 
              1 	amount paid in September 2005 
              2 	amount paid in August 2005 
              3 	amount paid in July 2005 
              4 	amount paid in June 2005 
              5 	amount paid in May 2005 
              6 	amount paid in April 2005 
Payment default (Yes / No) 1-Yes, 0-No 
 
