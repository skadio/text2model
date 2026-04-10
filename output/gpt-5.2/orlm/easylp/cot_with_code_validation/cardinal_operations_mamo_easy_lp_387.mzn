% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: price = [100, 200, 300, 400];

int: cap12 = 50;
int: cap34 = 80;

float: w1 = 0.6;
float: w2 = 0.8;
float: w3 = 0.7;
float: w4 = 0.9;

float: min12 = 20.0;
float: min34 = 30.0;

% Variables
array[P] of var 0..max(cap12, cap34): x;

var 0..(max(cap12, cap34) * max(price)): total_cost;

% Constraints
constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

% Quality/standard constraints (as given)
constraint w1*int2float(x[1]) + w2*int2float(x[2]) >= min12;
constraint w3*int2float(x[3]) + w4*int2float(x[4]) >= min34;

constraint total_cost = sum(i in P)(price[i] * x[i]);

% Objective
solve minimize total_cost;