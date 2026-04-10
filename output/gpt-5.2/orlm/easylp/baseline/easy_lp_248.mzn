% Shift scheduling optimization (all data embedded)

int: max_total_shifts = 24;

int: costX = 8;
int: costY = 6;
int: costZ = 10;

int: maxX = 12;
int: maxY = 8;
int: maxZ = 6;

var 0..maxX: x;  % shifts of type X
var 0..maxY: y;  % shifts of type Y
var 0..maxZ: z;  % shifts of type Z

constraint x + y + z <= max_total_shifts;

% Skill requirement: X at least 2 more than Y
constraint x >= y + 2;

% Balance: difference between Y and Z does not exceed 4
constraint abs(y - z) <= 4;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];