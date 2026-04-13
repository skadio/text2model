% Land allocation for four crops with cost minimization

int: max_WC = 500;   % Wheat + Corn
int: max_RB = 600;   % Rice + Barley

int: costW = 10;
int: costC = 20;
int: costR = 30;
int: costB = 40;

% Decision variables: whole acres
var 0..10000: W; % Wheat
var 0..10000: C; % Corn
var 0..10000: R; % Rice
var 0..10000: B; % Barley

constraint W + C <= max_WC;
constraint R + B <= max_RB;

constraint W >= R + 100;
constraint C >= B + 200;

var int: total_cost = costW*W + costC*C + costR*R + costB*B;

solve minimize total_cost;

output [
  "Wheat acres = ", show(W), "\n",
  "Corn acres  = ", show(C), "\n",
  "Rice acres  = ", show(R), "\n",
  "Barley acres= ", show(B), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];