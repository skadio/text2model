% Parameters
% Vitamin requirements (minimums / maximums)
int: minVitA = 150;
int: minVitD = 300;
int: maxVitE = 400;

% Vitamin contents per cup of each drink
int: vitA_A = 8;
int: vitD_A = 6;
int: vitE_A = 10;
int: vitK_A = 4;

int: vitA_B = 15;
int: vitD_B = 2;
int: vitE_B = 20;
int: vitK_B = 12;

% Variables
% Number of cups of each drink to use (non-negative integers)
var 0..1000: cupsA;
var 0..1000: cupsB;

% Total Vitamin K in the mix (objective-related variable)
var 0..(vitK_A * 1000 + vitK_B * 1000): totalVitK;

% Constraints
% --- Vitamin requirement constraints ---
% Ensure at least the minimum required Vitamin A
constraint vitA_A * cupsA + vitA_B * cupsB >= minVitA;

% Ensure at least the minimum required Vitamin D
constraint vitD_A * cupsA + vitD_B * cupsB >= minVitD;

% Ensure at most the maximum allowed Vitamin E
constraint vitE_A * cupsA + vitE_B * cupsB <= maxVitE;

% --- Definition of total Vitamin K ---
% Link totalVitK to the cups chosen (used for the objective)
constraint totalVitK = vitK_A * cupsA + vitK_B * cupsB;

% Objective
solve minimize totalVitK;