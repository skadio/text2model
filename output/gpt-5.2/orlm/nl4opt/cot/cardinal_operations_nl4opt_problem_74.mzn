% Parameters (with values embedded)
int: morphine_total = 3000;
int: morphine_pain = 10;
int: morphine_sleep = 6;

int: digest_pain = 3;
int: digest_sleep = 5;

int: min_pain = 50;
int: sleep_share_percent = 70;

% Variables
var 0..morphine_total div morphine_pain: painkillers;
var 0..morphine_total div morphine_sleep: sleeping;

var 0..(digest_pain * (morphine_total div morphine_pain) + digest_sleep * (morphine_total div morphine_sleep)): total_digest;

% Constraints
constraint morphine_pain * painkillers + morphine_sleep * sleeping <= morphine_total;
constraint painkillers >= min_pain;

% At least 70% of pills are sleeping:
% sleeping / (painkillers + sleeping) >= 0.7  <=>  100*sleeping >= 70*(painkillers + sleeping)
constraint 100 * sleeping >= sleep_share_percent * (painkillers + sleeping);

constraint total_digest = digest_pain * painkillers + digest_sleep * sleeping;

% Objective
solve minimize total_digest;