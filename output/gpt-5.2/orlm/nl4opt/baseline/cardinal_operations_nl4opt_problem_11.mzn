int: bike_cap = 3;
int: car_cap  = 5;
int: people_needed = 500;

var 0..10000: bikes;
var 0..10000: cars;

constraint bike_cap * bikes + car_cap * cars >= people_needed;

% At most 40% of the vehicles can be cars: cars <= 0.4*(bikes+cars)
% Use integer form to avoid fractions: 5*cars <= 2*(bikes+cars)  <=> 3*cars <= 2*bikes
constraint 3 * cars <= 2 * bikes;

solve minimize bikes;

output [
  "bikes=", show(bikes), "\n",
  "cars=", show(cars), "\n",
  "total_vehicles=", show(bikes + cars), "\n",
  "capacity=", show(bike_cap*bikes + car_cap*cars), "\n"
];