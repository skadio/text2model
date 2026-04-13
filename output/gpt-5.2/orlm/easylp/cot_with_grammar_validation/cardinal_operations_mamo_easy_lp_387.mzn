% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: price = [100, 200, 300, 400];

int: cap12 = 50;
int: cap34 = 80;

% Weighted quality requirements (scaled by 10 to keep integers)
% 0.6,0.8,0.7,0.9 -> 6,8,7,9
array[P] of int: w = [6, 8, 7, 9];
int: req12 = 200; % 20 * 10
int: req34 = 300; % 30 * 10

% Variables
array[P] of var 0..80: x;

var 0..(400*80*4): total_cost;

% Constraints
constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

constraint w[1]*x[1] + w[2]*x[2] >= req12;
constraint w[3]*x[3] + w[4]*x[4] >= req34;

constraint total_cost = sum(i in P)(price[i] * x[i]);

% Objective
solve minimize total_cost;