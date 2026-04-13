% Carelland GDP maximization model (embedded data)
% Commodities: steel, engines, electronics, plastic

set of int: C = 1..4;
int: STEEL = 1;
int: ENGINES = 2;
int: ELECTRONICS = 3;
int: PLASTIC = 4;

array[C] of int: price = [500, 1500, 300, 1200]; % Klunz per unit

% Input requirements per unit of output (intermediate commodities)
% req[i,j] = units of commodity j required to produce 1 unit of commodity i
array[C, C] of float: req =
[
 % needs:  steel   engines electronics plastic
          0.0,    0.02,    0.0,       0.01,   % steel
          0.8,    0.0,     0.15,      0.11,   % engines
          0.01,   0.01,    0.0,       0.05,   % electronics
          0.2,    0.03,    0.05,      0.0     % plastic
];

% Imported goods requirement (Klunz) per unit
array[C] of float: imp = [250.0, 300.0, 50.0, 300.0];

% Labor requirement in person-months per unit
% (1 person-year = 12 person-months)
array[C] of float: labor = [
  6.0,          % steel
  12.0,         % engines (1 person-year)
  6.0,          % electronics
  24.0          % plastic (2 person-years)
];

float: labor_avail = 830000.0;

% Production limits
float: engines_max = 650000.0;
float: plastic_max = 60000.0;

% Decision variables: production quantities
array[C] of var float: x;

% Bounds (non-negativity, plus stated caps)
constraint forall(i in C)(x[i] >= 0.0);
constraint x[ENGINES] <= engines_max;
constraint x[PLASTIC] <= plastic_max;

% Material balance: net exports e[i] = x[i] - sum_k req[k,i]*x[k]  must be >= 0
% (no imports of the four commodities; only imported "other goods" are allowed via imp[])
constraint forall(i in C)(
  x[i] - sum(k in C)(req[k,i] * x[k]) >= 0.0
);

% Labor capacity
constraint sum(i in C)(labor[i] * x[i]) <= labor_avail;

% Objective: maximize GDP = value added = total output value - imported goods cost
var float: gdp =
  sum(i in C)(price[i] * x[i]) - sum(i in C)(imp[i] * x[i]);

solve maximize gdp;

% Reporting: net exports
array[C] of var float: net_export;
constraint forall(i in C)(
  net_export[i] = x[i] - sum(k in C)(req[k,i] * x[k])
);

output [
  "GDP (Klunz): ", show(gdp), "\n",
  "Production:\n",
  "  steel:       ", show(x[STEEL]), "\n",
  "  engines:     ", show(x[ENGINES]), "\n",
  "  electronics: ", show(x[ELECTRONICS]), "\n",
  "  plastic:     ", show(x[PLASTIC]), "\n",
  "Net exports:\n",
  "  steel:       ", show(net_export[STEEL]), "\n",
  "  engines:     ", show(net_export[ENGINES]), "\n",
  "  electronics: ", show(net_export[ELECTRONICS]), "\n",
  "  plastic:     ", show(net_export[PLASTIC]), "\n",
  "Labor used (person-months): ", show(sum(i in C)(labor[i] * x[i])), "\n",
  "Imported goods cost (Klunz): ", show(sum(i in C)(imp[i] * x[i])), "\n"
];