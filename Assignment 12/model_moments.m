function mm = model_moments(estimates,ADPRICE)

delta1 = estimates(1);
delta2 = estimates(2);
q = estimates(3);

pSTAR = ADPRICE(length(ADPRICE)) + delta1;
pLBAR = ADPRICE(1) - delta2;

r = pLBAR / (1 - q) - (q / (2 * (1 - q))) * (pLBAR + pSTAR);

p50 = (1 -  q) * r + q * pSTAR;
p25 = 2 * (1 - q) * (1 - 1/4) / (2 * (1 - q) * (1 - 1/4) + q) * r + q / (2 * (1 - q) * (1 - 1/4) + q) * pSTAR;
p75 = 2 * (1 - q) * (1 - 3/4) / (2 * (1 - q) * (1 - 3/4) + q) * r + q / (2 * (1 - q) * (1 - 3/4) + q) * pSTAR;

mm = [p25 p50 p75];