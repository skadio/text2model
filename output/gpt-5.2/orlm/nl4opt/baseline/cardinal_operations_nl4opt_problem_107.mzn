% Berry farmer LP: minimize operating cost while meeting contract demands

int: cost_old = 300;
int: cost_new = 200;

int: req_rasp = 10;
int: req_blue = 9;
int: req_straw = 15;

int: old_rasp = 2;
int: old_blue = 2;
int: old_straw = 4;

int: new_rasp = 4;
int: new_blue = 1;
int: new_straw = 2;

% Decision variables: days to operate each farm (can be fractional for LP)
var 0.0..1.0e9: days_old;
var 0.0..1.0e9: days_new;

constraint old_rasp * days_old + new_rasp * days_new >= req_rasp;
constraint old_blue * days_old + new_blue * days_new >= req_blue;
constraint old_straw * days_old + new_straw * days_new >= req_straw;

var float: total_cost = cost_old * days_old + cost_new * days_new;

solve minimize total_cost;

output [
  "days_old = ", show(days_old), "\n",
  "days_new = ", show(days_new), "\n",
  "total_cost = ", show(total_cost), "\n"
];