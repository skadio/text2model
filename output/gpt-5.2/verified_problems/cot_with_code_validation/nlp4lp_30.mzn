% Parameters
int: K;
int: L;

set of int: DEPTS = 1..K;
set of int: LOCS  = 1..L;

array[DEPTS, LOCS] of int: Benefit;
array[DEPTS, DEPTS] of float: Communication;
array[LOCS, LOCS] of int: Cost;

% Decision variables: location chosen for each department
array[DEPTS] of var LOCS: loc;

% Objective components
var float: total_comm;
var float: total_benefit;
var float: total_cost;

% At most 3 departments per location (including London if it is among LOCS)
constraint
  forall(l in LOCS) (
    sum(k in DEPTS)(bool2int(loc[k] = l)) <= 3
  );

% Total benefit (thousands of pounds)
constraint
  total_benefit = sum(k in DEPTS)( int2float(Benefit[k, loc[k]]) );

% Total communication cost:
% sum over unordered department pairs (k<j) to avoid double counting
constraint
  total_comm =
    sum(k in DEPTS, j in DEPTS where k < j)(
      Communication[k,j] * int2float(Cost[loc[k], loc[j]])
    );

% Overall yearly cost to minimize: communication cost minus relocation benefit
constraint
  total_cost = total_comm - total_benefit;

solve minimize total_cost;

output [
  "loc = ", show(loc), "\n",
  "total_comm = ", show(total_comm), "\n",
  "total_benefit = ", show(total_benefit), "\n",
  "total_cost = ", show(total_cost), "\n"
];