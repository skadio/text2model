% Parameters
int: total_budget_units = 150;          % Max total allocation across X, Y, Z
int: min_x_over_y = 10;                % X must be at least this many units more than Y
int: max_y_over_z = 20;                % Y can be at most this many units more than Z

int: cost_x = 100;                     % Cost per unit allocated to department X ($)
int: cost_y = 50;                      % Cost per unit allocated to department Y ($)
int: cost_z = 30;                      % Cost per unit allocated to department Z ($)

% Variables
var 0..total_budget_units: x_units;     % Whole-number units allocated to department X
var 0..total_budget_units: y_units;     % Whole-number units allocated to department Y
var 0..total_budget_units: z_units;     % Whole-number units allocated to department Z

% Upper bound is the maximum possible cost if all 150 units were allocated to each dept (loose but valid)
var 0..(cost_x*total_budget_units + cost_y*total_budget_units + cost_z*total_budget_units): total_cost;

% Constraints
% Budget feasibility: total allocated units cannot exceed the available budget units
constraint x_units + y_units + z_units <= total_budget_units;

% Department balance constraints
% X must receive at least min_x_over_y more units than Y
constraint x_units >= y_units + min_x_over_y;

% Y can receive at most max_y_over_z more units than Z
constraint y_units <= z_units + max_y_over_z;

% Total cost definition (link total_cost to decision variables)
constraint total_cost = cost_x * x_units + cost_y * y_units + cost_z * z_units;

% Objective
solve minimize total_cost;