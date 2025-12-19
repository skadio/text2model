% Parameters
int: M; % Number of machines
int: P; % Number of parts to be produced
array[1..M, 1..P] of int: TimeRequired; % Time required to produce each part 'p' on machine 'm'
array[1..M] of int: MachineCosts; % Cost associated with each machine 'm'
array[1..M] of int: Availability; % Availability in hours of each machine 'm' per month
array[1..P] of int: Prices; % Price obtained from selling each part 'p'
array[1..P] of int: MinBatches; % Minimum number of batches of part 'p' that must be produced
int: StandardCost; % Standard cost for a machine to run for one hour
int: OvertimeCost; % Overtime cost for a machine to run for one hour beyond the standard availability
int: OvertimeHour; % Numbers of overtime hours available for a machine to run beyond standard availability
int: MinProfit; % The minimum profit the manufacturer wants to achieve

% Variables
array[1..P] of var 0..100: Batches; % Number of batches of each part 'p' to be produced
var 0..OvertimeHour: OvertimeUsed; % Overtime hours used by the first machine

% Constraints

% The total time required to produce all parts on each machine should not exceed the machine's availability
constraint forall(m in 2..M) (
    sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

% The total time required to produce all parts on the first machine should not exceed the machine's availability plus overtime
constraint sum(p in 1..P) (TimeRequired[1,p] * Batches[p]) <= Availability[1] + OvertimeUsed;

% The number of batches of each part produced should be greater than or equal to the minimum number of batches required
constraint forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
);

% The total cost of producing all parts should not exceed the revenue from selling the parts minus the minimum profit
constraint 
    sum(p in 1..P) (Prices[p] * Batches[p]) - MinProfit >= 
    sum(m in 2..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p])) + 
    (StandardCost * sum(p in 1..P) (TimeRequired[1,p] * Batches[p])) + 
    (OvertimeCost * OvertimeUsed);

% The overtime used should not exceed the available overtime hours
constraint OvertimeUsed <= OvertimeHour;

% Objective
solve maximize sum(p in 1..P) (Prices[p] * Batches[p]) - 
    sum(m in 2..M) (MachineCosts[m] * sum(p in 1..P) (TimeRequired[m,p] * Batches[p])) - 
    (StandardCost * sum(p in 1..P) (TimeRequired[1,p] * Batches[p])) - 
    (OvertimeCost * OvertimeUsed);