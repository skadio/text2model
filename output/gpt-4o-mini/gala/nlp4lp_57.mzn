include "globals.mzn";

int: NumMachines;                          % Number of machines
int: NumParts;                             % Number of part types
array[1..NumMachines, 1..NumParts] of int: TimeRequired;  % Time required to produce one batch of part p on machine m
array[1..NumMachines] of int: MachineCosts;  % Cost of operating machine m for one month
array[1..NumMachines] of int: Availability;   % Number of hours machine m is available each month without overtime
array[1..NumParts] of int: Prices;           % Price received for selling one batch of part p
array[1..NumParts] of int: MinBatches;       % Minimum number of batches of part p to be produced
int: StandardCost;                          % Standard cost for operating all machines during normal operating hours
int: OvertimeCost;                          % Extra cost for operating a machine in overtime per hour
array[1..NumMachines] of int: OvertimeHour;  % Number of overtime hours available for machine m

/* Decision Variables */
array[1..NumParts] of var 0..max_batches: batches;  % Number of batches to produce for each part
var 0..sum(MinBatches): k;  % Auxiliary variable for counting minimum batches

/* Constraints */
constraint count(batches, MinBatches, k);  % Ensure minimum batches are produced

/* Profit Calculation */
var int: totalProfit = sum(p in 1..NumParts)(Prices[p] * batches[p]) - 
                      sum(m in 1..NumMachines)(MachineCosts[m] + 
                      (sum(p in 1..NumParts)(TimeRequired[m, p] * batches[p]) > Availability[m] ? 
                      (sum(p in 1..NumParts)(TimeRequired[m, p] * batches[p]) - Availability[m]) * OvertimeCost : 0));

/* Solve */
solve maximize totalProfit;

/* Output */
output [ "Batches = ", show(batches), "\nTotal Profit = ", show(totalProfit), "\n" ];