int: maxProps = 100;

% Decision variables: number of properties invested in
var 10..maxProps: X; % residential (at least 10)
var 5..maxProps: Y;  % commercial (at least 5)

% Costs per property
int: costX = 50000;
int: costY = 70000;

% Constraints
constraint X + Y <= maxProps;

% ROI constraint: 30% of residential + 40% of commercial >= 30
% 0.3 X + 0.4 Y >= 30  ->  3X + 4Y >= 300
constraint 3*X + 4*Y >= 300;

% Risk diversification: |(1/2)X - (1/5)Y| <= 40
% Multiply by 10: |5X - 2Y| <= 400
constraint abs(5*X - 2*Y) <= 400;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X(residential)=", show(X), "\n",
  "Y(commercial)=", show(Y), "\n",
  "MinTotalCost=", show(totalCost), "\n"
];