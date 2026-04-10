% Manufacturing materials cost minimization (all data embedded)

int: cost_steel = 10;
int: cost_wood = 15;
int: cost_plastic = 20;

int: total_qty = 3500;

% Decision variables (whole numbers)
var 0..total_qty: steel;
var 0..total_qty: wood;
var 0..total_qty: plastic;

% Constraints
constraint 2 * steel + wood >= 1000;
constraint steel + plastic <= 2000;
constraint wood - plastic >= 500;
constraint steel + wood + plastic == total_qty;

% Objective: minimize total cost
var int: total_cost = cost_steel * steel + cost_wood * wood + cost_plastic * plastic;
solve minimize total_cost;

output [
  "steel=", show(steel), "\n",
  "wood=", show(wood), "\n",
  "plastic=", show(plastic), "\n",
  "total_cost=", show(total_cost), "\n"
];