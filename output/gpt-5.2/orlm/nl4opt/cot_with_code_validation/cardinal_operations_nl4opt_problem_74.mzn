% Parameters
int: morphine_total = 3000;
int: morphine_pain = 10;
int: morphine_sleep = 6;

int: digest_pain = 3;
int: digest_sleep = 5;

int: min_pain = 50;

int: sleep_share_num = 70;  % at least 70%
int: sleep_share_den = 100;

% Variables
int: max_pain = morphine_total div morphine_pain;
int: max_sleep = morphine_total div morphine_sleep;

var 0..max_pain: pain;
var 0..max_sleep: sleep;

var 0..(digest_pain*max_pain + digest_sleep*max_sleep): total_digest;

% Constraints
constraint morphine_pain * pain + morphine_sleep * sleep <= morphine_total;

constraint pain >= min_pain;

% sleep >= 0.7 * (pain + sleep)  <=>  100*sleep >= 70*(pain+sleep)  <=>  30*sleep >= 70*pain
constraint (sleep_share_den - sleep_share_num) * sleep >= sleep_share_num * pain;

constraint total_digest = digest_pain * pain + digest_sleep * sleep;

% Objective
solve minimize total_digest;