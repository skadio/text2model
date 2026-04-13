% Parameters (with values embedded)
int: total_budget_max = 5000;

int: rhs1 = 2000;   % 3*X - Y + Z >= 2000
int: rhs2 = 1000;   % X - 2*Y + Z >= -1000  (rearranged from X - 2Y - Z <= 1000)
int: rhs3 = 1500;   % X - Y + 3*Z >= 1500

int: costX = 60;
int: costY = 75;
int: costZ = 50;

% Variables
var 0..total_budget_max: X;
var 0..total_budget_max: Y;
var 0..total_budget_max: Z;

var 0..(costX*total_budget_max + costY*total_budget_max + costZ*total_budget_max): TotalCost;

% Constraints
constraint X + Y + Z <= total_budget_max;

constraint 3*X - Y + Z >= rhs1;

% From: X - 2*Y - Z <= 1000  =>  X - 2*Y + Z >= -1000
constraint X - 2*Y + Z >= -rhs2;

constraint X - Y + 3*Z >= rhs3;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;