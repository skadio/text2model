% Parameters
int: nPackages = 4;                                   % number of tour packages
set of int: PACKAGES = 1..nPackages;                  % package index set

array[PACKAGES] of int: price = [100, 200, 300, 400]; % launch cost per package

set of int: GROUP12 = {1,2};                          % packages x1,x2
set of int: GROUP34 = {3,4};                          % packages x3,x4

int: cap12 = 50;                                      % resource cap for x1+x2
int: cap34 = 80;                                      % resource cap for x3+x4

float: w1 = 0.6;                                      % weight for x1 in quality constraint
float: w2 = 0.8;                                      % weight for x2 in quality constraint
float: w3 = 0.7;                                      % weight for x3 in quality constraint
float: w4 = 0.9;                                      % weight for x4 in quality constraint

float: minQual12 = 20.0;                              % minimum weighted quality for x1,x2
float: minQual34 = 30.0;                              % minimum weighted quality for x3,x4


% Variables
array[PACKAGES] of var 0..1000: x;                    % integer number of each package to launch

var 0..(sum(i in PACKAGES)(price[i] * 1000)): total_cost;  % total launch cost (bounded)


% Constraints
%-----------------------------
% Total cost definition
%-----------------------------
constraint
  total_cost = sum(i in PACKAGES)(price[i] * x[i]);

%-----------------------------
% Resource capacity constraints
%-----------------------------
constraint
  sum(i in GROUP12)(x[i]) <= cap12;   % x1 + x2 cannot exceed 50

constraint
  sum(i in GROUP34)(x[i]) <= cap34;   % x3 + x4 cannot exceed 80

%-----------------------------
% Quality (weighted minimum) constraints
% Note: x is integer, weights/thresholds are float; use float() for consistency.
%-----------------------------
constraint
  w1 * float(x[1]) + w2 * float(x[2]) >= minQual12;

constraint
  w3 * float(x[3]) + w4 * float(x[4]) >= minQual34;


% Objective
solve minimize total_cost;