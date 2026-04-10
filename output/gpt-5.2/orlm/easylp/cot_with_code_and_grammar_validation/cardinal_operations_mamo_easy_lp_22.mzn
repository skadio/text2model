% Parameters
int: costX = 50;
int: costY = 60;

int: cap_rhs = 500;          % X + 2Y <= 500
int: demand_rhs = 200;       % 3X + Y >= 200
int: balance_limit = 100;    % |X - Y| <= 100

% Variables
var 0..500: X;
var 0..250: Y;
var int: total_cost;

% Constraints
constraint X + 2*Y <= cap_rhs;
constraint 3*X + Y >= demand_rhs;
constraint abs(X - Y) <= balance_limit;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;