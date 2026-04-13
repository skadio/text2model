int: total_acres = 120;

int: profit_apples = 2000;
int: profit_pears  = 1800;
int: profit_oranges= 2200;
int: profit_lemons = 3000;

var 0..total_acres: A; % apples acres
var 0..total_acres: P; % pears acres
var 0..total_acres: O; % oranges acres
var 0..total_acres: L; % lemons acres

var bool: useA = (A > 0);
var bool: useP = (P > 0);
var bool: useO = (O > 0);
var bool: useL = (L > 0);

constraint A + P + O + L <= total_acres;

constraint A >= 2 * P;
constraint A >= 3 * L;
constraint O = 2 * L;

% No more than two fruit types grown
constraint bool2int(useA) + bool2int(useP) + bool2int(useO) + bool2int(useL) <= 2;

var int: total_profit = profit_apples*A + profit_pears*P + profit_oranges*O + profit_lemons*L;

solve maximize total_profit;

output [
  "Apples acres = ", show(A), "\n",
  "Pears acres  = ", show(P), "\n",
  "Oranges acres= ", show(O), "\n",
  "Lemons acres = ", show(L), "\n",
  "Total profit = $", show(total_profit), "\n"
];