% Parameters
int: cost_X = 20;              % Cost per unit of Project X (tree planting)
int: cost_Y = 30;              % Cost per unit of Project Y (river cleaning)

int: eff_X = 3;                % Effectiveness contribution per unit of X
int: eff_Y = 1;                % Effectiveness contribution per unit of Y
int: min_effectiveness = 10;   % Minimum required effectiveness score

int: cap_X = 1;                % Weight of X in capacity/manpower constraint
int: cap_Y = 5;                % Weight of Y in capacity/manpower constraint
int: max_capacity = 50;        % Maximum allowed capacity/manpower usage


% Variables
var 0..max_capacity: x;        % Integer units of Project X
var 0..max_capacity: y;        % Integer units of Project Y

% Upper bound: worst-case cost if both x and y are at max_capacity
var 0..(cost_X * max_capacity + cost_Y * max_capacity): total_cost;  % Total cost


% Constraints
% Effectiveness requirement: ensure minimum combined effectiveness is met
constraint eff_X * x + eff_Y * y >= min_effectiveness;

% Capacity/manpower limitation: weighted sum of project units must not exceed max capacity
constraint cap_X * x + cap_Y * y <= max_capacity;

% Total cost definition: link decision variables to computed total cost
constraint total_cost = cost_X * x + cost_Y * y;


% Objective
solve minimize total_cost;