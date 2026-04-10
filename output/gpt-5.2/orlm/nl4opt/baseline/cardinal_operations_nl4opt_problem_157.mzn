% Meat shop shipment planning (all data embedded)

int: truck_capacity = 1000;
int: van_capacity   = 500;

int: truck_cost = 300;
int: van_cost   = 100;

int: min_patties = 50000;
int: budget      = 12500;

% Decision variables: number of trips by each vehicle type
var 0..ceil(budget div truck_cost): trucks;
var 0..ceil(budget div van_cost):   vans;

% Capacity requirement
constraint trucks * truck_capacity + vans * van_capacity >= min_patties;

% Budget constraint
constraint trucks * truck_cost + vans * van_cost <= budget;

% City constraint: trucks not exceed vans
constraint trucks <= vans;

% Objective: minimize total number of trips
var int: total_trips = trucks + vans;
solve minimize total_trips;

output [
  "trucks_trips = ", show(trucks), "\n",
  "vans_trips   = ", show(vans), "\n",
  "total_trips  = ", show(total_trips), "\n",
  "patties      = ", show(trucks * truck_capacity + vans * van_capacity), "\n",
  "cost         = ", show(trucks * truck_cost + vans * van_cost), "\n"
];