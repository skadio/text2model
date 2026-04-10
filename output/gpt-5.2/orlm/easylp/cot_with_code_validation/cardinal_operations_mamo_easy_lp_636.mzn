% Parameters
int: c1 = 300;
int: c2 = 200;
int: c3 = 100;
int: c4 = 50;

int: ub12 = 500;

int: rhs_min_23 = 700;      % 2*x1 + 3.5*x3 >= 700  ->  4*x1 + 7*x3 >= 1400
int: bal1_ub = 300;         % x2 - 0.5*x3 - x1 <= 300 -> 2*x2 - x3 - 2*x1 <= 600
int: bal2_ub = 400;         % 0.5*x4 - x2 <= 400      -> x4 - 2*x2 <= 800
int: policy_gap = 150;      % x4 <= x1 - 150

% Variable bounds (safe finite upper bounds derived from constraints)
int: UBx1 = 500;                        % from x1 + x2 <= 500 and x2 >= 0
int: UBx2 = 500;                        % from x1 + x2 <= 500 and x1 >= 0
int: UBx3 = 1400 div 7;                 % from 4*x1 + 7*x3 >= 1400 with x1 >= 0 => x3 <= 200 is safe for bounding
int: UBx4 = UBx1;                       % from x4 <= x1 - 150, so x4 <= x1

% Variables
var 0..UBx1: x1;
var 0..UBx2: x2;
var 0..UBx3: x3;
var 0..UBx4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= ub12;

% 2*x1 + 3.5*x3 >= 700  -> multiply by 2 to keep integers: 4*x1 + 7*x3 >= 1400
constraint 4*x1 + 7*x3 >= 2 * rhs_min_23;

% x2 - 0.5*x3 - x1 <= 300  -> multiply by 2: 2*x2 - x3 - 2*x1 <= 600
constraint 2*x2 - x3 - 2*x1 <= 2 * bal1_ub;

% 0.5*x4 - x2 <= 400  -> multiply by 2: x4 - 2*x2 <= 800
constraint x4 - 2*x2 <= 2 * bal2_ub;

% x4 <= x1 - 150
constraint x4 <= x1 - policy_gap;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;