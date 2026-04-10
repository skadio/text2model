% Data (embedded)
int: cows_needed = 80;

int: heli_capacity = 3;
int: truck_capacity = 7;

int: heli_pollution = 5;
int: truck_pollution = 10;

int: max_truck_trips = 8;

% Decision variables: number of trips
var 0..cows_needed: heli_trips;
var 0..max_truck_trips: truck_trips;

% Total cows transported (must be at least the required number)
constraint heli_capacity * heli_trips + truck_capacity * truck_trips >= cows_needed;

% Objective: minimize total pollution
var int: total_pollution = heli_pollution * heli_trips + truck_pollution * truck_trips;
solve minimize total_pollution;

output [
  "Helicopter trips: ", show(heli_trips), "\n",
  "Truck trips: ", show(truck_trips), "\n",
  "Total cows transported: ", show(heli_capacity*heli_trips + truck_capacity*truck_trips), "\n",
  "Total pollution: ", show(total_pollution), "\n"
];