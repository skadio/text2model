% Parameters (with values embedded)
int: LAB_HOURS_AVAILABLE = 6000;
int: RAW_LB_MAX = 4000;

% Costs and revenues
float: RAW_COST_PER_LB = 3.0;

float: PRICE_REG_BRUTE_PER_OZ = 7.0;
float: PRICE_REG_CHANELLE_PER_OZ = 6.0;

float: PRICE_LUX_BRUTE_PER_OZ = 18.0;
float: PRICE_LUX_CHANELLE_PER_OZ = 14.0;

float: EXTRA_COST_PER_OZ_LUX_BRUTE = 4.0;
float: EXTRA_COST_PER_OZ_LUX_CHANELLE = 4.0;

% Processing requirements/yields
float: HOURS_PER_LB_RAW = 1.0;
float: YIELD_REG_BRUTE_OZ_PER_LB = 3.0;
float: YIELD_REG_CHANELLE_OZ_PER_LB = 4.0;

float: EXTRA_HOURS_PER_OZ_LUX_BRUTE = 3.0;
float: EXTRA_HOURS_PER_OZ_LUX_CHANELLE = 2.0;

% Variables
var float: raw_lb;                 % pounds of raw material purchased/processed
var float: reg_brute_oz;           % oz of regular brute produced
var float: reg_chanelle_oz;        % oz of regular chanelle produced

var float: lux_brute_oz;           % oz of luxury brute produced (from regular brute)
var float: lux_chanelle_oz;        % oz of luxury chanelle produced (from regular chanelle)

var float: reg_brute_sold_oz;      % oz of regular brute sold
var float: reg_chanelle_sold_oz;   % oz of regular chanelle sold

var float: profit;

% Constraints
constraint raw_lb >= 0.0 /\ raw_lb <= RAW_LB_MAX;

constraint reg_brute_oz >= 0.0;
constraint reg_chanelle_oz >= 0.0;
constraint lux_brute_oz >= 0.0;
constraint lux_chanelle_oz >= 0.0;
constraint reg_brute_sold_oz >= 0.0;
constraint reg_chanelle_sold_oz >= 0.0;

% Yields from raw material processing
constraint reg_brute_oz = YIELD_REG_BRUTE_OZ_PER_LB * raw_lb;
constraint reg_chanelle_oz = YIELD_REG_CHANELLE_OZ_PER_LB * raw_lb;

% Further processing cannot exceed available regular output
constraint lux_brute_oz <= reg_brute_oz;
constraint lux_chanelle_oz <= reg_chanelle_oz;

% Regular sales are what's left after luxury conversion
constraint reg_brute_sold_oz = reg_brute_oz - lux_brute_oz;
constraint reg_chanelle_sold_oz = reg_chanelle_oz - lux_chanelle_oz;

% Laboratory time capacity (lab hour cost is fixed, so only a constraint)
constraint
  HOURS_PER_LB_RAW * raw_lb
  + EXTRA_HOURS_PER_OZ_LUX_BRUTE * lux_brute_oz
  + EXTRA_HOURS_PER_OZ_LUX_CHANELLE * lux_chanelle_oz
  <= LAB_HOURS_AVAILABLE;

% Profit definition: revenues - (raw material cost + extra processing cost)
constraint profit =
    PRICE_REG_BRUTE_PER_OZ * reg_brute_sold_oz
  + PRICE_REG_CHANELLE_PER_OZ * reg_chanelle_sold_oz
  + PRICE_LUX_BRUTE_PER_OZ * lux_brute_oz
  + PRICE_LUX_CHANELLE_PER_OZ * lux_chanelle_oz
  - RAW_COST_PER_LB * raw_lb
  - EXTRA_COST_PER_OZ_LUX_BRUTE * lux_brute_oz
  - EXTRA_COST_PER_OZ_LUX_CHANELLE * lux_chanelle_oz;

% Objective
solve maximize profit;