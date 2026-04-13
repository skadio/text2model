% Parameters (with values embedded)
int: max_x1 = 150;
int: max_x2 = 100;
int: max_x3 = 80;
int: max_x4 = 20;

int: cost_x1 = 10000;
int: cost_x2 = 5000;
int: cost_x3 = 8000;
int: cost_x4 = 6000;

% Variables
var 0..max_x1: X1;
var 0..max_x2: X2;
var 0..max_x3: X3;
var 0..max_x4: X4;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_support_points;

% Constraints
constraint X1 + X2 <= 200;

% 2*X1 + 3.5*X3 >= 400  -> multiply by 2 to keep integer arithmetic: 4*X1 + 7*X3 >= 800
constraint 4*X1 + 7*X3 >= 800;

% |X2 - 0.5*X4| <= 50  -> multiply by 2: |2*X2 - X4| <= 100
constraint abs(2*X2 - X4) <= 100;

% X2 - X1 - X3 <= 70
constraint X2 - X1 - X3 <= 70;

% Objective expression
constraint total_support_points = cost_x1*X1 + cost_x2*X2 + cost_x3*X3 + cost_x4*X4;

% Objective
solve minimize total_support_points;