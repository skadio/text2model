int: n;
array[1..n] of var 1..n: queens;

constraint all_different(queens);
constraint all_different([queens[i] - i | i in 1..n]);
constraint all_different([queens[i] + i | i in 1..n]);

solve satisfy;

output [
    "\n",
    "Queens positions (row -> column):\n",
    concat([show(i) ++ " -> " ++ show(queens[i]) ++ "\n" | i in 1..n])
];