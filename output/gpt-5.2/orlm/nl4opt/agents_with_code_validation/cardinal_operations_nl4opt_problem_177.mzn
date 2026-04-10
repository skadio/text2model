% Parameters
int: canoe_capacity = 10;              % fish per canoe
int: diesel_capacity = 15;             % fish per diesel boat
int: min_fish = 1000;                  % minimum fish to transport
int: canoe_per_diesel_ratio = 3;       % canoes must be at least this times diesel boats

% Variables
var 0..(min_fish div canoe_capacity + 1): num_canoes;    % number of canoes used
var 0..(min_fish div diesel_capacity + 1): num_diesel;   % number of diesel boats used

% Constraints
% Fish transport capacity constraint: total carried fish must meet or exceed the minimum required
constraint
  canoe_capacity * num_canoes + diesel_capacity * num_diesel >= min_fish;

% Environmental regulation constraint: canoes must be at least a given ratio times diesel boats
constraint
  num_canoes >= canoe_per_diesel_ratio * num_diesel;

% Objective
solve minimize num_canoes + num_diesel;