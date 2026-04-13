int: capacity_scooter = 2;
int: capacity_rickshaw = 3;
int: min_visitors = 300;

var 0..1000: scooters;
var 0..1000: rickshaws;

constraint capacity_scooter * scooters + capacity_rickshaw * rickshaws >= min_visitors;

% At most 40% of vehicles are rickshaws:
% rickshaws / (scooters + rickshaws) <= 0.4  <=>  5*rickshaws <= 2*(scooters + rickshaws)
constraint 5 * rickshaws <= 2 * (scooters + rickshaws);

solve minimize scooters;

output [
  "scooters=", show(scooters), "\n",
  "rickshaws=", show(rickshaws), "\n",
  "total_vehicles=", show(scooters + rickshaws), "\n",
  "total_capacity=", show(capacity_scooter * scooters + capacity_rickshaw * rickshaws), "\n"
];