% Parameters
int: canoe_capacity = 10;          % fish per canoe
int: diesel_capacity = 15;         % fish per diesel boat
int: min_fish = 1000;              % minimum fish to transport
int: canoe_to_diesel_ratio = 3;    % canoes must be at least this multiple of diesel boats

% Upper bounds for decision variables (safe, derived from min_fish)
int: max_canoes = min_fish div canoe_capacity + 1;   % enough canoes alone to cover min_fish
int: max_diesel = min_fish div diesel_capacity + 1;  % enough diesel boats alone to cover min_fish

% Variables
var 0..max_canoes: num_canoes;     % number of canoes used
var 0..max_diesel: num_diesel;     % number of diesel boats used

% Constraints

% Fish transport requirement: total capacity must meet or exceed the minimum fish to transport
constraint
    canoe_capacity * num_canoes + diesel_capacity * num_diesel >= min_fish;

% Environmental rule: canoes must be at least a fixed multiple of diesel boats
constraint
    num_canoes >= canoe_to_diesel_ratio * num_diesel;

% Objective
solve minimize num_canoes + num_diesel;