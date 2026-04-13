% Parameters
int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: supply = [120, 330, 400, 400, 600];
array[LOC] of int: demand = [150, 200, 600, 200, 400];

% Costs (directed). Missing arcs are disallowed by forcing 0 flow.
array[LOC, LOC] of int: cost = array2d(LOC, LOC, [
  0,  0, 11, 13, 28,
  0,  0, 18,  8, 46,
  0,  0,  0,  9, 27,
  0,  0,  0,  0, 20,
  0,  0,  0,  0,  0
]);

array[LOC] of int: surplus = [supply[i] - demand[i] | i in LOC];
int: TOTAL = sum(i in LOC)(supply[i]); % upper bound for flows

% Variables
array[LOC, LOC] of var 0..TOTAL: x;

% Constraints
constraint
  forall(i in LOC)(x[i,i] = 0);

% Disallow unspecified moves (only i<j arcs listed in the description)
constraint
  forall(i,j in LOC where not (i<j)) (x[i,j] = 0);

% Flow balance: net outflow equals surplus (positive = send out, negative = receive)
constraint
  forall(i in LOC)(
    sum(j in LOC)(x[i,j]) - sum(j in LOC)(x[j,i]) = surplus[i]
  );

% Objective
solve minimize sum(i,j in LOC)(cost[i,j] * x[i,j]);