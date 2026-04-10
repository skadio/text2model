% Farm planning: potatoes vs cucumbers (maximize profit)

% Data (embedded)
int: total_acres = 50;

int: min_potatoes = 12;
int: min_cucumbers = 15;

int: profit_potato = 500;
int: profit_cucumber = 650;

% Decision variables (acres)
var 0..total_acres: potatoes;
var 0..total_acres: cucumbers;

% Constraints
constraint potatoes + cucumbers <= total_acres;
constraint potatoes >= min_potatoes;
constraint cucumbers >= min_cucumbers;

% Preference: more cucumbers than potatoes
constraint cucumbers > potatoes;

% Resource limit: at most twice as many cucumbers as potatoes
constraint cucumbers <= 2 * potatoes;

% Objective
var int: total_profit = profit_potato * potatoes + profit_cucumber * cucumbers;

solve maximize total_profit;

output [
  "Potatoes acres = ", show(potatoes), "\n",
  "Cucumbers acres = ", show(cucumbers), "\n",
  "Total profit = $", show(total_profit), "\n"
];