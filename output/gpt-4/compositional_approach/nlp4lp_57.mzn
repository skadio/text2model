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
array[1..NumMachines] of var 0..sum(i in 1..NumParts)(TimeRequired[i]*Batches[i]): MachineHours; % Total hours each machine is used
array[1..NumMachines] of var 0..OvertimeHour[i]: Overtime; % Overtime hours for each machine

% Constraints

% The total hours each machine is used should be equal to the sum of the time required to produce all batches of each part
constraint forall(m in 1..NumMachines)(
  MachineHours[m] = sum(p in 1..NumParts)(TimeRequired[m,p]*Batches[p])
);

% The total hours each machine is used should not exceed the availability of the machine plus the overtime hours
constraint forall(m in 1..NumMachines)(
  MachineHours[m] <= Availability[m] + Overtime[m]
);

% The number of batches of each part produced should be greater than or equal to the minimum number of batches required
constraint forall(p in 1..NumParts)(
  Batches[p] >= MinBatches[p]
);

% The total cost of operating each machine should not exceed the sum of the standard cost and the overtime cost
constraint forall(m in 1..NumMachines)(
  MachineCosts[m]*MachineHours[m] <= StandardCost*Availability[m] + OvertimeCost*Overtime[m]
);

% The overtime hours for each machine should not exceed the available overtime hours
constraint forall(m in 1..NumMachines)(
  Overtime[m] <= OvertimeHour[m]
);

% The total hours used by the first machine should not exceed the sum of the standard hours and the overtime hours
constraint MachineHours[1] <= Availability[1] + Overtime[1];

% Objective
solve maximize sum(p in 1..NumParts)(Prices[p]*Batches[p]) - sum(m in 1..NumMachines)(MachineCosts[m]*MachineHours[m]);