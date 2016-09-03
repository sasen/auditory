function texturePSTH(PSTHs, smoothsize, stimdur, binsize, figtitle)
% texturePSTH plots panels of PSTHs for a texture x duration
% texturePSTH(PSTHs, smoothsize, stimdur, binsize)
% PSTHs: num array, PSTH in rows in the right order
% smoothsize: int, smoothing kernel size in bins, for PSTH
% stimdur: double, stimulus duration in seconds
% binsize: double, duration of a PSTH bin, in seconds
% figtitle: str, to use as figure title

pp = 2;   % prepost duration, in seconds

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);

tAx = [-pp : binsize : stimdur+pp];  % has one extra bin!
[maxfam, maxstats, maxIDs, psthbins] = size(PSTHs);
for f = 1:maxfam
  for s = 1:maxstats
    pltidx = sub2ind([maxstats,maxfam],s,f);  % fprintf('%d %d %d\n',f, s, pltidx);
    subplot(maxfam,maxstats,pltidx); hold on
    allIDs = squeeze(PSTHs(f,s,:,:))';
    plot(tAx(1:end-1), (reshape(smooth(allIDs(:), smoothsize),psthbins,maxIDs)' + repmat([2 1 0]',1,psthbins)) );
    axis([-pp, stimdur+pp, 0, 3])
    line([0 0; stimdur stimdur]',[0 3; 0 3]','Color',[0 0 0])
    line(repmat([-pp; stimdur+pp],1,3), [0 1 2; 0 1 2],'Color',[0 0 0])
    if f==1 && s==1
      title('Noise'); ylabel('Applause')
    elseif f==1 && s==2
      title('Marginals');
    elseif f==1 && s==3
      title('Full Stats')
    elseif f==1 && s==4
      title('Original')
    elseif s==1 && f==2
      ylabel('Bubwater')
    elseif s==1 && f==3
      ylabel('Sparrows')
    elseif s==1 && f==4
      ylabel('Starlings')
    elseif s==1 && f==5
      ylabel('Wind')
    end   % if edge subplot
  end % for stats
end % for fams
subplotsqueeze(gcf,1.2)
suptitle(figtitle)
