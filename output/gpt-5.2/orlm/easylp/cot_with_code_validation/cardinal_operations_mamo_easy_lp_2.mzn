% Parameters
int: min_impact = 100;
int: adv_impact = 4;
int: promo_impact = 5;
int: adv_promo_diff_max = 50;

% Variables
var 0..ceil(int2float(min_impact) / int2float(adv_impact)): A; % Advertising spend
var 0..ceil(int2float(min_impact) / int2float(promo_impact)): P; % Promotion spend
var 0..(ceil(int2float(min_impact) / int2float(adv_impact)) + ceil(int2float(min_impact) / int2float(promo_impact))): Total;

% Constraints
constraint adv_impact * A + promo_impact * P >= min_impact;
constraint A - P <= adv_promo_diff_max;
constraint Total = A + P;

% Objective
solve minimize Total;