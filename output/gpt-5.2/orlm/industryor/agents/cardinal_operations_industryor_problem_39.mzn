% Parameters

% Commodities: 1=steel, 2=engines, 3=electronics, 4=plastic
int: nCommodities = 4;
set of int: C = 1..nCommodities;

int: STEEL = 1;
int: ENGINES = 2;
int: ELECTRONICS = 3;
int: PLASTIC = 4;

% World market unit prices (Klunz per unit)
array[C] of int: price = [
  500,   % steel
  1500,  % engines
  300,   % electronics
  1200   % plastic
];

% Intermediate input requirements: input_req[i,j] = units of commodity j needed per 1 unit of commodity i
% Rows: output produced; Cols: input required
array[C, C] of float: input_req = array2d(C, C, [
  % inputs:   steel   engines  electronics  plastic
             0.0,    0.02,    0.0,         0.01,   % produce steel
             0.8,    0.0,     0.15,        0.11,   % produce engines
             0.01,   0.01,    0.0,         0.05,   % produce electronics
             0.2,    0.03,    0.05,        0.0     % produce plastic
]);

% Imported goods requirement (Klunz of imported goods per unit produced)
array[C] of int: imported_goods = [
  250,  % steel
  300,  % engines
  50,   % electronics
  300   % plastic
];

% Labor requirement (person-months per unit produced)
% 1 person-year = 12 person-months
array[C] of int: labor_pm = [
  6,    % steel
  12,   % engines (1 person-year)
  6,    % electronics
  24    % plastic (2 person-years)
];

% Production upper bounds (units); use a large number as "unbounded"
int: BIG_UB = 1000000000;
array[C] of int: prod_ub = [
  BIG_UB,  % steel (no explicit limit)
  650000,  % engines
  BIG_UB,  % electronics (no explicit limit)
  60000    % plastic
];

% Total available labor per year (person-months)
int: labor_available_pm = 830000;


% Variables

% Production quantities (units produced of each commodity)
array[C] of var 0..BIG_UB: produce;

% Total exports (value) and imports (value), useful for GDP/accounting formulations
var 0..(sum(c in C)(price[c] * prod_ub[c])): export_value;
var 0..(sum(c in C)(imported_goods[c] * prod_ub[c])): import_value;

% Domestic GDP proxy (exports minus imported-goods spending)
var int: gdp;


% Constraints

% --- Production capacity constraints (upper bounds) ---
constraint
  forall(c in C) (
    produce[c] <= prod_ub[c]
  );

% --- Labor availability constraint ---
constraint
  sum(c in C) (labor_pm[c] * produce[c]) <= labor_available_pm;

% --- Material balance constraints (domestic availability for intermediate inputs) ---
% For each commodity j used as an intermediate input, total use across all productions
% cannot exceed domestic production of j.
constraint
  forall(j in C) (
    sum(i in C) (input_req[i,j] * int2float(produce[i])) <= int2float(produce[j])
  );

% --- Accounting: define total export value as value of total production at world prices ---
constraint
  export_value = sum(c in C) (price[c] * produce[c]);

% --- Accounting: define total imported-goods spending (imports proxy) ---
constraint
  import_value = sum(c in C) (imported_goods[c] * produce[c]);

% --- GDP definition (domestic GDP proxy) ---
constraint
  gdp = export_value - import_value;


% Objective
solve maximize gdp;