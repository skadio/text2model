% Parameters
int: cost_online = 20;
int: cost_offline = 30;
int: cost_social = 10;
int: cost_email = 15;

int: max_online_offline_sum = 5000;
int: max_social_email_sum = 3000;

int: min_online_minus_offline = 1000;
int: min_social_minus_email = 500;

int: max_online = 3000;
int: max_offline = 2000;
int: max_social = 1500;
int: max_email = 1500;

% Variables
var 0..max_online: Online_Ad;
var 0..max_offline: Offline_Ad;
var 0..max_social: Social_Media_Ad;
var 0..max_email: Email_Marketing;

var 0..(cost_online*max_online + cost_offline*max_offline + cost_social*max_social + cost_email*max_email): Total_Cost;

% Constraints
constraint Online_Ad + Offline_Ad <= max_online_offline_sum;
constraint Social_Media_Ad + Email_Marketing <= max_social_email_sum;

constraint Online_Ad - Offline_Ad >= min_online_minus_offline;
constraint Social_Media_Ad - Email_Marketing >= min_social_minus_email;

constraint Total_Cost =
  cost_online * Online_Ad
+ cost_offline * Offline_Ad
+ cost_social * Social_Media_Ad
+ cost_email * Email_Marketing;

% Objective
solve minimize Total_Cost;