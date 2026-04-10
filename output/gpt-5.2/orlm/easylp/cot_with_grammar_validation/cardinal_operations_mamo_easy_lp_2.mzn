% Parameters
int: min_impact = 100;
int: adv_impact = 4;
int: prom_impact = 5;
int: max_adv_over_prom = 50;

% Variables
var 0..ceil(int2float(min_impact) / int2float(adv_impact)): A; % advertising spend
var 0..ceil(int2float(min_impact) / int2float(prom_impact)): P; % promotion spend
var 0..(ceil(int2float(min_impact) / int2float(adv_impact)) + ceil(int2float(min_impact) / int2float(prom_impact))): Total;

% Constraints
constraint adv_impact * A + prom_impact * P >= min_impact;
constraint A - P <= max_adv_over_prom;
constraint Total = A + P;

% Objective
solve minimize Total;