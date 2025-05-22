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
var 0..OvertimeHour: Overtime; % Overtime hours used

% Constraints
constraint forall(p in 1..P)(Batches[p] >= MinBatches[p]); % Minimum number of batches constraint
constraint forall(m in 2..M)(sum(p in 1..P)(TimeRequired[m,p]*Batches[p]) <= Availability[m]); % Machine availability constraint
constraint sum(p in 1..P)(TimeRequired[1,p]*Batches[p]) <= Availability[1] + Overtime; % Machine 1 availability constraint with overtime
constraint Overtime * OvertimeCost + sum(m in 1..M)(MachineCosts[m] * sum(p in 1..P)(TimeRequired[m,p]*Batches[p])) <= sum(p in 1..P)(Prices[p]*Batches[p]) - MinProfit; % Profit constraint

% Objective
solve maximize sum(p in 1..P)(Prices[p]*Batches[p]); % Maximize total revenue