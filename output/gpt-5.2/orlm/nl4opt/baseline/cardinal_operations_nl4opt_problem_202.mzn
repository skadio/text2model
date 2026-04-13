% Crop planning: tomatoes and potatoes (hectares)

var int: tomatoes;  % hectares of tomatoes
var int: potatoes;  % hectares of potatoes

% Land availability
constraint tomatoes + potatoes <= 140;

% Preference: more tomatoes than potatoes
constraint tomatoes >= potatoes + 1;

% At most twice as many tomatoes as potatoes
constraint tomatoes <= 2 * potatoes;

% Minimum community demands
constraint tomatoes >= 20;
constraint potatoes >= 30;

% Profit
var int: profit = 350 * tomatoes + 600 * potatoes;

solve maximize profit;

output [
  "tomatoes_hectares = ", show(tomatoes), "\n",
  "potatoes_hectares = ", show(potatoes), "\n",
  "profit = $", show(profit), "\n"
];