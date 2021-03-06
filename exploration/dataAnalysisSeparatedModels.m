addpath(genpath('./data'), genpath('../data'));
addpath(genpath('./src'), genpath('../src'));

%% Data pre-processing
clear;
load('regression.mat');

X = X_train;
y = y_train;

% Normalize the features except discrete ones
X(:,1:35) = normalized(X(:,1:35));

% separate into 2 different dataset according to our 2 hypothetical
% distributions
[betaClassify, X_m1, y_m1, X_m2, y_m2] = separateDataSet(y, X, 6200);

% Normalize the new datasets features
X_m1(:,1:35) = normalized(X_m1(:,1:35));
X_m2(:,1:35) = normalized(X_m2(:,1:35));


%% Model 1 Visualization
figure;
hist(y_m1);
title('Repartition of y_{m1}');

figure;
side = 7;
for k = 1:size(X_m1, 2)
    subplot(side, side, k);
    hist(X_m1(:, k));
    title(['X_{m1}', int2str(k)]);
end;

figure;
side = 7;
for k = 1:size(X_m1, 2)
    subplot(side, side, k);
    plot(X_m1(:, k), y_m1, '.');
    title(['X_{m1}', int2str(k), ' versus y_{m1}']);
end;

% It does look better. We could have nicer results with a more accurate
% threshold when separating the dataset
% The extra data points for which y is small could be discarded as
% outliers.

%% Model 2 Visualization
figure;
hist(y_m2);
title('Repartition of y_{m2}');

figure;
side = 7;
for k = 1:size(X_m2, 2)
    subplot(side, side, k);
    hist(X_m2(:, k));
    title(['X_{m2}', int2str(k)]);
end;

figure;
side = 7;
for k = 1:size(X_m2, 2)
    subplot(side, side, k);
    plot(X_m2(:, k), y_m2, '.');
    title(['X_{m2}', int2str(k), ' versus y_{m2}']);
end;


%% Modele 1: Compute the correlation between the features

selector = @(x) abs(x) > 0.4;
correlatedVariables = findCorrelations(selector, X_m1);
correlatedVariables

% There are very high correlations between some features,
% e.g.X25/X26, X13/X8, X16/X2.
% These correlations are stronger than without separating the dataset,
% which makes sense.

%% Modele 2: Compute the correlation between the features

selector = @(x) abs(x) > 0.4;
correlatedVariables = findCorrelations(selector, X_m2);
correlatedVariables

% Here as well we obtain some highly correlated features.
