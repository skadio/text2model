int: n;
array[0..n-1] of int: demand;
int: full_time_pay;
int: part_time_pay;
int: full_time_shift;
int: part_time_shift;

array[0..n-full_time_shift] of var bool: start_full;
array[0..n-part_time_shift] of var bool: start_part;

var int: total_cost = sum(start_full) * full_time_pay * full_time_shift
                     + sum(start_part) * part_time_pay * part_time_shift;

constraint
  forall(d in 0..n-1) (
    sum(i in 0..n-full_time_shift) (
      start_full[i] * (if d >= i /\ d < i + full_time_shift then 1 else 0)
    ) + sum(i in 0..n-part_time_shift) (
      start_part[i] * (if d >= i /\ d < i + part_time_shift then 1 else 0)
    ) >= demand[d]
  );

solve minimize total_cost;

output [
  "Total cost: ", show(total_cost), "\n",
  "Full time starts: ", show(start_full), "\n",
  "Part time starts: ", show(start_part), "\n"
];