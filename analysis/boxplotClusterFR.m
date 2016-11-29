function [bpfigh, ByFam, ByStat] = boxplotClusterFR(txtS,txtL)  %,plotparameters)
% function [bpfigh, ByFam, ByStat] = boxplotClusterFR(txtS,txtL)
% boxplotClusterFR   Plots distributions of firing rates (or any stat) grouping by Family & Statistics
%   txtS, txtL (double, 15x40): firing rates from each trial, as produced by processClusterFR
%        e.g., [base,txtS,txtL,motifs] = processClusterFR('sptrains_unit31.mat','B1040_3');
% ** Currently assumes 10 trials, 5 famililes (Applause, BubWater, Sparrows, Starlings, Wind),
%    4 statistical models (Noise, Marginals, Full Stats, Originals)

texturelabels = {'App','Bub','Spar','Star','Wind'};
App = [txtS(1:3,:); txtL(1:3,:)];
Bub = [txtS(4:6,:); txtL(4:6,:)];
Spar = [txtS(7:9,:); txtL(7:9,:)];
Star = [txtS(10:12,:); txtL(10:12,:)];
Wind = [txtS(13:15,:); txtL(13:15,:)];
ByFam = [App(:) Bub(:) Spar(:) Star(:) Wind(:)];
ByFam(~isfinite(ByFam)) = NaN;

statlabels = {'Noise','Marg','Full','Orig'};
Noise = [txtS(:,1:10); txtL(:,1:10)];
Marg = [txtS(:,11:20); txtL(:,11:20)];
Full = [txtS(:,21:30); txtL(:,21:30)];
Orig = [txtS(:,31:40); txtL(:,31:40)];
ByStat = [Noise(:) Marg(:) Full(:) Orig(:)];
ByStat(~isfinite(ByStat)) = NaN;

bpfigh=figure();
subplot(1,2,1),boxplot(ByFam,'labels',texturelabels)   %,'plotstyle','compact')
subplot(1,2,2),boxplot(ByStat,'labels',statlabels)     %,'plotstyle','compact')
%   plotparameters (optional, cellstr): stuff to pass to boxplot, like figure title, etc.