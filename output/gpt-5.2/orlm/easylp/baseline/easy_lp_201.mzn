% Investment allocation across portfolios X, Y, Z
% Minimize total cost subject to budget and allocation constraints.

var 0..500: X;          % Portfolio X max 500
var 0..400: Y;          % Portfolio Y max 400
var 50..1000: Z;        % Portfolio Z min 50 (upper bound set by total budget)

constraint X + Y + Z <= 1000;          % Total investment budget
constraint 3*X + 2*Y - Z >= 10;        % Risk/return (or diversification) requirement
constraint Z - Y >= 30;                % Exposure requirement

var int: total_cost = 5*X + 6*Y + 7*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];