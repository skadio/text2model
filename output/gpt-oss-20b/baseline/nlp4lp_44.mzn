int: N;
float: Capacity;
array[1..N] of float: Size;

var 1..N: bin_of_file[1..N];
var bool: bin_used[1..N];

constraint
  forall(b in 1..N) (
    sum(i in 1..N) (Size[i] * (bin_of_file[i] == b)) <= Capacity
  );

constraint
  forall(b in 2..N) (
    bin_used[b] -> bin_used[b-1]
  );

constraint
  forall(b in 1..N) (
    bin_used[b] = sum(i in 1..N) (bin_of_file[i] == b) > 0
  );

solve minimize sum(b in 1..N) (bin_used[b]);

output [
  "Number of bins used: ", show(sum(b in 1..N) (bin_used[b])), "\n",
  "Assignments: ", show(bin_of_file), "\n"
];