% Tourist allocation / revenue maximization (all data embedded)

int: cap = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 500;
int: revY = 300;
int: revZ = 200;

var minX..cap: x;   % tourists to attraction X
var minY..cap: y;   % tourists to attraction Y
var minZ..cap: z;   % tourists to attraction Z

constraint x + y + z <= cap;

var int: totalRevenue = revX*x + revY*y + revZ*z;

solve maximize totalRevenue;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalRevenue = ", show(totalRevenue), "\n"
];