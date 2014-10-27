addpath('../data');

%% Data pre-processing
clear;
load('regression.mat');

X = X_train;
y = y_train;

% Normalize the features except discrete ones
X(:,1:35) = normalized(X(:,1:35));

% separate into 2 different dataset according to our 2 hypothetical
% distributions
[X_m1, y_m1, X_m2, y_m2] = separateDataSet(X, y, 35);

% Normalize the new datasets features
X_m1(:,1:35) = normalized(X_m1(:,1:35));
X_m2(:,1:35) = normalized(X_m2(:,1:35));


%% Model 1 Visualization
hist(y_m1);

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

% it does look better. We could have nicer results with a more accurate
% threshold when separating the dataset

%% Model 2 Visualization
hist(y_m2);

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