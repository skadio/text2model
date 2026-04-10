% Parameters (with values embedded)
int: cost_steel = 10;
int: cost_wood = 15;
int: cost_plastic = 20;

int: min_2steel_plus_wood = 1000;
int: max_steel_plus_plastic = 2000;
int: min_wood_minus_plastic = 500;
int: total_material = 3500;

% Variables
var 0..total_material: steel;
var 0..total_material: wood;
var 0..total_material: plastic;

var 0..(cost_steel*total_material + cost_wood*total_material + cost_plastic*total_material): total_cost;

% Constraints
constraint 2 * steel + wood >= min_2steel_plus_wood;
constraint steel + plastic <= max_steel_plus_plastic;
constraint wood - plastic >= min_wood_minus_plastic;
constraint steel + wood + plastic == total_material;

constraint total_cost = cost_steel * steel + cost_wood * wood + cost_plastic * plastic;

% Objective
solve minimize total_cost;

output [
  "steel=", show(steel), "\n",
  "wood=", show(wood), "\n",
  "plastic=", show(plastic), "\n",
  "total_cost=", show(total_cost), "\n"
];