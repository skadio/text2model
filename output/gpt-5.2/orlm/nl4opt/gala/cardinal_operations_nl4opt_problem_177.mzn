include "globals.mzn";

/* Data (embedded as requested) */
int: canoe_cap = 10;
int: diesel_cap = 15;
int: min_fish = 1000;

/* Decision variables */
var 0..min_fish div canoe_cap + min_fish div diesel_cap: canoes;
var 0..min_fish div diesel_cap: diesels;

/* Constraints */
constraint canoe_cap * canoes + diesel_cap * diesels >= min_fish;
constraint canoes >= 3 * diesels;

/* Objective: minimize total number of boats */
var 0..min_fish: total_boats = canoes + diesels;

solve minimize total_boats;

output [
  "Canoes = ", show(canoes), "\n",
  "Diesels = ", show(diesels), "\n",
  "TotalBoats = ", show(total_boats), "\n",
  "FishCapacity = ", show(canoe_cap * canoes + diesel_cap * diesels), "\n"
];