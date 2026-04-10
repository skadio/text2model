% Parameters
int: max_budget_online_offline = 5000;          % Max combined units for Online_Ad + Offline_Ad
int: max_budget_social_email  = 3000;          % Max combined units for Social_Media_Ad + Email_Marketing

int: min_diff_online_offline = 1000;           % Online_Ad >= Offline_Ad + 1000
int: min_diff_social_email  = 500;             % Social_Media_Ad >= Email_Marketing + 500

int: cost_online  = 20;                        % $/unit Online_Ad
int: cost_offline = 30;                        % $/unit Offline_Ad
int: cost_social  = 10;                        % $/unit Social_Media_Ad
int: cost_email   = 15;                        % $/unit Email_Marketing

int: max_online  = 3000;                       % Upper bound Online_Ad units
int: max_offline = 2000;                       % Upper bound Offline_Ad units
int: max_social  = 1500;                       % Upper bound Social_Media_Ad units
int: max_email   = 1500;                       % Upper bound Email_Marketing units

% Variables
var 0..max_online:  online_ad;                 % Units allocated to Online Advertising
var 0..max_offline: offline_ad;                % Units allocated to Offline Advertising
var 0..max_social:  social_media_ad;           % Units allocated to Social Media Advertising
var 0..max_email:   email_marketing;           % Units allocated to Email Marketing

% Aggregate variables for combined budgets (in units)
var 0..max_budget_online_offline: budget_online_offline;
var 0..max_budget_social_email:  budget_social_email;

% Total cost in dollars (integer)
var 0..(
  cost_online*max_online +
  cost_offline*max_offline +
  cost_social*max_social +
  cost_email*max_email
): total_cost;

% Constraints
% --- Combined budget definitions (link aggregate variables to decision variables) ---
constraint budget_online_offline = online_ad + offline_ad;
constraint budget_social_email   = social_media_ad + email_marketing;

% --- Combined budget upper limits (campaign budget caps) ---
constraint budget_online_offline <= max_budget_online_offline;
constraint budget_social_email   <= max_budget_social_email;

% --- Strategy requirements (minimum differences between paired channels) ---
constraint online_ad - offline_ad >= min_diff_online_offline;
constraint social_media_ad - email_marketing >= min_diff_social_email;

% --- Total cost definition (linear cost of allocations) ---
constraint total_cost =
    cost_online  * online_ad
  + cost_offline * offline_ad
  + cost_social  * social_media_ad
  + cost_email   * email_marketing;

% Objective
solve minimize total_cost;