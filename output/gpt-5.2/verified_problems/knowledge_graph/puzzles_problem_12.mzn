int: area1;
int: area2;
int: area3;

var int: x;        % left column width
var int: len;      % right column width
var int: y;        % top row height
var int: height;   % bottom row height

var int: area4;

constraint x > 0 /\ len > 0 /\ y > 0 /\ height > 0;

% Areas of the three known rectangles
constraint x * y = area1;
constraint len * y = area2;
constraint x * height = area3;

% Area of the unknown rectangle (bottom-right)
constraint area4 = len * height;

solve maximize area4;

output [
  "x=", show(x), " len=", show(len), " y=", show(y), " height=", show(height), "\n",
  "area4=", show(area4), "\n"
];