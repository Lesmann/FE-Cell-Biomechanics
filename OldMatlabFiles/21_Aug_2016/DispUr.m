function [ f, x, y1, y2, r, LF ] = DispUr( R, r, n, Ur, leg, f )

% Display U(r) plot

dr = (R-r)/n; % degree-interval for averaging
radi = r+dr : dr : R-2*dr;
lleg = length(leg);

% Prepare legend for display
for i = 1 : lleg
    currleg = leg{i};
    leg{i} = strrep(currleg, '_', '');
end

figure(f)
% plot main graph
hold on

ax1 = loglog(radi, Ur, 'LineWidth', 1.5);
% axis([min(radi), min(min(Ur)), max(radi), max(max(Ur))]),

for i = 1 : lleg
    Urr = Ur(i, :);
    rrange = round(length(Urr)/12) : round(1*length(Urr)/6);
    [LF(i), intercept] = logfit(radi(rrange),Urr(rrange),'loglog');
    yfit = (10^intercept)*radi.^(LF(i));
    lslope = real(log(LF(i)));
    fit = strcat('logfit = ', num2str(LF(i)));
    leg = horzcat(leg, fit);
end

% set( gca, 'XTick', 0: 0.05 : max(radi) ),
% set( gca, 'YTick', min(min(Ur)): 1e-4 : max(max(Ur)) ),
title('Average U(r)', 'FontSize', 16)
xlabel('Radial Distance, r/a', 'FontSize', 16),
ylabel('Radial Displacement, u/a', 'FontSize', 16)
grid on,

% % plot 1st subset
% handax1 = axes('position', [0.2 0.35 0.05 0.1]);
% x = radi;
% y1 = x.^(-2);
% r = mean(-log(Ur)/log(x));
% loglog(x, y1, 'black');
% % set(gca, 'XTick', []), set(gca, 'YTick', [])
% title('-2', 'FontSize', 16),
% set(handax1, 'box', 'off');
% set(gca,'Color','None')
% 
% % plot 2nd subset
% handax2 = axes('position', [0.2 0.2 0.05 0.1]);
% y2 = x.^(-0.52);
% loglog(x, y2, 'black');
% % set(gca, 'XTick', []), set(gca, 'YTick', [])
% title('-0.52', 'FontSize', 16),
% set(handax2, 'box', 'off');
% set(gca,'Color','None')
% linkaxes([ax1, handax1, handax2], 'xy')

% plot 1st subset
x=linspace(min(radi)*1.7,min(radi)*2.3,10);
y1=(10^(-6.8))*x.^(-2);
% loglog(x,y1, 'LineWidth', 1.5);

% plot 2nd subset
y2=(10^(-4.1))*x.^(-0.5);
% loglog(x,y2, 'LineWidth', 1.5);

legend(leg, 'FontSize', 14)

hold off
f = f + 1;
