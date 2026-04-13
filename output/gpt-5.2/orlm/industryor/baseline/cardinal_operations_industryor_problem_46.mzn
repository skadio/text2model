% Farm planning MILP (integer labor days; all data embedded)

%----------------------------
% Data
%----------------------------
int: land_total = 100;              % hectares
int: funds_total = 15000;           % yuan

int: labor_AW_total = 3500;         % person-days in autumn/winter
int: labor_SS_total = 4000;         % person-days in spring/summer

float: wage_SS = 2.1;               % yuan per person-day (spring/summer) external work
float: wage_AW = 1.8;               % yuan per person-day (autumn/winter) external work

% Crops (per hectare)
set of int: CROPS = 1..3;
array[CROPS] of string: crop_name = ["Soybean","Corn","Wheat"];
array[CROPS] of int: labor_AW_crop = [20, 35, 10];
array[CROPS] of int: labor_SS_crop = [50, 75, 40];
array[CROPS] of int: income_crop   = [175, 300, 120];  % yuan/ha

% Animals
int: cow_cap = 32;
int: chicken_cap = 3000;

int: invest_cow = 400;              % yuan per cow
int: invest_chicken = 3;            % yuan per chicken

float: land_per_cow = 1.5;          % ha per cow for feed

int: labor_AW_cow = 100;
int: labor_SS_cow = 50;
int: income_cow = 400;              % yuan per cow

% Chickens
float: labor_AW_chicken = 0.6;
float: labor_SS_chicken = 0.3;
int: income_chicken = 2;            % yuan per chicken
float: land_per_chicken = 0.0;

% To enforce whole labor-days when chicken labor has decimals:
% 0.6 = 3/5 and 0.3 = 3/10, scale by 10 to make integers.
int: SCALE = 10;

%----------------------------
% Decision variables
%----------------------------
array[CROPS] of var 0..land_total: ha;      % hectares planted (integer)
var 0..cow_cap: cows;                       % number of dairy cows
var 0..chicken_cap: chickens;               % number of chickens

% External labor used (must be whole days)
var 0..labor_AW_total: ext_AW;
var 0..labor_SS_total: ext_SS;

%----------------------------
% Constraints
%----------------------------

% Land limit (crops + cow feed land)
constraint sum(c in CROPS)(ha[c]) + land_per_cow * cows <= land_total;

% Funds / investment limit (crops require no special investment)
constraint invest_cow * cows + invest_chicken * chickens <= funds_total;

% Labor balance with external work; enforce whole-day accounting via scaling
% Autumn/Winter labor:
constraint
  SCALE * sum(c in CROPS)(labor_AW_crop[c] * ha[c])
  + SCALE * labor_AW_cow * cows
  + int(10 * labor_AW_chicken) * chickens   % 0.6*10 = 6
  + SCALE * ext_AW
  = SCALE * labor_AW_total;

% Spring/Summer labor:
constraint
  SCALE * sum(c in CROPS)(labor_SS_crop[c] * ha[c])
  + SCALE * labor_SS_cow * cows
  + int(10 * labor_SS_chicken) * chickens   % 0.3*10 = 3
  + SCALE * ext_SS
  = SCALE * labor_SS_total;

%----------------------------
% Objective: maximize annual net income (including external work earnings)
% Use scaled objective to keep integers: multiply everything by 10.
%----------------------------
var int: obj10 =
    10 * sum(c in CROPS)(income_crop[c] * ha[c])
  + 10 * income_cow * cows
  + 10 * income_chicken * chickens
  + int(10.0 * wage_AW) * ext_AW           % 1.8*10 = 18
  + int(10.0 * wage_SS) * ext_SS;          % 2.1*10 = 21

solve maximize obj10;

%----------------------------
% Output
%----------------------------
output [
  "Max net income (yuan) = ", show(obj10 div 10), ".", show(obj10 mod 10), "\n",
  "Planting plan (ha):\n",
  concat([ "  " ++ crop_name[c] ++ ": " ++ show(ha[c]) ++ "\n" | c in CROPS ]),
  "Animals:\n",
  "  Dairy cows: ", show(cows), "\n",
  "  Chickens:   ", show(chickens), "\n",
  "External work (person-days):\n",
  "  Autumn/Winter: ", show(ext_AW), "\n",
  "  Spring/Summer: ", show(ext_SS), "\n",
  "Land used (ha) = ",
    show( sum(c in CROPS)(ha[c]) + land_per_cow * cows ), "\n"
];