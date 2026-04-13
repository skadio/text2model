% Crop planting cost minimization with embedded data

% Decision variables: acres planted (integers, nonnegative)
var 0..100000: wheat;
var 0..100000: corn;
var 0..100000: soybeans;
var 0..100000: potatoes;

% Costs per acre
int: cost_wheat = 2;
int: cost_corn = 3;
int: cost_soybeans = 1;
int: cost_potatoes = 4;

% Constraints
constraint wheat + corn >= 1000;
constraint soybeans + potatoes <= 800;
constraint wheat >= soybeans + 200;
constraint corn + potatoes <= 500;

% Objective: minimize total cost
var int: total_cost =
  cost_wheat * wheat +
  cost_corn * corn +
  cost_soybeans * soybeans +
  cost_potatoes * potatoes;

solve minimize total_cost;

output [
  "wheat=", show(wheat), " acres\n",
  "corn=", show(corn), " acres\n",
  "soybeans=", show(soybeans), " acres\n",
  "potatoes=", show(potatoes), " acres\n",
  "total_cost=$", show(total_cost), "\n"
];