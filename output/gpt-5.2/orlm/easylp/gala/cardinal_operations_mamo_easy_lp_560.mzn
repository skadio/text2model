% Tourism budget allocation optimization (all data embedded)

% Decision variables: whole-number allocations
var 2000..5000: x;  % Initiative X (min 2000)
var 0..1000:    y;  % Initiative Y (max 1000)
var 500..5000:  z;  % Initiative Z (min 500)

% Total budget constraint
constraint x + y + z <= 5000;

% Cost per unit effectiveness
int: cx = 50;
int: cy = 100;
int: cz = 150;

% Objective: minimize total cost
var int: total_cost = cx*x + cy*y + cz*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];