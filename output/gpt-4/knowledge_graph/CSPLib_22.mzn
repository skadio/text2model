% Input Data Nomenclature
int: num_work; % Number of pieces of work to cover
int: num_shifts; % Number of possible shifts available
int: min_num_shifts; % Minimum number of shifts required for a partition
array[1..num_shifts, 1..num_work] of 0..1: shifts; % Details of shifts each shift covers

% Variables
array[1..num_shifts] of var 0..1: x; % Binary variable indicating whether a shift is selected or not

% Constraints
constraint forall(i in 1..num_work)(
  sum(j in 1..num_shifts)(shifts[j,i]*x[j]) = 1
); % Each piece of work is covered exactly once

constraint sum(i in 1..num_shifts)(x[i]) >= min_num_shifts; % At least minimum number of shifts are selected

% Objective
var int: total_shifts = sum(i in 1..num_shifts)(x[i]);
solve minimize total_shifts;

% Output
output [ "Total shifts: ", show(total_shifts), "\n",
         "Shifts: ", show(x), "\n" ];