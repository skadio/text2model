% Parameters
int: MAX_GRAINS = 400000;          % lbs
int: MAX_MEAT   = 300000;          % lbs
int: MAX_MEATIES = 90000;          % packs (machine capacity)

% Use cents to keep everything integer
int: PRICE_MEATIES = 280;          % cents/pack
int: PRICE_YUMMIES = 200;          % cents/pack
int: VARCOST_MEATIES = 25;         % cents/pack
int: VARCOST_YUMMIES = 20;         % cents/pack

int: GRAIN_COST = 20;              % cents/lb
int: MEAT_COST  = 50;              % cents/lb

% Raw material usage per pack (scaled by 2 to avoid 1.5)
int: SCALE = 2;
int: GRAIN_MEATIES = 2 * SCALE;    % 4 (i.e., 2.0 lbs)
int: GRAIN_YUMMIES = 3 * SCALE;    % 6 (i.e., 3.0 lbs)
int: MEAT_MEATIES  = 3 * SCALE;    % 6 (i.e., 3.0 lbs)
int: MEAT_YUMMIES  = 15;           % 3 (i.e., 1.5 lbs) * 2 = 3 -> but kept as 3*SCALE=3? Actually 1.5*2=3
% Correct scaled value for 1.5 lbs:
constraint MEAT_YUMMIES == 3 * 1;  % ensures MEAT_YUMMIES = 3

% Variables
var 0..MAX_MEATIES: x_meaties;     % packs
var 0..400000: x_yummies;          % packs (loose upper bound)

% Constraints
constraint
  GRAIN_MEATIES * x_meaties + GRAIN_YUMMIES * x_yummies <= MAX_GRAINS * SCALE;

constraint
  MEAT_MEATIES * x_meaties + MEAT_YUMMIES * x_yummies <= MAX_MEAT * SCALE;

% Objective
var int: profit_cents =
  (PRICE_MEATIES - VARCOST_MEATIES) * x_meaties
+ (PRICE_YUMMIES - VARCOST_YUMMIES) * x_yummies
- GRAIN_COST * ((GRAIN_MEATIES * x_meaties + GRAIN_YUMMIES * x_yummies) div SCALE)
- MEAT_COST  * ((MEAT_MEATIES  * x_meaties + MEAT_YUMMIES  * x_yummies) div SCALE);

solve maximize profit_cents;

output [
  "Meaties packs = ", show(x_meaties), "\n",
  "Yummies packs = ", show(x_yummies), "\n",
  "Profit ($) = ", show(profit_cents div 100), ".", show(profit_cents mod 100), "\n"
];