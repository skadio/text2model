% Parameters
int: min_diversification = 10;          % 2*X + Y + Z >= 10
int: max_risk_exposure = 15;            % X - Y + 2*Z <= 15
int: x_minus_y = 3;                     % X = Y + 3
int: budget = 20;                       % X + Y + Z <= 20

int: costX = 7;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint 2*X + Y + Z >= min_diversification;
constraint X - Y + 2*Z <= max_risk_exposure;
constraint X = Y + x_minus_y;
constraint X + Y + Z <= budget;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;