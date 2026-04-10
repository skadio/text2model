% Parameters
int: total_land_ha = 100;                 % Total available land (hectares)
int: total_funds_yuan = 15000;            % Total available funds (yuan)

int: labor_aw_available = 3500;           % Available labor in Autumn/Winter (person-days)
int: labor_ss_available = 4000;           % Available labor in Spring/Summer (person-days)

float: wage_ss = 2.1;                     % External work wage in Spring/Summer (yuan/person-day)
float: wage_aw = 1.8;                     % External work wage in Autumn/Winter (yuan/person-day)

set of int: Crops = 1..3;                 % 1=Soybean, 2=Corn, 3=Wheat

array[Crops] of int: crop_aw_pd_per_ha =  [20, 35, 10];    % A/W labor per hectare by crop
array[Crops] of int: crop_ss_pd_per_ha =  [50, 75, 40];    % S/S labor per hectare by crop
array[Crops] of int: crop_income_per_ha = [175, 300, 120]; % Net income per hectare by crop (yuan)

int: cow_invest_per_head = 400;           % Investment per dairy cow (yuan/head)
float: cow_land_per_head = 1.5;           % Land needed per dairy cow for feed (hectares/head)
int: cow_aw_pd_per_head = 100;            % A/W labor per dairy cow (person-days/head)
int: cow_ss_pd_per_head = 50;             % S/S labor per dairy cow (person-days/head)
int: cow_income_per_head = 400;           % Net income per dairy cow (yuan/head)
int: cow_capacity = 32;                   % Max number of dairy cows

int: chicken_invest_per_head = 3;         % Investment per chicken (yuan/head)
float: chicken_aw_pd_per_head = 0.6;      % A/W labor per chicken (person-days/head)
float: chicken_ss_pd_per_head = 0.3;      % S/S labor per chicken (person-days/head)
int: chicken_income_per_head = 2;         % Net income per chicken (yuan/head)
int: chicken_capacity = 3000;             % Max number of chickens


% Variables
array[Crops] of var 0..total_land_ha: crop_area_ha;  % Area allocated to each crop (hectares, integer)

var 0..cow_capacity: num_cows;                       % Number of dairy cows (integer)
var 0..chicken_capacity: num_chickens;               % Number of chickens (integer)

var 0..labor_aw_available: external_aw_pd;           % External work in A/W (person-days, integer)
var 0..labor_ss_available: external_ss_pd;           % External work in S/S (person-days, integer)


% Constraints

% --- Land availability (crop land + cow feed land <= total land) ---
% cow_land_per_head = 1.5 = 3/2; enforce without floats by multiplying by 2.
constraint
  2 * sum(c in Crops)(crop_area_ha[c]) + 3 * num_cows
  <= 2 * total_land_ha;

% --- Funds / investment budget (cows and chickens only) ---
constraint
  cow_invest_per_head * num_cows
+ chicken_invest_per_head * num_chickens
<= total_funds_yuan;

% --- Capacity constraints (redundant with variable domains but kept for clarity) ---
constraint num_cows <= cow_capacity;
constraint num_chickens <= chicken_capacity;

% --- Labor balance: Autumn/Winter (farm labor used + external work = available) ---
% Avoid float labor coefficients by scaling by 10 (0.6 -> 6/10).
constraint
  10 * sum(c in Crops)(crop_aw_pd_per_ha[c] * crop_area_ha[c])
+ 10 * cow_aw_pd_per_head * num_cows
+ 6 * num_chickens
+ 10 * external_aw_pd
= 10 * labor_aw_available;

% --- Labor balance: Spring/Summer (farm labor used + external work = available) ---
% Avoid float labor coefficients by scaling by 10 (0.3 -> 3/10).
constraint
  10 * sum(c in Crops)(crop_ss_pd_per_ha[c] * crop_area_ha[c])
+ 10 * cow_ss_pd_per_head * num_cows
+ 3 * num_chickens
+ 10 * external_ss_pd
= 10 * labor_ss_available;

% --- Integrality of land allocation (hectares must be whole) ---
% (Domains already enforce integrality for var int, so this is unnecessary; kept as a clear statement.)
constraint forall(c in Crops)(is_int(crop_area_ha[c]));


% Objective
% Maximize total net income from crops + animals + external labor wages.
solve maximize
    sum(c in Crops)(crop_income_per_ha[c] * crop_area_ha[c])
  + cow_income_per_head * num_cows
  + chicken_income_per_head * num_chickens
  + wage_aw * external_aw_pd
  + wage_ss * external_ss_pd;