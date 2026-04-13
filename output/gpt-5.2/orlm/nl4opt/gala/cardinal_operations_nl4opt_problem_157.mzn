% Meat shop shipment planning (embed all data here)

% Data
int: truck_capacity = 1000;
int: van_capacity   = 500;

int: truck_cost = 300;
int: van_cost   = 100;

int: min_patties = 50000;
int: budget      = 12500;

% Decision variables: number of trips by trucks and vans
% Upper bounds derived from budget (safe tight bounds)
int: max_trucks = budget div truck_cost; % 41
int: max_vans   = budget div van_cost;   % 125

var 0..max_trucks: trucks;
var 0..max_vans: vans;

% Constraints
constraint truck_capacity * trucks + van_capacity * vans >= min_patties;
constraint truck_cost * trucks + van_cost * vans <= budget;
constraint trucks <= vans; % trucks must not exceed vans

% Objective: minimize total number of trips
var 0..(max_trucks + max_vans): total_trips = trucks + vans;
solve minimize total_trips;

output [
  "trucks = ", show(trucks), "\n",
  "vans   = ", show(vans), "\n",
  "total_trips = ", show(total_trips), "\n",
  "patties_shipped = ", show(truck_capacity * trucks + van_capacity * vans), "\n",
  "total_cost = ", show(truck_cost * trucks + van_cost * vans), "\n"
];