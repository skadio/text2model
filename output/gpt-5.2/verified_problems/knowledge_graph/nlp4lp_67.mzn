include "globals.mzn";

int: M;                         % number of roll types
int: N;                         % number of cutting patterns
float: large_roll_width;        % width of a large roll (not required if patterns are prevalidated)
array[1..M] of int: demands;    % demand for each roll type
array[1..M] of float: roll_width_options; % widths of each roll type (not required if patterns are prevalidated)
array[1..N, 1..M] of int: patterns;       % patterns[p, i] = number of rolls of type i produced by pattern p

% Decision variables: how many large rolls are cut using each pattern
int: max_rolls = sum(demands);
array[1..N] of var 0..max_rolls: x;

% Demand satisfaction
constraint
  forall(i in 1..M) (
    sum(p in 1..N) (patterns[p, i] * x[p]) >= demands[i]
  );

% Optional (redundant) feasibility check if patterns were not guaranteed feasible w.r.t. widths
% constraint
%   forall(p in 1..N) (
%     sum(i in 1..M) (patterns[p, i] * roll_width_options[i]) <= large_roll_width + 1e-6
%   );

var int: total_large_rolls = sum(p in 1..N)(x[p]);

solve minimize total_large_rolls;

output [
  "total_large_rolls=", show(total_large_rolls), "\n",
  "x=", show(x), "\n"
];