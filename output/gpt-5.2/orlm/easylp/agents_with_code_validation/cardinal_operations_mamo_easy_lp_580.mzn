% Parameters
% Total available resource units (embedded from description)
int: total_resource_cap = 1000;

% Minimum differences / gap limits (embedded from description)
int: min_res_minus_com = 50;      % X >= Y + 50
int: max_ind_minus_res_abs = 200; % |Z - X| <= 200
int: min_com_minus_ind = 30;      % Y >= Z + 30

% Unit costs (embedded from description)
int: cost_residential = 200;
int: cost_commercial  = 150;
int: cost_industrial  = 300;

% Variables
var 0..total_resource_cap: X; % residential resource units
var 0..total_resource_cap: Y; % commercial resource units
var 0..total_resource_cap: Z; % industrial resource units

% Upper bound uses maximum unit cost to keep domain safe and finite
var 0..(total_resource_cap * max(cost_residential, max(cost_commercial, cost_industrial))): total_cost;

% Constraints
% Resource-cap constraint
constraint X + Y + Z <= total_resource_cap;

% Strategic allocation gaps
constraint X >= Y + min_res_minus_com;
constraint Y >= Z + min_com_minus_ind;

% Balance constraint
constraint abs(Z - X) <= max_ind_minus_res_abs;

% Total cost definition
constraint total_cost = cost_residential * X + cost_commercial * Y + cost_industrial * Z;

% Objective
solve minimize total_cost;