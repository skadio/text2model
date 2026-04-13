% Parameters
int: toys_per_medium = 50;          % toys produced per day by a medium factory
int: operators_per_medium = 3;      % operators required by a medium factory
int: toys_per_small = 35;           % toys produced per day by a small factory
int: operators_per_small = 2;       % operators required by a small factory

int: min_toys_per_day = 250;        % minimum required toys per day
int: max_operators = 16;            % available operators

% Safe upper bounds derived from operator limit (since objective minimizes factories)
int: max_medium = max_operators div operators_per_medium; % max medium factories possible
int: max_small  = max_operators div operators_per_small;  % max small factories possible

% Variables
var 0..max_medium: num_medium;      % number of medium factories to build
var 0..max_small:  num_small;       % number of small factories to build

% Constraints
% Production requirement: total toys produced must meet or exceed the minimum
constraint
  toys_per_medium * num_medium + toys_per_small * num_small >= min_toys_per_day;

% Operator availability: total operators used cannot exceed the available operators
constraint
  operators_per_medium * num_medium + operators_per_small * num_small <= max_operators;

% Objective
solve minimize num_medium + num_small;