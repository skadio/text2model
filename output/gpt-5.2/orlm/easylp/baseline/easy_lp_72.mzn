% Land allocation problem (all data embedded)

int: profit_wheat = 5;
int: profit_corn  = 3;

int: limit = 1000;

% Decision variables: integer land units for each crop
var 0..limit: wheat;
var 0..limit: corn;

% Constraints
constraint 2*wheat + 4*corn <= limit;
constraint wheat >= corn + 100;

% Objective: minimize profit
var int: profit = profit_wheat*wheat + profit_corn*corn;
solve minimize profit;

output [
  "wheat=", show(wheat), "\n",
  "corn=", show(corn), "\n",
  "profit=", show(profit), "\n"
];