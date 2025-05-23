include "globals.mzn";

% Input parameters
int: n;
array[0..n-1] of int: demand;
int: full_time_pay;
int: part_time_pay;
int: full_time_shift;
int: part_time_shift;

% Decision variables
array[0..n-1] of var 0..n: full_time;
array[0..n-1] of var 0..n: part_time;

% Objective function
var int: total_cost = sum(i in 0..n-1) (full_time[i]*full_time_pay + part_time[i]*part_time_pay);
minimize total_cost;

% Constraints
constraint forall(i in 0..n-1) (full_time[i] + part_time[i] >= demand[i]);

% Full time workers work for full_time_shift consecutive days and then have full_time_shift days off
constraint forall(i in 0..n-1) (
  if i < full_time_shift then
    sum(j in 0..i) (full_time[j]) = sum(j in i+1..i+full_time_shift) (full_time[j])
  else if i < n - full_time_shift then
    sum(j in i-full_time_shift+1..i) (full_time[j]) = sum(j in i+1..i+full_time_shift) (full_time[j])
  else
    sum(j in i-full_time_shift+1..i) (full_time[j]) = sum(j in 0..full_time_shift-(n-i)) (full_time[j])
  endif
);

% Part time workers work for part_time_shift consecutive days and then have part_time_shift days off
constraint forall(i in 0..n-1) (
  if i < part_time_shift then
    sum(j in 0..i) (part_time[j]) = sum(j in i+1..i+part_time_shift) (part_time[j])
  else if i < n - part_time_shift then
    sum(j in i-part_time_shift+1..i) (part_time[j]) = sum(j in i+1..i+part_time_shift) (part_time[j])
  else
    sum(j in i-part_time_shift+1..i) (part_time[j]) = sum(j in 0..part_time_shift-(n-i)) (part_time[j])
  endif
);

solve satisfy;