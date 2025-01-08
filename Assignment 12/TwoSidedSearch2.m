clear

%%%%%%%%%%%%%%%%%%%%%%%%%%
% create vectors of data %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% a vector of advertised prices for a Breville Cafe Roma Espresso Machine
ADPRICE = sort([223.99; 279.99; 199.99; 199.99; 224.99; 279.99; 209.99; 279.99; 243.10; 249.98; 299.99; 305.21; 314.99; 329.40; 403.56]);
N = length(ADPRICE);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the empirical CDF %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate the empirical CDF of advertised prices
ADECDF = ecdf(ADPRICE);

F1 = figure(1);
stairs([0; unique(ADPRICE)],ADECDF);
lines = get(gca,'children');
set(lines,'LineWidth',2)
set(gca,'fontsize',18)
xlabel({'posted price (CAD)'},'FontSize',18)
ylabel({'CDF'},'FontSize',18)
xlim([180 420]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameterization of the Burdett-Judd model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set pSTAR and pLBAR as the highest and the lowest observed prices
pSTAR = ADPRICE(N);
pLBAR = ADPRICE(1);

% try different values of q
qVALUES = [0.3 0.5343 0.8];

for j = 1:3

    q = qVALUES(j);

    % pLBAR, pSTAR, and q imply a value for r (because of equal profit)
    r = pLBAR / (1 - q) - (q / (2 * (1 - q))) * (pLBAR + pSTAR)

    % plot the CDF implied by the theory
    pSTEP = (pSTAR-pLBAR)/100;
    for p = pLBAR:pSTEP:pSTAR

        pGRID(round((p-pLBAR)/pSTEP)+1,1) = p;
        FGRID(round((p-pLBAR)/pSTEP)+1,1) = 1 - (1/2) * (q / (1 - q)) * ((pSTAR - p) / (p - r));

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % recovering the search cost, c %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % CDF of one sampled price
    F11 = FGRID;

    % CDF of min of two sampled prices
    F12 = 1 - (1 - FGRID).^2;

    % expected minimum price:
    Ep11 = pGRID' * diff([0; F11])
    Ep12 = pGRID' * diff([0; F12])

    % set c = Delta_1(1) = Ep11 - Ep12
    c = Ep11 - Ep12

    FGRIDS(:,j) = FGRID;
    cVALUES(1,j) = c;
    rVALUES(1,j) = r;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the empirical and theoretical CDFs %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F2 = figure(2);
plot1 = stairs([0; unique(ADPRICE)],ADECDF); hold on
plot2 = plot(pGRID,FGRIDS(:,1));
plot3 = plot(pGRID,FGRIDS(:,2));
plot4 = plot(pGRID,FGRIDS(:,3));
lines = get(gca,'children');
set(lines,'LineWidth',2)
set(gca,'fontsize',18)
xlabel({'posted price, p'},'FontSize',18)
ylabel({'CDF'},'FontSize',18)
xlim([180 420]);
ylim([0 1]);
legend([plot1 plot2 plot3 plot4], {'empirical CDF','parameterized CDF with q = 0.30','parameterized CDF with q = 0.5343','parameterized CDF with q = 0.80'},'Location','southeast','FontSize',14)
