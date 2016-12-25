function out = Rec18(Rec)
%
% ABAQUS pore or acoustic pressure output to MATLAB
% 
% Syntax
%     #Rec# = Fil2str('*.fil');
%     #out# = Rec18(#Rec#)
%
% Description
%     Read pore or acoustic pressure output from the results (*.fil) file
%     generated from the ABAQUS finite element software. The asterisk (*)
%     is replaced by the name of the results file. The record key for pore
%     or acoustic pressure output is 18 (only in ABAQUS/Standard). See
%     section < < Results file output format > > in ABAQUS Analysis User's manual
%     for more details.
%     The following options with parameters have to be specified in the
%     ABAQUS input file for the results (*.fil) file to be created and to
%     contain pore or acoustic pressure results:
%         ...
%         *FILE FORMAT, ASCII
%         *EL FILE
%         POR
%         ...
%     NOTE: The results file (*.fil) must be placed in the same directory
%     with the MATLAB source files in order to be processed.
%     
% Input parameters
%     #Rec# (string) is an one-row string containing the ASCII code of the
%         ABAQUS results (*.fil) file. It is generated by the function
%         Fil2str.m.
% 
% Output parameters
%     #out# ([#n# x 1]) is a double array containing the attributes of
%         the record key 18 as follows:
%         Column  1  �  Liquid pressure. 
%         where #n# is the number of elements multiplied by the number of
%         integration points multiplied by the number of increments. If the
%         results file does not contain the desired output, #out# will be
%         an empty array
%
% _________________________________________________________________________
% Abaqus2Matlab - www.abaqus2matlab.com
% Copyright (c) 2016 by George Papazafeiropoulos
%
% If using this toolbox for research or industrial purposes, please cite:
% G. Papazafeiropoulos, M. Muniz-Calvente, E. Martinez-Paneda.
% Abaqus2Matlab: a novel tool for finite element post-processing (submitted)
%
%

ind = strfind(Rec,'I 218D'); % record key for element pore or acoustic pressure output (18)
if isempty(ind)
    out=[];
    return;
end
nextpos=numel('I 218')+1;
for i=1:numel(ind)
    % check ind
    Rec2=Rec(ind(i)-7:ind(i));
    indNW=strfind(Rec2,'*'); % record starting position
    % ensure that the record exists and that the record type key is at
    % location 2
    if isempty(indNW) || indNW>3
        ind(i)=NaN;
        continue;
    end
end
ind(isnan(ind))=[];
EleOut=zeros(numel(ind),1);
for i=1:numel(ind)
    ind2=ind(i)+nextpos-2;
    % Element pore or acoustic pressure
    ind1=ind2+1+1; % +1 character+1
    ind2=ind2+1+22; % +1 character +22 floating point digits
    EleOut(i)=str2num(Rec(ind1:ind2));
end
% Assembly of matrices for output
out=EleOut;

end

