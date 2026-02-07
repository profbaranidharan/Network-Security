function rsa_gui
clc;
close all;

%% ================= GUI WINDOW =================
f = figure('Name','RSA Algorithm GUI',...
           'NumberTitle','off',...
           'Position',[300 150 550 450]);

%% ================= INPUT FIELDS =================
uicontrol(f,'Style','text','Position',[40 390 120 20],'String','Prime p');
pBox = uicontrol(f,'Style','edit','Position',[180 390 120 25]);

uicontrol(f,'Style','text','Position',[40 355 120 20],'String','Prime q');
qBox = uicontrol(f,'Style','edit','Position',[180 355 120 25]);

uicontrol(f,'Style','text','Position',[40 320 120 20],'String','Public key e');
eBox = uicontrol(f,'Style','edit','Position',[180 320 120 25]);

%% ================= KEY OUTPUT =================
uicontrol(f,'Style','text','Position',[40 280 120 20],'String','Modulus n');
nBox = uicontrol(f,'Style','edit','Position',[180 280 120 25],'Enable','inactive');

uicontrol(f,'Style','text','Position',[40 245 120 20],'String','Private key d');
dBox = uicontrol(f,'Style','edit','Position',[180 245 120 25],'Enable','inactive');

%% ================= MESSAGE =================
uicontrol(f,'Style','text','Position',[40 200 120 20],'String','Plaintext M');
mBox = uicontrol(f,'Style','edit','Position',[180 200 120 25]);

uicontrol(f,'Style','text','Position',[40 165 120 20],'String','Ciphertext C');
cBox = uicontrol(f,'Style','edit','Position',[180 165 120 25],'Enable','inactive');

uicontrol(f,'Style','text','Position',[40 130 120 20],'String','Decrypted M');
decBox = uicontrol(f,'Style','edit','Position',[180 130 120 25],'Enable','inactive');

%% ================= BUTTONS =================
uicontrol(f,'Style','pushbutton','String','Generate Keys',...
    'Position',[350 350 160 40],'FontSize',10,'Callback',@generateKeys);

uicontrol(f,'Style','pushbutton','String','Encrypt',...
    'Position',[350 290 160 40],'FontSize',10,'Callback',@encryptMsg);

uicontrol(f,'Style','pushbutton','String','Decrypt',...
    'Position',[350 230 160 40],'FontSize',10,'Callback',@decryptMsg);

%% ================= CALLBACK FUNCTIONS =================
    function generateKeys(~,~)
        p = str2double(pBox.String);
        q = str2double(qBox.String);
        e = str2double(eBox.String);

        if isnan(p) || isnan(q) || isnan(e)
            errordlg('Enter valid numeric values for p, q, and e');
            return;
        end

        n = p * q;
        phi = (p - 1) * (q - 1);

        if gcd(e,phi) ~= 1
            errordlg('e must be coprime with φ(n)');
            return;
        end

        d = modInverse(e,phi);

        nBox.String = num2str(n);
        dBox.String = num2str(d);
    end

    function encryptMsg(~,~)
        if isempty(nBox.String)
            errordlg('Generate keys first!');
            return;
        end

        M = str2double(mBox.String);
        e = str2double(eBox.String);
        n = str2double(nBox.String);

        if isnan(M) || M >= n
            errordlg('Plaintext must be a number less than n');
            return;
        end

        C = modExp(M,e,n);
        cBox.String = num2str(C);
    end

    function decryptMsg(~,~)
        if isempty(cBox.String)
            errordlg('Encrypt message first!');
            return;
        end

        C = str2double(cBox.String);
        d = str2double(dBox.String);
        n = str2double(nBox.String);

        M = modExp(C,d,n);
        decBox.String = num2str(M);
    end
end

%% ================= SUPPORT FUNCTIONS =================
function y = modExp(b,e,n)
    y = 1;
    b = mod(b,n);
    while e > 0
        if mod(e,2)==1
            y = mod(y*b,n);
        end
        e = floor(e/2);
        b = mod(b*b,n);
    end
end

function d = modInverse(e,phi)
    for k = 1:phi
        if mod(e*k,phi)==1
            d = k;
            return;
        end
    end
    error('No modular inverse found');
end