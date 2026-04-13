% Parameters
% Vitamin content per cup for each drink (fixed from problem statement)
int: vitA_A = 8;
int: vitD_A = 6;
int: vitE_A = 10;
int: vitK_A = 4;

int: vitA_B = 15;
int: vitD_B = 2;
int: vitE_B = 20;
int: vitK_B = 12;

% Requirement bounds for the final mix
int: reqA_min = 150;   % at least 150 units of Vitamin A
int: reqD_min = 300;   % at least 300 units of Vitamin D
int: reqE_max = 400;   % at most 400 units of Vitamin E

% Variables
var 0..1000: cupsA;        % number of cups of drink A (non-negative)
var 0..1000: cupsB;        % number of cups of drink B (non-negative)

var 0..100000: totalVitA;  % total Vitamin A in the mix
var 0..100000: totalVitD;  % total Vitamin D in the mix
var 0..100000: totalVitE;  % total Vitamin E in the mix
var 0..100000: totalVitK;  % total Vitamin K in the mix (objective to minimize)

% Constraints
% --- Total vitamin calculations (link totals to decision variables) ---
constraint totalVitA = vitA_A * cupsA + vitA_B * cupsB;
constraint totalVitD = vitD_A * cupsA + vitD_B * cupsB;
constraint totalVitE = vitE_A * cupsA + vitE_B * cupsB;
constraint totalVitK = vitK_A * cupsA + vitK_B * cupsB;

% --- Nutrient requirement constraints (meet minimums / respect maximum) ---
constraint totalVitA >= reqA_min;   % at least 150 units of Vitamin A
constraint totalVitD >= reqD_min;   % at least 300 units of Vitamin D
constraint totalVitE <= reqE_max;   % at most 400 units of Vitamin E

% Objective
solve minimize totalVitK;