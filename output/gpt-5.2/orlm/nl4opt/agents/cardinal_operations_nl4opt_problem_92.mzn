% Parameters
int: cost_ztube = 1000;                % cost per z-tube ad ($)
int: cost_soorchle = 200;              % cost per soorchle ad ($)
int: cost_wassa = 100;                 % cost per wassa ad ($)

int: viewers_ztube = 400000;           % viewers per z-tube ad
int: viewers_soorchle = 5000;          % viewers per soorchle ad
int: viewers_wassa = 3000;             % viewers per wassa ad

int: budget = 10000;                   % weekly advertising budget ($)
int: soorchle_max_ads = 15;            % max soorchle ads allowed

% Variables
var 0..(budget div cost_ztube): ads_ztube;          % number of z-tube ads
var 0..soorchle_max_ads: ads_soorchle;             % number of soorchle ads
var 0..(budget div cost_wassa): ads_wassa;          % number of wassa ads

% total ads is bounded by spending all budget on the cheapest option
var 0..(budget div min(cost_ztube, min(cost_soorchle, cost_wassa))): total_ads;

% total audience upper bound from max feasible counts by individual limits
var 0..( (budget div cost_ztube) * viewers_ztube
       + soorchle_max_ads * viewers_soorchle
       + (budget div cost_wassa) * viewers_wassa ): total_audience;

% Constraints
% --- Total ads definition ---
constraint
  total_ads = ads_ztube + ads_soorchle + ads_wassa;

% --- Budget limit ---
constraint
  cost_ztube * ads_ztube
+ cost_soorchle * ads_soorchle
+ cost_wassa * ads_wassa
<= budget;

% --- Soorchle cap (already enforced by domain, kept for clarity) ---
constraint
  ads_soorchle <= soorchle_max_ads;

% --- Balance constraint: at most one third of total ads on wassa ---
% Integer-safe form: wassa <= total/3  <=>  3*wassa <= total
constraint
  3 * ads_wassa <= total_ads;

% --- Balance constraint: at least 5% of total ads on z-tube ---
% Integer-safe form: z-tube >= 0.05*total  <=>  20*z-tube >= total
constraint
  20 * ads_ztube >= total_ads;

% --- Total audience definition ---
constraint
  total_audience =
    viewers_ztube * ads_ztube
  + viewers_soorchle * ads_soorchle
  + viewers_wassa * ads_wassa;

% Objective
solve maximize total_audience;