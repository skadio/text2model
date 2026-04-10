% Parameters
int: c1 = 100;
int: c2 = 150;
int: c3 = 80;
int: c4 = 50;

% To avoid fractions in constraints, scale all constraints by 2 (since 7.5=15/2 and 8.5=17/2)
int: SCALE = 2;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Constraints
% Non-negativity bounds (explicit bounds were not provided; assume resources cannot be negative)
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% 1) 3*x1 + 2*x2 - x3 <= 5000
constraint 3*x1 + 2*x2 - x3 <= 5000;

% 2) 4*x2 + x4 - x1 >= 2000
constraint 4*x2 + x4 - x1 >= 2000;

% 3) 5*x3 - x1 - x2 - x4 = 4000
constraint 5*x3 - x1 - x2 - x4 = 4000;

% 4) 6*x2 + 7.5*x3 - 8.5*x4 - x1 <= 3000
% Scaled by 2: 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000
constraint 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 2*3000;

% Objective
solve minimize total_cost;