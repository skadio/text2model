% Farm planning MILP (all data embedded)
% Uses integer hectares for crops (whole hectares) and integer animals.
% External work uses unused labor; model it via equality with total labor.

%%%% Parameters %%%%
int: LAND = 100;                 % hectares
int: BUDGET = 15000;             % yuan

int: LAB_AW = 3500;              % person-days (autumn/winter)
int: LAB_SS = 4000;              % person-days (spring/summer)

int: WAGE_AW_NUM = 18;           % 1.8 yuan/person-day scaled by 10
int: WAGE_SS_NUM = 21;           % 2.1 yuan/person-day scaled by 10
int: MONEY_SCALE = 10;           % scale all monetary values by 10 to keep integers

set of int: CROPS = 1..3;        % 1=soybean, 2=corn, 3=wheat

array[CROPS] of int: crop_aw = [20, 35, 10];       % person-days per hectare
array[CROPS] of int: crop_ss = [50, 75, 40];       % person-days per hectare
array[CROPS] of int: crop_inc = [175, 300, 120];   % yuan per hectare

int: COW_INV = 400;              % yuan per cow
int: CHICK_INV = 3;              % yuan per chicken

% Land per cow: 1.5 ha -> use scaling of land by 2 (0.5 ha units) for cows only
int: LAND_SCALE = 2;             % 1 unit = 0.5 ha
int: LAND_SCALED = LAND * LAND_SCALE;

int: COW_LAND_UNITS = 3;         % 1.5 ha = 3 * 0.5ha units
int: COW_AW = 100;               % person-days per cow
int: COW_SS = 50;                % person-days per cow
int: COW_INC = 400;              % yuan per cow
int: MAX_COWS = 32;

% Chicken labor: 0.6 and 0.3 person-day per chicken => scale by 10 in constraints
int: CHICK_AW_NUM = 6;           % 0.6 * 10
int: CHICK_SS_NUM = 3;           % 0.3 * 10
int: CHICK_INC = 2;              % yuan per chicken
int: MAX_CHICKS = 3000;

%%%% Decision variables %%%%
array[CROPS] of var 0..LAND: ha;     % hectares of each crop (whole hectares)
var 0..MAX_COWS: cows;
var 0..MAX_CHICKS: chicks;

% External work days (integer)
var 0..LAB_AW: ext_aw;
var 0..LAB_SS: ext_ss;

%%%% Constraints %%%%

% Land (use scaled land to represent 1.5 ha per cow exactly)
constraint
  LAND_SCALE * sum(i in CROPS)(ha[i]) + COW_LAND_UNITS * cows <= LAND_SCALED;

% Budget (investment only for animals)
constraint
  COW_INV * cows + CHICK_INV * chicks <= BUDGET;

% Capacity limits (redundant due to var domains, but explicit)
constraint cows <= MAX_COWS;
constraint chicks <= MAX_CHICKS;

% Labor accounting:
% To maximize income, all unused labor will be allocated to external work, so we can model as equalities.
% Autumn/Winter: crop + cows + chickens + external = total labor
constraint
  sum(i in CROPS)(crop_aw[i] * ha[i]) + COW_AW * cows + ext_aw
  + (CHICK_AW_NUM * chicks) div 10 = LAB_AW;

% Spring/Summer
constraint
  sum(i in CROPS)(crop_ss[i] * ha[i]) + COW_SS * cows + ext_ss
  + (CHICK_SS_NUM * chicks) div 10 = LAB_SS;

% Ensure chicken labor is integral person-days
constraint (CHICK_AW_NUM * chicks) mod 10 = 0;
constraint (CHICK_SS_NUM * chicks) mod 10 = 0;

%%%% Objective (scaled by 10 to keep integer arithmetic) %%%%
var int: profit10 =
  MONEY_SCALE * sum(i in CROPS)(crop_inc[i] * ha[i])
+ MONEY_SCALE * (COW_INC * cows + CHICK_INC * chicks)
+ WAGE_AW_NUM * ext_aw
+ WAGE_SS_NUM * ext_ss;

solve maximize profit10;

%%%% Output %%%%
output [
  "ha_soybeans=", show(ha[1]), "\n",
  "ha_corn=", show(ha[2]), "\n",
  "ha_wheat=", show(ha[3]), "\n",
  "cows=", show(cows), "\n",
  "chicks=", show(chicks), "\n",
  "ext_aw_days=", show(ext_aw), "\n",
  "ext_ss_days=", show(ext_ss), "\n",
  "profit_yuan=", show(profit10 div 10), ".", show(profit10 mod 10), "\n"
];