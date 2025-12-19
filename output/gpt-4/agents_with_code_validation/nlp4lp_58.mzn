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

% Constraints

% The total time required to produce all batches of each part on each machine should not exceed the machine's availability
constraint forall(m in 1..M)(
  sum(p in 1..P)(TimeRequired[m,p]*Batches[p]) <= Availability[m]
);

% The number of batches of each part produced should be at least the minimum number of batches required
constraint forall(p in 1..P)(
  Batches[p] >= MinBatches[p]
);

% The total cost of operating all machines should not exceed the revenue from selling all parts
% The cost of operating the first machine includes the standard cost and the overtime cost
% The cost of operating the other machines is the machine cost times the time required to produce all batches of each part
% The revenue from selling all parts is the price of each part times the number of batches produced
constraint 
  StandardCost*min(sum(p in 1..P)(TimeRequired[1,p]*Batches[p]), Availability[1]) +
  OvertimeCost*max(0, sum(p in 1..P)(TimeRequired[1,p]*Batches[p]) - Availability[1]) +
  sum(m in 2..M)(MachineCosts[m]*sum(p in 1..P)(TimeRequired[m,p]*Batches[p])) <=
  sum(p in 1..P)(Prices[p]*Batches[p]);

% The profit from selling all parts should be at least the minimum profit
% The profit is the revenue from selling all parts minus the total cost of operating all machines
constraint 
  sum(p in 1..P)(Prices[p]*Batches[p]) -
  (
    StandardCost*min(sum(p in 1..P)(TimeRequired[1,p]*Batches[p]), Availability[1]) +
    OvertimeCost*max(0, sum(p in 1..P)(TimeRequired[1,p]*Batches[p]) - Availability[1]) +
    sum(m in 2..M)(MachineCosts[m]*sum(p in 1..P)(TimeRequired[m,p]*Batches[p]))
  ) >= MinProfit;

% Objective
solve maximize sum(p in 1..P)(Prices[p]*Batches[p]) -
  (
    StandardCost*min(sum(p in 1..P)(TimeRequired[1,p]*Batches[p]), Availability[1]) +
    OvertimeCost*max(0, sum(p in 1..P)(TimeRequired[1,p]*Batches[p]) - Availability[1]) +
    sum(m in 2..M)(MachineCosts[m]*sum(p in 1..P)(TimeRequired[m,p]*Batches[p]))
  );