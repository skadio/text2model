```mzn
include "globals.mzn";

/* ---------- Data Declaration (input via .dzn file) ---------- */
int: NumMachines;
int: NumParts;

array[1..NumMachines, 1..NumParts] of int: TimeRequired;
array[1..NumMachines] of int: MachineCosts;       % Operating cost per hour for machines 2..NumMachines (machine 1 is outsourced/labor)
array[1..NumMachines] of int: Availability;         % Normal operating hours available (for m >=2; for machine 1 this is only the threshold for standard cost)
array[1..NumMachines] of int: OvertimeHour;         % Maximum overtime hours available on each machine

array[1..NumParts] of int: Prices;                  % Price received per batch of part p
array[1..NumParts] of int: MinBatches;              % Minimum required batches for part p

int: StandardCost;     % Labor cost per hour during standard (normal) time on machine 1
int: OvertimeCost;     % Labor cost per hour during overtime on machine 1

/* ---------- Decision Variables ---------- */
/* x[p]: Number of batches to produce for part p */
array[1..NumParts] of var int: x;
constraint forall(p in 1..NumParts)( x[p] >= MinBatches[p] );

/* H[m]: Total hours used on machine m */
array[1..NumMachines] of var int: H;
constraint forall(m in 1..NumMachines)(
   H[m] = sum(p in 1..NumParts)( TimeRequired[m, p] * x[p] )
);

/* ---------- Capacity Constraints ---------- */
/* For machine 1, the normal availability is disregarded;
   however, overtime is limited. Thus, H[1] cannot exceed (Availability[1] + OvertimeHour[1]).
   For machines 2..NumMachines, production (normal + overtime) is limited similarly.
*/
constraint H[1] <= Availability[1] + OvertimeHour[1];
constraint forall(m in 2..NumMachines)(
  H[m] <= Availability[m] + OvertimeHour[m]
);

/* ---------- Cost Calculation ---------- */
/* For machine 1 (outsourced labor), cost is computed in two parts:
   - Standard time: up to Availability[1] hours are charged at StandardCost.
   - Overtime: any hours beyond Availability[1] (if any) are charged at OvertimeCost.
   Note: Even though machine 1’s capacity isn’t limited by normal availability,
   the Availability[1] parameter is used