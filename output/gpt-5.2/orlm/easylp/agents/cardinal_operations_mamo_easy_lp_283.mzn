% Parameters
int: max_total_budget = 50;              % Maximum total allocation across campaigns (units)
int: min_x = 10;                         % Minimum allocation for campaign X (units)
int: min_y = 15;                         % Minimum allocation for campaign Y (units)
int: min_z = 5;                          % Minimum allocation for campaign Z (units)

int: cost_x = 500;                       % Cost per unit invested in campaign X (dollars/unit)
int: cost_y = 400;                       % Cost per unit invested in campaign Y (dollars/unit)
int: cost_z = 300;                       % Cost per unit invested in campaign Z (dollars/unit)

% Variables
var min_x..max_total_budget: x_units;    % Units allocated to campaign X
var min_y..max_total_budget: y_units;    % Units allocated to campaign Y
var min_z..max_total_budget: z_units;    % Units allocated to campaign Z

% Upper bound uses worst-case cost per unit times max units (safe bound)
var 0..(max_total_budget * max(cost_x, max(cost_y, cost_z))): total_cost;
                                         % Total investment cost (dollars)

% Constraints
% Budget feasibility: total allocated units across campaigns cannot exceed the maximum budget
constraint
  x_units + y_units + z_units <= max_total_budget;

% Cost accounting: total_cost equals the weighted sum of units invested in each campaign
constraint
  total_cost = cost_x * x_units + cost_y * y_units + cost_z * z_units;

% Objective
solve minimize total_cost;