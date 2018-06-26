prdct= csvread("prdct.csv");
prdct= flip(prdct,1);
realdta= csvread("realdta.csv");
realdta= flip(realdta,1);
load spine
%%
figure
image(prdct)
x = max(max(prdct));
caxis([0 x])
colormap hot;
col = colormap;
col = flipud(col);
colormap(col);
colorbar
caxis([0 60])
title("Prediction: total number of cirmes")


figure
image(realdta)
colormap hot;
col = colormap;
col = flipud(col);
colormap(col);
colorbar
caxis([0 60])
title("Reality: total number of cirmes")

%% vancouver crime map
num = xlsread('crime_combined1','E2:F502418');
cn = 15;
rw = 13;
figure
plot(num(:,1),num(:,2),'.')
minx = 4.83705e05;
maxx = 4.98306e05;
miny = 5.4498e06;
maxy = 5.4623e06;
axis([minx maxx miny maxy])
%edit axis properties, tricks, by below two numbers, so that will give you
%the right grid on
xtris = (maxx-minx)/cn;
ytris = (maxy-miny)/rw;
xlabel("X")
ylabel("Y")
% grid on
% set(gca,'LineWid',2)

%% per hour
prdct_hour= csvread("prdct_hour.csv");
prdct_hour= flip(prdct_hour,1);
realdta_hour= csvread("realdta_hour.csv");
realdta_hour= flip(realdta_hour,1);
load spine

figure
image(prdct_hour)
x = max(max(prdct_hour));
colormap hot;
col = colormap;
col = flipud(col);
colormap(col);
colorbar
caxis([0 60])
title("Prediction: cirmes per hour summed over a month")


figure
image(realdta_hour)
colormap hot;
col = colormap;
col = flipud(col);
colormap(col);
caxis([0 60])
colorbar
title("Reality: cirmes per hour summed over a month")
