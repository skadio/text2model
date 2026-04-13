int: max_total = 5000;
int: min_diff = 100;

float: cost_x = 0.5;
float: cost_y = 0.3;

var 0..max_total: x; % activities for Project X
var 0..max_total: y; % activities for Project Y

constraint 2*x + 3*y <= max_total;
constraint x - y >= min_diff;

var float: total_cost = cost_x * int2float(x) + cost_y * int2float(y);

solve minimize total_cost;

% Rounded to nearest integer (0.5 rounds away from 0)
var int: rounded_cost =
    if total_cost >= 0.0 then floor(total_cost + 0.5)
    else ceil(total_cost - 0.5)
    endif;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_cost=", show(rounded_cost), "\n"
];