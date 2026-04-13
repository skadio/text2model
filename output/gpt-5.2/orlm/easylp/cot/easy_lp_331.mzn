% Parameters (with values embedded)
int: cost_advertising = 5;
int: cost_pr = 2;
int: cost_online = 3;
int: cost_offline = 4;

int: max_advertising = 6000;
int: max_pr = 4000;
int: max_online = 3000;
int: max_offline = 7000;

int: max_adv_plus_pr = 10000;
int: min_online_plus_offline = 2000;
int: max_diff_adv_online = 5000;
int: min_diff_pr_offline = -1000;

% Variables
var 0..max_advertising: Advertising;
var 0..max_pr: PR;
var 0..max_online: OnlineMarketing;
var 0..max_offline: OfflineMarketing;

var int: TotalCost;

% Constraints
constraint Advertising + PR <= max_adv_plus_pr;
constraint OnlineMarketing + OfflineMarketing >= min_online_plus_offline;

constraint Advertising - OnlineMarketing <= max_diff_adv_online;
constraint OnlineMarketing - Advertising <= max_diff_adv_online; % |Advertising-OnlineMarketing| <= 5000

constraint PR - OfflineMarketing >= min_diff_pr_offline;

constraint TotalCost =
    cost_advertising * Advertising
  + cost_pr * PR
  + cost_online * OnlineMarketing
  + cost_offline * OfflineMarketing;

% Objective
solve minimize TotalCost;