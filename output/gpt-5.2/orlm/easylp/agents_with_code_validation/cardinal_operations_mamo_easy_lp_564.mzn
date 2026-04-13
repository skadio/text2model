% Parameters
int: total_budget = 1000;              % Maximum total funding available across all programs

int: min_funding_X = 300;              % Minimum required funding for program X
int: min_funding_Y = 200;              % Minimum required funding for program Y
int: min_funding_Z = 100;              % Minimum required funding for program Z

int: cost_per_unit_X = 500;            % Cost per unit funding in program X
int: cost_per_unit_Y = 300;            % Cost per unit funding in program Y
int: cost_per_unit_Z = 200;            % Cost per unit funding in program Z


% Variables
var min_funding_X..total_budget: fund_X;  % Funding allocated to program X (integer units)
var min_funding_Y..total_budget: fund_Y;  % Funding allocated to program Y (integer units)
var min_funding_Z..total_budget: fund_Z;  % Funding allocated to program Z (integer units)

% Total cost upper bound: worst case if each program could individually take total_budget
var 0..(cost_per_unit_X*total_budget + cost_per_unit_Y*total_budget + cost_per_unit_Z*total_budget): total_cost;


% Constraints
% Total funding across programs cannot exceed available budget
constraint fund_X + fund_Y + fund_Z <= total_budget;

% Total cost definition
constraint
  total_cost = cost_per_unit_X * fund_X
             + cost_per_unit_Y * fund_Y
             + cost_per_unit_Z * fund_Z;


% Objective
solve minimize total_cost;