% Parameters
int: morphine_total = 3000;
int: morphine_pain = 10;
int: digest_pain = 3;
int: morphine_sleep = 6;
int: digest_sleep = 5;
int: min_pain = 50;
int: sleep_pct_num = 70;
int: sleep_pct_den = 100;

% Variables
var 0..(morphine_total div morphine_pain): pain;
var 0..(morphine_total div morphine_sleep): sleep;

% Constraints
constraint pain >= min_pain;

constraint morphine_pain * pain + morphine_sleep * sleep <= morphine_total;

% At least 70% of all pills are sleeping:
% sleep / (pain + sleep) >= 0.70  <=>  100*sleep >= 70*(pain+sleep)
constraint sleep_pct_den * sleep >= sleep_pct_num * (pain + sleep);

% Objective
solve minimize digest_pain * pain + digest_sleep * sleep;