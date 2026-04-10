% Parameters
float: min_nitrous = 5.0;          % minimum required units of nitrous oxide
float: min_vitamin = 8.0;          % minimum required units of vitamin mix

float: cost_C = 2.0;               % $ per kg of fertilizer C
float: cost_Y = 3.0;               % $ per kg of fertilizer Y

float: nitrous_perkg_C = 1.5;      % nitrous oxide units per kg of C
float: vitamin_perkg_C = 3.0;      % vitamin mix units per kg of C
float: nitrous_perkg_Y = 5.0;      % nitrous oxide units per kg of Y
float: vitamin_perkg_Y = 1.0;      % vitamin mix units per kg of Y

% Variables
var float: kg_C;                   % kilograms of fertilizer C to use (>= 0)
var float: kg_Y;                   % kilograms of fertilizer Y to use (>= 0)
var float: total_cost;             % total cost of the compound

% Constraints
% Non-negativity of decision variables (amounts of fertilizers cannot be negative)
constraint kg_C >= 0.0;
constraint kg_Y >= 0.0;

% Minimum nitrous oxide requirement
constraint nitrous_perkg_C * kg_C + nitrous_perkg_Y * kg_Y >= min_nitrous;

% Minimum vitamin mix requirement
constraint vitamin_perkg_C * kg_C + vitamin_perkg_Y * kg_Y >= min_vitamin;

% Define total cost based on chosen quantities
constraint total_cost = cost_C * kg_C + cost_Y * kg_Y;

% Objective
solve minimize total_cost;