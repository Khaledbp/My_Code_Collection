%%
% GRM Z
load ../s1_mcode_make_grm/grm_bin
n=3925;
Z = triu(ones(n),1);
Z(~~Z)=M.off;
Z=Z+Z';
Z(1:(n+1):end)=M.diag;


load ../s3_mcode_HE_regress/test_inputs X y
X(isnan(X))=1;

%%
tic
% X0=X(:,sum(isnan(X))==0);
lme = fitlmematrix(X,y,Z,[],'CovariancePattern','Isotropic');
beta1 = fixedEffects(lme);
toc

%%
figure; 
hold on
plot(beta1)
load gctares_beta b
plot(b)

