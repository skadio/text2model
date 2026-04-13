% Investment allocation problem (all data embedded)

int: budget = 200000;          % dollars
int: min_score = 400000;       % dollars (required minimum score)

int: costX = 1000;             % dollars per unit of X
int: costY = 500;              % dollars per unit of Y

int: scoreX = 5;               % score coefficient for X
int: scoreY = 3;               % score coefficient for Y

% Decision variables: number of whole-thousand-dollar units invested
var 0..budget div costX: x;    % units of X (each unit costs $1000)
var 0..budget div costY: y;    % units of Y (each unit costs $500)

constraint costX * x + costY * y <= budget;
constraint scoreX * x + scoreY * y >= min_score;

var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x_units=", show(x), "\n",
  "y_units=", show(y), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];