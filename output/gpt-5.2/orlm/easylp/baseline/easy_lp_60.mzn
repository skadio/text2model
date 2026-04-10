% Resource allocation between two projects with integer units

var 0..1000: x; % units allocated to Project X
var 0..1000: y; % units allocated to Project Y

% Constraints
constraint 5 * x + 10 * y >= 50;      % performance target
constraint 3 * x + 4 * y <= 40;       % limited resource availability

% Cost (in dollars)
var int: cost = 2000 * x + 3000 * y;

solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost_dollars = ", show(cost), "\n"
];