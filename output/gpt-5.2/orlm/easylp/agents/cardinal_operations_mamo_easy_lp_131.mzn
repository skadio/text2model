% Parameters
int: total_budget_cap = 10000;              % Maximum combined budget for X and Y (dollars)
int: impact_min = 40000;                    % Minimum required combined mission impact (points)
int: impact_coeff_x = 10;                   % Impact score coefficient for budget on X
int: impact_coeff_y = 4;                    % Impact score coefficient for budget on Y
int: cost_per_dollar_x = 50;                % Cost weight per dollar for X
int: cost_per_dollar_y = 30;                % Cost weight per dollar for Y

% Variables
var 0..total_budget_cap: budget_x;          % Integer budget allocated to project X (dollars)
var 0..total_budget_cap: budget_y;          % Integer budget allocated to project Y (dollars)

% Total cost (weighted dollars), bounded using worst-case spend on both
var 0..(cost_per_dollar_x*total_budget_cap + cost_per_dollar_y*total_budget_cap): total_cost;

% Constraints

%-------------------------------
% Total cost definition (linking)
%-------------------------------
constraint
  total_cost = cost_per_dollar_x * budget_x + cost_per_dollar_y * budget_y;

%-------------------------------
% Budget feasibility constraints
%-------------------------------
constraint
  budget_x + budget_y <= total_budget_cap;

%-------------------------------
% Mission impact requirement
%-------------------------------
constraint
  impact_coeff_x * budget_x + impact_coeff_y * budget_y >= impact_min;

%-------------------------------
% Integrality / accounting regulations
% (Already ensured by integer domains; included for explicitness)
%-------------------------------
constraint
  is_int(budget_x) /\ is_int(budget_y);

% Objective
solve minimize total_cost;