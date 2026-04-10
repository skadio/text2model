% Production planning: maximize profit for products A and B

% Parameters (embedded data)
int: profitA = 3;
int: profitB = 5;

int: timeA = 12;          % minutes per unit of A
int: timeB = 25;          % minutes per unit of B
int: availableTime = 30 * 60;  % 30 hours per week -> minutes

% Decision variables: number of units to produce (nonnegative integers)
var 0..availableTime div timeA: A;
var 0..availableTime div timeB: B;

% Machine time capacity
constraint timeA * A + timeB * B <= availableTime;

% Technical constraint: for every 5 units of A, at least 2 units of B
% i.e., B >= (2/5) * A  ->  5B >= 2A
constraint 5 * B >= 2 * A;

% Objective: maximize total profit
var int: totalProfit = profitA * A + profitB * B;
solve maximize totalProfit;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Total time (min) = ", show(timeA*A + timeB*B), " / ", show(availableTime), "\n",
  "Profit = ", show(totalProfit), "\n"
];