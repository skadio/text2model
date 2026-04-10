include "globals.mzn";

/* Input data */
int: N;                % number of time periods
int: Capacity;         % maximum storage capacity
int: HoldingCost;      % cost per unit for holding stock for one period
array[1..N] of int: Price;  % selling price in each period
array[1..N] of int: Cost;   % buying cost in each period

/* Decision variables */
array[1..N] of var 0..Capacity: buy;   % units to buy in period i
array[1..N] of var 0..Capacity: sell;  % units to sell in period i

/* Inventory levels for each period (including period 0) */
array[0..N] of var 0..Capacity: inventory;

/* Initial and terminal conditions */
constraint inventory[0] = 0;
constraint inventory[N] = 0;

/* Flow balance and capacity constraints for each period */
constraint
  forall(i in 1..N) (
      inventory[i] = inventory[i-1] + buy[i] - sell[i] /\
      inventory[i] <= Capacity /\
      inventory[i] >= 0
  );

/* It is natural that sell in each period cannot exceed available inventory */
constraint forall(i in 1..N) ( sell[i] <= inventory[i-1] + buy[i] );

/* Objective: maximize profit 
   Profit is revenue from sales minus purchasing costs minus holding costs.
   We assume holding costs are incurred on inventory held at the end of each period
   (except the initial and final periods where inventory is fixed at 0).
*/
var int: profit = sum(i in 1..N)( Price[i] * sell[i] - Cost[i] * buy[i] )
                    - sum(i in 1..N-1)( HoldingCost * inventory[i] );

solve maximize profit;

output [
  "Buy: ", show(buy), "\n",
  "Sell: ", show(sell), "\n",
  "Inventory: ", show(inventory), "\n",
  "Profit: ", show(profit), "\n"
];