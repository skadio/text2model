% Parameters
% Budget caps (units)
int: max_budget_online_offline = 5000;
int: max_budget_social_email  = 3000;

% Minimum difference requirements (units)
int: min_diff_online_offline = 1000;   % Online_Ad >= Offline_Ad + 1000
int: min_diff_social_email   = 500;    % Social_Media_Ad >= Email_Marketing + 500

% Cost per unit effectiveness (dollars per unit)
int: cost_online  = 20;
int: cost_offline = 30;
int: cost_social  = 10;
int: cost_email   = 15;

% Operational upper bounds (units)
int: max_online  = 3000;
int: max_offline = 2000;
int: max_social  = 1500;
int: max_email   = 1500;


% Variables
% Allocation decisions (whole units)
var 0..max_online:  online_units;     % Online_Ad units allocated
var 0..max_offline: offline_units;    % Offline_Ad units allocated
var 0..max_social:  social_units;     % Social_Media_Ad units allocated
var 0..max_email:   email_units;      % Email_Marketing units allocated

% Total cost (dollars)
var 0..(cost_online*max_online + cost_offline*max_offline + cost_social*max_social + cost_email*max_email): total_cost;


% Constraints
% --- Budget cap constraints (combined channel limits) ---
constraint online_units + offline_units <= max_budget_online_offline;
constraint social_units + email_units   <= max_budget_social_email;

% --- Strategy / minimum difference constraints (relative allocations) ---
constraint online_units >= offline_units + min_diff_online_offline;
constraint social_units >= email_units   + min_diff_social_email;

% --- Total cost definition (link allocations to total dollars spent) ---
constraint total_cost =
    cost_online  * online_units +
    cost_offline * offline_units +
    cost_social  * social_units +
    cost_email   * email_units;


% Objective
solve minimize total_cost;