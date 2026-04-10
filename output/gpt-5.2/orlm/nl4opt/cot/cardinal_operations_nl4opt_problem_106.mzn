% Parameters (with values embedded)
int: total_land = 50;
int: min_potatoes = 12;
int: min_cucumbers = 15;
int: profit_potatoes = 500;
int: profit_cucumbers = 650;

% Variables
var 0..total_land: potatoes;
var 0..total_land: cucumbers;
var 0..(profit_potatoes * total_land + profit_cucumbers * total_land): profit;

% Constraints
constraint potatoes + cucumbers <= total_land;
constraint potatoes >= min_potatoes;
constraint cucumbers >= min_cucumbers;

% Mark prefers to grow more cucumbers than potatoes
constraint cucumbers >= potatoes + 1;

% At most twice as many cucumbers as potatoes
constraint cucumbers <= 2 * potatoes;

% Profit definition
constraint profit = profit_potatoes * potatoes + profit_cucumbers * cucumbers;

% Objective
solve maximize profit;

output [
  "potatoes_acres = ", show(potatoes), "\n",
  "cucumbers_acres = ", show(cucumbers), "\n",
  "profit = $", show(profit), "\n"
];