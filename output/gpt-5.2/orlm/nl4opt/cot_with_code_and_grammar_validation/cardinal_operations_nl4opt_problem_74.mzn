% Parameters
int: morphine_total = 3000;
int: morphine_per_pain = 10;
int: morphine_per_sleep = 6;

int: digest_per_pain = 3;
int: digest_per_sleep = 5;

int: min_pain = 50;
int: sleep_share_pct = 70;

% Variables
var 0..(morphine_total div morphine_per_pain): pain;
var 0..(morphine_total div morphine_per_sleep): sleep;
var 0..(digest_per_pain * (morphine_total div morphine_per_pain)
      + digest_per_sleep * (morphine_total div morphine_per_sleep)): total_digest;

% Constraints
constraint morphine_per_pain * pain + morphine_per_sleep * sleep <= morphine_total;

constraint pain >= min_pain;

% at least 70% sleeping: sleep / (pain + sleep) >= 0.7  ->  100*sleep >= 70*(pain+sleep)
constraint 100 * sleep >= sleep_share_pct * (pain + sleep);

constraint total_digest = digest_per_pain * pain + digest_per_sleep * sleep;

% Objective
solve minimize total_digest;