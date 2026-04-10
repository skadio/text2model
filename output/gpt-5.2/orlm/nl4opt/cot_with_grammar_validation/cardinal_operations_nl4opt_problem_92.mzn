% Parameters
int: cost_ztube = 1000;
int: cost_soorchle = 200;
int: cost_wassa = 100;

int: viewers_ztube = 400000;
int: viewers_soorchle = 5000;
int: viewers_wassa = 3000;

int: budget = 10000;
int: soorchle_max_ads = 15;

% Variables
var 0..(budget div cost_ztube): z;
var 0..soorchle_max_ads: s;
var 0..(budget div cost_wassa): w;

var 0..(budget div min([cost_ztube, cost_soorchle, cost_wassa])): total_ads;

% Constraints
constraint total_ads = z + s + w;

constraint cost_ztube * z + cost_soorchle * s + cost_wassa * w <= budget;

% wassa at most one third of total: 3*w <= total_ads
constraint 3 * w <= total_ads;

% z-tube at least 5% of total: 20*z >= total_ads
constraint 20 * z >= total_ads;

% Objective
solve maximize viewers_ztube * z + viewers_soorchle * s + viewers_wassa * w;