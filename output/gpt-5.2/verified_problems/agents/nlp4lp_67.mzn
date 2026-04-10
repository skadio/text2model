% Parameters
int: M;                                 % Number of types of smaller rolls
int: N;                                 % Number of different cutting patterns
float: large_roll_width;                % Width of the large roll

array[1..M] of int: demands;            % Demand for each roll width type
array[1..M] of float: roll_width_options; % Width option for each roll type (may be non-integer)

array[1..N, 1..M] of int: patterns;     % patterns[p,i] = number of rolls of type i produced by pattern p

% Variables
array[1..N] of var 0..sum(demands): use_pattern; % Number of large rolls cut using each pattern
var 0..sum(demands): total_large_rolls;          % Total number of large rolls used

% Constraints
% Link total number of large rolls to the number of times each pattern is used
constraint
  total_large_rolls = sum(p in 1..N)(use_pattern[p]);

% Demand satisfaction: produced rolls of each type must meet or exceed its demand
constraint
  forall(i in 1..M)(
    sum(p in 1..N)(patterns[p, i] * use_pattern[p]) >= demands[i]
  );

% (Optional consistency) Ensure each cutting pattern fits within the large roll width
% Uses float arithmetic due to possible non-integer widths.
constraint
  forall(p in 1..N)(
    sum(i in 1..M)(roll_width_options[i] * int2float(patterns[p, i])) <= large_roll_width
  );

% Objective
solve minimize total_large_rolls;