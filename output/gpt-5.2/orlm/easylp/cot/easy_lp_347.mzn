% Parameters (with values embedded)
int: total_investment = 10000000;

int: min_X = 2000000;
int: max_Y = 5000000;
int: min_Z = 1500000;
int: max_W = 3000000;

% Returns per dollar (in percent). Objective uses integer arithmetic via scaling.
int: rX = 5;
int: rY = 7;
int: rZ = 6;
int: rW = 8;

% Variables
var 0..total_investment: X;
var 0..total_investment: Y;
var 0..total_investment: Z;
var 0..total_investment: W;

% Total return in dollars (rounded to nearest dollar will be handled via objective scaling)
var 0..(total_investment * 100): total_return_cents;

% Constraints
constraint X + Y + Z + W = total_investment;

constraint X >= min_X;
constraint Y <= max_Y;
constraint Z >= min_Z;
constraint W <= max_W;

% Return calculation in cents to avoid floating point:
% return_cents = sum( allocation * (percent/100) * 100 ) = sum(allocation * percent)
constraint total_return_cents = X * rX + Y * rY + Z * rZ + W * rW;

% Objective
solve minimize total_return_cents;

% Output (convert cents back to dollars; here cents are actually "dollars*1" since we used percent)
output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "W = $", show(W), "\n",
  "Minimum total return (nearest dollar) = $", show(total_return_cents div 100), "\n"
];