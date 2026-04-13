% Parameters
int: cost_x = 5000;                 % Cost per unit of product X (dollars)
int: cost_y = 3000;                 % Cost per unit of product Y (dollars)
int: capacity_total = 1000;         % Maximum combined units of X and Y

int: demand_min = 2000;             % Minimum required value of (3*X + 2*Y)
int: demand_coeff_x = 3;            % Coefficient of X in demand expression
int: demand_coeff_y = 2;            % Coefficient of Y in demand expression

int: diff_min = 150;                % Minimum required difference X - Y

% Variables
var 0..capacity_total: units_x;     % Integer units produced of product X
var 0..capacity_total: units_y;     % Integer units produced of product Y

var 0..(cost_x * capacity_total + cost_y * capacity_total): total_cost;
                                    % Total production cost (dollars)

% Constraints
% Total capacity constraint: combined production cannot exceed capacity_total
constraint units_x + units_y <= capacity_total;

% Demand satisfaction constraint: 3*X + 2*Y must be at least demand_min
constraint demand_coeff_x * units_x + demand_coeff_y * units_y >= demand_min;

% Portfolio balance constraint: X - Y must be at least diff_min
constraint units_x - units_y >= diff_min;

% Define total cost as linear function of produced units
constraint total_cost = cost_x * units_x + cost_y * units_y;

% Objective
solve minimize total_cost;