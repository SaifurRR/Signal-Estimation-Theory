% Objective: Use reset operating mode of mlseeq equalizer
% to demodulate the signal and check for BER

M = 16; % modulation order;
tblen =  10; % equalizer traceback depth ?;
nsamp = 2;  %No. of samples
msgLen = 1000; % message length
Nsample = 16;

const = pammod([0:M-1],M); %generating reference constellation

%generating msg with random data: modulate and upsample the data
msgData = randi([0 M-1],msgLen,1); % generating random msg
modsig = rectpulse(msgData,Nsamp);
msgSym = qammod(msgData,M);% using PAM modulation to generate 'fig 9-pg 1599'- of paper
msgSymUp = upsample(msgSym,nsamp); % upsampling the signal

% 
channel_coefficient = [1; 0.5]; % h (1,0.5): signal estimation parameter
msgFilt = filter(channel_coefficient,1,msgSymUp); % filtering the data through a lossy channel
msgRx = awgn(msgFilt,5,'measured'); % received message  'z' after adding 'w'-as noise - following FIg 1- pg 1593
eqSym = mlseeq(msgRx,channel_coefficient,const,tblen,'rst',nsamp); % using MLSE estimation method
eqMsg = pamdemod(eqSym,M); % applying Pam-demodulation in MLSE

[nerrs ber] = biterr(msgData, eqMsg)  % calculating bit-error rate
[nsymerrs,ser] = symerr(msgSym,eqSym)  % calculating symbol-error rate

%  Symbol error probability
% binocoeff = arrayfun(@(m)nchoosek(M-1,M),M);
% sum((-1).^(M+1).*binocoeff./(M+1).*exp(-E_b/N_0.*M./(M+1)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nsample = 16;
num = ones(Nsample,1)/Nsample;
den = 1;
EbNo = 11:20; % Range of Eb/No values under study
Bit_Error_Rate = semianalytic(msgData,msgRx,'qam',M,Nsample,num,den,EbNo);

% For comparison, calculate theoretical BER.
BER_analytic = berawgn(EbNo,'qam',M);

% Plot computed BER and theoretical BER.
figure; semilogy(EbNo,Bit_Error_Rate,'k*');
hold on; semilogy(EbNo,BER_analytic,'ro');
title('Semianalytic BER Compared with Theoretical BER');
legend('Semianalytic BER with Phase Offset',...
    'Theoretical BER Without Phase Offset','Location','SouthWest');
grid on
hold off;
