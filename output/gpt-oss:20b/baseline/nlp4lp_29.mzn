int: K;
array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;
array[1..K] of int: Stock;
array[1..K] of int: Capacity;
array[1..K] of int: Demand;
array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

array[1..K, 1..K] of var int: production;
array[0..K, 1..K] of var float: stock;
array[0..K, 1..K] of var float: capacity;

constraint
  forall(i in 1..K) (
    stock[0,i] = Stock[i] /\
    capacity[0,i] = Capacity[i]
  );

constraint
  forall(t in 1..K, i in 1..K) (
    production[t,i] >= 0 /\
    production[t,i] <= capacity[t,i]
  );

constraint
  forall(t in 1..K, j in 1..K) (
    sum(i in 1..K) (InputOne[t,i,j] + InputTwo[t,i,j]) * production[t,i] <= stock[t-1,j]
  );

constraint
  forall(t in 1..K, j in 1..K) (
    stock[t,j] = stock[t-1,j]
                 - sum(i in 1..K) (InputOne[t,i,j] + InputTwo[t,i,j]) * production[t,i]
                 + production[t,j]
                 - Demand[t] /\
    stock[t,j] >= 0
  );

constraint
  forall(t in 1..K, i in 1..K) (
    capacity[t,i] = capacity[t-1,i]
                    + (if t >= 3 then
                        sum(j in 1..K) (InputOne[t-2,i,j] + InputTwo[t-2,i,j]) * production[t-2,j]
                       else 0)
  );

solve maximize
  sum(t in 1..K, i in 1..K) production[t,i] * (ManpowerOne[t] + ManpowerTwo[t]);

output [
  "Total Manpower: ", show(sum(t in 1..K, i in 1..K) production[t,i] * (ManpowerOne[t] + ManpowerTwo[t])), "\n",
  "Production matrix:\n",
  concat([ show(t) ++ ": " ++ show([production[t,i] | i in 1..K]) ++ "\n" | t in 1..K ])
];