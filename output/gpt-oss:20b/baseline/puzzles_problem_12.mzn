int: area1;
int: area2;
int: area3;

var int: area4;

constraint area2 * area3 = area1 * area4;
constraint area4 > 0;

solve satisfy;

output ["\(area4)"];