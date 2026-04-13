% Parameters
% Budget caps
int: cap12 = 1000;          % Maximum combined investment in X1 and X2
int: cap34 = 500;           % Maximum combined investment in X3 and X4

% Profit / loss thresholds (scaled by 100 to keep everything integer)
int: minReturn12 = 50;      % Minimum required return from X1 and X2
int: maxLoss34 = -20;       % Net loss from X3 and X4 should not exceed -20 (i.e., must be >= -20)

% Returns/loss coefficients in percent (scaled by 100)
int: r1 = 5;                % 5% return on X1
int: r2 = 7;                % 7% return on X2
int: r3 = -3;               % -3% (loss) on X3
int: r4 = -4;               % -4% (loss) on X4

% Unit costs
int: c1 = 10;               % Cost per unit of X1
int: c2 = 15;               % Cost per unit of X2
int: c3 = 20;               % Cost per unit of X3
int: c4 = 25;               % Cost per unit of X4


% Variables
var 0..cap12: X1;           % Integer investment units in asset X1
var 0..cap12: X2;           % Integer investment units in asset X2
var 0..cap34: X3;           % Integer investment units in asset X3
var 0..cap34: X4;           % Integer investment units in asset X4

% Upper bound computed from max possible spend under variable bounds
var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): totalCost;


% Constraints
% --- Budget cap constraints ---
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;

% --- Return / loss constraints (scaled integers) ---
% r1*X1 + r2*X2 >= 100*minReturn12  => 5*X1 + 7*X2 >= 5000
constraint r1 * X1 + r2 * X2 >= 100 * minReturn12;

% r3*X3 + r4*X4 >= 100*maxLoss34   => -3*X3 - 4*X4 >= -2000
constraint r3 * X3 + r4 * X4 >= 100 * maxLoss34;

% --- Total cost definition ---
constraint totalCost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;


% Objective
solve minimize totalCost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "totalCost=", show(totalCost), "\n"
];