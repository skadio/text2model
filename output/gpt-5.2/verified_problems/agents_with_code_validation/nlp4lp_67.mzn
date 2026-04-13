% Parameters
int: M; % Number of types of smaller rolls
int: N; % Number of different cutting patterns
int: large_roll_width; % Width of a large (master) roll

array[1..M] of int: demands; % Demand for each roll width type
array[1..M] of float: roll_width_options; % Smaller roll widths (may be non-integer)

array[1..N, 1..M] of int: patterns;
% patterns[p, i] = number of rolls of type i produced by cutting pattern p

% Variables
array[1..N] of var 0..sum(demands): use_pattern;
% use_pattern[p] = number of large rolls cut using pattern p

var 0..sum(demands): total_large_rolls;
array[1..M] of var 0..sum(demands): produced;

% Constraints

% Total large rolls used
constraint total_large_rolls = sum(p in 1..N)(use_pattern[p]);

% Produced amounts per roll type
constraint
  forall(i in 1..M) (
    produced[i] = sum(p in 1..N)(use_pattern[p] * patterns[p, i])
  );

% Meet demand
constraint forall(i in 1..M) (produced[i] >= demands[i]);

% Validity check: pattern width must not exceed large roll width
% (avoid using "float(...)" cast; use explicit real conversion with 1.0*)
constraint
  forall(p in 1..N) (
    sum(i in 1..M)( (1.0 * patterns[p, i]) * roll_width_options[i] )
    <= 1.0 * large_roll_width
  );

% Objective
solve minimize total_large_rolls;