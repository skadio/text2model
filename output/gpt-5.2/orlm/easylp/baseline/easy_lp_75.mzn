int: maxProjects = 15;
int: requiredStrength = 10;

int: strengthX = 2;
int: strengthY = 3;

int: supportX = 5;
int: supportY = 3;

var 0..maxProjects: X;
var 0..maxProjects: Y;

constraint X + Y <= maxProjects;
constraint strengthX * X + strengthY * Y >= requiredStrength;

var int: totalSupport = supportX * X + supportY * Y;

solve minimize totalSupport;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_support=", show(totalSupport), "\n"
];