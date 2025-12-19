include "globals.mzn";

/* Parameters (provided via .dzn file) */
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

/* Decision Variables: number of batches produced for each part */
% We assume an upper bound on the number of batches production.
array[1..P] of var 0..10000: batches;
 
/* Each part must meet its minimum batch requirement */
constraint forall(p in 1..P) (
    batches[p] >= MinBatches[p]
);

/* For machines 2..M (in-house machines), production time must not exceed availability */
constraint forall(m in 2..M) (
    sum(p in 1..P)( TimeRequired[m, p] * batches[p] ) <= Availability[m]
);

/* For machine 1, the manufacturer outsources the work,
   so there is no availability constraint but the labor is paid with a tariff:
   Standard cost per hour up to OvertimeHour, then OvertimeCost applies. */

/* Total labor hours for machine 1 */
var 0..100000: L;
constraint L = sum(p in 1..P)( TimeRequired[1, p] * batches[p] );

/* Compute standard and overtime labor hours */
var 0..100000: laborStandard;
constraint laborStandard = if L <= OvertimeHour then L else OvertimeHour endif;

var 0..100000: laborOvertime;
constraint laborOvertime = L - laborStandard;

/* Compute labor cost for machine 1 */
var 0..1000000: laborCost;
constraint laborCost = StandardCost * laborStandard + OvertimeCost * laborOvertime;

/* Compute machine operating costs for machines 2..M */
var 0..1000000: machineCost;
constraint machineCost = sum(m in 2..M)(
    MachineCosts[m] * sum(p in 1..P)( TimeRequired[m, p] * batches[p] )
);

/* Total cost */
var 0..10000000: totalCost;
constraint totalCost = laborCost + machineCost;

/* Revenue from selling batches of parts */
var 0..10000000: revenue;
constraint revenue = sum(p in 1..P)( Prices[p] * batches[p] );

/* Profit must surpass the given minimum profit */
var -10000000..10000000: profit;
constraint profit = revenue - totalCost;
constraint profit >= MinProfit;

solve satisfy;

output [
  "Batches per part: ", show(batches), "\n",
  "Revenue: ", show(revenue), "\n",
  "Labor Cost: ", show(laborCost), "\n",
  "Machine Cost: ", show(machineCost), "\n",
  "Total Cost: ", show(totalCost), "\n",
  "Profit: ", show(profit), "\n"
];