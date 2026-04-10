% Parameters
int: N = 5;
set of int: LOC = 1..N;

array[LOC] of int: supply = [120, 330, 400, 400, 600];
array[LOC] of int: demand = [150, 200, 600, 200, 400];

% cost[i,j] = cost to move one car from i to j (only i<j given; other entries 0)
array[LOC, LOC] of int: cost =
  array2d(LOC, LOC,
    [
      0, 0, 11, 13, 28,
      0, 0, 18,  8, 46,
      0, 0,  0,  9, 27,
      0, 0,  0,  0, 20,
      0, 0,  0,  0,  0
    ]);

% total cars conserved and feasibility check
int: total_supply = sum(i in LOC)(supply[i]);
int: total_demand = sum(i in LOC)(demand[i]);

% derived net requirement at each location: positive => needs inflow, negative => has surplus
array[LOC] of int: net = [demand[i] - supply[i] | i in LOC];

% Variables
array[LOC, LOC] of var 0..max(total_supply, total_demand): x;

var 0..(max(total_supply, total_demand) * max(cost)): total_cost;

% Constraints
constraint total_supply = total_demand;

% disallow self-moves and moves not listed (only allow i<j as given)
constraint forall(i in LOC)(x[i,i] = 0);
constraint forall(i,j in LOC where i > j)(x[i,j] = 0);

% flow balance: out - in = surplus = supply - demand = -net
constraint forall(k in LOC)(
  sum(j in LOC)(x[k,j]) - sum(i in LOC)(x[i,k]) = supply[k] - demand[k]
);

% objective definition
constraint total_cost = sum(i,j in LOC)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;