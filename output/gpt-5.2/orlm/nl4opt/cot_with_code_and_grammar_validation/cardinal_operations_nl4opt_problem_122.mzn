% Investment LP (embedded data)

% Parameters
int: B = 760000;            % total budget
int: pC_num = 1;            % condos profit = 0.5 = 1/2
int: pC_den = 2;
int: pD = 1;                % detached profit = 1 per dollar
int: minCondoPct = 20;      % at least 20% in condos
int: minDetached = 20000;   % at least $20000 in detached

% Variables (integer dollars)
var 0..B: xC;               % dollars in condos
var 0..B: xD;               % dollars in detached

% Constraints
constraint xC + xD <= B;
% xC >= 0.20*(xC+xD)  <=>  100*xC >= 20*(xC+xD)
constraint 100 * xC >= minCondoPct * (xC + xD);
constraint xD >= minDetached;

% Objective: maximize profit (use scaled profit to keep it integer)
% scaled_profit = 2 * profit = 1*xC + 2*xD
var 0..(B + 2*B): scaled_profit;
constraint scaled_profit = xC + 2 * xD;

solve maximize scaled_profit;

output [
  "xC=", show(xC), "\n",
  "xD=", show(xD), "\n",
  "profit=", show(scaled_profit / 2.0), "\n"
];