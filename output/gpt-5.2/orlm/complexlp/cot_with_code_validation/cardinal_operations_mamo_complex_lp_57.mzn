% Food redistribution / transportation problem

int: N = 6;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [255, 250, 314, 8, 385, 440];
array[CITIES] of int: demand = [251, 200, 366, 114, 59, 287];

array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES, [
  0, 26, 39, 13, 37, 28,
  36, 0, 48, 5, 22, 14,
  38, 36, 0, 12, 45, 36,
  32, 18, 47, 0, 7, 9,
  18, 6, 12, 20, 0, 42,
  4, 28, 42, 43, 7, 0
]);

int: total_supply = sum(i in CITIES)(supply[i]);
int: total_demand = sum(i in CITIES)(demand[i]);
int: max_ship = min(total_supply, total_demand);

% x[i,j] = amount shipped from city i to city j
array[CITIES, CITIES] of var 0..max_ship: x;

% No self-shipments
constraint forall(i in CITIES)(x[i,i] = 0);

% Outgoing shipments cannot exceed available supply
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

% Each city must end with at least its demand:
% final[j] = supply[j] + incoming - outgoing >= demand[j]
constraint forall(j in CITIES)(
  supply[j] + sum(i in CITIES)(x[i,j]) - sum(k in CITIES)(x[j,k]) >= demand[j]
);

var int: total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;