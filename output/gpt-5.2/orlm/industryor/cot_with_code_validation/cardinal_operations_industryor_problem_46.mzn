% Farm planning model (all data embedded)

%----------------------------
% Parameters
%----------------------------
int: LAND = 100;          % hectares
int: FUNDS = 15000;       % yuan

int: LAB_AW = 3500;       % autumn/winter labor (person-days)
int: LAB_SS = 4000;       % spring/summer labor (person-days)
float: WAGE_AW = 1.8;     % yuan per person-day (AW) if working externally
float: WAGE_SS = 2.1;     % yuan per person-day (SS) if working externally

% Crop requirements per hectare
int: AW_SOY = 20;   int: SS_SOY = 50;   int: INC_SOY = 175;
int: AW_CORN = 35;  int: SS_CORN = 75;  int: INC_CORN = 300;
int: AW_WHEAT = 10; int: SS_WHEAT = 40; int: INC_WHEAT = 120;

% Livestock
int: COW_INV = 400;
int: COW_LAND10 = 15;     % 1.5 hectares per cow, in tenths of hectare
int: COW_AW = 100;
int: COW_SS = 50;
int: COW_INC = 400;
int: COW_CAP = 32;

int: CH_INV = 3;
int: CH_AW_NUM = 6;       % 0.6 day per chicken = 6/10
int: CH_SS_NUM = 3;       % 0.3 day per chicken = 3/10
int: CH_DEN = 10;
int: CH_INC = 2;
int: CH_CAP = 3000;

int: LAND10 = LAND * 10;

%----------------------------
% Decision variables
%----------------------------
var 0..LAND10: soy10;      % soybean area in tenths of hectare
var 0..LAND10: corn10;     % corn area in tenths of hectare
var 0..LAND10: wheat10;    % wheat area in tenths of hectare

var 0..COW_CAP: cows;
var 0..CH_CAP: chickens;

var 0..LAB_AW: extAW;      % external work person-days in AW (integer)
var 0..LAB_SS: extSS;      % external work person-days in SS (integer)

%----------------------------
% Constraints
%----------------------------
% Keep crop areas in whole hectares (multiples of 10 tenths)
constraint soy10 mod 10 = 0;
constraint corn10 mod 10 = 0;
constraint wheat10 mod 10 = 0;

% Land use (cows require feed land)
constraint soy10 + corn10 + wheat10 + COW_LAND10 * cows <= LAND10;

% Enforce whole labor days for poultry usage:
% (0.6 * chickens) and (0.3 * chickens) must be integer days
constraint (CH_AW_NUM * chickens) mod CH_DEN = 0;
constraint (CH_SS_NUM * chickens) mod CH_DEN = 0;

% Labor balance (all labor either used on-farm or externally)
constraint
  AW_SOY   * (soy10 div 10) +
  AW_CORN  * (corn10 div 10) +
  AW_WHEAT * (wheat10 div 10) +
  COW_AW   * cows +
  (CH_AW_NUM * chickens) div CH_DEN +
  extAW
  = LAB_AW;

constraint
  SS_SOY   * (soy10 div 10) +
  SS_CORN  * (corn10 div 10) +
  SS_WHEAT * (wheat10 div 10) +
  COW_SS   * cows +
  (CH_SS_NUM * chickens) div CH_DEN +
  extSS
  = LAB_SS;

% Funds for livestock investment
constraint COW_INV * cows + CH_INV * chickens <= FUNDS;

%----------------------------
% Objective
%----------------------------
var float: total_income =
    float(INC_SOY * (soy10 div 10)
        + INC_CORN * (corn10 div 10)
        + INC_WHEAT * (wheat10 div 10)
        + COW_INC * cows
        + CH_INC * chickens)
  + WAGE_AW * float(extAW)
  + WAGE_SS * float(extSS);

solve maximize total_income;

output [
  "soy(ha)=", show(soy10 div 10), "\n",
  "corn(ha)=", show(corn10 div 10), "\n",
  "wheat(ha)=", show(wheat10 div 10), "\n",
  "cows=", show(cows), "\n",
  "chickens=", show(chickens), "\n",
  "extAW(days)=", show(extAW), "\n",
  "extSS(days)=", show(extSS), "\n",
  "total_income=", show(total_income), "\n"
];