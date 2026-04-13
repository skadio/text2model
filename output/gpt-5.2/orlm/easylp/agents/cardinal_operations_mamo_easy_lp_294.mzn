% Parameters
int: total_budget = 100;              % Total funding available (units)

int: min_fund_X = 30;                 % Minimum funding required for department X
int: min_fund_Y = 20;                 % Minimum funding required for department Y
int: min_fund_Z = 10;                 % Minimum funding required for department Z

int: cost_per_unit_X = 20;            % Cost per unit of effectiveness for X
int: cost_per_unit_Y = 15;            % Cost per unit of effectiveness for Y
int: cost_per_unit_Z = 10;            % Cost per unit of effectiveness for Z

% Variables
var min_fund_X..total_budget: fund_X; % Allocated funding to department X (integer units)
var min_fund_Y..total_budget: fund_Y; % Allocated funding to department Y (integer units)
var min_fund_Z..total_budget: fund_Z; % Allocated funding to department Z (integer units)

var 0..(cost_per_unit_X*total_budget + cost_per_unit_Y*total_budget + cost_per_unit_Z*total_budget): total_cost;
                                     % Total cost (bounded upper by worst-case spend)

% Constraints

% Funding feasibility: total allocated funding cannot exceed the available budget
constraint
  fund_X + fund_Y + fund_Z <= total_budget;

% Minimum funding requirements (reinforced by variable domains, kept for clarity/maintenance)
constraint fund_X >= min_fund_X;
constraint fund_Y >= min_fund_Y;
constraint fund_Z >= min_fund_Z;

% Total cost definition: linear cost based on allocated funding per department
constraint
  total_cost = cost_per_unit_X * fund_X
             + cost_per_unit_Y * fund_Y
             + cost_per_unit_Z * fund_Z;

% Objective
solve minimize total_cost;