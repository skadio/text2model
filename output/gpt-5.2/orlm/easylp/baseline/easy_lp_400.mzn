% Resource allocation MILP (all data embedded)

int: max12 = 200;
int: max34 = 150;

int: req12 = 1000;
int: req34 = 750;

% Strength coefficients (scaled to avoid decimals: *2)
int: a1 = 10;   % 2*5
int: a2 = 20;   % 2*10
int: b3 = 15;   % 2*7.5
int: b4 = 10;   % 2*5

% Funding costs in dollars
int: c1 = 5000;
int: c2 = 7000;
int: c3 = 10000;
int: c4 = 3000;

var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

constraint X1 + X2 <= max12;
constraint X3 + X4 <= max34;

constraint a1 * X1 + a2 * X2 >= 2 * req12;
constraint b3 * X3 + b4 * X4 >= 2 * req34;

var int: TotalCost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize TotalCost;

output [
  "Minimum total cost ($): ", show(TotalCost), "\n",
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n"
];