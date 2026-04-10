% Parameters
int: R = 5;
set of int: Regions = 1..R;

array[Regions, Regions] of int: cost =
  [|  0, 10, 12, 17, 34
   | 10,  0, 18,  8, 46
   | 12, 18,  0,  9, 27
   | 17,  8,  9,  0, 20
   | 34, 46, 27, 20,  0 |];

array[Regions] of int: current = [115, 385, 410, 480, 610];
array[Regions] of int: needed  = [200, 500, 800, 200, 300];

array[Regions] of int: supply = [max(0, current[i] - needed[i]) | i in Regions];
array[Regions] of int: demand = [max(0, needed[i] - current[i]) | i in Regions];

int: total_supply = sum(i in Regions)(supply[i]);
int: total_demand = sum(i in Regions)(demand[i]);
constraint total_supply = total_demand;

int: max_flow = total_supply;

% Variables
array[Regions, Regions] of var 0..max_flow: x;

% Constraints
constraint forall(i in Regions)(x[i,i] = 0);

constraint forall(i in Regions)(
  sum(j in Regions where j != i)(x[i,j]) <= supply[i]
);

constraint forall(j in Regions)(
  sum(i in Regions where i != j)(x[i,j]) >= demand[j]
);

% Objective
var int: total_cost = sum(i in Regions, j in Regions where i != j)(cost[i,j] * x[i,j]);
solve minimize total_cost;