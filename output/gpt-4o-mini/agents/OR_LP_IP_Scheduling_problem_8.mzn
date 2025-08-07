int: n;  % Number of days in the recurring period
array[0..n-1] of int: demand;  % Required employees per day
int: full_time_pay;  % Pay per day of full time employee
int: part_time_pay;  % Pay per day of part time employee
int: full_time_shift;  % Number of consecutive days a full time employee works for
int: part_time_shift;  % Number of consecutive days a part time employee works for

% Variables
array[0..n-1] of var 0..n: full_time_workers;  % Number of full time workers assigned each day
array[0..n-1] of var 0..n: part_time_workers;  % Number of part time workers assigned each day

% Objective: Minimize total staffing cost
var int: total_cost = sum(i in 0..n-1)(full_time_workers[i] * full_time_pay + part_time_workers[i] * part_time_pay);
solve minimize total_cost;

% Constraints
% Ensure that the total number of workers meets the daily demand
constraint forall(i in 0..n-1)(full_time_workers[i] + part_time_workers[i] >= demand[i]);

% Full time workers work for 'full_time_shift' days and then have a break
constraint forall(i in 0..n-1)(
    (i + full_time_shift <= n - 1) -> 
    (sum(j in i..i + full_time_shift - 1)(full_time_workers[j]) >= 1)
);

% Part time workers work for 'part_time_shift' days and then have a break
constraint forall(i in 0..n-1)(
    (i + part_time_shift <= n - 1) -> 
    (sum(j in i..i + part_time_shift - 1)(part_time_workers[j]) >= 1)
);

% Output
output [
    "Total Cost = ", show(total_cost), "\n",
    "Full Time Workers = ", show(full_time_workers), "\n",
    "Part Time Workers = ", show(part_time_workers), "\n"
];