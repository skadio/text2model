% Parameters
% Per-dose delivery amounts
float: legs_pk1  = 0.5;
float: back_pk1  = 0.8;
float: sleep_pk1 = 0.3;

float: legs_pk2  = 0.7;
float: back_pk2  = 0.4;
float: sleep_pk2 = 0.6;

% Requirements / limits
float: max_sleep = 8.0;   % at most this much sleeping medicine
float: min_legs  = 4.0;   % at least this much medicine to legs

% Variables
% Number of doses to take (nonnegative integers)
var 0..1000: dose_pk1;
var 0..1000: dose_pk2;

% Constraints
% Sleeping medicine limit (at most max_sleep)
constraint sleep_pk1 * dose_pk1 + sleep_pk2 * dose_pk2 <= max_sleep;

% Legs medicine requirement (at least min_legs)
constraint legs_pk1 * dose_pk1 + legs_pk2 * dose_pk2 >= min_legs;

% Objective
% Maximize medicine delivered to the back
solve maximize back_pk1 * dose_pk1 + back_pk2 * dose_pk2;