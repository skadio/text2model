% Parameters
int: BUDGET_MAX = 5000;

int: a1x = 3;
int: a1y = -1;
int: a1z = 1;
int: rhs1 = 2000; % >=

int: a2x = 1;   % x - 2y + z >= -1000  (equivalent to x - 2y + z + 1000 >= 0)
int: a2y = -2;
int: a2z = 1;
int: rhs2 = -1000; % >=

int: a3x = 1;
int: a3y = -1;
int: a3z = 3;
int: rhs3 = 1500; % >=

int: costX = 60;
int: costY = 75;
int: costZ = 50;

% Variables
var 0..BUDGET_MAX: x;
var 0..BUDGET_MAX: y;
var 0..BUDGET_MAX: z;

var 0..(costX*BUDGET_MAX + costY*BUDGET_MAX + costZ*BUDGET_MAX): total_cost;

% Constraints
constraint x + y + z <= BUDGET_MAX;

constraint a1x*x + a1y*y + a1z*z >= rhs1;
constraint a2x*x + a2y*y + a2z*z >= rhs2;
constraint a3x*x + a3y*y + a3z*z >= rhs3;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;