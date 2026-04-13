% Bright Future Toys - Product mix optimization (all data embedded)

set of int: T = 1..4;
int: ROBOT = 1;
int: CAR   = 2;
int: BLOCK = 3;
int: DOLL  = 4;

array[T] of int: profit = [15, 8, 12, 5];

int: plastic_avail = 1200;
array[T] of int: plastic_use = [30, 10, 20, 15];

int: elec_avail = 800;
array[T] of int: elec_use = [8, 5, 3, 2];

% Decision: how many of each toy to manufacture
array[T] of var 0..1000000: x;

% Optional: whether each toy type is manufactured (to model logical constraints)
array[T] of var bool: make;

constraint forall(t in T)( make[t] <-> (x[t] > 0) );

% Resource constraints
constraint sum(t in T)(plastic_use[t] * x[t]) <= plastic_avail;
constraint sum(t in T)(elec_use[t] * x[t]) <= elec_avail;

% If manufacture robots, then not manufacture dolls
constraint make[ROBOT] -> not make[DOLL];

% If manufacture model cars, then also manufacture building blocks
constraint make[CAR] -> make[BLOCK];

% Dolls cannot exceed model cars
constraint x[DOLL] <= x[CAR];

var int: total_profit = sum(t in T)(profit[t] * x[t]);
solve maximize total_profit;

output [
  "Robots: ", show(x[ROBOT]), "\n",
  "Model cars: ", show(x[CAR]), "\n",
  "Building blocks: ", show(x[BLOCK]), "\n",
  "Dolls: ", show(x[DOLL]), "\n",
  "Total profit: $", show(total_profit), "\n",
  "Types manufactured: ",
    show(sum(t in T)(bool2int(make[t]))), "\n"
];