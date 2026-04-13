% Transportation planning: camel caravans vs desert trucks

int: demand = 1500;

int: camel_capacity = 50;
int: camel_time = 12;

int: truck_capacity = 150;
int: truck_time = 5;

% Decision variables: number of trips (nonnegative integers)
var 0..demand div camel_capacity: camels;
var 0..demand div truck_capacity: trucks;

% Must deliver at least the required amount
constraint camel_capacity * camels + truck_capacity * trucks >= demand;

% Preference: more camel caravans than desert trucks
constraint camels > trucks;

% Objective: minimize total hours
var int: total_hours = camel_time * camels + truck_time * trucks;
solve minimize total_hours;

output [
  "camels_trips=", show(camels), "\n",
  "trucks_trips=", show(trucks), "\n",
  "delivered_units=", show(camel_capacity * camels + truck_capacity * trucks), "\n",
  "total_hours=", show(total_hours), "\n"
];