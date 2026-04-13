% Budget allocation minimization for four departments

int: costT = 500;
int: costP = 300;
int: costS = 200;
int: costR = 100;

var int: T; % Technology units
var int: P; % Physics units
var int: S; % Sports units
var int: R; % Research units

constraint T >= 15;
constraint P >= 10;
constraint S >= 5;
constraint R >= 2;

constraint T + P <= 50;
constraint S + R <= 30;

var int: total_cost = costT*T + costP*P + costS*S + costR*R;

solve minimize total_cost;

output [
  "T=", show(T), " P=", show(P), " S=", show(S), " R=", show(R), "\n",
  "Minimum total cost ($): ", show(total_cost), "\n"
];