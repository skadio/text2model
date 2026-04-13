int: van_capacity = 50;
int: truck_capacity = 100;
int: demand = 2000;

var 0..demand div van_capacity: vans;
var 0..demand div truck_capacity: trucks;

constraint vans * van_capacity + trucks * truck_capacity >= demand;
constraint trucks <= vans;

solve minimize vans;

output [
  "vans=", show(vans), "\n",
  "trucks=", show(trucks), "\n",
  "total_pairs=", show(vans*van_capacity + trucks*truck_capacity), "\n"
];