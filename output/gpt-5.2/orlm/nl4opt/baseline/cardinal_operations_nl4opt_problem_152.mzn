% Vitamin mix optimization (embedded data)

% Decision variables: number of cups of each drink (nonnegative integers)
var 0..1000: xA; % cups of drink A
var 0..1000: xB; % cups of drink B

% Nutrient content per cup
int: A_A = 8;   int: A_D = 6;   int: A_E = 10;  int: A_K = 4;
int: B_A = 15;  int: B_D = 2;   int: B_E = 20;  int: B_K = 12;

% Requirements
int: reqA = 150;
int: reqD = 300;
int: maxE = 400;

constraint A_A*xA + B_A*xB >= reqA;   % Vitamin A at least 150
constraint A_D*xA + B_D*xB >= reqD;   % Vitamin D at least 300
constraint A_E*xA + B_E*xB <= maxE;   % Vitamin E at most 400

% Objective: minimize Vitamin K
var int: totalK = A_K*xA + B_K*xB;
solve minimize totalK;

output [
  "cups_A=", show(xA), "\n",
  "cups_B=", show(xB), "\n",
  "total_VitA=", show(A_A*xA + B_A*xB), "\n",
  "total_VitD=", show(A_D*xA + B_D*xB), "\n",
  "total_VitE=", show(A_E*xA + B_E*xB), "\n",
  "total_VitK=", show(totalK), "\n"
];