% Parameters
int: K;
int: L;

set of int: DEPTS = 1..K;
set of int: LOCS  = 1..L;

array[DEPTS, LOCS] of float: Benefit;
array[DEPTS, DEPTS] of float: Communication;
array[LOCS , LOCS ] of float: Cost;

% Variables
array[DEPTS] of var LOCS: loc;               % location chosen for each department

% Constraints
% Capacity constraint: no location (including London) hosts more than three departments
constraint
  forall(l in LOCS) (
    sum(k in DEPTS)(bool2int(loc[k] = l)) <= 3
  );

% Objective
var float: total_communication_cost =
  sum(k in DEPTS, j in DEPTS)(
    Communication[k,j] * Cost[loc[k], loc[j]]
  );

var float: total_benefit =
  sum(k in DEPTS)( Benefit[k, loc[k]] );

solve minimize total_communication_cost - total_benefit;