% Plant nutrition blending problem (all data embedded)

% Decision variables: kilograms of fertilizers A and B
var 0.0..1000.0: xA;
var 0.0..1000.0: xB;

% Nutrient contents per kg
float: N_A = 13.0;  float: P_A = 5.0;   float: VA_A = 6.0;  float: VD_A = 5.0;
float: N_B = 8.0;   float: P_B = 14.0;  float: VA_B = 6.0;  float: VD_B = 9.0;

% Requirements
float: minN  = 220.0;
float: minP  = 160.0;
float: maxVA = 350.0;

% Totals
var float: totalN  = N_A * xA + N_B * xB;
var float: totalP  = P_A * xA + P_B * xB;
var float: totalVA = VA_A * xA + VA_B * xB;
var float: totalVD = VD_A * xA + VD_B * xB;

% Constraints
constraint totalN >= minN;
constraint totalP >= minP;
constraint totalVA <= maxVA;

% Objective: minimize vitamin D
solve minimize totalVD;

output [
  "kg_A = ", show(xA), "\n",
  "kg_B = ", show(xB), "\n",
  "min_vitamin_D = ", show(totalVD), "\n",
  "total_N = ", show(totalN), "\n",
  "total_P = ", show(totalP), "\n",
  "total_vitamin_A = ", show(totalVA), "\n"
];