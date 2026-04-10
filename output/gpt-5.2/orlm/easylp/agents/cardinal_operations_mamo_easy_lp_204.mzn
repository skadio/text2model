% Parameters
int: budget = 1000;                 % Total funds available across all investments

int: min_invest_x = 300;            % Minimum investment required for option X
int: max_invest_y = 500;            % Maximum investment allowed for option Y
int: min_invest_z = 200;            % Minimum investment required for option Z

int: cost_per_unit_x = 10;          % Cost/return coefficient per unit for X
int: cost_per_unit_y = 15;          % Cost/return coefficient per unit for Y
int: cost_per_unit_z = 20;          % Cost/return coefficient per unit for Z

% Variables
var 0..budget: x;                   % Integer units invested in X
var 0..budget: y;                   % Integer units invested in Y
var 0..budget: z;                   % Integer units invested in Z

var 0..(cost_per_unit_x*budget + cost_per_unit_y*budget + cost_per_unit_z*budget): total_cost;
                                    % Total cost to minimize (safe upper bound)

% Constraints

% Budget constraint: total funds allocated across X, Y, Z cannot exceed the available budget
constraint x + y + z <= budget;

% Investment-specific feasibility/risk constraints
constraint x >= min_invest_x;       % Option X requires a minimum investment
constraint y <= max_invest_y;       % Option Y has a maximum allowable investment
constraint z >= min_invest_z;       % Option Z requires a minimum investment

% Total cost definition: link decision variables to the derived total_cost variable
constraint total_cost =
    cost_per_unit_x * x
  + cost_per_unit_y * y
  + cost_per_unit_z * z;

% Objective
solve minimize total_cost;