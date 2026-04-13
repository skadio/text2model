% Parameters
int: max_total_budget = 5000;                 % Total budget cannot exceed this amount
int: reach_target = 2000;                     % Minimum required reach points

int: reach_coeff_x = 5;                       % Reach expression coefficient for X
int: reach_coeff_y = -3;                      % Reach expression coefficient for Y
int: reach_coeff_z = 1;                       % Reach expression coefficient for Z

int: yz_limit_offset = 1000;                  % Offset in X+Z vs 2Y constraint

int: cost_x = 100;                            % Cost per unit budget for campaign X
int: cost_y = 50;                             % Cost per unit budget for campaign Y
int: cost_z = 20;                             % Cost per unit budget for campaign Z


% Variables
var 0..max_total_budget: budget_x;            % Whole-number budget for campaign X
var 0..max_total_budget: budget_y;            % Whole-number budget for campaign Y
var 0..max_total_budget: budget_z;            % Whole-number budget for campaign Z

var 0..(cost_x*max_total_budget + cost_y*max_total_budget + cost_z*max_total_budget): total_cost;
                                              % Total cost to minimize (explicit upper bound)


% Constraints

% Total budget limit across all campaigns
constraint budget_x + budget_y + budget_z <= max_total_budget;

% Minimum reach requirement: 5*X - 3*Y + 1*Z >= 2000
constraint
  reach_coeff_x * budget_x + reach_coeff_y * budget_y + reach_coeff_z * budget_z >= reach_target;

% Spending relation constraint: (X + Z) cannot exceed (2*Y + offset)
constraint budget_x + budget_z <= 2 * budget_y + yz_limit_offset;

% Define total_cost consistently with per-campaign unit costs
constraint total_cost = cost_x * budget_x + cost_y * budget_y + cost_z * budget_z;


% Objective
solve minimize total_cost;