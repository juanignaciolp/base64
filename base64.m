
function strOut=base64(strIn,decoder_func,varargin)
% Simple Base64 encoder/decoder.
% 
% USE: strOut=base64(strIn,decoder_func,[verbose])
%      strIn: Input string.
%      decoder_func: string indicating the encoder/decoder action.
%             decoder_func='encode': strIn is Base64 encoded.
%                Encoded characters are [A-Z,a-z,0-9,'+','/']
%             decoder_func='decode': Base64 encoded strIn is decoded into
%                a string of 8 bits ASCII chars
%      verbose: verbose flag. If verbose=true, strOut is printed in console
%      strOut: Output string. If encoded string is larger than 64 chars, 
%             it is splitted in 64 chars length lines delimited by '\n' 
%              (char(10)) character.
%             
%-----------Coded by Juan Ignacio Fernández M. -2022- ----------------------
assert (nargin<=3,'Incorrect number of parameters. See help base64/USE.');
if ~isempty(varargin)
    verbose=varargin{1};
else
    verbose=false;
end
if strcmp(decoder_func,'encode')
    %encoder
    dicbase64=[65:90,97:122,48:57,'+','/']; %ASCII codes of dictionary of 
                                            %pintable chars
    str=strIn;
    %Complete the binary str length with zeros so that is is divisible by 6
    append_chars=mod(length(str),3); % 3*8=24 is the MCM of 8 and 6 
    num_of_equal_signs=0;
    num_of_zeros=0;      
    if append_chars
        num_of_equal_signs=3-append_chars; %# of equal signs to append to the output str.
        num_of_zeros=2*(num_of_equal_signs); %# of zeros to append to the bnary string.
    end
    binstr=dec2bin(str,8)'; %convert each char to an 8bit ASCII number
    binstr=[binstr(:)' '0'*ones(1,num_of_zeros)]; 
    binstr=reshape(binstr,6,[]); %reshape binary string into 6-bits columns 
    %Encode and add equal signs at the end if necessary
    base64str=[dicbase64(bin2dec(binstr')+1) '='*ones(1,num_of_equal_signs)];
    %wrapp into 64 chars lines long
    if length(base64str)>64 
        n_LF=floor(length(base64str)/64);
        remaining_text=base64str(end-rem(length(base64str),64)+1:end);
        dummy=[];
        for k=1:n_LF
            dummy=[dummy base64str((k-1)*64+1:64*k) '\n'];
        end
        base64str=sprintf([dummy remaining_text]);
        if base64str(end)==newline
            base64str(end)='';
        end
    end
    strOut=base64str;
    if verbose==true
        fprintf(1,['\nBase64 encoded string: ' '\n'  base64str '\n']);
    end
    
elseif  strcmp(decoder_func,'decode')
    % decoder
    dicbase64=[65:90,97:122,48:57,'+','/'];
    revdicbase64=char(dicbase64); %reverse list
    base64str=strIn;
    base64str([strfind(base64str,newline) strfind(base64str,sprintf('\r'))])='';%Eliminate any LF or NL chars
    num_of_equal_signs=sum(base64str(end-2:end)=='='); 
    num_of_zeros=2*(num_of_equal_signs);
    base64str=base64str(1:end-num_of_equal_signs);% Eliminate '=' signs
    [~,pos]=ismember(base64str',revdicbase64); %reverse map the chars
    assert(not(any(pos==0)),'Input string must be a Base64 encoded sting.'); %Is the input string a valid Code64 string?
    %re-encode 6bits chars into 8 bit ASCII chars
    binstr=dec2bin(pos-1,6)'; 
    binstr=binstr(:);
    binstr=binstr(1:end-num_of_zeros);
    binstr=reshape(binstr,8,[]);
    str=char(bin2dec(binstr'))';
    strOut=str;
    if verbose==true
        fprintf(1,['\nBase64 decoded string: ' '\n'  str '\n']);
    end
else
    assert (any([isequal(decoder_func,'encode'),isequal(decoder_func,'decode')]),...
        'decoder_func must be equal to "decode" or "encode". See help base64/USE.')
end
