function digital_signature_gui_figure
clc; close all;

%% ================= MAIN INPUT GUI =================
f = figure('Name','Digital Signature using RSA (Input)',...
           'Position',[350 200 600 350],...
           'MenuBar','none',...
           'NumberTitle','off');

uicontrol(f,'Style','text','Position',[40 290 120 20],...
    'String','Message','HorizontalAlignment','left');
msgBox = uicontrol(f,'Style','edit','Position',[170 290 380 25]);

uicontrol(f,'Style','text','Position',[40 250 120 20],...
    'String','Prime p','HorizontalAlignment','left');
pBox = uicontrol(f,'Style','edit','Position',[170 250 120 25]);

uicontrol(f,'Style','text','Position',[40 210 120 20],...
    'String','Prime q','HorizontalAlignment','left');
qBox = uicontrol(f,'Style','edit','Position',[170 210 120 25]);

uicontrol(f,'Style','text','Position',[40 170 120 20],...
    'String','Public key e','HorizontalAlignment','left');
eBox = uicontrol(f,'Style','edit','Position',[170 170 120 25]);

uicontrol(f,'Style','pushbutton','Position',[350 230 200 35],...
    'String','Generate Signature','FontSize',10,...
    'Callback',@signMessage);

uicontrol(f,'Style','pushbutton','Position',[350 180 200 35],...
    'String','Verify Signature','FontSize',10,...
    'Callback',@verifySignature);

signature = [];
n = [];

%% ================= CALLBACK FUNCTIONS =================
    function signMessage(~,~)
        msg = get(msgBox,'String');
        p = str2double(get(pBox,'String'));
        q = str2double(get(qBox,'String'));
        e = str2double(get(eBox,'String'));

        msgBytes = double(msg);
        hashVal = mod(sum(msgBytes),1000);

        n = p*q;
        phi = (p-1)*(q-1);
        d = modInverse(e,phi);

        signature = modExp(hashVal,d,n);

        showOutputFigure({
            'DIGITAL SIGNATURE GENERATION'
            ['Message        : ' msg]
            ['Hash Value     : ' num2str(hashVal)]
            ['Private Key d  : ' num2str(d)]
            ['Signature      : ' num2str(signature)]
            });
    end

    function verifySignature(~,~)
        msg = get(msgBox,'String');
        e = str2double(get(eBox,'String'));

        msgBytes = double(msg);
        newHash = mod(sum(msgBytes),1000);
        verifiedHash = modExp(signature,e,n);

        if verifiedHash == newHash
            result = 'Signature VERIFIED ✅';
        else
            result = 'Signature INVALID ❌';
        end

        showOutputFigure({
            'DIGITAL SIGNATURE VERIFICATION'
            ['Recomputed Hash : ' num2str(newHash)]
            ['Verified Hash   : ' num2str(verifiedHash)]
            result
            });
    end
end

%% ================= OUTPUT FIGURE =================
function showOutputFigure(textData)
    figure('Name','Output','Position',[450 250 500 300]);
    axis off;
    text(0.05,0.9,textData,'FontSize',11,'VerticalAlignment','top');
end

%% ================= SUPPORT FUNCTIONS =================
function d = modInverse(e, phi)
    [g,x,~] = gcd(e,phi);
    d = mod(x,phi);
end

function y = modExp(base, exp, modn)
    y = 1;
    for i = 1:exp
        y = mod(y*base,modn);
    end
end