int: N;
array[0..N-1] of int: Num;
int: WorkingDays;
int: RestingDays;

int: L = WorkingDays + RestingDays;

array[0..L-1] of var int: x;

constraint forall(s in 0..L-1) x[s] >= 0;

array[0..L-1] of int: required = [
    if exists(d in 0..N-1 where d mod L == r) then
        max([Num[d] | d in 0..N-1 where d mod L == r])
    else
        0
    endif
    | r in 0..L-1
];

constraint forall(r in 0..L-1) (
    sum(s in 0..L-1) x[s] * (if ((r - s + L) mod L) < WorkingDays then 1 else 0) >= required[r]
);

var int: total = sum(x);

solve minimize total;

output [
    "Minimum number of employees: ", show(total), "\n",
    "Shift start counts: ", show(x), "\n"
];