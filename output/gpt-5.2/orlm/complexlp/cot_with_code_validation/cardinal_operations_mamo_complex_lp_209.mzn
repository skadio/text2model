% Star Oil investment LP (continuous fractions)
% Use MIP on scaled integers to avoid Float::linear limits in Gecode.

int: N = 5;
set of int: INV = 1..N;

array[INV] of int: out0 = [11, 53, 5, 5, 29];
array[INV] of int: out1 = [3, 6, 5, 1, 34];
array[INV] of int: npv  = [13, 16, 16, 14, 39];

int: budget0 = 40;
int: budget1 = 20;

% Scale fractions x[i] in [0,1] by 1000 (i.e., 0.001 precision)
int: SCALE = 1000;
array[INV] of var 0..SCALE: xs;  % xs[i] = round(x[i]*SCALE)

% Objective (scaled by SCALE)
var int: total_npv_scaled = sum(i in INV)(npv[i] * xs[i]);

% Budget constraints (also scaled by SCALE)
constraint sum(i in INV)(out0[i] * xs[i]) <= budget0 * SCALE;
constraint sum(i in INV)(out1[i] * xs[i]) <= budget1 * SCALE;

solve maximize total_npv_scaled;

output [
  "max_npv_million = ", show(total_npv_scaled), "/", show(SCALE), "\n",
  "x = [", concat([ if i>1 then ", " else "" endif ++ show(xs[i]) ++ "/" ++ show(SCALE) | i in INV ]), "]\n"
];