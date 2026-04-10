% Energy investment planning (all data embedded)

int: minTotalProduction = 10000;

int: costSolar   = 10;
int: costWind    = 15;
int: costNuclear = 20;

int: maxSolarWindDiff = 5000;
int: nuclearAtLeastMoreThanWind = 2000;

% Decision variables (whole numbers)
var 0..minTotalProduction + maxSolarWindDiff + nuclearAtLeastMoreThanWind: solar;
var 0..minTotalProduction + maxSolarWindDiff + nuclearAtLeastMoreThanWind: wind;
var 0..minTotalProduction + maxSolarWindDiff + nuclearAtLeastMoreThanWind: nuclear;

% Constraints
constraint solar + wind + nuclear >= minTotalProduction;

% |solar - wind| <= 5000
constraint solar - wind <= maxSolarWindDiff;
constraint wind - solar <= maxSolarWindDiff;

% nuclear >= wind + 2000
constraint nuclear >= wind + nuclearAtLeastMoreThanWind;

% Objective
var int: total_cost = costSolar * solar + costWind * wind + costNuclear * nuclear;
solve minimize total_cost;

output [
  "Solar = ", show(solar), "\n",
  "Wind = ", show(wind), "\n",
  "Nuclear = ", show(nuclear), "\n",
  "TotalCost = ", show(total_cost), "\n"
];