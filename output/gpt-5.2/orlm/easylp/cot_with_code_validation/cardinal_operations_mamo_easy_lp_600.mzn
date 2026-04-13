% Parameters
int: BUDGET = 100000;

int: X1_MIN = 10000;
int: X1_MAX = 60000;

int: X2_MIN = 20000;
int: X2_MAX = 80000;

int: X3_MIN = 15000;
int: X3_MAX = 50000;

int: X4_MIN = 200;

% Scale costs by 100 to keep integer objective (cents per $1)
int: C1 = 5;   % 0.05 * 100
int: C2 = 8;   % 0.08 * 100
int: C3 = 12;  % 0.12 * 100
int: C4 = 15;  % 0.15 * 100

% Variables
var X1_MIN..X1_MAX: x1;
var X2_MIN..X2_MAX: x2;
var X3_MIN..X3_MAX: x3;
var X4_MIN..BUDGET: x4;

var 0..(C1*X1_MAX + C2*X2_MAX + C3*X3_MAX + C4*BUDGET): total_cost_cents;

% Constraints
constraint x1 + x2 + x3 + x4 <= BUDGET;

% 0.60*x1 - 0.40*x2 >= 0  <=>  3*x1 - 2*x2 >= 0
constraint 3*x1 - 2*x2 >= 0;

% x3 + x4 should not be less than (x1 + x2) by more than 30000:
% (x3 + x4) >= (x1 + x2) - 30000
constraint x3 + x4 >= x1 + x2 - 30000;

% 0.70*x3 - 0.50*x4 <= 500  <=>  7*x3 - 5*x4 <= 5000
constraint 7*x3 - 5*x4 <= 5000;

constraint total_cost_cents = C1*x1 + C2*x2 + C3*x3 + C4*x4;

% Objective
solve minimize total_cost_cents;