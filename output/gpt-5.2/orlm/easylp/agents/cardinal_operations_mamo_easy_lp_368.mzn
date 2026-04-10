% Parameters
int: cost_X1 = 500;          % Cost per unit for project X1
int: cost_X2 = 300;          % Cost per unit for project X2
int: cost_X3 = 700;          % Cost per unit for project X3
int: cost_X4 = 600;          % Cost per unit for project X4

int: max_X1 = 50;            % Maximum units allowed for X1
int: max_X2 = 60;            % Maximum units allowed for X2
int: max_X3 = 40;            % Maximum units allowed for X3
int: max_X4 = 30;            % Maximum units allowed for X4

int: cap_X1_X2 = 100;        % Upper bound on X1 + X2
int: cap_2X3_X4 = 120;       % Upper bound on 2*X3 + X4
int: min_X1_X3 = 60;         % Lower bound on X1 + X3
int: min_X2_X4 = 80;         % Lower bound on X2 + X4


% Variables
var 0..max_X1: X1;           % Resource allocation for project X1 (integer units)
var 0..max_X2: X2;           % Resource allocation for project X2 (integer units)
var 0..max_X3: X3;           % Resource allocation for project X3 (integer units)
var 0..max_X4: X4;           % Resource allocation for project X4 (integer units)

var 0..(cost_X1*max_X1 + cost_X2*max_X2 + cost_X3*max_X3 + cost_X4*max_X4): total_cost;
                             % Total cost of allocations (bounded by max allocations)


% Constraints
% Link total_cost to the linear cost expression
constraint total_cost =
  cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% Budget/capacity constraint: combined allocation for X1 and X2 cannot exceed cap_X1_X2
constraint X1 + X2 <= cap_X1_X2;

% Budget/capacity constraint: allocation for (2 * X3 + X4) cannot exceed cap_2X3_X4
constraint 2 * X3 + X4 <= cap_2X3_X4;

% Minimum requirement: combined resources for X1 and X3 must be at least min_X1_X3
constraint X1 + X3 >= min_X1_X3;

% Minimum requirement: combined resources for X2 and X4 must be at least min_X2_X4
constraint X2 + X4 >= min_X2_X4;


% Objective
solve minimize total_cost;