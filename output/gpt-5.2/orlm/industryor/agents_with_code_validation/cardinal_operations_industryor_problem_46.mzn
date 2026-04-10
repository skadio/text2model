% Parameters
int: total_land_ha = 100;                 % Total available land (hectares)
int: total_funds_yuan = 15000;            % Total available funds (yuan)

int: labor_aw_available = 3500;           % Available labor in Autumn/Winter (person-days)
int: labor_ss_available = 4000;           % Available labor in Spring/Summer (person-days)

float: wage_ss = 2.1;                     % External work wage Spring/Summer (yuan per person-day)
float: wage_aw = 1.8;                     % External work wage Autumn/Winter (yuan per person-day)

% Crop sets and data
set of int: CROPS = 1..3;
int: SOY = 1;
int: CORN = 2;
int: WHEAT = 3;

array[CROPS] of int: crop_labor_aw = [20, 35, 10];     % person-days/ha (Autumn/Winter)
array[CROPS] of int: crop_labor_ss = [50, 75, 40];     % person-days/ha (Spring/Summer)
array[CROPS] of int: crop_income   = [175, 300, 120];  % yuan/ha annual net income

% Livestock parameters
int: max_cows = 32;                         % Barn capacity for dairy cows
int: max_chickens = 3000;                   % Coop capacity for chickens

int: cow_invest = 400;                      % yuan per cow investment
int: chicken_invest = 3;                    % yuan per chicken investment

float: cow_land = 1.5;                      % hectares per cow for feed
int: cow_labor_aw = 100;                    % person-days per cow (Autumn/Winter)
int: cow_labor_ss = 50;                     % person-days per cow (Spring/Summer)
int: cow_income = 400;                      % yuan per cow annual net income

float: chicken_land = 0.0;                  % hectares per chicken (not used)
float: chicken_labor_aw = 0.6;              % person-days per chicken (Autumn/Winter) (not used directly)
float: chicken_labor_ss = 0.3;              % person-days per chicken (Spring/Summer) (not used directly)
int: chicken_income = 2;                    % yuan per chicken annual net income


% Variables
array[CROPS] of var 0..total_land_ha: area_ha;  % Planted area for each crop (hectares), integer hectares

var 0..max_cows: num_cows;                      % Number of dairy cows (integer)
var 0..max_chickens: num_chickens;              % Number of chickens (integer)

var 0..labor_aw_available: external_work_aw;    % External work in Autumn/Winter (person-days), integer
var 0..labor_ss_available: external_work_ss;    % External work in Spring/Summer (person-days), integer

% Auxiliary variables for accounting
var 0.0..(int2float(total_land_ha) + cow_land * int2float(max_cows)): land_used;  % Total land used (ha)
var 0.0..1.0e9: total_income;                                                      % Total annual net income (yuan)

var 0..labor_aw_available: labor_used_aw;     % On-farm labor used A/W (person-days)
var 0..labor_ss_available: labor_used_ss;     % On-farm labor used S/S (person-days)


% Constraints

%--- Land use accounting and limit -------------------------------------------
% Land is used by crop areas (1 ha per ha planted) plus feed land for cows.
constraint land_used
  = sum(c in CROPS)(int2float(area_ha[c])) + cow_land * int2float(num_cows);

% Total land cannot exceed available hectares.
constraint land_used <= int2float(total_land_ha);

%--- Funds / investment limit -------------------------------------------------
% Only livestock requires investment; crops require none.
constraint cow_invest * num_cows + chicken_invest * num_chickens <= total_funds_yuan;

%--- Capacity limits (redundant with variable bounds, kept for clarity) -------
constraint num_cows <= max_cows;
constraint num_chickens <= max_chickens;

%--- Labor use accounting -----------------------------------------------------
% Labor days must be whole days; handle chicken labor via integer arithmetic:
% 0.6 = 3/5 and 0.3 = 3/10, taking floor via div to keep integer person-days.
constraint labor_used_aw =
    sum(c in CROPS)(crop_labor_aw[c] * area_ha[c])
  + cow_labor_aw * num_cows
  + (3 * num_chickens) div 5;

constraint labor_used_ss =
    sum(c in CROPS)(crop_labor_ss[c] * area_ha[c])
  + cow_labor_ss * num_cows
  + (3 * num_chickens) div 10;

%--- Labor availability and external work ------------------------------------
% All available labor is either used on-farm or used as external work.
constraint labor_used_aw + external_work_aw = labor_aw_available;
constraint labor_used_ss + external_work_ss = labor_ss_available;

%--- Income accounting --------------------------------------------------------
% Total income = crop income + livestock income + external work wages.
constraint total_income =
    sum(c in CROPS)(int2float(crop_income[c] * area_ha[c]))
  + int2float(cow_income * num_cows + chicken_income * num_chickens)
  + wage_aw * int2float(external_work_aw)
  + wage_ss * int2float(external_work_ss);


% Objective
solve maximize total_income;