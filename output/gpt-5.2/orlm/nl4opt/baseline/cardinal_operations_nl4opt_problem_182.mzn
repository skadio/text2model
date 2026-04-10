% Transportation planning: ships and planes
% Minimize total fuel subject to capacity and trip constraints.

int: ship_capacity = 40;
int: plane_capacity = 20;

int: ship_fuel = 500;
int: plane_fuel = 300;

int: required_containers = 500;

int: max_plane_trips = 10;

var 0..1000: ship_trips;
var 0..max_plane_trips: plane_trips;

% At least required containers transported
constraint ship_capacity * ship_trips + plane_capacity * plane_trips >= required_containers;

% At least 50% of trips must be by ship:
% ship_trips / (ship_trips + plane_trips) >= 0.5  <=>  ship_trips >= plane_trips
constraint ship_trips >= plane_trips;

% Objective: minimize total fuel
var int: total_fuel = ship_fuel * ship_trips + plane_fuel * plane_trips;
solve minimize total_fuel;

output [
  "ship_trips = ", show(ship_trips), "\n",
  "plane_trips = ", show(plane_trips), "\n",
  "total_fuel = ", show(total_fuel), "\n",
  "total_containers = ", show(ship_capacity*ship_trips + plane_capacity*plane_trips), "\n"
];