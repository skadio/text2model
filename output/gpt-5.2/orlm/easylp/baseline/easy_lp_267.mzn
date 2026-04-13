% Employee allocation to projects X, Y, Z (all data embedded)

int: total_employees = 20;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: minX = 5;
int: minY = 3;
int: minZ = 2;

var 0..total_employees: x; % employees on X
var 0..total_employees: y; % employees on Y
var 0..total_employees: z; % employees on Z

constraint x + y + z = total_employees;
constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];