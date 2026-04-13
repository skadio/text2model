int: van_capacity = 50;
int: truck_capacity = 80;

int: van_cost = 30;
int: truck_cost = 50;

int: min_boxes = 1500;
int: budget = 1000;

var 0..ceil(int2float(min_boxes)/van_capacity): van_trips;
var 0..ceil(int2float(min_boxes)/truck_capacity): truck_trips;

constraint van_capacity * van_trips + truck_capacity * truck_trips >= min_boxes;
constraint van_cost * van_trips + truck_cost * truck_trips <= budget;
constraint van_trips > truck_trips;

var int: total_trips = van_trips + truck_trips;

solve minimize total_trips;

output [
  "van_trips=", show(van_trips), "\n",
  "truck_trips=", show(truck_trips), "\n",
  "total_trips=", show(total_trips), "\n",
  "boxes_transported=", show(van_capacity*van_trips + truck_capacity*truck_trips), "\n",
  "total_cost=", show(van_cost*van_trips + truck_cost*truck_trips), "\n"
];