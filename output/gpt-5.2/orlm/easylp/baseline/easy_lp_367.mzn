% Workforce allocation across four projects with cost minimization

int: costP1 = 1000;
int: costP2 = 2000;
int: costP3 = 3000;
int: costP4 = 4000;

% Decision variables: number of workers on each project (integers)
var 0..10: P1;
var 0..15: P2;
var 0..12: P3;
var 0..8:  P4;

% Constraints
constraint P1 + P2 <= 20;
constraint P2 + P3 >= 10;
constraint abs(P3 - P4) <= 5;
constraint 2*P1 + 3*P2 - P4 >= 15;

% Objective: minimize total cost
var int: total_cost = costP1*P1 + costP2*P2 + costP3*P3 + costP4*P4;

solve minimize total_cost;

output [
  "P1=", show(P1), " ",
  "P2=", show(P2), " ",
  "P3=", show(P3), " ",
  "P4=", show(P4), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];