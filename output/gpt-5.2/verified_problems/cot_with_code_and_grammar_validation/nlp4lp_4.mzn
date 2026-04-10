% Parameters
int: Period;
array[1..7] of int: Demand;

% Variables
int: maxDemand = max(d in 1..7)(Demand[d]);
int: maxNurses = 7 * maxDemand;

array[1..7] of var 0..maxNurses: start;
var 0..maxNurses: total_nurses;

% Constraints
constraint total_nurses = sum(d in 1..7)(start[d]);

constraint
  forall(day in 1..7) (
    sum(offset in 0..Period-1)(
      start[((day - offset - 1 + 7) mod 7) + 1]
    ) >= Demand[day]
  );

% Objective
solve minimize total_nurses;