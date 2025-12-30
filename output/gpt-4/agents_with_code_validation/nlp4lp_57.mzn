% Parameters
int: NumMachines; % Number of machines
int: NumParts; % Number of part types
array[1..NumMachines, 1..NumParts] of int: TimeRequired; % Time required to produce one batch of part p on machine m
array[1..NumMachines] of int: MachineCosts; % Cost of operating machine m for one month
array[1..NumMachines] of int: Availability; % Number of hours machine m is available each month without overtime
array[1..NumParts] of int: Prices; % Price received for selling one batch of part p
array[1..NumParts] of int: MinBatches; % Minimum number of batches of part p to be produced
int: StandardCost; % Standard cost for operating all machines during normal operating hours
int: OvertimeCost; % Extra cost for operating a machine in overtime per hour
array[1..NumMachines] of int: OvertimeHour; % Number of overtime hours available for machine m

% Variables
array[1..NumParts] of var 0..100: Batches; % Number of batches of each part to be produced
array[1..NumMachines] of var 0..sum(Availability) + sum(OvertimeHour): MachineHours; % Number of hours each machine is operated
array[1..NumMachines] of var 0..sum(OvertimeHour): OvertimeHours; % Number of overtime hours each machine is operated

% Constraints

% The number of batches produced for each part should be at least the minimum required
constraint forall(p in 1..NumParts) (
    Batches[p] >= MinBatches[p]
);

% The total time required on each machine should not exceed the machine's availability plus overtime
constraint forall(m in 1..NumMachines) (
    MachineHours[m] <= Availability[m] + OvertimeHours[m]
);

% The total time required on each machine should be equal to the sum of the time required for each part
constraint forall(m in 1..NumMachines) (
    MachineHours[m] = sum(p in 1..NumParts) (TimeRequired[m, p] * Batches[p])
);

% The number of overtime hours on each machine should not exceed the available overtime hours
constraint forall(m in 1..NumMachines) (
    OvertimeHours[m] <= OvertimeHour[m]
);

% Objective
solve maximize sum(p in 1..NumParts) (Prices[p] * Batches[p]) - (StandardCost * MachineHours[1] + OvertimeCost * OvertimeHours[1]) - sum(m in 2..NumMachines) (MachineCosts[m] * MachineHours[m] + OvertimeCost * OvertimeHours[m]);