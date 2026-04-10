% Parameters (with values embedded)
int: MAX_TOTAL = 5000;
int: MIN_EFFECTIVENESS = 2000; % points
int: DIFF_LIMIT = 100;

int: C1 = 50;
int: C2 = 75;
int: C3 = 60;

int: X1_MAX = 3000;
int: X2_MAX = 2500;
int: X3_MAX = 1500;

% To avoid fractional coefficients, scale effectiveness by 10:
% 0.5*X1 + 0.4*X2 + 0.6*X3 >= 2000
% => 5*X1 + 4*X2 + 6*X3 >= 20000
int: MIN_EFFECTIVENESS_SCALED = 20000;

% Variables
var 0..X1_MAX: X1;
var 0..X2_MAX: X2;
var 0..X3_MAX: X3;

var 0..(C1*X1_MAX + C2*X2_MAX + C3*X3_MAX): total_cost;

% Constraints
constraint X1 + X2 + X3 <= MAX_TOTAL;

constraint 5*X1 + 4*X2 + 6*X3 >= MIN_EFFECTIVENESS_SCALED;

constraint abs(2*X2 - (X1 + X3)) <= DIFF_LIMIT;

constraint total_cost = C1*X1 + C2*X2 + C3*X3;

% Objective
solve minimize total_cost;