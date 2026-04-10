% Parameters
% Cost score per unit for each investment option
int: costX = 7;
int: costY = 9;

% Risk tolerance constraint coefficients and bound:
% 4*X + 5*Y <= 1000
int: riskCoefX = 4;
int: riskCoefY = 5;
int: riskMax = 1000;

% Balance constraint coefficients and bound:
% 3*X - 2*Y >= 200
int: balanceCoefX = 3;
int: balanceCoefY = 2;
int: balanceMin = 200;

% Total investment limit:
% X + Y <= 300
int: totalMax = 300;

% Variables
% Integer investment amounts in options X and Y (non-negative, whole units)
var 0..totalMax: investX;
var 0..totalMax: investY;

% Total cost score to minimize (bounded for safe linear expressions)
var 0..(costX*totalMax + costY*totalMax): totalCost;

% Constraints
% Total cost definition
constraint
  totalCost = costX * investX + costY * investY;

% Risk tolerance constraint (4*X + 5*Y <= 1000)
constraint
  riskCoefX * investX + riskCoefY * investY <= riskMax;

% Balance constraint (3*X - 2*Y >= 200)
constraint
  balanceCoefX * investX - balanceCoefY * investY >= balanceMin;

% Total investment limit (X + Y <= 300)
constraint
  investX + investY <= totalMax;

% Objective
solve minimize totalCost;