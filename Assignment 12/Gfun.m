function G = GfunPARAMS(estimates,ADPRICE)

pSTAR = ADPRICE(length(ADPRICE)) + estimates(1);
pLBAR = ADPRICE(1) - estimates(2);
q = estimates(3);
r = (2 - q) / (2 * (1 - q)) * pLBAR - q / (2 * (1 - q)) * pSTAR;

pSTEP = (pSTAR-pLBAR)/100000;
for p = pLBAR:pSTEP:pSTAR

    pGRID(round((p-pLBAR)/pSTEP)+1,1) = p;
    FGRID(round((p-pLBAR)/pSTEP)+1,1) = 1 - (1/2) * (q / (1 - q)) * ((pSTAR - p) / (p - r));

end

% CDF of one sampled price
F11 = FGRID;
% CDF of min of two sampled prices
F12 = 1 - (1 - FGRID).^2;

% expected minimum price:
Ep11 = pGRID' * diff([0; F11]);
Ep12 = pGRID' * diff([0; F12]);

% set c = Delta_1(1) = Ep11 - Ep12
c = Ep11 - Ep12;

G = [pSTAR r c];