include "globals.mzn";

int: M;  % Number of types of smaller rolls
int: N;  % Number of different cutting patterns
int: large_roll_width;  % Large Roll Width
array[1..M] of int: demands;  % Demands for each type of roll
array[1..M] of int: roll_width_options;  % Width options for each type of roll
array[1..M, 1..N] of int: patterns;  % Cutting patterns

/* Variables */
array[1..N] of var 1..M: roll_types;  % Each cutting pattern results in rolls of different types
array[1..M] of var 0..sum(demands): counts;  % Counts of each type of roll produced

/* Constraints */
constraint global_cardinality(roll_types, 1..M, counts);

/* Calculate total width produced by each cutting pattern */
array[1..N] of var 0..large_roll_width: total_width;
constraint forall(j in 1..N)(
    total_width[j] = sum(i in 1..M)(patterns[i, j] * roll_width_options[i])
);

/* Ensure that the total width produced meets the demands */
array[1..M] of var 0..sum(demands): total_produced;
constraint forall(i in 1..M)(
    total_produced[i] = sum(j in 1..N)(patterns[i, j] * counts[j])
);

/* Ensure that the total produced meets the demands */
constraint forall(i in 1..M)(
    total_produced[i] >= demands[i]
);

/* Objective: Minimize the number of large rolls used */
var 0..sum(demands): total_large_rolls;
constraint total_large_rolls = sum(j in 1..N)(if counts[j] > 0 then 1 else 0 endif);

/* Solve & output */
solve minimize total_large_rolls;
output [ "Total Large Rolls Used = ", show(total_large_rolls), "\nCounts = ", show(counts), "\nRoll Types = ", show(roll_types), "\n" ];