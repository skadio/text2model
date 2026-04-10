include "globals.mzn";

% Farm planning MILP/CP model (all data embedded)

%-------------------- Data --------------------
int: land_total = 100;          % hectares
int: fund_total = 15000;        % yuan

int: labor_AW_total = 3500;     % person-days in Autumn/Winter
int: labor_SS_total = 4000;     % person-days in Spring/Summer

float: wage_AW = 1.8;           % yuan per person-day if working externally
float: wage_SS = 2.1;

% Crops: 1=Soybean, 2=Corn, 3=Wheat
int: C = 3;
set of int: CROPS = 1..C;
array[CROPS] of int: aw_per_ha  = [20, 35, 10];
array[CROPS] of int: ss_per_ha  = [50, 75, 40];
array[CROPS] of int: inc_per_ha = [175, 300, 120];

% Animals
int: cow_cap = 32;
int: chick_cap = 3000;

int: cow_inv = 400;     % yuan per cow
int: cow_inc = 400;     % yuan per cow
int: cow_aw  = 100;     % person-days per cow
int: cow_ss  = 50;
float: cow_land = 1.5;  % ha per cow (feed land)

int: chick_inv = 3;     % yuan per chicken
int: chick_inc = 2;     % yuan per chicken
float: chick_aw = 0.6;  % person-days per chicken
float: chick_ss = 0.3;

% Labor must be whole days; use scaling to avoid fractions:
% - Scale land by 2 so cow land (1.5) becomes 3 units.
% - Scale chicken labor by 10 so 0.6 and 0.3 become integers.
int: land_scale = 2;            % 1 ha = 2 units
int: land_total_u = land_total * land_scale;  % 200 units
int: cow_land_u = 3;            % 1.5 ha = 3 units

int: lab_scale = 10;            % 1 day = 10 units (to handle 0.1)
int: labor_AW_total_u = labor_AW_total * lab_scale;
int: labor_SS_total_u = labor_SS_total * lab_scale;

array[CROPS] of int: aw_per_ha_u = [aw_per_ha[i] * lab_scale | i in CROPS];
array[CROPS] of int: ss_per_ha_u = [ss_per_ha[i] * lab_scale | i in CROPS];

int: cow_aw_u = cow_aw * lab_scale;
int: cow_ss_u = cow_ss * lab_scale;
int: chick_aw_u = 6;    % 0.6 * 10
int: chick_ss_u = 3;    % 0.3 * 10

% Objective scaling: make all profits integral by multiplying by 10
int: obj_scale = 10;
int: wage_AW_s = round(wage_AW * obj_scale);  % 18
int: wage_SS_s = round(wage_SS * obj_scale);  % 21

%-------------------- Decision variables --------------------
array[CROPS] of var 0..land_total: ha;   % hectares planted (integer ha)
var 0..cow_cap: cows;
var 0..chick_cap: chicks;

% External labor used (must be whole days)
var 0..labor_AW_total: ext_AW;
var 0..labor_SS_total: ext_SS;

%-------------------- Constraints --------------------
% Land (scaled)
constraint
  sum(i in CROPS)(ha[i] * land_scale) + cows * cow_land_u <= land_total_u;

% Funds
constraint
  cows * cow_inv + chicks * chick_inv <= fund_total;

% Labor capacity (scaled, with external work using leftover labor)
var 0..labor_AW_total_u: used_AW_u;
var 0..labor_SS_total_u: used_SS_u;

constraint used_AW_u =
  sum(i in CROPS)(ha[i] * aw_per_ha_u[i]) + cows * cow_aw_u + chicks * chick_aw_u;
constraint used_SS_u =
  sum(i in CROPS)(ha[i] * ss_per_ha_u[i]) + cows * cow_ss_u + chicks * chick_ss_u;

% Must not exceed available labor
constraint used_AW_u <= labor_AW_total_u;
constraint used_SS_u <= labor_SS_total_u;

% External labor equals unused labor; ensure it's in whole days (multiple of 10)
constraint ext_AW * lab_scale = labor_AW_total_u - used_AW_u;
constraint ext_SS * lab_scale = labor_SS_total_u - used_SS_u;

%-------------------- Objective --------------------
% Total net income = crops + animals + external wages.
var int: profit_scaled =
  obj_scale * sum(i in CROPS)(ha[i] * inc_per_ha[i]) +
  obj_scale * (cows * cow_inc + chicks * chick_inc) +
  wage_AW_s * ext_AW + wage_SS_s * ext_SS;

solve maximize profit_scaled;

%-------------------- Output --------------------
output [
  "Hectares (Soybean,Corn,Wheat) = ", show([ha[i] | i in CROPS]), "\n",
  "Cows = ", show(cows), "\n",
  "Chickens = ", show(chicks), "\n",
  "External labor AW (days) = ", show(ext_AW), "\n",
  "External labor SS (days) = ", show(ext_SS), "\n",
  "Total profit (yuan) = ", show(profit_scaled / obj_scale), "\n",
  "Profit scaled (x10) = ", show(profit_scaled), "\n"
];