% Oil transport optimization: minimize number of containers and trucks

int: container_capacity = 30;
int: truck_capacity = 40;

int: min_oil = 2000;
int: min_containers = 15;

var int: containers;
var int: trucks;

constraint containers >= min_containers;
constraint trucks >= 0;

% Government restriction: trucks used at most half the number of containers
constraint 2 * trucks <= containers;

% Must ship at least the required oil
constraint container_capacity * containers + truck_capacity * trucks >= min_oil;

solve minimize containers + trucks;

output [
  "containers = ", show(containers), "\n",
  "trucks = ", show(trucks), "\n",
  "total_units_shipped = ", show(container_capacity * containers + truck_capacity * trucks), "\n",
  "total_vehicles = ", show(containers + trucks), "\n"
];