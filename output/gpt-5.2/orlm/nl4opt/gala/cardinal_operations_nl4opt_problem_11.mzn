% Banquet transportation planning (no external data)

int: bikeCap = 3;
int: carCap  = 5;
int: peopleNeeded = 500;

% Decision variables: number of bikes and cars
var 0..10000: bikes;
var 0..10000: cars;

% Capacity constraint
constraint bikeCap * bikes + carCap * cars >= peopleNeeded;

% At most 40% of vehicles are cars:
% cars <= 0.4 * (bikes + cars)  <=> 5*cars <= 2*(bikes + cars) <=> 3*cars <= 2*bikes
constraint 3 * cars <= 2 * bikes;

% Objective: minimize number of bikes needed
solve minimize bikes;

output [
  "bikes = ", show(bikes), "\n",
  "cars  = ", show(cars), "\n",
  "total_vehicles = ", show(bikes + cars), "\n",
  "people_capacity = ", show(bikeCap*bikes + carCap*cars), "\n"
];