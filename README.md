ml-project-1
============

EPFL's Pattern Classification and Machine Learning first course project

## Methods to be implemented

- `beta = leastSquaresGD(y,tX,alpha)`: Least squares using gradient descent (alpha is the step-size)
- `beta = leastSquares(y,tX)`: Least squares using normal equations
- `beta = ridgeRegression(y,tX, lambda)`: Ridge regression using normal equations (lambda is the regularization coefficient)
- `beta = logisticRegression(y,tX,alpha)`: Logistic regression using gradient descent or Newton's method (alpha is the step size, in case of gradient descent)
- `beta = penLogisticRegression(y,tX,alpha,lambda)`: Penalized logistic regression using gradient descent or Newton's method (alpha is the step size for gradient descent, lambda is the regularization parameter)