% Military resource allocation: minimize support points

int: supportX = 1000;
int: supportY = 2000;

% Variable bounds (chosen large enough to cover feasible solutions)
int: MAXX = 50000;
int: MAXY = 50000;

var 0..MAXX: X;
var 0..MAXY: Y;

constraint 5 * X + 10 * Y >= 50000;
constraint 3 * X + 4 * Y <= 30000;
constraint X - Y >= 1000;

var int: total_support = supportX * X + supportY * Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total support points = ", show(total_support), "\n"
];