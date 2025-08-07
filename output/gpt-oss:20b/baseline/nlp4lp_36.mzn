int: C;
array[1..*] of int: Value;
array[1..*] of int: Size;
int: K = length(Value);
array[1..K] of var 0..1: x;

constraint sum(i in 1..K)(Size[i] * x[i]) <= C;

solve maximize sum(i in 1..K)(Value[i] * x[i]);

output [
    "Selected items: " ++ show([i | i in 1..K where x[i] = 1]) ++ "\n",
    "Total value: " ++ show(sum(i in 1..K)(Value[i] * x[i])) ++ "\n",
    "Total size: " ++ show(sum(i in 1..K)(Size[i] * x[i])) ++ "\n"
];