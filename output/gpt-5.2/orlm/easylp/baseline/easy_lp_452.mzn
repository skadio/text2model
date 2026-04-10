int: cost_fertilizer = 5;
int: cost_seeds = 10;

var 0..500: fertilizer;
var 0..500: seeds;

constraint fertilizer + seeds = 500;
constraint 2 * fertilizer + 3 * seeds <= 1000;
constraint 4 * fertilizer - seeds >= 200;

var int: total_cost = cost_fertilizer * fertilizer + cost_seeds * seeds;

solve minimize total_cost;

output [
  "fertilizer=", show(fertilizer), "\n",
  "seeds=", show(seeds), "\n",
  "total_cost=", show(total_cost), "\n"
];