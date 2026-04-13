% Crop planning cost minimization (all data embedded)

int: max_acres = 50;
int: min_total = 40;

int: costX = 5;
int: costY = 10;

% Decision variables: integer acres for crops X and Y
var 0..max_acres: x;
var 0..max_acres: y;

% Constraints
constraint x + y <= max_acres;        % at most 50 acres
constraint x + y >= min_total;        % at least 40 acres total
constraint x >= 2 * y;                % at least twice as much X as Y
constraint x <= 2 * y + 10;           % cannot exceed twice Y by more than 10

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x_acres = ", show(x), "\n",
  "y_acres = ", show(y), "\n",
  "minimum_cost_dollars = ", show(total_cost), "\n"
];