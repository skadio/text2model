% Carelland exports/imports model (LP)
% Data embedded as per problem statement.

int: n = 4;
set of int: P = 1..n;

int: STEEL = 1;
int: ENGINES = 2;
int: ELECTRONICS = 3;
int: PLASTIC = 4;

array[P] of float: price = [500.0, 1500.0, 300.0, 1200.0];

% Other imported goods requirement (Klunz per unit of output)
array[P] of float: import_goods = [250.0, 300.0, 50.0, 300.0];

% Labor requirement (person-months per unit of output)
array[P] of float: labor_pm = [
  6.0,    % steel
  12.0,   % engines (1 person-year)
  6.0,    % electronics
  24.0    % plastic (2 person-years)
];

float: labor_available_pm = 830000.0;

% Upper bounds (units)
float: max_engines = 650000.0;
float: max_plastic = 60000.0;

% Input coefficients: a[i,j] = units of input i required per unit of output j
array[P, P] of float: a = array2d(P, P, [
  % outputs:         steel   engines  electronics  plastic
  /* steel */         0.0,    0.8,     0.01,       0.2,
  /* engines */       0.02,   0.0,     0.01,       0.03,
  /* electronics */   0.0,    0.15,    0.0,        0.05,
  /* plastic */       0.01,   0.11,    0.05,       0.0
]);

% Decision variables: production levels (continuous, nonnegative)
array[P] of var float: x;

% Nonnegativity
constraint forall(p in P)(x[p] >= 0.0);

% Capacity constraints
constraint x[ENGINES] <= max_engines;
constraint x[PLASTIC] <= max_plastic;

% Labor constraint
constraint sum(p in P)(labor_pm[p] * x[p]) <= labor_available_pm;

% Material balance: net exports (must be >= 0 for each commodity)
constraint forall(i in P)(
  x[i] - sum(j in P)(a[i,j] * x[j]) >= 0.0
);

% Objective: maximize GDP = value of net exports - cost of other imported goods
var float: gdp =
  sum(i in P)(
    price[i] * (x[i] - sum(j in P)(a[i,j] * x[j]))
  )
  - sum(i in P)(import_goods[i] * x[i]);

solve maximize gdp;

output [
  "x_steel=", show(x[STEEL]), "\n",
  "x_engines=", show(x[ENGINES]), "\n",
  "x_electronics=", show(x[ELECTRONICS]), "\n",
  "x_plastic=", show(x[PLASTIC]), "\n",
  "gdp=", show(gdp), "\n"
];