include "globals.mzn";

int: area1;
int: area2;
int: area3;

var int: x;
var int: len;
var int: y;
var int: height;

var int: area4;

constraint x > 0 /\ len > 0 /\ y > 0 /\ height > 0;
constraint area4 > 0;

% Area relations from the partitioned rectangle:
constraint x * y = area1;
constraint len * y = area2;
constraint x * height = area3;
constraint len * height = area4;

solve satisfy;

output [
  "x=", show(x), "\n",
  "len=", show(len), "\n",
  "y=", show(y), "\n",
  "height=", show(height), "\n",
  "area4=", show(area4), "\n"
];