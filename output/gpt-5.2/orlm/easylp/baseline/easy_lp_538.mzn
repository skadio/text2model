% Resource allocation optimization (all data embedded)

int: cost_labor = 5;
int: cost_material = 3;
int: cost_equipment = 2;

% Decision variables (whole numbers, nonnegative)
var 0..1000: labor;
var 0..1000: material;
var 0..1000: equipment;

% Constraints
constraint 4 * labor + material <= 1000;
constraint 2 * labor + 3 * equipment >= 500;
constraint material - equipment = 100;

% Objective: minimize total cost
var int: total_cost = cost_labor * labor + cost_material * material + cost_equipment * equipment;
solve minimize total_cost;

output [
  "labor=", show(labor), "\n",
  "material=", show(material), "\n",
  "equipment=", show(equipment), "\n",
  "min_total_cost=", show(total_cost), "\n"
];