include "globals.mzn";

int: n;
array[0..n-1] of int: demand;

int: full_time_pay;
int: part_time_pay;

int: full_time_shift;
int: part_time_shift;

set of int: Days = 0..n-1;

array[Days] of var 0..max(demand): start_full;
array[Days] of var 0..max(demand): start_part;

array[Days] of var 0..sum(demand): cover_full;
array[Days] of var 0..sum(demand): cover_part;

function var int: in_shift(array[Days] of var int: start, int: shift_len, int: day) =
    sum(i in Days where ((day - i + n) mod n) < shift_len) ( start[i] );

constraint
    forall(d in Days) (
        cover_full[d] = in_shift(start_full, full_time_shift, d) /\
        cover_part[d] = in_shift(start_part, part_time_shift, d) /\
        cover_full[d] + cover_part[d] >= demand[d]
    );

var int: total_cost =
    sum(d in Days) ( full_time_pay * cover_full[d] + part_time_pay * cover_part[d] );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "start_full=", show(start_full), "\n",
  "start_part=", show(start_part), "\n",
  "cover_full=", show(cover_full), "\n",
  "cover_part=", show(cover_part), "\n"
];