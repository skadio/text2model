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
var 0..(budget div cost_ztube): ztube_ads;
var 0..min(soorchle_max_ads, budget div cost_soorchle): soorchle_ads;
var 0..(budget div cost_wassa): wassa_ads;

var 0..(budget div min(min(cost_ztube, cost_soorchle), cost_wassa)): total_ads;
var 0..(budget div min(min(cost_ztube, cost_soorchle), cost_wassa)) * max(max(viewers_ztube, viewers_soorchle), viewers_wassa): total_viewers;

% Constraints
constraint total_ads = ztube_ads + soorchle_ads + wassa_ads;

constraint cost_ztube * ztube_ads + cost_soorchle * soorchle_ads + cost_wassa * wassa_ads <= budget;

constraint soorchle_ads <= soorchle_max_ads;

% At most 1/3 of total ads on wassa: wassa_ads <= total_ads / 3  ->  3*wassa_ads <= total_ads
constraint 3 * wassa_ads <= total_ads;

% At least 5% of total ads on z-tube: ztube_ads >= 0.05*total_ads  ->  20*ztube_ads >= total_ads
constraint 20 * ztube_ads >= total_ads;

constraint total_viewers = viewers_ztube * ztube_ads + viewers_soorchle * soorchle_ads + viewers_wassa * wassa_ads;

% Objective
solve maximize total_viewers;