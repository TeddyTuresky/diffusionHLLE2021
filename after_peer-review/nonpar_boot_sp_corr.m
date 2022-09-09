function [r, p1] = nonpar_boot_sp_corr(x, y, r, n)
% Generates effect sizes and p-values using non-parametric bootstrapping
% Originally written by Xi Yu. 
% For questions: theodore_turesky@gse.harvard.edu

% Inputs:
%   x     - independent variable
%   y     - dependent variable
%   n     - number of permutations


mdl = fitlm(r, y); 
r = corr(x, mdl.Residuals.Raw, 'rows', 'pairwise', 'type', 'Spearman');


for pp = 1:n
    shuffx(:,pp) = Shuffle(x); 
    perbaget(pp,1) = corr(shuffx(:,pp), mdl.Residuals.Raw,'rows','pairwise','type','Spearman'); 
end

temppt = (perbaget(:,1) > r);
p1 = sum(temppt)/n;