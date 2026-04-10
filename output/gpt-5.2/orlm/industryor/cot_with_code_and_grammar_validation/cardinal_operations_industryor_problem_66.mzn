int: T = 6;
set of int: M = 1..T;
set of int: P = 1..2;

array[P] of float: vol = [0.2, 0.4];

int: cap_prod = 120000;
float: cap_wh = 15000.0;

float: cost_wh_in  = 1.0;
float: cost_wh_out = 1.5;

array[P, M] of int: demand = array2d(P, M,
[
  30000, 30000, 30000, 100000, 100000, 100000,
  15000, 15000, 15000,  50000,  50000,  50000
]);

array[P, M] of float: prod_cost = array2d(P, M,
[
  4.5, 4.5, 4.5, 4.5, 4.5, 4.5,
  7.0, 7.0, 7.0, 7.0, 7.0, 7.0
]);

array[P] of int: inv0 = [0, 0];

int: inv_ub = 200000;

array[P] of int: vol10 = [2, 4];
int: cap_wh10 = 150000;

array[P, M] of int: prod_cost2 = array2d(P, M,
[
  9, 9, 9, 9, 9, 9,
  14,14,14,14,14,14
]);
int: cost_wh_in2  = 2;
int: cost_wh_out2 = 3;

array[P, M] of var 0..cap_prod: prod;
array[P, M] of var 0..inv_ub: inv;

array[M] of var 0..cap_wh10: wh_in10;
var int: total_cost2;

constraint forall(m in M) (
  sum(p in P)(prod[p,m]) <= cap_prod
);

constraint forall(p in P, m in M) (
  inv[p,m] = (if m = 1 then inv0[p] else inv[p,m-1] endif) + prod[p,m] - demand[p,m]
);

constraint forall(m in M) (
  let {
    var 0..(cap_wh10 + 10*inv_ub): tot10 = sum(p in P)(inv[p,m] * vol10[p])
  } in
    wh_in10[m] <= cap_wh10 /\
    wh_in10[m] <= tot10
);

constraint
  total_cost2 =
    sum(p in P, m in M)(prod_cost2[p,m] * prod[p,m])
    + sum(m in M)(
        let {
          var 0..(cap_wh10 + 10*inv_ub): tot10 = sum(p in P)(inv[p,m] * vol10[p]),
          var 0..(cap_wh10 + 10*inv_ub): out10 = tot10 - wh_in10[m]
        } in
          cost_wh_in2 * wh_in10[m] + cost_wh_out2 * out10
      );

solve minimize total_cost2;

output [
  "Total cost (yuan) = ", show(total_cost2 div 2), if (total_cost2 mod 2 == 0) then ".0" else ".5" endif, "\n",
  "Month: Jul Aug Sep Oct Nov Dec\n",
  "Prod I: ", show([prod[1,m] | m in M]), "\n",
  "Prod II:", show([prod[2,m] | m in M]), "\n",
  "Inv I : ", show([inv[1,m]  | m in M]), "\n",
  "Inv II: ", show([inv[2,m]  | m in M]), "\n",
  "In-house used (m3): ", show([wh_in10[m] div 10 | m in M]), "\n"
];