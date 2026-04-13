% Fishing transport optimization

int: canoe_capacity = 10;
int: diesel_capacity = 15;
int: min_fish = 1000;

var 0..min_fish: canoes;
var 0..min_fish: diesel_boats;

constraint canoe_capacity * canoes + diesel_capacity * diesel_boats >= min_fish;
constraint canoes >= 3 * diesel_boats;

var 0..2*min_fish: total_boats = canoes + diesel_boats;

solve minimize total_boats;

output [
  "canoes=", show(canoes), "\n",
  "diesel_boats=", show(diesel_boats), "\n",
  "total_boats=", show(total_boats), "\n",
  "fish_capacity=", show(canoe_capacity * canoes + diesel_capacity * diesel_boats), "\n"
];