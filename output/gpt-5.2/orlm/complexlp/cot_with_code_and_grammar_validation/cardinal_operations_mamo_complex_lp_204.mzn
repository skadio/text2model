int: F = 5;
set of int: Fert = 1..F;

array[Fert] of int: Ni = [10, 8, 12, 10, 15];
array[Fert] of int: Ph = [8, 11, 7, 10, 10];
array[Fert] of int: Po = [12, 15, 12, 10, 6];

array[Fert] of int: price100_cents = [2175, 2350, 2200, 1950, 1850];

int: Ni_min10 = 100; int: Ni_max10 = 105;
int: Ph_min10 = 80;  int: Ph_max10 = 85;
int: Po_min10 = 120; int: Po_max10 = 125;

array[Fert] of var 0..10000: x;
var 0..10000000: cost100_cents;

constraint sum(i in Fert)(x[i]) = 10000;

constraint sum(i in Fert)(x[i] * (Ni[i] * 10)) >= Ni_min10 * 10000;
constraint sum(i in Fert)(x[i] * (Ni[i] * 10)) <= Ni_max10 * 10000;

constraint sum(i in Fert)(x[i] * (Ph[i] * 10)) >= Ph_min10 * 10000;
constraint sum(i in Fert)(x[i] * (Ph[i] * 10)) <= Ph_max10 * 10000;

constraint sum(i in Fert)(x[i] * (Po[i] * 10)) >= Po_min10 * 10000;
constraint sum(i in Fert)(x[i] * (Po[i] * 10)) <= Po_max10 * 10000;

constraint cost100_cents * 10000 = sum(i in Fert)(x[i] * price100_cents[i]);

solve minimize cost100_cents;

output [
  "cost_per_100lb_cents=", show(cost100_cents), "\n",
  "cost_per_lb_cents=", show(cost100_cents div 100), ".", show_int(2, cost100_cents mod 100), "\n",
  "mix_basis_points=", show(x), "\n"
];