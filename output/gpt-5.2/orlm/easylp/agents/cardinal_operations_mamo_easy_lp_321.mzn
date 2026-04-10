% Parameters
int: costX = 5;              % Cost per unit on ship X
int: costY = 7;              % Cost per unit on ship Y
int: costZ = 3;              % Cost per unit on ship Z

int: maxX = 100;             % Capacity upper bound for ship X
int: maxY = 80;              % Capacity upper bound for ship Y
int: maxZ = 60;              % Capacity upper bound for ship Z

% Constraint RHS values
int: min_weighted_1 = 30;    % 2*X + 3*Y + Z >= 30
int: max_weighted_2 = 50;    % X + 4*Y + 2*Z <= 50
int: min_diff_3 = 10;        % X - Y + Z >= 10


% Variables
var 0..maxX: cargoX;         % Integer cargo allocated to ship X
var 0..maxY: cargoY;         % Integer cargo allocated to ship Y
var 0..maxZ: cargoZ;         % Integer cargo allocated to ship Z

var int: totalCost;          % Total shipping cost (to minimize)


% Constraints
% --- Cost definition (linear expression for total cost) ---
constraint totalCost = costX*cargoX + costY*cargoY + costZ*cargoZ;

% --- Weighted minimum cargo requirement: 2*X + 3*Y + Z >= 30 ---
constraint 2*cargoX + 3*cargoY + cargoZ >= min_weighted_1;

% --- Weighted maximum cargo limitation: X + 4*Y + 2*Z <= 50 ---
constraint cargoX + 4*cargoY + 2*cargoZ <= max_weighted_2;

% --- Difference/combination requirement: X - Y + Z >= 10 ---
constraint cargoX - cargoY + cargoZ >= min_diff_3;


% Objective
solve minimize totalCost;

output [
  "cargoX=", show(cargoX), "\n",
  "cargoY=", show(cargoY), "\n",
  "cargoZ=", show(cargoZ), "\n",
  "totalCost=", show(totalCost), "\n"
];