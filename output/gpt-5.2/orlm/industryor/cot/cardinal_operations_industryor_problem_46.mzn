% Parameters (with values embedded)
int: LAND = 100;                      % hectares
int: FUNDS = 15000;                   % yuan

int: LAB_AW = 3500;                   % person-days (autumn/winter)
int: LAB_SS = 4000;                   % person-days (spring/summer)

int: N_CROPS = 3;
set of int: CROPS = 1..N_CROPS;
int: SOY = 1;
int: CORN = 2;
int: WHEAT = 3;

array[CROPS] of int: crop_lab_AW = [20, 35, 10];      % per hectare
array[CROPS] of int: crop_lab_SS = [50, 75, 40];      % per hectare
array[CROPS] of int: crop_income = [175, 300, 120];   % yuan per hectare

int: cow_invest = 400;
int: chick_invest = 3;

int: cow_land = 15;                   % 1.5 hectares per cow, scaled by 10
int: cow_lab_AW = 100;
int: cow_lab_SS = 50;
int: cow_income = 400;
int: cow_cap = 32;

int: chick_lab_AW = 6;                % 0.6 per chicken, scaled by 10
int: chick_lab_SS = 3;                % 0.3 per chicken, scaled by 10
int: chick_income = 2;
int: chick_cap = 3000;

int: out_income_AW_num = 18;          % 1.8 yuan/person-day, scaled by 10
int: out_income_SS_num = 21;          % 2.1 yuan/person-day, scaled by 10

% Variables
array[CROPS] of var 0..LAND: area;    % hectares in each crop
var 0..cow_cap: cows;
var 0..chick_cap: chicks;

var 0..LAB_AW: out_AW;                % external work person-days (autumn/winter)
var 0..LAB_SS: out_SS;                % external work person-days (spring/summer)

% Constraints
% Land (scale land used by cows by 10 to keep integers with 1.5 ha/cow)
constraint
  10 * sum(c in CROPS)(area[c]) + cow_land * cows <= 10 * LAND;

% Funds for animal investment
constraint
  cow_invest * cows + chick_invest * chicks <= FUNDS;

% Labor (all labor variables are integer person-days; chickens use scaled-by-10 coefficients)
constraint
  sum(c in CROPS)(crop_lab_AW[c] * area[c]) + cow_lab_AW * cows + chick_lab_AW * chicks + out_AW * 10 <= LAB_AW * 10;

constraint
  sum(c in CROPS)(crop_lab_SS[c] * area[c]) + cow_lab_SS * cows + chick_lab_SS * chicks + out_SS * 10 <= LAB_SS * 10;

% Objective
% Maximize total annual net income (scaled by 10 to incorporate 2.1 and 1.8 exactly)
var int: total_income10 =
    10 * sum(c in CROPS)(crop_income[c] * area[c])
  + 10 * cow_income * cows
  + 10 * chick_income * chicks
  + out_income_AW_num * out_AW
  + out_income_SS_num * out_SS;

solve maximize total_income10;