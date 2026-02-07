clc;
clear;
close all;

%% ===================== USER INPUT =====================
disp('--- USER INPUT ---');

M = input('Enter the message M: ','s');           
K = input('Enter symmetric key (number): ');      
S = input('Enter shared secret S: ','s');          

M_bytes = double(M);
S_bytes = double(S);

fprintf('\nOriginal Message: %s\n\n', M);

%% ===================== SIMPLE HASH FUNCTION =====================
% Simple hash: sum of ASCII values mod 256
hash_M = simpleHash(M_bytes);

%% ======================================================
%% (a) Encrypt Message + Hash
disp('--- Method (a): Encrypt Message + Hash ---');

data_a = [M_bytes hash_M];
cipher_a = bitxor(data_a, K);
plain_a  = bitxor(cipher_a, K);

recv_M_a    = plain_a(1:length(M_bytes));
recv_hash_a = plain_a(end);

check_hash = simpleHash(recv_M_a);

if recv_hash_a == check_hash
    disp('Authentication Successful (a)');
else
    disp('Authentication Failed (a)');
end
disp(' ');

%% ======================================================
%% (b) Encrypt Only the Hash
disp('--- Method (b): Encrypt Only Hash ---');

enc_hash_b = bitxor(hash_M, K);
dec_hash_b = bitxor(enc_hash_b, K);

check_hash = simpleHash(M_bytes);

if dec_hash_b == check_hash
    disp('Authentication Successful (b)');
else
    disp('Authentication Failed (b)');
end
disp(' ');

%% ======================================================
%% (c) Hash with Shared Secret (No Encryption)
disp('--- Method (c): Hash with Shared Secret ---');

hash_c = simpleHash([M_bytes S_bytes]);
check_hash = simpleHash([M_bytes S_bytes]);

if hash_c == check_hash
    disp('Authentication Successful (c)');
else
    disp('Authentication Failed (c)');
end
disp(' ');

%% ======================================================
%% (d) Hash with Secret + Encryption
disp('--- Method (d): Hash + Secret + Encryption ---');

data_d = [M_bytes hash_c];
cipher_d = bitxor(data_d, K);
plain_d  = bitxor(cipher_d, K);

recv_M_d    = plain_d(1:length(M_bytes));
recv_hash_d = plain_d(end);

check_hash = simpleHash([recv_M_d S_bytes]);

if recv_hash_d == check_hash
    disp('Authentication Successful (d)');
else
    disp('Authentication Failed (d)');
end

%% ===================== HASH FUNCTION =====================
function h = simpleHash(data)
    h = mod(sum(data), 256);   % Simple hash
end