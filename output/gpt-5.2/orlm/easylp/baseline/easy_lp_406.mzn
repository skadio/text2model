int: costX = 10;
int: costY = 15;
int: costZ = 20;
int: costW = 25;

int: capXY = 500;
int: capZW = 700;
int: minXZ = 200;
int: minYW = 300;

var 0..capXY: x;
var 0..capXY: y;
var 0..capZW: z;
var 0..capZW: w;

constraint x + y <= capXY;
constraint z + w <= capZW;
constraint x + z >= minXZ;
constraint y + w >= minYW;

var int: total_cost = costX*x + costY*y + costZ*z + costW*w;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), " w=", show(w), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];