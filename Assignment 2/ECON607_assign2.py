import pandas as pd
import numpy as np

from mlxtend.frequent_patterns import apriori
from mlxtend.frequent_patterns import association_rules

basket_data = pd.read_csv("/Users/andrew/Downloads/UW courses/ECON 607/Assignment 2/MarketBasketAnalysisData.csv")
print(basket_data)

basket_data = basket_data.drop(['ID'], axis=1)

print(basket_data)

df=pd.DataFrame(basket_data.head(),columns=['Oranges', 'Apples', 'Bananas', 'Berries', 'Pears', 'Grapes'] )

frequentsets = apriori(basket_data, min_support=0.4, use_colnames=True)
print(frequentsets)

rules = association_rules(frequentsets, metric="lift", min_threshold=1)
print(rules)

basket_data2 = pd.DataFrame(rules, columns=['antecedents', 'consequents', 'support', 'confidence', 'lift'])
print(basket_data2)