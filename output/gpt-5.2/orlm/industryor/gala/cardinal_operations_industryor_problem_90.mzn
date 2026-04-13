% Production planning for products A and B
% Maximize weekly profit subject to machine time and mix constraints.

include "globals.mzn";

% --- Data (embedded) ---
int: profitA = 3;
int: profitB = 5;

int: timeA_min = 12;   % minutes per unit A
int: timeB_min = 25;   % minutes per unit B

int: available_hours = 30;
int: available_min = available_hours * 60;  % 1800 minutes

% --- Decision variables ---
% Units produced per week (nonnegative integers)
var 0..(available_min div timeA_min): A;
var 0..(available_min div timeB_min): B;

% --- Constraints ---
% Machine time capacity
constraint timeA_min * A + timeB_min * B <= available_min;

% Mix/technical constraint: for every 5 units of A, at least 2 units of B
% B >= (2/5) * A  <=>  5B >= 2A
constraint 5 * B >= 2 * A;

% --- Objective ---
var int: Profit = profitA * A + profitB * B;
solve maximize Profit;

% --- Output ---
output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Profit = ", show(Profit), "\n",
  "TimeUsed(min) = ", show(timeA_min*A + timeB_min*B), " / ", show(available_min), "\n"
];