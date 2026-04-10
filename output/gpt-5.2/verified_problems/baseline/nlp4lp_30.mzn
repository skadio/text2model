% Department relocation / assignment with communication costs
% Data (from .dzn):
%   int: K;                          % number of departments
%   int: L;                          % number of locations (including London if desired)
%   array[1..K,1..L] of int: Benefit; % benefit (in thousands) if dept k at location l
%   array[1..K,1..K] of float: Communication; % quantity of communication between depts k and j
%   array[1..L,1..L] of int: Cost;    % unit communication cost between locations l and m

include "globals.mzn";

int: CAP = 3;

set of int: DEPTS = 1..K;
set of int: LOCS  = 1..L;

array[DEPTS] of var LOCS: loc;  % location chosen for each department

% Capacity: no location hosts more than 3 departments
constraint
  forall(l in LOCS) (
    sum(k in DEPTS)(bool2int(loc[k] = l)) <= CAP
  );

% Objective:
% Minimize communication cost between all ordered pairs (k,j) plus a "cost"
% of losing benefits: subtract benefits from total (equivalently minimize comm - benefit)
% Communication term: Communication[k,j] * Cost[loc[k], loc[j]]
var float: total_comm =
  sum(k in DEPTS, j in DEPTS) (
    Communication[k,j] * int2float(Cost[loc[k], loc[j]])
  );

var int: total_benefit =
  sum(k in DEPTS) ( Benefit[k, loc[k]] );

var float: obj = total_comm - int2float(total_benefit);

solve minimize obj;

output [
  "Objective (comm - benefit): ", show(obj), "\n",
  "Total communication cost:   ", show(total_comm), "\n",
  "Total benefit:              ", show(total_benefit), "\n",
  "Locations per department (dept:loc):\n",
  concat([ show(k) ++ ":" ++ show(loc[k]) ++ if k<K then " " else "\n" endif | k in DEPTS ])
];