% Parameters
int: K; % number of departments
int: L; % number of locations

array[1..K, 1..L] of int: Benefit;               % benefit (thousands of pounds)
array[1..K, 1..K] of float: Communication;       % communication quantity between departments
array[1..L, 1..L] of int: Cost;                  % unit communication cost between locations

% Variables
array[1..K] of var 1..L: loc;                    % location chosen for each department

% Constraints
constraint
  forall(l in 1..L) (
    sum(k in 1..K) (bool2int(loc[k] = l)) <= 3
  );

% Objective
var float: total_cost =
  sum(k in 1..K, j in 1..K) (
    Communication[k,j] * int2float(Cost[loc[k], loc[j]])
  )
  - int2float(sum(k in 1..K) (Benefit[k, loc[k]]));

solve minimize total_cost;