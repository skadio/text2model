% Parameters
% Costs per package (in dollars)
array[1..4] of int: cost = [100, 200, 300, 400];

% Resource caps
int: cap12 = 50;  % x1 + x2 <= 50
int: cap34 = 80;  % x3 + x4 <= 80

% Quality/ratings weights and minimum required totals
float: w1 = 0.6;
float: w2 = 0.8;
float: w3 = 0.7;
float: w4 = 0.9;

float: minQual12 = 20.0; % 0.6*x1 + 0.8*x2 >= 20
float: minQual34 = 30.0; % 0.7*x3 + 0.9*x4 >= 30


% Variables
% Number of each tour package to launch (integers, non-negative, bounded by caps)
var 0..cap12: x1;  % package 1
var 0..cap12: x2;  % package 2
var 0..cap34: x3;  % package 3
var 0..cap34: x4;  % package 4

% Total cost (explicitly bounded for linear objective use)
var 0..(cost[1]*cap12 + cost[2]*cap12 + cost[3]*cap34 + cost[4]*cap34): total_cost;


% Constraints
% --- Resource capacity constraints ---
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% --- Quality / minimum weighted rating constraints ---
constraint w1 * int2float(x1) + w2 * int2float(x2) >= minQual12;
constraint w3 * int2float(x3) + w4 * int2float(x4) >= minQual34;

% --- Total cost definition constraint ---
constraint
  total_cost =
    cost[1] * x1 +
    cost[2] * x2 +
    cost[3] * x3 +
    cost[4] * x4;


% Objective
solve minimize total_cost;