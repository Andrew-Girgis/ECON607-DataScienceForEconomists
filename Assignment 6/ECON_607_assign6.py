import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import GridSearchCV, train_test_split
import skfda
from skfda.ml.classification import KNeighborsClassifier

X, y = skfda.datasets.fetch_growth(return_X_y=True, as_frame=True)
X = X.iloc[:, 0].values
y = y.values

# Plot samples grouped by sex
X.plot(group=y.codes, group_names=y.categories)
plt.show()

y = y.codes

print(y)

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.25,
    stratify=y,
    random_state=21108082,
)

knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train, y_train)

pred = knn.predict(X_test)
print(pred)

score = knn.score(X_test, y_test)
print(score)

probs = knn.predict_proba(X_test[:5])  # Predict first 5 samples
print(probs)

# Only odd numbers, to prevent ties
param_grid = {"n_neighbors": range(1, 18, 2)}

knn = KNeighborsClassifier()

# Perform grid search with cross-validation
gscv = GridSearchCV(knn, param_grid, cv=5)
gscv.fit(X_train, y_train)

print("Best params:", gscv.best_params_)
print("Best cross-validation score:", gscv.best_score_)

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
ax.bar(param_grid["n_neighbors"], gscv.cv_results_["mean_test_score"])
ax.set_xticks(param_grid["n_neighbors"])
ax.set_ylabel("Cross-validation score")
ax.set_xlabel("Number of Neighbors")
ax.set_ylim((0.9, 1))
plt.show()

score = gscv.score(X_test, y_test)
print(score)

# Counting occurrences of each value in y_test
counts = [sum(y_test == 0), sum(y_test == 1)]

# Defining the labels and colors
labels = ['Female', 'Male']
colors = ['pink', 'lightblue']

plt.barh(labels, counts, color=colors)
plt.title("Male vs Females")
plt.show()


print("hello")
print(y_test)