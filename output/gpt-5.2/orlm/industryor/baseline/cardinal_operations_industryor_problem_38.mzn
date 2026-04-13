% Environmentally friendly transportation planning

set of int: METHODS = 1..3;
int: motorcycle = 1;
int: small_truck = 2;
int: large_truck = 3;

array[METHODS] of int: pollution = [40, 70, 100];
array[METHODS] of int: capacity  = [10, 20, 50];

int: max_motorcycle_trips = 8;
int: min_total_products = 300;
int: max_total_trips = 20;

array[METHODS] of var 0..max_total_trips: trips;
array[METHODS] of var bool: use;

constraint forall(m in METHODS) (
  trips[m] <= max_total_trips * bool2int(use[m])
);

% Can only choose exactly two methods
constraint sum(m in METHODS)(bool2int(use[m])) = 2;

% Road restriction for motorcycles
constraint trips[motorcycle] <= max_motorcycle_trips;

% Demand constraint
constraint sum(m in METHODS)(capacity[m] * trips[m]) >= min_total_products;

% Total trips limit
constraint sum(m in METHODS)(trips[m]) <= max_total_trips;

var int: total_pollution = sum(m in METHODS)(pollution[m] * trips[m]);

solve minimize total_pollution;

output [
  "Trips (motorcycle, small_truck, large_truck) = ", show(trips), "\n",
  "Use (motorcycle, small_truck, large_truck)   = ", show(use), "\n",
  "Total products transported = ", show(sum(m in METHODS)(capacity[m] * trips[m])), "\n",
  "Total trips = ", show(sum(m in METHODS)(trips[m])), "\n",
  "Total pollution = ", show(total_pollution), "\n"
];