function  proofortest(type, a, b, c, proofx, setup)
% 
% Function to change the SLDV proof or test block automatically with requirement tags
%
% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu

if strcmp(type,'init')
    if proofx == 1
        temp=get_param(gcb,'MaskValues');
        temp{2}='off';
        temp{3}='on';
        set_param(gcb,'MaskValues',temp);
    elseif proofx == 0
        temp=get_param(gcb,'MaskValues');
        temp{2}='on';
        temp{3}='off';
        set_param(gcb,'MaskValues',temp);
    end
end
if (setup == 1) && strcmp(type,'init')
    x=find_system(gcb,'LookUnderMasks','On', 'SearchDepth','1','regexp','on','name','proofortest');
    bname=get_param(gcb,'Name');
    set_param(char(x),'Name',[bname '_#proofortest']);
    
    S=sfroot;    
    B = S.find('Name',[bname '_#proofortest'],'-isa','Stateflow.EMChart') ;
    BB = ['''' c ''''];
    if (proofx == 1) || (a == 0 && b == 1)
        str = sprintf(['\n sldv.prove(u,' BB ');']);
    elseif (proofx == 0) || (b == 0 && a == 1)
        str = sprintf(['\n sldv.test(u,' BB ');']);
    else
        str = ' ';
    end
    B.script = str;
end
end

