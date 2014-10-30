addpath(genpath('./data'), genpath('../data'));
addpath(genpath('./src'), genpath('../src'));

%% Data pre-processing
clear;
load('regression.mat');

X = X_train;
y = y_train;
N = length(y);

% We have N = 1400, D = 44
size(X);
size(y);

% Normalize the features except discrete ones
X(:,1:35) = normalized(X(:,1:35));
%X = [X(:,26) X(:,35)];


%%
proportion = 0.8;
maxDegree = 6;
maxSeeds = 50;

%ridgeTrErr = zeros(size(X,1),maxSeeds);
%ridgeTeErr = zeros(size(X,1),maxSeeds);
rmseTr = zeros(maxSeeds,maxDegree);
rmseTe = zeros(maxSeeds,maxDegree);

degrees = [1:maxDegree];
for degree = 1:length(degrees);
    figure;
    for s = 1:maxSeeds % # of seeds
        % get train and test data with given seed and proportion
        [XTr, yTr, XTe, yTe] = split(y,X,proportion,s);

        % form tX
        tXTr = [ones(length(yTr), 1) createPoly(XTr, degree)];
        tXTe = [ones(length(yTe), 1) createPoly(XTe, degree)];

        % least squares
        %beta = leastSquares(yTr, tXTr);

        % ridge regression
        k = 5; % k-fold cross validation
        lambdas = logspace(-1, 4, 50);
        % We leave X_test and y_test out of the learning process of ridge
        % regression to be able to test its results on truly fresh data
        [beta, trainingErr, testErr] = ridgeRegressionAuto(yTr, tXTr, proportion, k, lambdas);
      
        ridgeTrErr(:,s) = trainingErr;
        ridgeTeErr(:,s) = testErr;
        
        % train and test RMSE
        rmseTr(s,degree) =  computeRmse(yTr, tXTr*beta); 
        rmseTe(s,degree) =  computeRmse(yTe, tXTe*beta);  
        
        % print for each seeds
        %fprintf('Degree %.2f: Train RMSE :%0.4f Test RMSE :%0.4f\n', degree, rmseTr(s,degree), rmseTe(s,degree));
    end
    
    rmseTrMean(degree) = mean(rmseTr(:,degree));
    rmseTeMean(degree) = mean(rmseTe(:,degree));
    rmseTrStd(degree) = std(rmseTr(:,degree));
    rmseTeStd(degree) = std(rmseTe(:,degree));
    fprintf('Degree %d with %d seeds : Train RMSE :%0.4f (std : %0.4f) Test RMSE :%0.4f (std : %0.4f)\n', degree, maxSeeds, rmseTrMean(degree), rmseTrStd(degree), rmseTeMean(degree), rmseTeStd(degree));

    % plot training and test error wrt lambdas averaged on different seeds
    rigdeTrErrMean = mean(ridgeTrErr,2);
    rigdeTeErrMean = mean(ridgeTeErr,2);
    semilogx(lambdas, rigdeTrErrMean, '.-b');
    hold on;
    semilogx(lambdas, rigdeTeErrMean, '.-r');
    xlabel('Lambda');
    ylabel('Training (blue) and test (red) error');
    title(sprintf('Ridge regression with polynomial degree %d',degree))
end

%% Boxplots on different polynomials to visualize above printed results
figure;
boxplot(rmseTe, 'notch', 'on');
ylabel(['RMSE on ', int2str(maxSeeds) ' seeds']);
title(sprintf('RMSE on polynomials up to %d',maxDegree))