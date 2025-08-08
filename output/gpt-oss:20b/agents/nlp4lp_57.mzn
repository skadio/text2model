include "globals.mzn";

% --------------------------------------------------------------------
% Parameters (provided in the .dzn file)
% --------------------------------------------------------------------
int: NumMachines;                 % M
int: NumParts;                    % P

array[1..NumMachines, 1..NumParts] of int: TimeRequired;
array[1..NumMachines]              of int: MachineCosts;   % cost per hour for m>1
array[1..NumMachines]              of int: Availability;  % normal availability (m>1)
array[1..NumParts]                 of int: Prices;        % revenue per batch
array[1..NumParts]                 of int: MinBatches;    % contract minimum
int: StandardCost;                 % labor cost per hour for machine 1
int: OvertimeCost;                 % overtime labor cost per hour
array[1..NumMachines]              of int: OvertimeHour;  % overtime threshold per machine

% --------------------------------------------------------------------
% Decision variables
% --------------------------------------------------------------------
array[1..NumParts] of var int: Batches;          % number of batches to produce

constraint
  forall(p in 1..NumParts) (
    Batches[p] >= MinBatches[p]
  );

array[1..NumMachines] of var int: Hours;        % total hours used on each machine

constraint
  forall(m in 1..NumMachines) (
    Hours[m] = sum(p in 1..NumParts)(TimeRequired[m,p] * Batches[p])
  );

% Availability constraints (machine 1 is outsourced – no availability limit)
constraint
  forall(m in 2..NumMachines) (
    Hours[m] <= Availability[m]
  );

array[1..NumMachines] of var int: Cost;         % operating cost per machine

% Machine 1 – labor cost with overtime
constraint
  Cost[1] = StandardCost * min(Hours[1], OvertimeHour[1]) +
            OvertimeCost * max(Hours[1] - OvertimeHour[1], 0);

% Machines 2..M – fixed cost per hour
constraint
  forall(m in 2..NumMachines) (
    Cost[m] = MachineCosts[m] * Hours[m]
  );

var int: Profit;
constraint
  Profit = sum(p in 1..NumParts)(Prices[p] * Batches[p])
          - sum(m in 1..NumMachines)(Cost[m]);

% --------------------------------------------------------------------
% Solve and output
% --------------------------------------------------------------------
solve maximize Profit;

output [
  "Batches: ", show(Batches), "\n",
  "Hours:   ", show(Hours),   "\n",
  "Cost:    ", show(Cost),    "\n",
  "Profit:  ", show(Profit),  "\n"
];