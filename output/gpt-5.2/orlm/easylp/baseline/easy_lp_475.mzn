int: max_total = 50;
int: min_total = 10;

int: resX = 100;
int: resY = 150;

var 0..max_total: x; % number of package X
var 0..max_total: y; % number of package Y

constraint x + y <= max_total;
constraint x + y >= min_total;

% "the number of package X should not exceed twice the number of package Y by more than 20"
constraint x - 2*y <= 20;

var int: total_resources = resX * x + resY * y;

solve minimize total_resources;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_resources=", show(total_resources), "\n"
];