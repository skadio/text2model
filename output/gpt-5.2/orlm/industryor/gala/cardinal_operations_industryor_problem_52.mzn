include "globals.mzn";

% Children: 1=Harry, 2=Hermione, 3=Ron, 4=Fred, 5=George, 6=Ginny
int: n = 6;
set of int: CHILDREN = 1..n;

array[CHILDREN] of int: cost = [1200, 1650, 750, 800, 800, 1500];

% Decision: take[i] = 1 if child i is taken
array[CHILDREN] of var 0..1: take;

% Count taken (hint)
var 0..n: num_taken;
constraint count(take, 1, num_taken);

% Constraints
constraint take[6] = 1;                 % must take Ginny
constraint num_taken <= 4;              % up to four children
constraint num_taken >= 3;              % at least three children

% If take Harry, cannot take Fred or George
constraint take[1] = 1 -> take[4] = 0;
constraint take[1] = 1 -> take[5] = 0;

% If take George, must also take Fred and Hermione
constraint take[5] = 1 -> take[4] = 1;
constraint take[5] = 1 -> take[2] = 1;

% Objective: minimize total cost
var int: total_cost = sum(i in CHILDREN)(cost[i] * take[i]);

solve minimize total_cost;

output [
  "take (Harry,Hermione,Ron,Fred,George,Ginny) = ", show(take), "\n",
  "num_taken = ", show(num_taken), "\n",
  "total_cost = $", show(total_cost), "\n"
];