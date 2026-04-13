% Star Oil investment LP (continuous fractions)
% Use MILP backend by scaling to integers to avoid float-search timeouts.

int: nInv = 5;
set of int: INV = 1..nInv;

array[INV] of int: out0 = [11, 53, 5, 5, 29];
array[INV] of int: out1 = [3, 6, 5, 1, 34];
array[INV] of int: npv  = [13, 16, 16, 14, 39];

int: budget0 = 40;
int: budget1 = 20;

% Scale fractions to integers: y[i] = x[i] * scale
int: scale = 1000;
array[INV] of var 0..scale: y;

var int: total_npv_scaled;

constraint sum(i in INV)(out0[i] * y[i]) <= budget0 * scale;
constraint sum(i in INV)(out1[i] * y[i]) <= budget1 * scale;

constraint total_npv_scaled = sum(i in INV)(npv[i] * y[i]);

solve maximize total_npv_scaled;

output [
  "Max NPV (million dollars) = ",
  show(total_npv_scaled / scale), "\n",
  "Fractions x = [",
  concat([ if i > 1 then ", " else "" endif ++ show(y[i] / scale) | i in INV ]),
  "]\n"
];