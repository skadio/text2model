include "globals.mzn";

int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

% Upper bound to keep domains finite (assumes nonnegative demands).
int: MaxTotalDemand = sum(i in 1..T)(Deliver[i]);

array[1..T] of var 0..MaxTotalDemand: x;    % production in month i
array[0..T] of var 0..MaxTotalDemand: inv;  % inventory at end of month i (inv[0]=0)

constraint inv[0] = 0;

% Inventory balance: inv[i] = inv[i-1] + x[i] - Deliver[i]
constraint
  forall(i in 1..T) (
    inv[i] = inv[i-1] + x[i] - Deliver[i]
  );

% Must meet demand on time (no backlogging): ensured by inv[i] >= 0 domains.

% Objective components
var int: holding_cost = StorageCost * sum(i in 1..T-1)(inv[i]); % no cost for end-of-year inventory
var int: switch_cost = SwitchCost * sum(i in 1..T-1)(abs(x[i+1] - x[i]));

solve minimize holding_cost + switch_cost;

output [
  "x = ", show(x), "\n",
  "inv = ", show(inv), "\n",
  "holding_cost = ", show(holding_cost), "\n",
  "switch_cost = ", show(switch_cost), "\n",
  "total_cost = ", show(holding_cost + switch_cost), "\n"
];