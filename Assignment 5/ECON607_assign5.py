import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import sklearn.cluster as cluster
import warnings

warnings.filterwarnings('ignore')

# Load the dataset
df = pd.read_csv('/Users/andrew/Downloads/UW courses/ECON 607/Assignment 5/Mall_Customers.csv')

# Display the first few rows of the dataset
print(df.head())

# Rename the columns for easier access
df.rename(columns={'Annual Income (k$)': 'Income', 'Spending Score (1-100)': 'Spending_Score'}, inplace=True)
print(df.head())

# Display descriptive statistics of the dataset
print(df.describe())

# Visualize the pairwise relationships in the dataset
sns.pairplot(df[['Age', 'Income', 'Spending_Score']])
plt.show()

# Perform K-means clustering with 5 clusters using 'Spending_Score' and 'Income' variables
kmeans = cluster.KMeans(n_clusters=5, init="k-means++")
kmeans = kmeans.fit(df[['Spending_Score', 'Income']])
kmeans.cluster_centers_

# Assign the cluster labels to the dataframe
df['Clusters'] = kmeans.labels_

# Display the first few rows of the dataframe with cluster labels
print(df.head())

print(df['Clusters'].value_counts())

# Save the dataframe with cluster labels to a CSV file
#df.to_csv('mallClusters.csv', index=False)

# Visualize the clusters using a scatterplot
sns.scatterplot(x="Spending_Score", y="Income", hue='Clusters', data=df)
plt.show()


# Perform K-means clustering with 3 clusters using 'Age' and 'Spending_Score' variables
kmeans3 = cluster.KMeans(n_clusters=3, init="k-means++")
kmeans3 = kmeans3.fit(df[['Age', 'Spending_Score']])
kmeans3.cluster_centers_

# Assign the cluster labels to the dataframe
df['Clusters3'] = kmeans3.labels_

# Display the first few rows of the dataframe with cluster labels
print(df.head())

# Save the dataframe with cluster labels to a CSV file
df.to_csv('mallClusters_with_3_clusters.csv', index=False)

# Visualize the clusters using a scatterplot
sns.scatterplot(x="Age", y="Spending_Score", hue='Clusters3', data=df)
plt.show()

print(df['Clusters3'].value_counts())
