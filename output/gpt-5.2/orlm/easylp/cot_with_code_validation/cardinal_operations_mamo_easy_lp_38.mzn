% Parameters
int: budget = 100000;
int: minX = 10000;
int: minY = 5000;
int: risk_rhs = 20000;
int: coefX = 3;
int: coefY = -1;
int: costX = 5000;
int: costY = 4000;

% Variables
var minX..budget: X;
var minY..budget: Y;
var 0..(costX * budget + costY * budget): total_cost;
var 0..((costX * budget + costY * budget + 50) div 100): rounded_cost_hundreds;

% Constraints
constraint X + Y <= budget;
constraint coefX * X + coefY * Y >= risk_rhs;

constraint total_cost = costX * X + costY * Y;

% Round to nearest hundred dollars:
% rounded_cost = 100 * rounded_cost_hundreds
constraint rounded_cost_hundreds = (total_cost + 50) div 100;

% Objective
solve minimize rounded_cost_hundreds;