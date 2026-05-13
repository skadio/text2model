int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

int: N = r * c;

array[1..r, 1..c] of var 1..N: val;

constraint
    forall(i in 1..r, j in 1..c) (
        puzzle[i,j] > 0 -> val[i,j] = puzzle[i,j]
    );

constraint
    all_different([val[i,j] | i in 1..r, j in 1..c]);

constraint
    forall(i in 1..r, j in 1..c) (
        val[i,j] < N ->
        exists(i2 in 1..r, j2 in 1..c) (
            (abs(i2-i) <= 1 /\ abs(j2-j) <= 1 /\ (i2 != i \/ j2 != j)) /\
            (val[i2,j2] = val[i,j] + 1)
        )
    );

solve satisfy;

output [ show(val) ];