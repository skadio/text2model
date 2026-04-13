% Crop planting profit maximization (embedded data)

% Decision variables: acres planted (integers)
var 0..600: wheat;
var 0..400: corn;
var 0..350: soybean;
var 0..300: rice;

% Group area limits
constraint wheat + corn <= 1000;
constraint soybean + rice <= 800;

% Diversity / balance constraints
constraint wheat - soybean >= 200;
constraint abs(corn - rice) <= 500;

% Profit per acre
int: p_wheat = 4;
int: p_corn = 3;
int: p_soy = 2;
int: p_rice = 1;

var int: total_profit = p_wheat*wheat + p_corn*corn + p_soy*soybean + p_rice*rice;

solve maximize total_profit;

output [
  "wheat_acres=", show(wheat), "\n",
  "corn_acres=", show(corn), "\n",
  "soybean_acres=", show(soybean), "\n",
  "rice_acres=", show(rice), "\n",
  "maximum_total_profit=$", show(total_profit), "\n",
  "minimum_total_cost=$", show(-total_profit), "\n"
];