% Marketing budget allocation - minimize total cost with integer investments

var 0..1000: x; % dollars invested in channel X
var 0..1000: y; % dollars invested in channel Y
var 0..1000: z; % dollars invested in channel Z

constraint x + y <= 1000;
constraint y + z <= 800;
constraint x + z >= 500;

% Objective: minimize total cost (total dollars invested)
var 0..3000: total_cost = x + y + z;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n",
  "total_cost_rounded = ", show(total_cost), "\n",
  "total_roi = ", show(2*x + 3*y + 5*z), "\n"
];