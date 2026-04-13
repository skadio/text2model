% Crop planning: maximize profit
% Data embedded per instructions

int: land = 140;

int: minTomatoes = 20;
int: minPotatoes = 30;

int: profitTomatoes = 350;
int: profitPotatoes = 600;

% Decision variables (hectares)
var 0..land: tomatoes;
var 0..land: potatoes;

% Constraints
constraint tomatoes + potatoes <= land;
constraint tomatoes >= minTomatoes;
constraint potatoes >= minPotatoes;

% Preference and feasibility: more tomatoes than potatoes, but at most twice
constraint tomatoes > potatoes;
constraint tomatoes <= 2 * potatoes;

% Objective
var int: profit = profitTomatoes * tomatoes + profitPotatoes * potatoes;

solve maximize profit;

output [
  "Tomatoes (ha) = ", show(tomatoes), "\n",
  "Potatoes (ha) = ", show(potatoes), "\n",
  "Profit ($) = ", show(profit), "\n"
];