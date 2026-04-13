% Carelland export/import planning (LP)
% Maximize GDP = value of production - cost of imported goods used
% Data is embedded as requested.

% We model production quantities of:
% 1=Steel, 2=Engines, 3=Electronics, 4=Plastic

% ---------- Data ----------
int: n = 4;
set of int: P = 1..n;

array[P] of string: name = ["steel","engines","electronics","plastic"];

% World market unit prices (Klunz/unit)
array[P] of float: price = [500.0, 1500.0, 300.0, 1200.0];

% Imported goods required per unit (Klunz/unit)
array[P] of float: imp = [250.0, 300.0, 50.0, 300.0];

% Intermediate input coefficients A[i,j] = units of product i needed to produce 1 unit of j
array[P,P] of float: A =
[
  % to produce:    steel   engines  electronics  plastic
  % need steel
  | 0.0,    0.8,     0.01,     0.2
  % need engines
  | 0.02,   0.0,     0.01,     0.03
  % need electronics
  | 0.0,    0.15,    0.0,      0.05
  % need plastic
  | 0.01,   0.11,    0.05,     0.0
];

% Labor coefficients in person-months per unit
% steel: 6 person-months
% engines: 1 person-year = 12 person-months
% electronics: 6 person-months
% plastic: 2 person-years = 24 person-months
array[P] of float: labor = [6.0, 12.0, 6.0, 24.0];

float: labor_avail = 830000.0;      % person-months per year

% Capacity limits
float: cap_engines = 650000.0;
float: cap_plastic = 60000.0;

% ---------- Decision variables ----------
% Production quantities (continuous, nonnegative)
array[P] of var float: x;

% Net exports (>=0): production minus intermediate uses
array[P] of var float: net_export;

% ---------- Constraints ----------
constraint forall(i in P)( x[i] >= 0.0 );

% Material balance: net_export[i] = x[i] - sum_j A[i,j]*x[j], and require nonnegative net exports
constraint forall(i in P)(
  net_export[i] = x[i] - sum(j in P)(A[i,j] * x[j])
);
constraint forall(i in P)( net_export[i] >= 0.0 );

% Labor constraint
constraint sum(i in P)(labor[i] * x[i]) <= labor_avail;

% Capacity constraints
constraint x[2] <= cap_engines;
constraint x[4] <= cap_plastic;

% ---------- Objective ----------
% GDP = value of net exports at world prices - cost of other imported goods used in production
var float: gdp = sum(i in P)(price[i] * net_export[i]) - sum(i in P)(imp[i] * x[i]);

solve maximize gdp;

% ---------- Output ----------
output [
  "GDP (Klunz) = ", show(gdp), "\n\n",
  "Production (units):\n",
  concat([ name[i] ++ " = " ++ show(x[i]) ++ "\n" | i in P ]),
  "\nNet exports (units):\n",
  concat([ name[i] ++ " = " ++ show(net_export[i]) ++ "\n" | i in P ])
];