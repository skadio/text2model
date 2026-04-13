% Maple Oil blending/processing (LP)
% Use float variables but avoid Gecode float-linear overflow by bounding variables.

% Revenues per tank
int: revenue_light = 550;
int: revenue_nonsticky = 750;
int: revenue_heavy = 950;

% Compound requirements per tank
int: A_per_light = 3;  int: B_per_light = 3;
int: A_per_nonsticky = 6;  int: B_per_nonsticky = 2;
int: A_per_heavy = 9;  int: B_per_heavy = 3;

% Available compound amounts
int: A_available = 250;
int: B_available = 150;

% Safe upper bounds from resource limits (prevents solver float overflow)
float: ub_light =
  min(int2float(A_available) / int2float(A_per_light),
      int2float(B_available) / int2float(B_per_light));
float: ub_nonsticky =
  min(int2float(A_available) / int2float(A_per_nonsticky),
      int2float(B_available) / int2float(B_per_nonsticky));
float: ub_heavy =
  min(int2float(A_available) / int2float(A_per_heavy),
      int2float(B_available) / int2float(B_per_heavy));

% Decision variables (full or partial tanks allowed)
var 0.0..ub_light: tanks_light;
var 0.0..ub_nonsticky: tanks_nonsticky;
var 0.0..ub_heavy: tanks_heavy;

% Objective value
var float: total_revenue;

% Resource constraints
constraint
  int2float(A_per_light) * tanks_light +
  int2float(A_per_nonsticky) * tanks_nonsticky +
  int2float(A_per_heavy) * tanks_heavy
  <= int2float(A_available);

constraint
  int2float(B_per_light) * tanks_light +
  int2float(B_per_nonsticky) * tanks_nonsticky +
  int2float(B_per_heavy) * tanks_heavy
  <= int2float(B_available);

% Revenue definition
constraint
  total_revenue =
    int2float(revenue_light) * tanks_light +
    int2float(revenue_nonsticky) * tanks_nonsticky +
    int2float(revenue_heavy) * tanks_heavy;

solve maximize total_revenue;

output [
  "tanks_light = ", show(tanks_light), "\n",
  "tanks_nonsticky = ", show(tanks_nonsticky), "\n",
  "tanks_heavy = ", show(tanks_heavy), "\n",
  "total_revenue = ", show(total_revenue), "\n"
];