include "globals.mzn";

% Input parameters (provided in a .dzn file)
int: M;                        % Number of types of smaller rolls
int: N;                        % Number of different cutting patterns
float: large_roll_width;       % Width of the large roll
array[1..M] of int: demands;   % Demand for each type of smaller roll
array[1..M] of float: roll_width_options; % Width options for each type
array[1..N, 1..M] of int: patterns;        % Cutting patterns:
                                           % patterns[i,j] is the number
                                           % of rolls of type j produced by pattern i

% Upper bound on the number of large rolls: in the worst case each roll produces one small roll.
int: maxLargeRolls = sum(demands);

% Decision variables:
% usePattern[i] is the number of times pattern i is used.
array[1..N] of var 0..maxLargeRolls: usePattern;

% Demand satisfaction constraints:
% For each small roll type j, the total number produced over all patterns
% must meet or exceed its customer demand.
constraint
  forall(j in 1..M) (
    sum(i in 1..N)( patterns[i,j] * usePattern[i] ) >= demands[j]
  );

% (Optional) Feasibility check: each pattern production should not exceed large roll width.
% If a pattern is infeasible then it must not be used.
constraint
  forall(i in 1..N) (
    sum(j in 1..M)( roll_width_options[j] * patterns[i,j] ) <= large_roll_width \/ usePattern[i] = 0
  );

% Objective: minimize the total number of large rolls used.
solve minimize sum(i in 1..N)( usePattern[i] );

% Output the total number of large rolls used and the usage of each pattern.
output [
  "Total large rolls = " , show(sum(i in 1..N)( usePattern[i] )), "\n",
  "Pattern usage = ", show(usePattern)
];