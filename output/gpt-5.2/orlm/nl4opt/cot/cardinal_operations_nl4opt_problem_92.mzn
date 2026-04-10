% Parameters (with values embedded)
int: cost_ztube = 1000;
int: cost_soorchle = 200;
int: cost_wassa = 100;

int: viewers_ztube = 400000;
int: viewers_soorchle = 5000;
int: viewers_wassa = 3000;

int: budget = 10000;
int: max_soorchle_ads = 15;

% Upper bound on total ads (from cheapest ad cost)
int: max_total_ads = budget div min([cost_ztube, cost_soorchle, cost_wassa]);

% Variables
var 0..max_total_ads: ztube_ads;
var 0..max_soorchle_ads: soorchle_ads;
var 0..max_total_ads: wassa_ads;

var 0..max_total_ads: total_ads;

% Constraints
constraint total_ads = ztube_ads + soorchle_ads + wassa_ads;

constraint cost_ztube * ztube_ads
         + cost_soorchle * soorchle_ads
         + cost_wassa * wassa_ads <= budget;

% At most a third of total ads on wassa:  wassa_ads <= total_ads / 3  ->  3*wassa_ads <= total_ads
constraint 3 * wassa_ads <= total_ads;

% At least 5% on z-tube: ztube_ads >= 0.05 * total_ads -> 20*ztube_ads >= total_ads
constraint 20 * ztube_ads >= total_ads;

% Objective
var int: total_audience =
    viewers_ztube * ztube_ads + viewers_soorchle * soorchle_ads + viewers_wassa * wassa_ads;

solve maximize total_audience;