include "globals.mzn";

%--- data -------------------------------------------------------------
int: M;
int: P;
array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;
int: StandardCost;
int: OvertimeCost;
int: OvertimeHour;
int: MinProfit;

%--- decision variables -----------------------------------------------
array[1..P] of var int: batches;          % number of batches for each part
array[1..M] of var int: time_m;           % total hours on each machine

%--- constraints ------------------------------------------------------
% minimum production requirements
constraint forall(p in 1..P) (
   batches[p] >= MinBatches[p]
);

% calculate machine usage times
constraint forall(m in 1..M) (
   time_m[m] = sum(p in 1..P) ( TimeRequired[m,p] * batches[p] )
);

% availability constraints for machines 2..M (machine 1 is outsourced)
constraint forall(m in 2..M) (
   time_m[m] <= Availability[m]
);

% cost calculation
var int: total_cost;
constraint total_cost =
   ( if time_m[1] <= OvertimeHour
     then time_m[1] * StandardCost
     else OvertimeHour * StandardCost
          + (time_m[1] - OvertimeHour) * OvertimeCost
   endif)
   + sum(m in 2..M) ( time_m[m] * MachineCosts[m] );

% revenue calculation
var int: revenue;
constraint revenue = sum(p in 1..P) ( Prices[p] * batches[p] );

% profit and minimum profit requirement
var int: profit;
constraint profit = revenue - total_cost;
constraint profit >= MinProfit;

%--- solve ------------------------------------------------------------
solve satisfy;

%--- output -----------------------------------------------------------
output [
   "Batches: ", show(batches), "\n",
   "Revenue: ", show(revenue), "\n",
   "Total Cost: ", show(total_cost), "\n",
   "Profit: ", show(profit), "\n"
];