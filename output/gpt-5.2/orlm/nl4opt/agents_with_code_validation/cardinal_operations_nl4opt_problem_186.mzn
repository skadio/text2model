% Parameters
int: small_capacity = 20;          % units of ore per small wagon
int: large_capacity = 50;          % units of ore per large wagon
int: required_ore   = 2000;        % total units of ore to transport
int: min_large      = 10;          % at least this many large wagons must be used
int: small_to_large_ratio = 2;     % small wagons must be at least this multiple of large wagons

% Variables
var 0..(required_ore div small_capacity): num_small;                 % number of small wagons
var min_large..(required_ore div large_capacity): num_large;         % number of large wagons
var 0..((required_ore div small_capacity) + (required_ore div large_capacity)):
    total_wagons;                                                    % total wagons used

% Constraints
% Capacity constraint: transport at least the required amount of ore
constraint
  small_capacity * num_small + large_capacity * num_large >= required_ore;

% Space/ramp constraint: small wagons must be at least a multiple of large wagons
constraint
  num_small >= small_to_large_ratio * num_large;

% Definition constraint: total wagons equals the sum of small and large wagons
constraint
  total_wagons = num_small + num_large;

% Objective
solve minimize total_wagons;