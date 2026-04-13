% Parameters
int: total_budget = 1000;          % Maximum total funding available
int: min_fund_X = 300;             % Minimum required funding for program X
int: min_fund_Y = 200;             % Minimum required funding for program Y
int: min_fund_Z = 100;             % Minimum required funding for program Z

int: cost_X = 500;                 % Cost per unit of funding in program X
int: cost_Y = 300;                 % Cost per unit of funding in program Y
int: cost_Z = 200;                 % Cost per unit of funding in program Z


% Variables
var 0..total_budget: fund_X;       % Funding allocated to program X (integer units)
var 0..total_budget: fund_Y;       % Funding allocated to program Y (integer units)
var 0..total_budget: fund_Z;       % Funding allocated to program Z (integer units)

% Upper bound uses the maximum unit cost times the maximum possible total funded units
var 0..(total_budget * max([cost_X, cost_Y, cost_Z])): total_cost; % Total cost (integer)


% Constraints
% Budget feasibility: total funding across all programs cannot exceed available budget
constraint
  fund_X + fund_Y + fund_Z <= total_budget;

% Minimum operational funding requirements for each program
constraint fund_X >= min_fund_X;
constraint fund_Y >= min_fund_Y;
constraint fund_Z >= min_fund_Z;

% Total cost definition: cost equals sum of per-unit costs times allocated funding
constraint
  total_cost = cost_X * fund_X + cost_Y * fund_Y + cost_Z * fund_Z;


% Objective
solve minimize total_cost;