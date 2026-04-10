% Parameters
%-------------------------
% Cost and policy parameters (embedded data)
%-------------------------
int: cost_X = 50;                 % Cost per unit allocated to project X
int: cost_Y = 100;                % Cost per unit allocated to project Y

int: max_total_units = 2000;      % Upper bound on combined allocation X + Y
int: min_diff = 500;              % Minimum required difference: X - 2*Y >= 500
int: min_X_units = 750;           % Minimum allocation required for project X

% Variables
%-------------------------
% Decision variables and derived objective variable
%-------------------------
var int: units_X;                 % Units allocated to project X (integer)
var int: units_Y;                 % Units allocated to project Y (integer)
var int: total_cost;              % Total cost (integer dollars)

% Constraints
%-------------------------
% Allocation domain / feasibility constraints
%-------------------------

% Ensure minimum investment in Project X
constraint units_X >= min_X_units;

% Non-negativity for Project Y allocation
constraint units_Y >= 0;

% Simple upper bounds (redundant but explicit)
constraint units_X <= max_total_units;
constraint units_Y <= max_total_units;

%-------------------------
% Capacity / coupling constraints
%-------------------------

% Total available units across both projects
constraint units_X + units_Y <= max_total_units;

% Project requirement relating X and Y
constraint units_X - 2 * units_Y >= min_diff;

%-------------------------
% Cost definition (linking constraint)
%-------------------------
constraint total_cost = cost_X * units_X + cost_Y * units_Y;

% Objective
solve minimize total_cost;