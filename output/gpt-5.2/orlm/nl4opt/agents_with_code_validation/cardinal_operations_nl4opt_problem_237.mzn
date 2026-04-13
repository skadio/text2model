% Parameters
int: capacity_small = 200;          % Grapes per small crate
int: capacity_large = 500;          % Grapes per large crate

int: max_small_crates = 100;        % Available small crates
int: max_large_crates = 50;         % Available large crates
int: max_total_crates = 60;         % Truck limit on total crates

int: min_large_crates = 10;         % Must use at least this many large crates
int: small_to_large_ratio = 3;      % At least 3 times as many small as large

% Variables
var 0..max_small_crates: num_small_crates;                   % Number of small crates used
var min_large_crates..max_large_crates: num_large_crates;    % Number of large crates used
var 0..(capacity_small*max_small_crates + capacity_large*max_large_crates): total_grapes;
  % Total grapes transported

% Constraints
% Total crate count must not exceed the truck capacity
constraint
  num_small_crates + num_large_crates <= max_total_crates;

% Customer preference: at least 'small_to_large_ratio' times as many small crates as large crates
constraint
  num_small_crates >= small_to_large_ratio * num_large_crates;

% Define total grapes transported based on chosen crates
constraint
  total_grapes =
    capacity_small * num_small_crates +
    capacity_large * num_large_crates;

% Objective
solve maximize total_grapes;