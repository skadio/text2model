% Tourism resource allocation (embedded data)

int: capacity = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 500;
int: revY = 300;
int: revZ = 200;

var minX..capacity: x;
var minY..capacity: y;
var minZ..capacity: z;

constraint x + y + z <= capacity;

var int: totalRevenue = revX * x + revY * y + revZ * z;

solve maximize totalRevenue;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalRevenue = $", show(totalRevenue), "\n"
];