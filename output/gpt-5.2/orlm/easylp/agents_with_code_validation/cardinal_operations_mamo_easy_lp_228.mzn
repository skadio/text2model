% Parameters
int: cost_X = 5;                 % Cost per unit allocated to project X
int: cost_Y = 4;                 % Cost per unit allocated to project Y
int: cost_Z = 6;                 % Cost per unit allocated to project Z

int: rhs_min_1 = 10;             % RHS for constraint: 2X + 3Y + Z >= 10
int: rhs_max_2 = 8;              % RHS for constraint: X - Y + Z <= 8
int: rhs_min_3 = 3;              % RHS for constraint: Y - Z >= 3

% Variable bounds (chosen to keep the integer model bounded / well-posed)
int: X_lb = 0;                   % Non-negativity lower bound for X
int: Y_lb = 0;                   % Non-negativity lower bound for Y
int: Z_lb = 0;                   % Non-negativity lower bound for Z

int: X_ub = 18;                  % Safe upper bound for X (from constraints)
int: Y_ub = 18;                  % Safe upper bound for Y (from constraints)
int: Z_ub = 15;                  % Safe upper bound for Z (from constraints)

% Variables
var X_lb..X_ub: X;               % Integer allocation to project X
var Y_lb..Y_ub: Y;               % Integer allocation to project Y
var Z_lb..Z_ub: Z;               % Integer allocation to project Z
var 0..(cost_X*X_ub + cost_Y*Y_ub + cost_Z*Z_ub): total_cost;  % Total cost (bounded)

% Constraints

% --- Total cost definition (links decision variables to total_cost) ---
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% --- Resource/budget/manpower minimum requirement: 2X + 3Y + Z >= 10 ---
constraint
  2 * X + 3 * Y + Z >= rhs_min_1;

% --- Technology/feasibility upper limit: X - Y + Z <= 8 ---
constraint
  X - Y + Z <= rhs_max_2;

% --- Coverage/priority requirement: Y - Z >= 3 ---
constraint
  Y - Z >= rhs_min_3;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];