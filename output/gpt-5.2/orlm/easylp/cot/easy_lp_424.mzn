% Parameters (with values embedded)
int: costX1 = 50;
int: costX2 = 75;

int: cap_a1 = 10;
int: cap_a2 = 15;
int: cap_b  = 2000;

int: min_a1 = 12;
int: min_a2 = 6;
int: min_b  = 800;

int: bal_a1 = 1;      % X1 coefficient
int: bal_a2_num = -1; % - (1/2) * X2 implemented via 2*X1 - X2
int: bal_b  = 200;    % 2 * 100

% Variables
var 0..10000: X1;
var 0..10000: X2;

var 0..2000000: TotalCost;

% Constraints
constraint cap_a1 * X1 + cap_a2 * X2 <= cap_b;
constraint min_a1 * X1 + min_a2 * X2 >= min_b;

% X1 - 0.5*X2 <= 100  ==>  2*X1 - X2 <= 200
constraint 2 * X1 - X2 <= bal_b;

constraint TotalCost = costX1 * X1 + costX2 * X2;

% Objective
solve minimize TotalCost;