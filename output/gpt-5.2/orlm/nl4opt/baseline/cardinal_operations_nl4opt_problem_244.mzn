int: tires_per_plane = 10;
int: cost_per_plane = 1000;

int: tires_per_truck = 6;
int: cost_per_truck = 700;

int: min_tires = 200;
int: budget = 22000;

int: max_plane_trips = budget div cost_per_plane;
int: max_truck_trips = budget div cost_per_truck;

var 0..max_plane_trips: plane_trips;
var 0..max_truck_trips: truck_trips;

constraint tires_per_plane * plane_trips + tires_per_truck * truck_trips >= min_tires;
constraint cost_per_plane * plane_trips + cost_per_truck * truck_trips <= budget;
constraint plane_trips <= truck_trips;

solve minimize plane_trips + truck_trips;

output [
  "plane_trips=", show(plane_trips), "\n",
  "truck_trips=", show(truck_trips), "\n",
  "total_trips=", show(plane_trips + truck_trips), "\n",
  "total_tires=", show(tires_per_plane * plane_trips + tires_per_truck * truck_trips), "\n",
  "total_cost=", show(cost_per_plane * plane_trips + cost_per_truck * truck_trips), "\n"
];