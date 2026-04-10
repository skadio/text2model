int: dine_capacity = 100;
int: dine_employees = 8;

int: truck_capacity = 50;
int: truck_employees = 3;

int: min_sandwiches = 500;
int: max_employees = 35;

var 0..100: dine_in;
var 0..100: food_truck;

constraint
  dine_capacity * dine_in + truck_capacity * food_truck >= min_sandwiches;

constraint
  dine_employees * dine_in + truck_employees * food_truck <= max_employees;

var int: total_stores = dine_in + food_truck;

solve minimize total_stores;

output [
  "dine_in=", show(dine_in), "\n",
  "food_truck=", show(food_truck), "\n",
  "total_stores=", show(total_stores), "\n",
  "sandwiches=", show(dine_capacity * dine_in + truck_capacity * food_truck), "\n",
  "employees=", show(dine_employees * dine_in + truck_employees * food_truck), "\n"
];