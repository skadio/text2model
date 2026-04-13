include "globals.mzn";

/* Data (embedded as required) */
int: costSteel   = 10;
int: costWood    = 15;
int: costPlastic = 20;

int: min_twiceSteel_plus_wood = 1000;
int: max_steel_plus_plastic   = 2000;
int: min_wood_minus_plastic   = 500;
int: total_materials          = 3500;

/* Decision variables (whole numbers) */
var 0..total_materials: steel;
var 0..total_materials: wood;
var 0..total_materials: plastic;

/* Constraints */
constraint 2 * steel + wood >= min_twiceSteel_plus_wood;
constraint steel + plastic <= max_steel_plus_plastic;
constraint wood - plastic >= min_wood_minus_plastic;
constraint steel + wood + plastic = total_materials;

/* Objective: minimize total cost */
var 0..(costSteel + costWood + costPlastic) * total_materials: totalCost;
constraint totalCost = costSteel * steel + costWood * wood + costPlastic * plastic;

solve minimize totalCost;

output [
  "steel = ", show(steel), "\n",
  "wood = ", show(wood), "\n",
  "plastic = ", show(plastic), "\n",
  "min_total_cost = $", show(totalCost), "\n"
];