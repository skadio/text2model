% Farm planning: potatoes vs cucumbers

int: total_land = 50;

int: min_potatoes = 12;
int: min_cucumbers = 15;

int: profit_potatoes = 500;
int: profit_cucumbers = 650;

% Decision variables (acres)
var 0..total_land: potatoes;
var 0..total_land: cucumbers;

% Constraints
constraint potatoes + cucumbers <= total_land;
constraint potatoes >= min_potatoes;
constraint cucumbers >= min_cucumbers;

% Preference/ratio constraints
constraint cucumbers >= potatoes;        % prefers more cucumbers than potatoes
constraint cucumbers <= 2 * potatoes;    % at most twice as many cucumbers as potatoes

% Objective
var int: profit = profit_potatoes * potatoes + profit_cucumbers * cucumbers;
solve maximize profit;

output [
  "potatoes_acres = ", show(potatoes), "\n",
  "cucumbers_acres = ", show(cucumbers), "\n",
  "profit = $", show(profit), "\n"
];