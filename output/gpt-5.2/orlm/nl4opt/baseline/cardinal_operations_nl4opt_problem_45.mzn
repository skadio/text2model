% Oil blending profit maximization (integer containers)

int: A_total = 1345;
int: B_total = 346;
int: C_total = 1643;

int: A_max = 46;
int: B_max = 43;
int: C_max = 56;

int: A_pro = 13;
int: B_pro = 4;
int: C_pro = 45;

int: profit_max = 10;
int: profit_pro = 15;

% Decision variables: number of containers (nonnegative integers)
var 0..min(A_total div A_max, min(B_total div B_max, C_total div C_max)): x; % Oil Max
var 0..min(A_total div A_pro, min(B_total div B_pro, C_total div C_pro)): y; % Oil Max Pro

constraint A_max * x + A_pro * y <= A_total;
constraint B_max * x + B_pro * y <= B_total;
constraint C_max * x + C_pro * y <= C_total;

var int: total_profit = profit_max * x + profit_pro * y;

solve maximize total_profit;

output [
  "Oil Max containers = ", show(x), "\n",
  "Oil Max Pro containers = ", show(y), "\n",
  "Total profit = $", show(total_profit), "\n"
];