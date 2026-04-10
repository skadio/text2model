% International goods exporter: minimize fuel while meeting demand and policy constraints

int: ship_capacity = 40;     % containers per ship trip
int: ship_fuel     = 500;    % liters per ship trip
int: plane_capacity = 20;    % containers per plane trip
int: plane_fuel     = 300;   % liters per plane trip

int: demand = 500;           % containers to transport (at least)
int: max_planes = 10;        % at most 10 plane trips

% Decision variables: number of trips
var 0..1000: ship_trips;
var 0..max_planes: plane_trips;

% Constraints
constraint ship_capacity * ship_trips + plane_capacity * plane_trips >= demand;

% At least 50% of trips are by ship:
% ship_trips / (ship_trips + plane_trips) >= 0.5  <=>  ship_trips >= plane_trips
constraint ship_trips >= plane_trips;

% Objective: minimize total fuel
var int: total_fuel = ship_fuel * ship_trips + plane_fuel * plane_trips;
solve minimize total_fuel;

output [
  "ship_trips = ", show(ship_trips), "\n",
  "plane_trips = ", show(plane_trips), "\n",
  "total_containers = ", show(ship_capacity * ship_trips + plane_capacity * plane_trips), "\n",
  "total_fuel = ", show(total_fuel), "\n"
];