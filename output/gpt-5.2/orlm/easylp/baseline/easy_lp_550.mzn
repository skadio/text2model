% Employee allocation to projects X, Y, Z with minimum staffing and total staff limit
int: total_employees = 100;

int: minX = 30;
int: minY = 20;
int: minZ = 10;

int: costX = 5000;
int: costY = 7000;
int: costZ = 8000;

var minX..total_employees: x;
var minY..total_employees: y;
var minZ..total_employees: z;

constraint x + y + z = total_employees;

var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];