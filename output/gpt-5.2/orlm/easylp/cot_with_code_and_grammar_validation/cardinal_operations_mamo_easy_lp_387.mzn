% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: price = [100, 200, 300, 400];

int: cap12 = 50;
int: cap34 = 80;

int: req12 = 20;
int: req34 = 30;

% Use scaled integers to avoid floats (x10 scaling)
array[P] of int: w10 = [6, 8, 7, 9];
int: req12_10 = req12 * 10;
int: req34_10 = req34 * 10;

% Variable upper bounds from caps
array[P] of int: ub = [cap12, cap12, cap34, cap34];

% Variables
array[P] of var 0..max(ub): x;

% Constraints
constraint x[1] <= ub[1];
constraint x[2] <= ub[2];
constraint x[3] <= ub[3];
constraint x[4] <= ub[4];

constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

constraint w10[1]*x[1] + w10[2]*x[2] >= req12_10;
constraint w10[3]*x[3] + w10[4]*x[4] >= req34_10;

% Objective
solve minimize sum(i in P)(price[i] * x[i]);