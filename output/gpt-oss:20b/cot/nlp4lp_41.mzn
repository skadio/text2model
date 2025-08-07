% Parameters
int: N;
array[1..N] of float: Demand;
float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

% Variables
array[1..N] of var float: 0..MaxRegularAmount: regular_units;
array[1..N] of var float: 0..max(Demand): overtime_units;

% Constraints
constraint
  forall(n in 1..N) (
    regular_units[n] + overtime_units[n] >= Demand[n]
  );

% Objective
solve minimize
  sum(n in 1..N) (regular_units[n] * CostRegular + overtime_units[n] * CostOvertime);