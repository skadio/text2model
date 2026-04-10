% Real estate investment optimization (all data embedded)

int: costX = 150000;   % commercial building
int: costY = 200000;   % residential complex
int: maxProps = 10;

var 0..maxProps: X;    % number of commercial buildings
var 0..maxProps: Y;    % number of residential complexes

% Total properties limit
constraint X + Y <= maxProps;

% Diversification: X + 0.5*Y >= 5  ->  2X + Y >= 10
constraint 2 * X + Y >= 10;

% Objective: minimize total investment
var int: totalInvestment = costX * X + costY * Y;

solve minimize totalInvestment;

output [
  "X (commercial) = ", show(X), "\n",
  "Y (residential) = ", show(Y), "\n",
  "Total investment ($) = ", show(totalInvestment), "\n"
];