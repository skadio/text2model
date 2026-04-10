% Parameters (with values embedded)
int: n = 4;
set of int: C = 1..n;

int: STEEL = 1;
int: ENGINES = 2;
int: ELECTRONICS = 3;
int: PLASTIC = 4;

array[C] of int: price = [500, 1500, 300, 1200];          % Klunz per unit (export value)

% Imported goods requirement (Klunz per unit produced)
array[C] of int: imp_goods = [250, 300, 50, 300];

% Labor requirement in person-months per unit
% steel: 6 pm; engines: 1 person-year = 12 pm; electronics: 6 pm; plastic: 2 person-years = 24 pm
array[C] of int: labor_pm = [6, 12, 6, 24];

% Intermediate input requirements: input[i,j] = units of commodity i required per unit of commodity j
% i = input commodity, j = produced commodity
array[C, C] of float: input = array2d(C, C, [
  0.0,   0.8,   0.01,  0.2,   % steel needed for (steel, engines, electronics, plastic)
  0.02,  0.0,   0.01,  0.03,  % engines needed for (...)
  0.0,   0.15,  0.0,   0.05,  % electronics needed for (...)
  0.01,  0.11,  0.05,  0.0    % plastic needed for (...)
]);

int: max_engines = 650000;
int: max_plastic = 60000;
int: labor_available_pm = 830000;

% Variables
array[C] of var int: x;              % production levels (units), nonnegative
array[C] of var float: exports;      % net exports (units), can be negative (imports)

% Constraints
constraint forall(c in C) (x[c] >= 0);

% Capacity limits
constraint x[ENGINES] <= max_engines;
constraint x[PLASTIC] <= max_plastic;

% Labor limit
constraint sum(c in C)(labor_pm[c] * x[c]) <= labor_available_pm;

% Net exports definition: exports[c] = production - intermediate use of c
constraint forall(c in C)(
  exports[c] = float(x[c]) - sum(j in C)(input[c,j] * float(x[j]))
);

% Objective
% Maximize GDP = value of net exports (exports priced) minus cost of other imported goods.
% (Intermediate inputs cancel via net exports accounting; imported goods are external imports.)
var float: GDP =
  sum(c in C)(float(price[c]) * exports[c]) - sum(c in C)(float(imp_goods[c]) * float(x[c]));

solve maximize GDP;

output [
  "Production (units):\n",
  "  steel       = ", show(x[STEEL]), "\n",
  "  engines     = ", show(x[ENGINES]), "\n",
  "  electronics = ", show(x[ELECTRONICS]), "\n",
  "  plastic     = ", show(x[PLASTIC]), "\n\n",
  "Net exports (units; negative means import):\n",
  "  steel       = ", show(exports[STEEL]), "\n",
  "  engines     = ", show(exports[ENGINES]), "\n",
  "  electronics = ", show(exports[ELECTRONICS]), "\n",
  "  plastic     = ", show(exports[PLASTIC]), "\n\n",
  "GDP (Klunz) = ", show(GDP), "\n"
];