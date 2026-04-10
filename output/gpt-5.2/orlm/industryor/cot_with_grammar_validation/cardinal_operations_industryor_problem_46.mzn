% Parameters
int: LAND = 100;
int: BUDGET = 15000;

int: LAB_AW = 3500;          % available person-days in Autumn/Winter
int: LAB_SS = 4000;          % available person-days in Spring/Summer
int: WAGE_AW = 18;           % 1.8 yuan/person-day scaled by 10
int: WAGE_SS = 21;           % 2.1 yuan/person-day scaled by 10

int: COW_CAP = 32;
int: CHICK_CAP = 3000;

int: INV_COW = 400;
int: INV_CHICK = 3;

int: LAND_PER_COW = 15;      % 1.5 ha scaled by 10
int: PROF_COW = 400;
int: PROF_CHICK = 2;

int: PROF_SOY = 175;
int: PROF_CORN = 300;
int: PROF_WHEAT = 120;

int: AW_SOY = 20;
int: AW_CORN = 35;
int: AW_WHEAT = 10;

int: SS_SOY = 50;
int: SS_CORN = 75;
int: SS_WHEAT = 40;

% Variables
var 0..LAND: soy_ha;
var 0..LAND: corn_ha;
var 0..LAND: wheat_ha;

var 0..COW_CAP: cows;
var 0..CHICK_CAP: chicks;

var 0..LAB_AW: ext_aw;        % external work person-days (integer)
var 0..LAB_SS: ext_ss;        % external work person-days (integer)

var int: total_income10;      % objective scaled by 10

% Constraints
constraint soy_ha + corn_ha + wheat_ha <= LAND;

% Land for cows: soy+corn+wheat + 1.5*cows <= 100 (avoid fractions via scaling)
constraint 10 * (soy_ha + corn_ha + wheat_ha) + LAND_PER_COW * cows <= 10 * LAND;

% Budget for animal investment
constraint INV_COW * cows + INV_CHICK * chicks <= BUDGET;

% Labor constraints with integer person-days; unused labor goes to external work
constraint
  AW_SOY * soy_ha + AW_CORN * corn_ha + AW_WHEAT * wheat_ha
  + 100 * cows + 1 * ext_aw + (6 * chicks) div 10
  <= LAB_AW;

constraint 10 * (
  AW_SOY * soy_ha + AW_CORN * corn_ha + AW_WHEAT * wheat_ha
  + 100 * cows + ext_aw
) + 6 * chicks <= 10 * LAB_AW;

constraint
  SS_SOY * soy_ha + SS_CORN * corn_ha + SS_WHEAT * wheat_ha
  + 50 * cows + 1 * ext_ss + (3 * chicks) div 10
  <= LAB_SS;

constraint 10 * (
  SS_SOY * soy_ha + SS_CORN * corn_ha + SS_WHEAT * wheat_ha
  + 50 * cows + ext_ss
) + 3 * chicks <= 10 * LAB_SS;

% Objective definition (scaled by 10 to handle 2.1 and 1.8)
constraint total_income10 =
  10 * (PROF_SOY * soy_ha + PROF_CORN * corn_ha + PROF_WHEAT * wheat_ha
        + PROF_COW * cows + PROF_CHICK * chicks)
  + WAGE_AW * ext_aw + WAGE_SS * ext_ss;

% Objective
solve maximize total_income10;