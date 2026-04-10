% Grain trading planning for 3 months
% Maximize final cash (profit since initial cash is constant), with inventory target at end.

int: T = 3;
set of int: M = 1..T;

int: capacity = 5000;
int: I0 = 1000;          % initial inventory (dan)
int: cash0 = 20000;      % initial funds (yuan)
int: I_target = 2000;    % required inventory at end of month 3 (dan)

% Prices (yuan/dan). Use integer cents to avoid floating point.
array[M] of int: buyP  = [285, 305, 290];   % purchase prices
array[M] of int: sellP = [310, 325, 295];   % selling prices

% Decision variables:
% Buy[m]: amount purchased in month m (arrives same month, paid immediately)
% Sell[m]: amount sold in month m (must come from previous month's inventory, i.e., cannot sell what is bought in same month)
array[M] of var 0..capacity: Buy;
array[M] of var 0..capacity: Sell;

% Inventory at end of each month
array[M] of var 0..capacity: Inv;

% Cash at end of each month (in cents)
array[M] of var 0..intmax: Cash;

constraint
  % Month 1 dynamics
  Inv[1] = I0 + Buy[1] - Sell[1] /\
  Cash[1] = cash0*100 - buyP[1]*Buy[1] + sellP[1]*Sell[1] /\
  % Cannot sell in month 1 more than initial inventory (no earlier inventory)
  Sell[1] <= I0 /\
  % Capacity
  Inv[1] <= capacity /\
  % Cash cannot go negative at purchase time (month 1)
  buyP[1]*Buy[1] <= cash0*100
;

constraint
  % Months 2..3 dynamics and constraints
  forall(m in 2..T) (
    Inv[m] = Inv[m-1] + Buy[m] - Sell[m] /\
    Cash[m] = Cash[m-1] - buyP[m]*Buy[m] + sellP[m]*Sell[m] /\
    % Can only sell what was in inventory at start of month (i.e., previous end)
    Sell[m] <= Inv[m-1] /\
    % Capacity
    Inv[m] <= capacity /\
    % Cash cannot go negative at purchase time
    buyP[m]*Buy[m] <= Cash[m-1]
  )
;

% End-of-quarter inventory requirement
constraint Inv[T] = I_target;

% Objective: maximize final cash (equivalently total profit)
var int: finalCash = Cash[T];
solve maximize finalCash;

output [
  "Buy (dan):  ", show(Buy), "\n",
  "Sell (dan): ", show(Sell), "\n",
  "Inv (dan):  ", show(Inv), "\n",
  "Cash end (yuan): ", show(finalCash div 100), ".", show((finalCash mod 100) div 10), show(finalCash mod 10), "\n",
  "Profit (yuan): ", show((finalCash - cash0*100) div 100), ".", show(((finalCash - cash0*100) mod 100) div 10), show((finalCash - cash0*100) mod 10), "\n"
];