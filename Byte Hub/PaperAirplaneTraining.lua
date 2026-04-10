-- This script was generated using the MoonVeil Obfuscator v1.4.5 [https://moonveil.cc]

local za,z,Yc,La,Nc,Oa=pairs,getmetatable,type,bit32.bxor
local X,nb,R,Qa,sb,P,Ya,K,q,_d,E,Vc,Da,O,A,k,nc,qc,ad,d_,Wb,ka,ca,Wa,hb,qb,Gb,dc,gc,wc,tb,l_,ic,Va,D,sa,i_,S,H,Sc;
S=(getfenv());
Gb,qc,qb=(string.char),(string.byte),(bit32 .bxor);
ca=function(Tc,g)
    local Rb,ra,Z,Ea,Nb,rb,cb,Y;
    rb,Z=function(qa,ua,Qc)
        Z[Qc]=La(ua,12883)-La(qa,36542)
        return Z[Qc]
    end,{};
    Y=Z[-22313]or rb(24786,118900,-22313)
    repeat
        if Y<=58651 then
            if Y>47054 then
                ra,Y=ra..Gb(qb(qc(Tc,(Nb-229)+1),qc(g,(Nb-229)%#g+1))),Z[27829]or rb(12223,71476,27829)
            elseif Y>33894 then
                return ra
            elseif Y>32942 then
                Rb=Rb+Ea;
                Nb=Rb
                if Rb~=Rb then
                    Y=Z[6125]or rb(39186,64809,6125)
                else
                    Y=Z[-19099]or rb(10559,103400,-19099)
                end
            else
                Nb=Rb
                if cb~=cb then
                    Y=Z[-26354]or rb(64388,73563,-26354)
                else
                    Y=Z[25247]or rb(65223,88288,25247)
                end
            end
        elseif Y>62395 then
            if(Ea>=0 and Rb>cb)or((Ea<0 or Ea~=Ea)and Rb<cb)then
                Y=Z[-18713]or rb(2882,69529,-18713)
            else
                Y=Z[-12768]or rb(12392,102818,-12768)
            end
        else
            ra='';
            cb,Rb,Ea,Y=(#Tc-1)+229,229,1,32942
        end
    until Y==14873
end;
_d=(select);
nb=(function(...)
    return{[1]={...},[2]=_d('#',...)}
end);
E=((function()
    local function va(ec,n_,Ac)
        if n_>Ac then
            return
        end
        return ec[n_],va(ec,n_+1,Ac)
    end
    return va
end)());
A,Qa=(string.gsub),(string.char);
P=(function(Na)
    Na=A(Na,'[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]','')
    return(Na:gsub('.',function(t_)
        if(t_=='=')then
            return''
        end
        local y,Uc='',(('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'):find(t_)-1)
        for Wc=6,1,-1 do
            y=y..(Uc%2^Wc-Uc%2^(Wc-1)>0 and'1'or'0')
        end
        return y
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(la)
        if(#la~=8)then
            return''
        end
        local Ub=0
        for hc=1,8 do
            Ub=Ub+(la:sub(hc,hc)=='1'and 2^(8-hc)or 0)
        end
        return Qa(Ub)
    end))
end);
X,d_,Da,ka,hb,Sc,K,H=S[ca('\245\248\193\239\226\212','\134\140\179')][ca(' -I4 R','UC9')],S[ca('k\194\180q\216\161','\24\182\198')][ca('\5\3\20','v')],S[ca('}D\"g^7','\14\48P')][ca("\'\4\49\24",'E}')],S[ca('\254\150\232\204\174','\156\255')][ca('\131\250\132\134\239\152','\239\137\236')],S[ca('\207x\217\"\159','\173\17')][ca('\149q\f\142d\16','\231\2d')],S[ca('5\182#\236e','W\223')][ca('\fC\0F','n\"')],S[ca('\209U\199X\192','\165\52')][ca('U\231\221U\233\199','6\136\179')],{};
ad=(function(a_)
    local u_=H[a_]
    if u_ then
        return u_
    end
    local jb,Hc,eb,jc,Tb=ka(1,11),ka(1,5),1,{},''
    while eb<=#a_ do
        local Bc=Da(a_,eb);
        eb=eb+1
        for Rc=255,(8)+254 do
            local _c=nil
            if Sc(Bc,1)~=0 then
                if not(eb<=#a_)then
                else
                    _c=d_(a_,eb,eb);
                    eb=eb+1
                end
            else
                if eb+1<=#a_ then
                    local v=X(ca('\198\177\202','\248'),a_,eb);
                    eb=eb+2
                    local _a,m=#Tb-hb(v,5),Sc(v,(Hc-1))+3;
                    _c=d_(Tb,_a,_a+m-1)
                end
            end
            Bc=hb(Bc,1)
            if not(_c)then
            else
                jc[#jc+1]=_c;
                Tb=d_(Tb.._c,-jb)
            end
        end
    end
    local xa=K(jc);
    H[a_]=xa
    return xa
end)
local fb,M,V,mc,Cb,Ja,bd,Fa,wb,ia,ba,r_,Lb,fa_,rc,F,pa,w_,Za,Cc,cc,j,wa,L,p,Jc,Ca,f_,Aa,xc=S[ca('p\186t\166','\4\195')],S[ca('bRs]~','\18\49')],S[ca('\201p\222m\222','\172\2')],S[ca('B\244\192\199[\249\203\192','6\155\174\178')],S[ca('\173\164\242\169\165\245','\204\215\129')],S[ca('}\218\17k\220\t','\14\191}')],S[ca('\176F\176\140\169\170\162W\165\131\160\187','\195#\196\225\204\222')],S[ca('{8\211a\"\198','\bL\161')][ca('\223\226.\212\236(','\185\141\\')],S[ca('\244p\233\238j\252','\135\4\155')][ca('\237\187\5\249\182\30','\152\213u')],S[ca('xO\151bU\130','\v;\229')][ca('ect','\22')],S[ca('>-V$7C','MY$')][ca('Y\152O\132',';\225')],S[ca('4\156n.\134{','G\232\28')][ca('\175\156\173\134','\204\244')],S[ca('\232\27\254\22\249','\156z')][ca('H\175S\165','%\192')],S[ca('\173\226\187\239\188','\217\131')][ca('\238\56\253\50','\158Y')],S[ca('\210$\196)\195','\166E')][ca('L\26\207N\28\207','/h\170')],S[ca('\247[\225V\230','\131:')][ca('\252\196\16\240\216\23','\149\170c')],S[ca('\184\225\174\236\169','\204\128')][ca('\25x\225\25v\251','z\23\143')],S[ca('zv\246\157lm\237\156|','\25\25\132\242')][ca('\216T~\218R~','\187&\27')],S[ca('\150\30c\185\128\5x\184\144','\245q\17\214')][ca('\tW\21R\20','p>')],S[ca('\182\193\136\158\160\218\147\159\176','\213\174\250\241')][ca('\201L\2\206D\20','\187)q')],S[ca('\168\218\136\155\190\193\147\154\174','\203\181\250\244')][ca('\220\2\208\29\218','\191n')],S[ca('YV\252XV\230H','>3\136')],S[ca('\237\49\251k\189','\143X')][ca('\196\201\212','\166')],S[ca('\155\183\141\237\203','\249\222')][ca('\183\225\186\235','\213\153')],S[ca('\183\252\161\166\231','\213\149')][ca('\220\172\208\169','\190\205')],S[ca('\204\r\218W\156','\174d')][ca('a\204f\203w','\3\184')],S[ca('=\184+\226m','_\209')][ca('F}V]hJ','4\14>')],S[ca('{\142m\212+','\25\231')][ca('j\157\23o\136\v','\6\238\127')],S[ca(',\v:Q|','Nb')][ca('\211\96L\196y[\194','\182\24\56')],{[13426]={},[6623]={{6,5,true},{4,8,true},{4,8,false},{6,8,false},{6,8,false},{6,2,false},{10,2,true},{6,7,false},{2,0,true},{6,3,true},{2,9,true},{6,3,true},{3,9,true},{7,8,false},{7,10,true},{4,2,true},{6,9,true},{10,8,false},{6,8,false},{6,0,false},{6,8,false},{10,2,false},{6,8,true},{3,0,false},{7,0,true},{10,9,true},{10,5,false},{6,3,false},{6,2,false},{10,2,false},{3,1,false},{4,10,false},{7,9,false},{3,5,true},{2,1,false},{10,9,true},{4,0,true},{3,1,true},{6,8,false},{6,8,false},{2,5,false},{6,2,false},{4,10,false},{2,1,true},{10,1,false},{4,8,false},{4,9,false},{3,2,false},{7,10,false},{3,5,false},{6,8,false},{6,8,false},{6,3,true},{6,0,false},{6,7,true},{6,9,false},{6,2,false},{10,1,false},{2,0,true},{4,4,false},{10,8,true},{4,9,false},{6,8,false},{7,10,false},{3,1,true},{10,10,false},{4,0,false},{10,0,false},{10,8,false},{4,9,false},{2,7,true},{2,10,true},{2,1,false},{4,7,false},{10,8,true},{6,8,false},{7,8,false},{10,8,false},{6,2,true},{4,9,true},{10,8,false},{7,1,false},{6,5,true},{6,3,true},{6,3,true},{6,8,true},{4,10,true},{7,3,false},{4,1,true},{4,10,false},{4,5,false},{7,8,false},{6,8,false},{2,9,true},{2,9,true},{10,8,false},{7,10,false},{7,3,true},{10,2,false},{10,0,true},{10,8,false},{6,7,false},{3,0,true},{6,2,false},{6,1,true},{6,7,true},{6,7,true},{6,7,false},{4,5,true},{7,1,false},{6,8,false},{6,8,false},{10,9,true},{2,2,false},{10,1,false},{4,7,false},{7,10,true},{7,1,true},{3,1,false},{2,1,true},{2,3,true},{6,2,false},{6,9,true},{6,8,false},{6,8,false},{3,10,true},{10,9,false},{6,7,true},{7,8,false},{6,7,true},{10,8,false},{6,2,false},{4,2,true},{10,8,true},{10,8,true},{2,7,false},{6,8,true},{6,8,false},{6,8,false},{6,1,false},{2,9,true},{10,2,false},{6,8,false},{10,8,false},{6,6,false},{2,7,true},{6,9,false},{3,8,true},{6,8,false},{6,8,false},{6,2,false},{7,9,true},{10,7,true},{6,5,true},{3,3,true},{10,8,false},{2,2,false},{4,7,false},{6,3,true},{6,8,false},{10,10,true},{3,8,true},{4,0,true},{10,1,false},{6,8,false},{6,3,true},{3,0,false},{7,0,false},{10,7,false},{3,10,false},{6,2,false},{7,0,false},{10,10,true},{6,8,false},{6,8,false},{4,2,false},{6,2,false},{6,7,true},{10,8,false},{6,8,false},{2,7,false},{4,0,true},{3,2,true},{10,10,false},{2,9,false},{6,8,false},{3,7,false},{6,3,true},{10,5,true},{10,1,false},{10,8,false},{4,8,true},{10,2,false},{7,10,true},{6,8,false},{6,8,false},{6,3,false},{6,7,false},{4,1,true},{6,3,true},{7,2,true},{6,10,false},{10,1,true},{7,5,false},{4,7,false},{4,8,false},{6,6,false},{4,7,true},{6,9,true},{6,8,false},{10,10,false},{10,2,false},{4,3,true},{7,5,true},{6,3,true},{10,5,true},{10,5,true},{4,9,true},{10,8,false},{10,10,true},{10,7,true},{6,8,false},{6,7,true},{7,3,true},{6,7,false},{6,7,false},{2,3,true},{4,2,true},{10,8,true},{3,5,true},{7,5,true},{10,8,true},{2,0,false},{2,1,false},{6,8,true},{10,1,true},{6,3,true},{4,9,false},{3,0,false},{6,5,true},{7,10,false},{10,7,false},{3,9,false},{6,1,true},{6,8,false},{6,7,true},{10,0,false},{6,8,false},{7,2,false},{3,9,false},{10,0,true},{3,5,false},{6,8,false},{6,8,false},{2,0,true},{6,6,false}},[26341]={}}
local x=(function(I)
    local na=xc[13426][I]
    if(na)then
        return na
    end
    local Ia=1
    local function b_()
        local Xb,G,Db,Mb,Bb,Eb,Ta,_b,W,lc,Jb,ta,fc,Xa,mb,Ic,Sb,s_,ga,N,yb,zb,J,bb,Ba,Hb,Dc,Ib,Vb,Pc,ha,oa;
        J,Xb=function(db,pb,ac)
            Xb[db]=La(ac,455)-La(pb,25926)
            return Xb[db]
        end,{};
        Ib=Xb[-30424]or J(-30424,63032,89242)
        repeat
            if Ib<=27731 then
                if Ib>=11497 then
                    if Ib>19552 then
                        if Ib<25235 then
                            if Ib<21087 then
                                if Ib>20784 then
                                    fc=wb(ca('\178','\240'),I,Ia);
                                    Ib,Ia=28754,Ia+1
                                elseif Ib>20281 then
                                    Ib=Xb[-5361]or J(-5361,45231,82227)
                                    continue
                                else
                                    Dc=ga
                                    if oa~=oa then
                                        Ib=Xb[15484]or J(15484,11203,47191)
                                    else
                                        Ib=26257
                                    end
                                end
                            elseif Ib>=24175 then
                                if Ib>24175 then
                                    Bb=Mb;
                                    Hb=wa(Hb,f_(p(Bb,127),(Ta-86)*7))
                                    if(not Jc(Bb,128))then
                                        Ib=Xb[12038]or J(12038,30809,58086)
                                        continue
                                    else
                                        Ib=Xb[17178]or J(17178,3450,38397)
                                        continue
                                    end
                                    Ib=Xb[-8634]or J(-8634,31582,19409)
                                else
                                    Xa=lc;
                                    Eb=wa(Eb,f_(p(Xa,127),(Dc-229)*7))
                                    if(not Jc(Xa,128))then
                                        Ib=Xb[-7959]or J(-7959,42590,71055)
                                        continue
                                    else
                                        Ib=Xb[20616]or J(20616,14812,50126)
                                        continue
                                    end
                                    Ib=Xb[16850]or J(16850,8347,43659)
                                end
                            elseif Ib>21087 then
                                Ib,Db=Xb[7465]or J(7465,43747,66016),L(Ic,106)
                                continue
                            else
                                Xa,Ib=nb(Sb),Xb[-8711]or J(-8711,37653,77611)
                                continue
                            end
                        elseif Ib>26257 then
                            if Ib<=27620 then
                                if Ib<=27403 then
                                    Ib,Ic=27731,L(Eb,217050842)
                                    continue
                                else
                                    Dc=wb(ca('\145','\211'),I,Ia);
                                    Ia,Ib=Ia+1,11293
                                end
                            else
                                Eb=Ic;
                                ga=rc(Eb);
                                Ib,oa,ha,Dc=Xb[-14367]or J(-14367,13376,21975),213,(Eb)+212,1
                            end
                        elseif Ib>=26145 then
                            if Ib<=26145 then
                                Ib,Xa=58577,nb(nil)
                            else
                                if(ha>=0 and ga>oa)or((ha<0 or ha~=ha)and ga<oa)then
                                    Ib=Xb[-27081]or J(-27081,14134,48316)
                                else
                                    Ib=11623
                                end
                            end
                        elseif Ib<=25235 then
                            Ib=Xb[31936]or J(31936,39413,113770)
                            continue
                        else
                            ga=ga+ha;
                            Dc=ga
                            if ga~=ga then
                                Ib=Xb[-20740]or J(-20740,36412,87874)
                            else
                                Ib=26257
                            end
                        end
                    elseif Ib>15150 then
                        if Ib<19177 then
                            if Ib>=16830 then
                                if Ib>16830 then
                                    Sb,Ib=nil,Xb[8575]or J(8575,46032,89674)
                                else
                                    Ic=Ic+ga;
                                    oa=Ic
                                    if Ic~=Ic then
                                        Ib=Xb[22383]or J(22383,14689,24917)
                                    else
                                        Ib=9991
                                    end
                                end
                            else
                                bb=wb(ca('>',']')..Hb,I,Ia);
                                Ia,Ib=Ia+Hb,29212
                            end
                        elseif Ib<19487 then
                            if Ib>19177 then
                                W=Vb;
                                Db=rc(W);
                                Eb,Ib,ga,Ic=(W)+86,Xb[8232]or J(8232,53220,106536),1,87
                            else
                                Xa,Ib=nil,Xb[-8958]or J(-8958,53939,108265)
                            end
                        elseif Ib>19487 then
                            oa=ga;
                            ha=p(oa,255);
                            Dc=xc[6623][ha+1];
                            lc,Xa,Jb=Dc[1],Dc[2],Dc[3];
                            Hb={[50068]=Xa,[41034]=0,[28751]=0,[24414]=0,[58029]=0,[22]=0,[52851]=0,[13847]=0,[31730]=0,[33705]=0,[8213]=0,[13991]=ha,[548]=0,[61078]=nil,[35886]=0};
                            F(zb,Hb)
                            if lc==6 then
                                Ib=Xb[-4800]or J(-4800,44679,114477)
                                continue
                            elseif lc==4 then
                                Ib=Xb[32581]or J(32581,24741,16598)
                                continue
                            elseif lc==10 then
                                Ib=Xb[-19278]or J(-19278,63583,84610)
                                continue
                            end
                            Ib=49325
                        else
                            Ib,ha=27620,nil
                        end
                    elseif Ib>=12418 then
                        if Ib<=14489 then
                            if Ib>13727 then
                                Ib,lc=Xb[6275]or J(6275,59831,71121),E(Xa[1],1,Xa[2])
                            elseif Ib>12418 then
                                ha=wb(ca('\v','I'),I,Ia);
                                Ib,Ia=49430,Ia+1
                            else
                                Ic=Db;
                                _b=wa(_b,f_(p(Ic,127),(W-138)*7))
                                if(not Jc(Ic,128))then
                                    Ib=Xb[-12015]or J(-12015,64875,64263)
                                    continue
                                else
                                    Ib=Xb[-2830]or J(-2830,747,38031)
                                    continue
                                end
                                Ib=Xb[31522]or J(31522,57799,46043)
                            end
                        elseif Ib>14993 then
                            Sb,bb=p(Ca(oa,8),16777215),nil;
                            bb=if Sb<8388608 then Sb else Sb-16777216;
                            Ib,Hb[33705]=Xb[10517]or J(10517,47397,105687),bb
                        else
                            Ib,Vb=Xb[-31413]or J(-31413,8376,37074),L(W,217050842)
                            continue
                        end
                    elseif Ib>=11675 then
                        if Ib<=11675 then
                            zb=zb+Vb;
                            W=zb
                            if zb~=zb then
                                Ib=Xb[1855]or J(1855,25126,51613)
                            else
                                Ib=Xb[23125]or J(23125,40869,126021)
                            end
                        else
                            Ib,oa=Xb[-8601]or J(-8601,17953,22721),nil
                        end
                    elseif Ib>11497 then
                        lc,Ib=nil,Xb[16229]or J(16229,29728,11254)
                    else
                        Ib,Eb=Xb[-8841]or J(-8841,25639,51865),Jb
                        continue
                    end
                elseif Ib>=5788 then
                    if Ib<=9166 then
                        if Ib<=6347 then
                            if Ib>=6093 then
                                if Ib<6318 then
                                    Db=Db+Eb;
                                    ga=Db
                                    if Db~=Db then
                                        Ib=Xb[-236]or J(-236,5016,45224)
                                    else
                                        Ib=Xb[16152]or J(16152,56028,57862)
                                    end
                                elseif Ib<=6318 then
                                    N=wb(ca('*','h'),I,Ia);
                                    Ia,Ib=Ia+1,Xb[8935]or J(8935,48648,58270)
                                else
                                    Xa=wb(ca('l','.'),I,Ia);
                                    Ia,Ib=Ia+1,Xb[19175]or J(19175,6179,91907)
                                end
                            elseif Ib<=5788 then
                                Ib,ha[52851]=Xb[20339]or J(20339,26953,33543),Db[ha[41034]+1]
                            else
                                Ib,lc=Xb[-1783]or J(-1783,36329,93715),nil
                            end
                        elseif Ib>7902 then
                            ha=zb[(oa-95)];
                            Dc=ha[50068]
                            if Dc==0 then
                                Ib=Xb[4860]or J(4860,14394,24776)
                                continue
                            elseif Dc==10 then
                                Ib=Xb[7841]or J(7841,24961,6552)
                                continue
                            elseif Dc==1 then
                                Ib=Xb[16647]or J(16647,42227,81326)
                                continue
                            elseif Dc==4 then
                                Ib=Xb[14559]or J(14559,63364,67998)
                                continue
                            elseif Dc==3 then
                                Ib=Xb[-26690]or J(-26690,31968,12677)
                                continue
                            end
                            Ib=Xb[16080]or J(16080,13803,50841)
                        elseif Ib>6596 then
                            Sb,Ib=L(bb,976810442),Xb[18149]or J(18149,64219,106402)
                            continue
                        else
                            Ib=Xb[24150]or J(24150,17438,23086)
                            continue
                        end
                    elseif Ib<=9991 then
                        if Ib<9969 then
                            if Ib>9255 then
                                Db,Ib=nil,Xb[22499]or J(22499,17478,10608)
                            else
                                if(Eb>=0 and Db>Ic)or((Eb<0 or Eb~=Eb)and Db<Ic)then
                                    Ib=Xb[27443]or J(27443,9286,31318)
                                else
                                    Ib=Xb[8843]or J(8843,7590,43326)
                                end
                            end
                        elseif Ib<=9969 then
                            if Dc==6 then
                                Ib=Xb[-21784]or J(-21784,52989,63331)
                                continue
                            elseif Dc==3 then
                                Ib=Xb[4066]or J(4066,6390,57878)
                                continue
                            end
                            Ib=Xb[-22944]or J(-22944,13015,57201)
                        else
                            if(ga>=0 and Ic>Eb)or((ga<0 or ga~=ga)and Ic<Eb)then
                                Ib=1131
                            else
                                Ib=Xb[-11074]or J(-11074,57924,53990)
                            end
                        end
                    elseif Ib<=11262 then
                        if Ib<=10832 then
                            Ib,N,Pc=20813,s_,nil
                        else
                            Sb=Sb+yb;
                            Ta=Sb
                            if Sb~=Sb then
                                Ib=Xb[25720]or J(25720,31911,57780)
                            else
                                Ib=32380
                            end
                        end
                    else
                        ha,Ib=L(Dc,106),Xb[32667]or J(32667,54427,95021)
                        continue
                    end
                elseif Ib<=3460 then
                    if Ib>1855 then
                        if Ib<1999 then
                            Ic=wb(ca('A','\3'),I,Ia);
                            Ib,Ia=Xb[-25373]or J(-25373,37385,84004),Ia+1
                        elseif Ib>1999 then
                            Xa,Ib=Jb,34837
                            continue
                        else
                            if Xa==3 then
                                Ib=Xb[-19145]or J(-19145,35344,88636)
                                continue
                            end
                            Ib=Xb[13775]or J(13775,35266,90866)
                        end
                    elseif Ib<1131 then
                        if Ib<=778 then
                            lc=oa
                            if ha~=ha then
                                Ib=4710
                            else
                                Ib=60923
                            end
                        else
                            ha[52851],Ib=Aa(ha[41034],0,16),Xb[11472]or J(11472,63706,71050)
                        end
                    elseif Ib>=1803 then
                        if Ib>1803 then
                            if(ta)then
                                Ib=Xb[-17645]or J(-17645,9245,50571)
                                continue
                            else
                                Ib=Xb[3948]or J(3948,47585,59993)
                                continue
                            end
                            Ib=Xb[-4165]or J(-4165,24559,70284)
                        else
                            s_,Ib=L(N,106),Xb[6577]or J(6577,52893,55276)
                            continue
                        end
                    else
                        ga,Ic,Ib,Eb=1,96,63836,(_b)+95
                    end
                elseif Ib>4811 then
                    if Ib<=5016 then
                        lc=ha[41034];
                        Xa,Jb=Ca(lc,30),p(Ca(lc,20),1023);
                        ha[52851]=Db[Jb+1];
                        ha[35886]=Xa
                        if(Xa==2)then
                            Ib=Xb[22426]or J(22426,8050,77189)
                            continue
                        else
                            Ib=Xb[29216]or J(29216,43222,54424)
                            continue
                        end
                        Ib=Xb[-21158]or J(-21158,2612,59364)
                    else
                        W=zb
                        if ta~=ta then
                            Ib=Xb[17611]or J(17611,55672,97535)
                        else
                            Ib=Xb[-14380]or J(-14380,24426,77068)
                        end
                    end
                elseif Ib<=4710 then
                    if Ib>=4378 then
                        if Ib<=4378 then
                            fc,G,Ib=Pc,nil,Xb[28654]or J(28654,30214,51046)
                        else
                            return{[51848]=ga,[41904]='',[49992]=zb,[12604]=N,[11961]=mb,[54766]=fc}
                        end
                    else
                        Ib,Eb=Xb[21742]or J(21742,48874,104719),nil
                    end
                else
                    Ib,Xa=14489,nb''
                    continue
                end
            elseif Ib>49325 then
                if Ib>58048 then
                    if Ib>=62111 then
                        if Ib>=63836 then
                            if Ib>=64928 then
                                if Ib>64928 then
                                    bb=Sb;
                                    Hb[41034]=bb;
                                    F(zb,{});
                                    Ib=Xb[3444]or J(3444,8039,42701)
                                else
                                    Mb,Ib=L(Bb,106),Xb[-15671]or J(-15671,49527,66714)
                                    continue
                                end
                            elseif Ib>63836 then
                                Ib,Sb=16174,nil
                            else
                                oa=Ic
                                if Eb~=Eb then
                                    Ib=41416
                                else
                                    Ib=Xb[25088]or J(25088,24392,53712)
                                end
                            end
                        elseif Ib>62249 then
                            oa=Ic
                            if Eb~=Eb then
                                Ib=1131
                            else
                                Ib=Xb[6994]or J(6994,62856,46610)
                            end
                        elseif Ib<=62111 then
                            if(Vb>=0 and zb>ta)or((Vb<0 or Vb~=Vb)and zb<ta)then
                                Ib=Xb[22298]or J(22298,4466,79081)
                            else
                                Ib=9561
                            end
                        else
                            Hb[8213]=p(Ca(oa,8),255);
                            Hb[31730]=p(Ca(oa,16),255);
                            Ib,Hb[24414]=Xb[18783]or J(18783,9959,66953),p(Ca(oa,24),255)
                        end
                    elseif Ib>=60007 then
                        if Ib>=60923 then
                            if Ib<=60923 then
                                if(Dc>=0 and oa>ha)or((Dc<0 or Dc~=Dc)and oa<ha)then
                                    Ib=Xb[32246]or J(32246,51635,48796)
                                else
                                    Ib=30422
                                end
                            else
                                Jb=wb(ca('c;','_'),I,Ia);
                                Ib,Ia=Xb[25286]or J(25286,320,28749),Ia+8
                            end
                        else
                            _b=0;
                            ta,Vb,zb,Ib=142,1,138,5273
                        end
                    elseif Ib>=59193 then
                        if Ib>59193 then
                            lc,Ib=L(Xa,106),24175
                            continue
                        else
                            _b=Ba;
                            zb,ta=rc(_b),false;
                            Db,Vb,W,Ib=1,201,(_b)+200,Xb[6565]or J(6565,10742,53076)
                        end
                    else
                        Ib,Jb=31862,nil
                    end
                elseif Ib<=51679 then
                    if Ib>50834 then
                        if Ib>51322 then
                            Ib,s_=Xb[-25164]or J(-25164,42406,55369),nil
                        elseif Ib<=50992 then
                            Ib,Vb=56238,nil
                        else
                            mb,Ib,Ba=G,60007,nil
                        end
                    elseif Ib<49430 then
                        if Ib>49402 then
                            Dc=ha
                            if(Dc==2)then
                                Ib=Xb[-3828]or J(-3828,9616,22987)
                                continue
                            else
                                Ib=Xb[-26082]or J(-26082,13937,31727)
                                continue
                            end
                            Ib=34597
                        else
                            Ib,Ba=59193,L(_b,217050842)
                            continue
                        end
                    elseif Ib<50690 then
                        Ib,oa=28720,L(ha,106)
                        continue
                    elseif Ib>50690 then
                        Ib,Jb=Xb[-15786]or J(-15786,6334,90495),L(Hb,217050842)
                        continue
                    else
                        Ib=Xb[32359]or J(32359,57633,84798)
                        continue
                    end
                elseif Ib>55458 then
                    if Ib>=57659 then
                        if Ib<=57659 then
                            Ta=Sb
                            if bb~=bb then
                                Ib=Xb[101]or J(101,431,76476)
                            else
                                Ib=Xb[-20713]or J(-20713,210,58839)
                            end
                        else
                            Hb=Jb
                            if(Hb==0)then
                                Ib=Xb[-30863]or J(-30863,54488,50606)
                                continue
                            else
                                Ib=Xb[13111]or J(13111,19587,75165)
                                continue
                            end
                            Ib=Xb[-11573]or J(-11573,39859,123393)
                        end
                    else
                        W=0;
                        Db,Eb,Ic,Ib=59,1,63,45971
                    end
                elseif Ib<=53092 then
                    if Ib>=51917 then
                        if Ib<=51917 then
                            oa=oa+Dc;
                            lc=oa
                            if oa~=oa then
                                Ib=Xb[-2833]or J(-2833,8164,36047)
                            else
                                Ib=60923
                            end
                        else
                            Eb=0;
                            Ib,oa,ha,ga=Xb[-3314]or J(-3314,56341,67915),233,1,229
                        end
                    else
                        Ib,ta=Xb[28067]or J(28067,48392,110903),Eb
                    end
                else
                    Vb=Vb+Db;
                    Ic=Vb
                    if Vb~=Vb then
                        Ib=Xb[-7128]or J(-7128,3123,78178)
                    else
                        Ib=45008
                    end
                end
            elseif Ib>=34837 then
                if Ib<44588 then
                    if Ib<38409 then
                        if Ib<35063 then
                            lc,Ib=Xa,Xb[-14984]or J(-14984,25657,35171)
                        elseif Ib>35063 then
                            ga,Ib=L(oa,976810442),Xb[-22783]or J(-22783,59082,52779)
                            continue
                        else
                            bb=wb(ca('\129\244\137','\189'),I,Ia);
                            Ib,Ia=7902,Ia+4
                        end
                    elseif Ib>=41416 then
                        if Ib>41416 then
                            Ib,G=Xb[-31130]or J(-31130,21059,65208),L(mb,106)
                            continue
                        else
                            Ic,Ib=nil,53092
                        end
                    elseif Ib<=38409 then
                        if(ga>=0 and Ic>Eb)or((ga<0 or ga~=ga)and Ic<Eb)then
                            Ib=Xb[-6227]or J(-6227,35990,100959)
                        else
                            Ib=Xb[-5782]or J(-5782,2061,37086)
                        end
                    else
                        oa=wb(ca('\212\161\220','\232'),I,Ia);
                        Ia,Ib=Ia+4,Xb[-14970]or J(-14970,45117,91158)
                    end
                elseif Ib<=45921 then
                    if Ib<45008 then
                        if Ib>44588 then
                            Ib,Mb=Xb[1689]or J(1689,674,55604),nil
                        else
                            Hb[8213]=p(Ca(oa,8),255);
                            Sb=p(Ca(oa,16),65535);
                            Hb[548]=Sb;
                            bb=nil;
                            bb=if Sb<32768 then Sb else Sb-65536;
                            Ib,Hb[22]=Xb[8485]or J(8485,51269,93303),bb
                        end
                    elseif Ib<45582 then
                        if(Db>=0 and Vb>W)or((Db<0 or Db~=Db)and Vb<W)then
                            Ib=Xb[24846]or J(24846,38159,112318)
                        else
                            Ib=Xb[-22507]or J(-22507,16451,11651)
                        end
                    elseif Ib<=45582 then
                        Hb=p(Ca(lc,10),1023);
                        Ib,ha[28751]=Xb[-13528]or J(-13528,47164,87532),Db[Hb+1]
                    else
                        mb=wb(ca('(','j'),I,Ia);
                        Ib,Ia=Xb[24353]or J(24353,36598,102827),Ia+1
                    end
                elseif Ib<48412 then
                    ga=Db
                    if Ic~=Ic then
                        Ib=Xb[-17606]or J(-17606,38238,76654)
                    else
                        Ib=9255
                    end
                elseif Ib>48412 then
                    if(Jb)then
                        Ib=Xb[10079]or J(10079,8576,36794)
                        continue
                    else
                        Ib=Xb[7874]or J(7874,39022,76758)
                        continue
                    end
                    Ib=Xb[4215]or J(4215,22930,26746)
                else
                    Ib,ga=Xb[20850]or J(20850,60277,76158),nil
                end
            elseif Ib<=30422 then
                if Ib<=29212 then
                    if Ib<28754 then
                        if Ib>27813 then
                            ha=oa;
                            W=wa(W,f_(p(ha,127),(ga-59)*7))
                            if not Jc(ha,128)then
                                Ib=Xb[6235]or J(6235,59343,40330)
                                continue
                            end
                            Ib=Xb[18324]or J(18324,41563,57133)
                        else
                            Hb,Sb=p(Ca(lc,10),1023),p(Ca(lc,0),1023);
                            ha[28751]=Db[Hb+1];
                            Ib,ha[13847]=Xb[18403]or J(18403,36873,93639),Db[Sb+1]
                        end
                    elseif Ib>=28943 then
                        if Ib>28943 then
                            Sb,Ib=bb,Xb[-14191]or J(-14191,49459,63251)
                            continue
                        else
                            Bb=wb(ca('\237','\175'),I,Ia);
                            Ib,Ia=Xb[-24240]or J(-24240,52691,108530),Ia+1
                        end
                    else
                        Pc,Ib=L(fc,106),4378
                        continue
                    end
                elseif Ib>30385 then
                    Ib,ga[(lc-212)]=Xb[9698]or J(9698,28876,57744),b_()
                elseif Ib<=30103 then
                    Ib,ha[52851]=Xb[-30755]or J(-30755,37483,93209),Db[ha[33705]+1]
                else
                    Ic=Ic+ga;
                    oa=Ic
                    if Ic~=Ic then
                        Ib=Xb[19118]or J(19118,47705,98592)
                    else
                        Ib=Xb[27741]or J(27741,60038,74766)
                    end
                end
            elseif Ib<33251 then
                if Ib<31862 then
                    ha[52851],Ib=Db[ha[22]+1],Xb[14961]or J(14961,47287,87397)
                elseif Ib>31862 then
                    if(yb>=0 and Sb>bb)or((yb<0 or yb~=yb)and Sb<bb)then
                        Ib=Xb[7932]or J(7932,21973,63202)
                    else
                        Ib=44969
                    end
                else
                    Hb=0;
                    bb,Ib,yb,Sb=90,Xb[-30266]or J(-30266,23634,72584),1,86
                end
            elseif Ib<33521 then
                Ic=Vb
                if W~=W then
                    Ib=50992
                else
                    Ib=45008
                end
            elseif Ib<=33521 then
                ta,Ib=false,Xb[-16623]or J(-16623,61358,90701)
            else
                Ib,Db[(oa-86)]=Xb[-2353]or J(-2353,51900,61567),lc
            end
        until Ib==53116
    end
    local yc=b_();
    xc[13426][I]=yc
    return yc
end)
local lb=(function(ya,Q)
    ya=x(ya)
    local vb=j()
    local function aa(C,e_)
        local ab=(function(...)
            return{...},Ja('#',...)
        end)
        local Pb;
        Pb=(function(Kb,o_,bc)
            if o_>bc then
                return
            end
            return Kb[o_],Pb(Kb,o_+1,bc)
        end)
        local function h(Ma,B,Qb,ub)
            local zc,Ab,Ha,cd,U,uc,Ua,vc,Gc,Xc,kb,ja,tc,Ga,Zb,c,Oc,T,Sa,xb,gb,Ra,Ob,ma;
            tc,T=function(pc,Mc,oc)
                T[oc]=La(Mc,35076)-La(pc,42859)
                return T[oc]
            end,{};
            Ga=T[-2818]or tc(37873,30113,-2818)
            repeat
                if Ga>34258 then
                    if Ga>47479 then
                        if Ga>=57683 then
                            if Ga>61130 then
                                if Ga>63357 then
                                    if Ga<64644 then
                                        if Ga<=63583 then
                                            ma[Oc]=nil;
                                            vc+=1;
                                            Ga=T[10510]or tc(6332,16768,10510)
                                        else
                                            Ga,c=T[-32003]or tc(28632,79944,-32003),c..r_(L(ba(kb,(Ab-38)+1),ba(uc,(Ab-38)%#uc+1)))
                                        end
                                    elseif Ga>64644 then
                                        if not Ma[Oc[8213]]then
                                            Ga=T[1295]or tc(13300,11312,1295)
                                            continue
                                        end
                                        Ga=T[21709]or tc(7734,19214,21709)
                                    else
                                        if(uc==-2)then
                                            Ga=T[22993]or tc(1920,69710,22993)
                                            continue
                                        else
                                            Ga=T[13150]or tc(9375,19136,13150)
                                            continue
                                        end
                                        Ga=T[14218]or tc(3537,14947,14218)
                                    end
                                elseif Ga<62679 then
                                    if Ga<=61867 then
                                        if Ga>61808 then
                                            if(Oc[24414]==184)then
                                                Ga=T[-22796]or tc(23967,76829,-22796)
                                                continue
                                            else
                                                Ga=T[-16223]or tc(55212,116404,-16223)
                                                continue
                                            end
                                            Ga=T[21609]or tc(5023,13477,21609)
                                        else
                                            Xc,kb=Sa[52851],Oc[52851];
                                            kb=ca('\155{\226\226','Q\249')..kb;
                                            uc='';
                                            c,Ha,U,Ga=86,1,(#Xc-1)+86,15862
                                        end
                                    else
                                        uc[1]=uc[3][uc[2]];
                                        uc[3]=uc;
                                        uc[2]=1;
                                        cd[kb],Ga=nil,T[23353]or tc(17014,128141,23353)
                                    end
                                elseif Ga>=63253 then
                                    if Ga<=63253 then
                                        Ga,Ma[Oc[8213]]=T[28157]or tc(56820,1679,28157),Ob[Oc[28751]]
                                    else
                                        Xc,Ga=nil,T[-10671]or tc(33741,32701,-10671)
                                    end
                                else
                                    if Yc(Sa)==ca('e\16s\29t','\17q')then
                                        Ga=T[-7577]or tc(41949,49301,-7577)
                                        continue
                                    end
                                    Ga=T[10342]or tc(28737,124562,10342)
                                end
                            elseif Ga>59586 then
                                if Ga>=60519 then
                                    if Ga<=61124 then
                                        if Ga>60519 then
                                            if Oc[24414]==26 then
                                                Ga=T[-28776]or tc(1412,115037,-28776)
                                                continue
                                            elseif Oc[24414]==85 then
                                                Ga=T[25106]or tc(37628,29877,25106)
                                                continue
                                            elseif(Oc[24414]==116)then
                                                Ga=T[-10132]or tc(14616,22470,-10132)
                                                continue
                                            else
                                                Ga=T[19185]or tc(40337,107937,19185)
                                                continue
                                            end
                                            Ga=T[-17767]or tc(49544,59028,-17767)
                                        else
                                            V(uc);
                                            Ga=T[31575]or tc(25297,84794,31575)
                                        end
                                    else
                                        if(Ua>86)then
                                            Ga=T[26435]or tc(34355,41729,26435)
                                            continue
                                        else
                                            Ga=T[20413]or tc(14992,24848,20413)
                                            continue
                                        end
                                        Ga=T[17003]or tc(37154,47090,17003)
                                    end
                                elseif Ga>59832 then
                                    if(Ua>92)then
                                        Ga=T[9371]or tc(57431,8410,9371)
                                        continue
                                    else
                                        Ga=T[-29603]or tc(22014,99881,-29603)
                                        continue
                                    end
                                    Ga=T[26604]or tc(33329,42755,26604)
                                else
                                    Ga,Xc=58406,nil
                                end
                            elseif Ga<58406 then
                                if Ga<57814 then
                                    Ra={[2]=ja,[3]=Ma};
                                    cd[ja],Ga=Ra,T[23100]or tc(10963,113494,23100)
                                elseif Ga<=57814 then
                                    gb=e_[Oc[31730]+1];
                                    gb[3][gb[2]],Ga=Ma[Oc[8213]],T[29174]or tc(1654,8398,29174)
                                else
                                    Ob,Ga=uc,42781
                                    continue
                                end
                            elseif Ga<59545 then
                                kb,uc=Sa[28751],Oc[28751];
                                uc=ca('X\137!\16','\146\v')..uc;
                                c='';
                                Ha,Ga,U,zc=(#kb-1)+38,55488,38,1
                            elseif Ga>59545 then
                                if(Yc(Sa)==ca('\214$\192)\199','\162E'))then
                                    Ga=T[-31688]or tc(15434,109134,-31688)
                                    continue
                                else
                                    Ga=T[-8791]or tc(2221,24687,-8791)
                                    continue
                                end
                                Ga=T[-29745]or tc(35381,60935,-29745)
                            else
                                U=U+zc;
                                Ab=U
                                if U~=U then
                                    Ga=T[-7542]or tc(2690,23692,-7542)
                                else
                                    Ga=38812
                                end
                            end
                        elseif Ga<=53818 then
                            if Ga>=51235 then
                                if Ga>=52232 then
                                    if Ga<=53779 then
                                        if Ga<=52232 then
                                            uc[(zc-215)],Ga=e_[Ab[31730]+1],T[29760]or tc(52783,32626,29760)
                                        else
                                            kb,uc=Sa[28751],Oc[28751];
                                            uc=ca('\213\213\172L','\31W')..uc;
                                            c='';
                                            U,zc,Ha,Ga=127,1,(#kb-1)+127,T[-14157]or tc(23213,100103,-14157)
                                        end
                                    else
                                        Sa,Ob,Xc=cd
                                        if Yc(Sa)~=ca('\248\149\17&\234\137\16+','\158\224\127E')then
                                            Ga=T[17023]or tc(28942,81336,17023)
                                            continue
                                        end
                                        Ga=T[-4100]or tc(14296,106523,-4100)
                                    end
                                elseif Ga>=51568 then
                                    if Ga>51568 then
                                        Ga,Xc=T[-8632]or tc(29479,109825,-8632),xb-gb+1
                                    else
                                        gb[52851]=Sa;
                                        Oc[13991],Ga=91,T[22590]or tc(39750,52702,22590)
                                    end
                                else
                                    if(Oc[24414]==52)then
                                        Ga=T[-25311]or tc(64987,25522,-25311)
                                        continue
                                    else
                                        Ga=T[-27468]or tc(44062,37102,-27468)
                                        continue
                                    end
                                    Ga=T[-4467]or tc(1633,8371,-4467)
                                end
                            elseif Ga>50264 then
                                if Ga<=51211 then
                                    xb,Ga,vc,cd,ma,Gc=-1,2221,1,bd({},{[ca('\199\3\179\247\56\187','\152\\\222')]=ca('\206\203','\184')}),bd({},{[ca('\237\242\252\221\201\244','\178\173\145')]=ca('\206\214','\165')}),false
                                else
                                    vc-=1;
                                    Ga,Qb[vc]=T[21055]or tc(41724,34624,21055),{[13991]=173,[8213]=L(Oc[8213],237),[31730]=L(Oc[31730],65),[24414]=0}
                                end
                            elseif Ga>48544 then
                                gb,Sa=Oc[8213],Oc[31730]-1
                                if Sa==-1 then
                                    Ga=T[14937]or tc(36116,6342,14937)
                                    continue
                                end
                                Ga=T[133]or tc(6537,117611,133)
                            elseif Ga>47810 then
                                Sa,Ob,Xc=gb[ca('\218S\30\241i\5','\133\fw')](Sa);
                                Ga=T[4151]or tc(52777,104678,4151)
                            else
                                if(Ua>194)then
                                    Ga=T[1023]or tc(56982,13317,1023)
                                    continue
                                else
                                    Ga=T[-26021]or tc(30808,130105,-26021)
                                    continue
                                end
                                Ga=T[18608]or tc(442,9850,18608)
                            end
                        elseif Ga>56919 then
                            if Ga>=57219 then
                                if Ga>57219 then
                                    if gb==3 then
                                        Ga=T[2385]or tc(36256,105863,2385)
                                        continue
                                    end
                                    Ga=T[32340]or tc(21985,73030,32340)
                                else
                                    Ga,Sa=51568,kb
                                    continue
                                end
                            elseif Ga<=57065 then
                                gb,Sa=Oc[8213],Oc[31730];
                                Ob=Sa-1
                                if(Ob==-1)then
                                    Ga=T[-17894]or tc(25397,67170,-17894)
                                    continue
                                else
                                    Ga=T[-3051]or tc(25564,30615,-3051)
                                    continue
                                end
                                Ga=20409
                            else
                                kb,Ga=U,44763
                                continue
                            end
                        elseif Ga>55998 then
                            if Ga>56700 then
                                gb=z(Sa)
                                if(gb~=nil and gb[ca('\183\129k\156\187p','\232\222\2')]~=nil)then
                                    Ga=T[-8260]or tc(9163,109161,-8260)
                                    continue
                                else
                                    Ga=T[-26614]or tc(20012,87834,-26614)
                                    continue
                                end
                                Ga=T[14743]or tc(6395,122616,14743)
                            else
                                vc+=1;
                                Ga=T[9912]or tc(49994,58826,9912)
                            end
                        elseif Ga>=55488 then
                            if Ga>55488 then
                                if(U>=0 and uc>c)or((U<0 or U~=U)and uc<c)then
                                    Ga=T[21675]or tc(24554,86272,21675)
                                else
                                    Ga=23567
                                end
                            else
                                Ab=U
                                if Ha~=Ha then
                                    Ga=T[-6399]or tc(21794,102636,-6399)
                                else
                                    Ga=38812
                                end
                            end
                        elseif Ga<=54096 then
                            if Ua>11 then
                                Ga=T[-26062]or tc(22847,98781,-26062)
                                continue
                            else
                                Ga=T[-21533]or tc(46722,44830,-21533)
                                continue
                            end
                            Ga=T[488]or tc(15655,11261,488)
                        else
                            Ha=uc
                            if c~=c then
                                Ga=T[-18649]or tc(16612,85526,-18649)
                            else
                                Ga=T[9663]or tc(15812,130153,9663)
                            end
                        end
                    elseif Ga<40831 then
                        if Ga<=38210 then
                            if Ga>=36146 then
                                if Ga<36870 then
                                    if Ga>=36338 then
                                        if Ga>36338 then
                                            gb=Oc[52851];
                                            Ma[Oc[31730]]=vb[gb]or xc[26341][gb];
                                            vc+=1;
                                            Ga=T[24442]or tc(35067,45369,24442)
                                        else
                                            if(Ua>158)then
                                                Ga=T[19644]or tc(60093,1145,19644)
                                                continue
                                            else
                                                Ga=T[30880]or tc(15763,19094,30880)
                                                continue
                                            end
                                            Ga=T[1556]or tc(58957,49367,1556)
                                        end
                                    else
                                        c=c+Ha;
                                        zc=c
                                        if c~=c then
                                            Ga=T[-17061]or tc(51495,65533,-17061)
                                        else
                                            Ga=T[-1020]or tc(27992,29949,-1020)
                                        end
                                    end
                                elseif Ga<37927 then
                                    vc-=1;
                                    Qb[vc],Ga={[13991]=75,[8213]=L(Oc[8213],243),[31730]=L(Oc[31730],115),[24414]=0},T[17081]or tc(29756,21760,17081)
                                elseif Ga>37927 then
                                    vc+=Oc[22];
                                    Ga=T[-20259]or tc(10127,149,-20259)
                                else
                                    gb=z(Sa)
                                    if(gb~=nil and gb[ca('\29\55h6\rs','Bh\1')]~=nil)then
                                        Ga=T[-29019]or tc(13609,112020,-29019)
                                        continue
                                    else
                                        Ga=T[8490]or tc(1834,65543,8490)
                                        continue
                                    end
                                    Ga=T[-4985]or tc(51730,11802,-4985)
                                end
                            elseif Ga>=35452 then
                                if Ga>35618 then
                                    if(Ua>190)then
                                        Ga=T[31745]or tc(13920,19097,31745)
                                        continue
                                    else
                                        Ga=T[-22158]or tc(12954,108567,-22158)
                                        continue
                                    end
                                    Ga=T[22160]or tc(2855,15869,22160)
                                elseif Ga<=35452 then
                                    gb,Sa,Ga,Ob=Oc[35886],Qb[vc+1],T[31970]or tc(24240,90703,31970),nil
                                else
                                    if Ua>174 then
                                        Ga=T[17836]or tc(57533,28241,17836)
                                        continue
                                    else
                                        Ga=T[32541]or tc(45726,51356,32541)
                                        continue
                                    end
                                    Ga=T[31173]or tc(39687,52253,31173)
                                end
                            elseif Ga<=34857 then
                                if Ga<=34365 then
                                    if(Ua>1)then
                                        Ga=T[-4184]or tc(41585,7436,-4184)
                                        continue
                                    else
                                        Ga=T[25468]or tc(48781,15026,25468)
                                        continue
                                    end
                                    Ga=T[25963]or tc(21145,30619,25963)
                                else
                                    Sa,Ob,Xc=za(Sa);
                                    Ga=T[-13370]or tc(39261,65247,-13370)
                                end
                            else
                                gb,Sa=nil,L(Oc[548],58131);
                                gb=if Sa<32768 then Sa else Sa-65536;
                                Ob=gb;
                                Xc=B[Ob+1];
                                kb=Xc[11961];
                                uc=rc(kb);
                                Ma[L(Oc[8213],209)]=aa(Xc,uc);
                                c,U,Ga,Ha=216,(kb)+215,22324,1
                            end
                        elseif Ga>39688 then
                            if Ga<=40301 then
                                if Ga>=40014 then
                                    if Ga>40014 then
                                        uc[1]=uc[3][uc[2]];
                                        uc[3]=uc;
                                        uc[2]=1;
                                        cd[kb],Ga=nil,T[-3047]or tc(2224,24708,-3047)
                                    else
                                        gb,Sa=nil,L(Oc[548],51034);
                                        gb=if Sa<32768 then Sa else Sa-65536;
                                        Ob=gb;
                                        Ma[L(Oc[8213],92)],Ga=Ob,T[-8079]or tc(33706,42090,-8079)
                                    end
                                else
                                    Ga,Sa[28751]=T[17381]or tc(57080,102991,17381),Xc
                                end
                            else
                                Sa,Ob,Xc=gb[ca('\242\194\237\217\248\246','\173\157\132')](Sa);
                                Ga=T[14282]or tc(25038,120341,14282)
                            end
                        elseif Ga>=39020 then
                            if Ga>=39376 then
                                if Ga<=39376 then
                                    vc+=1;
                                    Ga=T[28527]or tc(42285,33783,28527)
                                else
                                    vc-=1;
                                    Qb[vc],Ga={[13991]=20,[8213]=L(Oc[8213],156),[31730]=L(Oc[31730],108),[24414]=0},T[30158]or tc(59613,53607,30158)
                                end
                            else
                                kb,uc=Sa(Ob,Xc);
                                Xc=kb
                                if Xc==nil then
                                    Ga=T[22368]or tc(38075,46457,22368)
                                else
                                    Ga=T[-27256]or tc(23308,119036,-27256)
                                end
                            end
                        elseif Ga>=38812 then
                            if Ga>38812 then
                                Ma[gb+2]=Ma[gb+3];
                                vc+=Oc[22];
                                Ga=T[-20748]or tc(3398,15326,-20748)
                            else
                                if(zc>=0 and U>Ha)or((zc<0 or zc~=zc)and U<Ha)then
                                    Ga=T[16480]or tc(1572,16874,16480)
                                else
                                    Ga=64627
                                end
                            end
                        else
                            Ma[Oc[31730]]=Oc[24414]==1;
                            vc+=Oc[8213];
                            Ga=T[7913]or tc(49328,63884,7913)
                        end
                    elseif Ga>43553 then
                        if Ga<46046 then
                            if Ga>44763 then
                                if Ga<=44987 then
                                    if(Ua>77)then
                                        Ga=T[5354]or tc(1500,66769,5354)
                                        continue
                                    else
                                        Ga=T[-29552]or tc(34468,5650,-29552)
                                        continue
                                    end
                                    Ga=T[-22753]or tc(12273,6211,-22753)
                                else
                                    Ga=T[1534]or tc(24714,128893,1534)
                                    continue
                                end
                            elseif Ga<=43598 then
                                if Ga<=43557 then
                                    vc-=1;
                                    Ga,Qb[vc]=T[5658]or tc(22399,29125,5658),{[13991]=142,[8213]=L(Oc[8213],197),[31730]=L(Oc[31730],172),[24414]=0}
                                else
                                    Sa,Ob,Xc=gb[ca('\165\127=\142E&','\250 T')](Sa);
                                    Ga=T[11928]or tc(29141,104807,11928)
                                end
                            else
                                Sa[13847],Ga=kb,T[-25117]or tc(16876,65851,-25117)
                            end
                        elseif Ga>46783 then
                            if Ga>47111 then
                                c=c+Ha;
                                zc=c
                                if c~=c then
                                    Ga=T[-2239]or tc(42369,28477,-2239)
                                else
                                    Ga=8552
                                end
                            else
                                gb,Sa=nil,Ma[Oc[8213]];
                                gb=fb(Sa)==ca('\185\5\54o\171\25\55b','\223pX\f')
                                if not gb then
                                    Ga=T[-31294]or tc(43415,40871,-31294)
                                    continue
                                end
                                Ga=18583
                            end
                        elseif Ga>=46134 then
                            if Ga>46134 then
                                vc+=Oc[22];
                                Ga=T[23597]or tc(44179,40353,23597)
                            else
                                gb=e_[Oc[31730]+1];
                                Ma[Oc[8213]],Ga=gb[3][gb[2]],T[-18395]or tc(26927,24565,-18395)
                            end
                        else
                            gb,Sa,Ob=L(Oc[31730],77),L(Oc[24414],115),L(Oc[8213],13);
                            Xc,kb=Sa==0 and xb-gb or Sa-1,Ma[gb];
                            uc,c=ab(kb(Pb(Ma,gb+1,gb+Xc)))
                            if(Ob==0)then
                                Ga=T[-3678]or tc(53689,9941,-3678)
                                continue
                            else
                                Ga=T[-27938]or tc(11444,107898,-27938)
                                continue
                            end
                            Ga=43171
                        end
                    elseif Ga>42346 then
                        if Ga<=43168 then
                            if Ga>43060 then
                                kb,uc=Sa(Ob,Xc);
                                Xc=kb
                                if Xc==nil then
                                    Ga=T[27700]or tc(2703,125011,27700)
                                else
                                    Ga=17361
                                end
                            elseif Ga>42781 then
                                gb=z(Sa)
                                if(gb~=nil and gb[ca('\170\230\17\129\220\n','\245\185x')]~=nil)then
                                    Ga=T[25012]or tc(51289,107990,25012)
                                    continue
                                else
                                    Ga=T[32677]or tc(6575,20471,32677)
                                    continue
                                end
                                Ga=T[-5410]or tc(40055,27320,-5410)
                            else
                                Sa[52851]=Ob
                                if(gb==2)then
                                    Ga=T[9286]or tc(38528,106604,9286)
                                    continue
                                else
                                    Ga=T[-14550]or tc(2100,72032,-14550)
                                    continue
                                end
                                Ga=T[13691]or tc(56164,103619,13691)
                            end
                        elseif Ga>43171 then
                            uc=uc+U;
                            Ha=uc
                            if uc~=uc then
                                Ga=T[6205]or tc(16216,130738,6205)
                            else
                                Ga=55998
                            end
                        else
                            Lb(uc,1,c,gb,Ma);
                            Ga=T[-14509]or tc(48612,43576,-14509)
                        end
                    elseif Ga<41119 then
                        if Ga>=40841 then
                            if Ga<=40841 then
                                Sa,Ob,Xc=cd
                                if(Yc(Sa)~=ca('\228\216\179\215\246\196\178\218','\130\173\221\180'))then
                                    Ga=T[4671]or tc(3810,111796,4671)
                                    continue
                                else
                                    Ga=T[7932]or tc(8500,18688,7932)
                                    continue
                                end
                                Ga=T[7299]or tc(10275,16873,7299)
                            else
                                if Ua>218 then
                                    Ga=T[-22250]or tc(35796,56401,-22250)
                                    continue
                                else
                                    Ga=T[7119]or tc(37776,13257,7119)
                                    continue
                                end
                                Ga=T[29067]or tc(10158,118,29067)
                            end
                        else
                            if(Ua>179)then
                                Ga=T[577]or tc(54791,64802,577)
                                continue
                            else
                                Ga=T[-4872]or tc(37490,10172,-4872)
                                continue
                            end
                            Ga=T[26876]or tc(63665,57731,26876)
                        end
                    elseif Ga>=42138 then
                        if Ga<=42138 then
                            Ga,uc[(zc-215)]=T[17988]or tc(28140,122557,17988),Ra
                        else
                            vc-=1;
                            Ga,Qb[vc]=T[-2633]or tc(45613,38135,-2633),{[13991]=174,[8213]=L(Oc[8213],1),[31730]=L(Oc[31730],226),[24414]=0}
                        end
                    elseif Ga<=41119 then
                        c,Ga=Ob-1,T[29461]or tc(941,115821,29461)
                    else
                        Oc[13991]=1;
                        vc+=1;
                        Ga=T[32140]or tc(22204,29568,32140)
                    end
                elseif Ga>15862 then
                    if Ga<23567 then
                        if Ga>18703 then
                            if Ga>=20696 then
                                if Ga>=21305 then
                                    if Ga<=21806 then
                                        if Ga<=21305 then
                                            kb={Ob(Ma[gb+1],Ma[gb+2])};
                                            Lb(kb,1,Sa,gb+3,Ma)
                                            if(Ma[gb+3]~=nil)then
                                                Ga=T[31235]or tc(5383,115612,31235)
                                                continue
                                            else
                                                Ga=T[-26930]or tc(54811,116712,-26930)
                                                continue
                                            end
                                            Ga=T[-22962]or tc(26131,17185,-22962)
                                        else
                                            if Ma[Oc[8213]]then
                                                Ga=T[-4704]or tc(31618,129839,-4704)
                                                continue
                                            end
                                            Ga=T[4933]or tc(60148,57160,4933)
                                        end
                                    else
                                        zc=c
                                        if U~=U then
                                            Ga=T[13216]or tc(6876,20320,13216)
                                        else
                                            Ga=13254
                                        end
                                    end
                                elseif Ga<=20696 then
                                    if Ua>100 then
                                        Ga=T[26165]or tc(55993,124306,26165)
                                        continue
                                    else
                                        Ga=T[16825]or tc(47071,20087,16825)
                                        continue
                                    end
                                    Ga=T[9755]or tc(25609,17675,9755)
                                else
                                    uc,c=Sa[13847],Oc[13847];
                                    c=ca('8\157A\4','\242\31')..c;
                                    U='';
                                    Ga,Ab,zc,Ha=16233,1,(#uc-1)+29,29
                                end
                            elseif Ga>19168 then
                                if Ga>20409 then
                                    Oc=Qb[vc];
                                    Ua,Ga=Oc[13991],T[-20497]or tc(16261,15426,-20497)
                                else
                                    return Pb(Ma,gb,gb+Xc-1)
                                end
                            elseif Ga>18969 then
                                Ha=Ha+Ab;
                                Zb=Ha
                                if Ha~=Ha then
                                    Ga=T[18214]or tc(28267,74079,18214)
                                else
                                    Ga=5009
                                end
                            elseif Ga>18719 then
                                if Ua>80 then
                                    Ga=T[7684]or tc(9544,99739,7684)
                                    continue
                                else
                                    Ga=T[381]or tc(14042,107771,381)
                                    continue
                                end
                                Ga=T[-19067]or tc(6818,20338,-19067)
                            else
                                if(Zb==1)then
                                    Ga=T[-26390]or tc(48580,7881,-26390)
                                    continue
                                else
                                    Ga=T[-1833]or tc(15497,17463,-1833)
                                    continue
                                end
                                Ga=T[-16084]or tc(59502,21811,-16084)
                            end
                        elseif Ga<17156 then
                            if Ga>=16336 then
                                if Ga<=16463 then
                                    if Ga<=16336 then
                                        Lb(uc,1,Sa,gb+3,Ma);
                                        Ma[gb+2]=Ma[gb+3];
                                        vc+=Oc[22];
                                        Ga=T[16697]or tc(3648,14556,16697)
                                    else
                                        vc-=1;
                                        Ga,Qb[vc]=T[-29708]or tc(59840,56924,-29708),{[13991]=62,[8213]=L(Oc[8213],216),[31730]=L(Oc[31730],53),[24414]=0}
                                    end
                                else
                                    vc+=Oc[22];
                                    Ga=T[16963]or tc(6563,20081,16963)
                                end
                            elseif Ga>16233 then
                                gb,Sa=Oc[35886],Oc[52851];
                                Ob=vb[Sa]or xc[26341][Sa]
                                if gb==1 then
                                    Ga=T[17234]or tc(9761,30597,17234)
                                    continue
                                elseif(gb==2)then
                                    Ga=T[29010]or tc(27518,84526,29010)
                                    continue
                                else
                                    Ga=T[13136]or tc(50754,9020,13136)
                                    continue
                                end
                                Ga=T[19739]or tc(63142,61373,19739)
                            else
                                Zb=Ha
                                if zc~=zc then
                                    Ga=T[-14709]or tc(30858,79416,-14709)
                                else
                                    Ga=T[-1849]or tc(64855,58569,-1849)
                                end
                            end
                        elseif Ga>=17903 then
                            if Ga<=18583 then
                                if Ga<=17903 then
                                    Ma[Oc[8213]],Ga=Ob[Oc[28751]][Oc[13847]],T[-2065]or tc(16407,30060,-2065)
                                else
                                    vc+=Oc[22];
                                    Ga=T[7376]or tc(14719,12229,7376)
                                end
                            else
                                if gb==3 then
                                    Ga=T[25612]or tc(52418,14492,25612)
                                    continue
                                end
                                Ga=T[23517]or tc(37347,49776,23517)
                            end
                        elseif Ga<17361 then
                            Ma[Oc[8213]],Ga=Ma[Oc[31730]],T[17079]or tc(10821,7391,17079)
                        elseif Ga>17361 then
                            Sa,Ob,Xc=za(Sa);
                            Ga=T[-11881]or tc(12044,109015,-11881)
                        else
                            cc(uc);
                            ma[kb],Ga=nil,T[19651]or tc(15121,117790,19651)
                        end
                    elseif Ga>29338 then
                        if Ga<=32071 then
                            if Ga<32030 then
                                if Ga>=31135 then
                                    if Ga<=31135 then
                                        if(Ua>178)then
                                            Ga=T[7079]or tc(64516,99913,7079)
                                            continue
                                        else
                                            Ga=T[-23677]or tc(20687,116182,-23677)
                                            continue
                                        end
                                        Ga=T[8529]or tc(36266,47722,8529)
                                    else
                                        kb,uc=Cc(ma[Oc],Ob,Ma[gb+1],Ma[gb+2])
                                        if(not kb)then
                                            Ga=T[-6660]or tc(26743,78471,-6660)
                                            continue
                                        else
                                            Ga=T[20686]or tc(59157,111622,20686)
                                            continue
                                        end
                                        Ga=64644
                                    end
                                else
                                    if Ua>68 then
                                        Ga=T[9485]or tc(7473,117736,9485)
                                        continue
                                    else
                                        Ga=T[-7158]or tc(37604,59596,-7158)
                                        continue
                                    end
                                    Ga=T[-26289]or tc(9030,1502,-26289)
                                end
                            elseif Ga<=32055 then
                                if Ga<=32030 then
                                    ja=Ab[31730];
                                    Ra=cd[ja]
                                    if(Ra==nil)then
                                        Ga=T[-30224]or tc(57793,110329,-30224)
                                        continue
                                    else
                                        Ga=T[30141]or tc(22952,76377,30141)
                                        continue
                                    end
                                    Ga=42138
                                else
                                    Ma[Oc[8213]],Ga=Ob,T[22311]or tc(6336,23955,22311)
                                end
                            else
                                if(Ua>59)then
                                    Ga=T[-7660]or tc(49781,22392,-7660)
                                    continue
                                else
                                    Ga=T[945]or tc(46677,28042,945)
                                    continue
                                end
                                Ga=T[19269]or tc(10118,158,19269)
                            end
                        elseif Ga<33677 then
                            if Ga>33201 then
                                gb,Sa,Ga=Qb[vc],nil,T[-27315]or tc(23274,99352,-27315)
                            else
                                if Oc[24414]==5 then
                                    Ga=T[-11634]or tc(18508,99170,-11634)
                                    continue
                                elseif Oc[24414]==55 then
                                    Ga=T[22]or tc(11260,30070,22)
                                    continue
                                elseif(Oc[24414]==129)then
                                    Ga=T[31800]or tc(11928,14154,31800)
                                    continue
                                else
                                    Ga=T[26792]or tc(27902,67305,26792)
                                    continue
                                end
                                Ga=T[-12758]or tc(10175,133,-12758)
                            end
                        elseif Ga>33677 then
                            if Ua>195 then
                                Ga=T[15216]or tc(9360,111878,15216)
                                continue
                            else
                                Ga=T[-22850]or tc(32514,72239,-22850)
                                continue
                            end
                            Ga=T[-28275]or tc(1866,8650,-28275)
                        else
                            Lb(ub[60532],1,Sa,gb,Ma);
                            Ga=T[-8326]or tc(38279,45725,-8326)
                        end
                    elseif Ga<26663 then
                        if Ga<=24942 then
                            if Ga>=23953 then
                                if Ga<=23953 then
                                    if uc[2]>=Oc[8213]then
                                        Ga=T[6245]or tc(35834,104271,6245)
                                        continue
                                    end
                                    Ga=T[-27697]or tc(55159,98700,-27697)
                                else
                                    Sa,Ob,Xc=ma
                                    if Yc(Sa)~=ca('\152\213\16\237\138\201\17\224','\254\160~\142')then
                                        Ga=T[-11951]or tc(20082,71753,-11951)
                                        continue
                                    end
                                    Ga=T[441]or tc(43905,15502,441)
                                end
                            elseif Ga>23567 then
                                Xc,Ga=c,T[-1804]or tc(27406,126634,-1804)
                                continue
                            else
                                Ga,kb=T[30324]or tc(40222,28050,30324),kb..r_(L(ba(Ob,(Ha-72)+1),ba(Xc,(Ha-72)%#Xc+1)))
                            end
                        elseif Ga>25250 then
                            Sa=ub[9682];
                            Ga,xb=T[16541]or tc(61710,20726,16541),gb+Sa-1
                        else
                            if Ua>123 then
                                Ga=T[-1662]or tc(35996,32030,-1662)
                                continue
                            else
                                Ga=T[21419]or tc(64876,9179,21419)
                                continue
                            end
                            Ga=T[-27159]or tc(28388,23352,-27159)
                        end
                    elseif Ga>27072 then
                        if Ga<=28635 then
                            vc-=1;
                            Qb[vc],Ga={[13991]=138,[8213]=L(Oc[8213],75),[31730]=L(Oc[31730],212),[24414]=0},T[-26525]or tc(29074,22178,-26525)
                        else
                            vb[Oc[52851]]=Ma[Oc[8213]];
                            vc+=1;
                            Ga=T[-20031]or tc(18217,25067,-20031)
                        end
                    elseif Ga>26845 then
                        V'';
                        Ga=T[-3447]or tc(53677,12560,-3447)
                    elseif Ga>=26697 then
                        if Ga>26697 then
                            ja={[1]=Ma[Ab[31730]],[2]=1};
                            ja[3]=ja;
                            uc[(zc-215)],Ga=ja,T[19334]or tc(1694,108067,19334)
                        else
                            U,Ga=U..r_(L(ba(uc,(Zb-29)+1),ba(c,(Zb-29)%#c+1))),T[-29714]or tc(14799,24704,-29714)
                        end
                    else
                        if(Oc[24414]==83)then
                            Ga=T[16420]or tc(16130,18949,16420)
                            continue
                        else
                            Ga=T[21420]or tc(37023,52861,21420)
                            continue
                        end
                        Ga=T[-31669]or tc(50879,58245,-31669)
                    end
                elseif Ga<8552 then
                    if Ga>4157 then
                        if Ga>=6975 then
                            if Ga>=7320 then
                                if Ga<8061 then
                                    if(Ua>91)then
                                        Ga=T[24810]or tc(36717,47543,24810)
                                        continue
                                    else
                                        Ga=T[29262]or tc(7686,74035,29262)
                                        continue
                                    end
                                    Ga=T[-12996]or tc(11688,6772,-12996)
                                elseif Ga>8061 then
                                    if Ua>236 then
                                        Ga=T[21362]or tc(53268,426,21362)
                                        continue
                                    else
                                        Ga=T[8403]or tc(33939,42707,8403)
                                        continue
                                    end
                                    Ga=T[20917]or tc(34568,40980,20917)
                                else
                                    Ga,c=T[29305]or tc(18442,107791,29305),c..r_(L(ba(kb,(Ab-127)+1),ba(uc,(Ab-127)%#uc+1)))
                                end
                            elseif Ga>6975 then
                                Gc=false;
                                vc+=1
                                if Ua>138 then
                                    Ga=T[19336]or tc(32308,126802,19336)
                                    continue
                                else
                                    Ga=T[8422]or tc(24646,131052,8422)
                                    continue
                                end
                                Ga=T[-12194]or tc(3997,14503,-12194)
                            else
                                vc-=1;
                                Qb[vc],Ga={[13991]=195,[8213]=L(Oc[8213],215),[31730]=L(Oc[31730],198),[24414]=0},T[-30832]or tc(35284,48744,-30832)
                            end
                        elseif Ga>=5009 then
                            if Ga<5169 then
                                if(Ab>=0 and Ha>zc)or((Ab<0 or Ab~=Ab)and Ha<zc)then
                                    Ga=T[-15447]or tc(56521,119801,-15447)
                                else
                                    Ga=26697
                                end
                            elseif Ga>5169 then
                                vc+=1;
                                Ga=T[17894]or tc(63161,54139,17894)
                            else
                                if Ua>9 then
                                    Ga=T[29744]or tc(33019,4910,29744)
                                    continue
                                else
                                    Ga=T[26580]or tc(38329,12299,26580)
                                    continue
                                end
                                Ga=T[-25575]or tc(47057,36963,-25575)
                            end
                        elseif Ga<=4245 then
                            vc+=Oc[22];
                            Ga=T[29591]or tc(8466,1570,29591)
                        else
                            gb,Sa=Oc[8213],Oc[52851];
                            xb=gb+6;
                            Ob,Xc=Ma[gb],nil;
                            Xc=fb(Ob)==ca('\160i\207\203\178u\206\198','\198\28\161\168')
                            if(Xc)then
                                Ga=T[-17907]or tc(10263,27569,-17907)
                                continue
                            else
                                Ga=T[15236]or tc(59848,16748,15236)
                                continue
                            end
                            Ga=T[-29858]or tc(22257,29507,-29858)
                        end
                    elseif Ga<=3039 then
                        if Ga<=2095 then
                            if Ga<=1959 then
                                if Ga>958 then
                                    V'';
                                    Ga=T[22309]or tc(24724,104850,22309)
                                elseif Ga<=698 then
                                    gb,Sa=nil,Ma[Oc[8213]];
                                    gb=fb(Sa)==ca('\26\162\b\b\b\190\t\5','|\215fk')
                                    if(not gb)then
                                        Ga=T[-14164]or tc(4721,104414,-14164)
                                        continue
                                    else
                                        Ga=T[-2653]or tc(62660,7673,-2653)
                                        continue
                                    end
                                    Ga=T[12603]or tc(1284,27321,12603)
                                else
                                    Sa[28751]=Xc;
                                    Ga,kb=21255,nil
                                end
                            else
                                if Yc(Sa)==ca('4\176\"\189%','@\209')then
                                    Ga=T[-11986]or tc(57066,15459,-11986)
                                    continue
                                end
                                Ga=T[-32497]or tc(5525,119450,-32497)
                            end
                        elseif Ga>2693 then
                            gb=Oc[52851];
                            Ma[Oc[24414]]=Ma[Oc[31730]][gb];
                            vc+=1;
                            Ga=T[-17343]or tc(60519,55997,-17343)
                        elseif Ga<=2221 then
                            if(not Gc)then
                                Ga=T[-28044]or tc(52732,12823,-28044)
                                continue
                            else
                                Ga=T[-27132]or tc(47539,45620,-27132)
                                continue
                            end
                            Ga=7256
                        else
                            if(Ua>44)then
                                Ga=T[11257]or tc(59008,19531,11257)
                                continue
                            else
                                Ga=T[-24337]or tc(37018,52678,-24337)
                                continue
                            end
                            Ga=T[23242]or tc(37238,47054,23242)
                        end
                    elseif Ga<=3973 then
                        if Ga>3701 then
                            Ma[Oc[8213]],Ga=nil,T[21647]or tc(25264,18316,21647)
                        elseif Ga<=3281 then
                            Ga,Ma[Oc[8213]]=T[-22007]or tc(39067,49561,-22007),Oc[52851]
                        else
                            if(Oc[24414]==58)then
                                Ga=T[-3057]or tc(47849,12686,-3057)
                                continue
                            else
                                Ga=T[10877]or tc(58309,9681,10877)
                                continue
                            end
                            Ga=T[29660]or tc(39035,52921,29660)
                        end
                    elseif Ga<=3995 then
                        Ob,Xc=gb[52851],Oc[52851];
                        Xc=ca('\24\169a0','\210+')..Xc;
                        kb='';
                        U,uc,Ga,c=1,72,T[-6851]or tc(48838,26367,-6851),(#Ob-1)+72
                    else
                        Ab=U
                        if Ha~=Ha then
                            Ga=T[4004]or tc(33474,2258,4004)
                        else
                            Ga=12567
                        end
                    end
                elseif Ga<=12625 then
                    if Ga>=10904 then
                        if Ga<11321 then
                            if Ga>11079 then
                                if(Ua>172)then
                                    Ga=T[-17461]or tc(16217,19069,-17461)
                                    continue
                                else
                                    Ga=T[29270]or tc(17198,129843,29270)
                                    continue
                                end
                                Ga=T[-3636]or tc(58879,49733,-3636)
                            elseif Ga>10904 then
                                if Ua>173 then
                                    Ga=T[17503]or tc(22466,84967,17503)
                                    continue
                                else
                                    Ga=T[-17787]or tc(64054,112183,-17787)
                                    continue
                                end
                                Ga=T[-22483]or tc(41106,39330,-22483)
                            else
                                vc-=1;
                                Qb[vc],Ga={[13991]=38,[8213]=L(Oc[8213],53),[31730]=L(Oc[31730],189),[24414]=0},T[327]or tc(1620,8424,327)
                            end
                        elseif Ga>12567 then
                            if Zb==2 then
                                Ga=T[-17009]or tc(24111,85064,-17009)
                                continue
                            end
                            Ga=T[14617]or tc(63035,22406,14617)
                        elseif Ga<=11321 then
                            if(Ua>62)then
                                Ga=T[-31977]or tc(59719,115705,-31977)
                                continue
                            else
                                Ga=T[-26886]or tc(16713,70492,-26886)
                                continue
                            end
                            Ga=T[29970]or tc(3932,14816,29970)
                        else
                            if(zc>=0 and U>Ha)or((zc<0 or zc~=zc)and U<Ha)then
                                Ga=T[9343]or tc(62792,10068,9343)
                            else
                                Ga=8061
                            end
                        end
                    elseif Ga>=10143 then
                        if Ga>10390 then
                            if(Ua>142)then
                                Ga=T[1078]or tc(56229,15067,1078)
                                continue
                            else
                                Ga=T[-18408]or tc(10009,101159,-18408)
                                continue
                            end
                            Ga=T[8970]or tc(57123,2545,8970)
                        elseif Ga>10143 then
                            Ma[Oc[24414]]=rc(Oc[41034]);
                            vc+=1;
                            Ga=T[-6242]or tc(5171,13569,-6242)
                        else
                            Ga,Xc=T[-23075]or tc(65253,54344,-23075),c
                            continue
                        end
                    elseif Ga<=9046 then
                        if Ga>8552 then
                            Ab=Qb[vc];
                            vc+=1;
                            Zb=Ab[8213]
                            if(Zb==0)then
                                Ga=T[25070]or tc(52129,23715,25070)
                                continue
                            else
                                Ga=T[-1892]or tc(29158,104104,-1892)
                                continue
                            end
                            Ga=T[-4858]or tc(7532,118333,-4858)
                        else
                            if(Ha>=0 and c>U)or((Ha<0 or Ha~=Ha)and c<U)then
                                Ga=T[-9832]or tc(1115,69499,-9832)
                            else
                                Ga=T[19076]or tc(20973,103232,19076)
                            end
                        end
                    else
                        uc,Ga=uc..r_(L(ba(Xc,(zc-86)+1),ba(kb,(zc-86)%#kb+1))),T[9640]or tc(37776,26486,9640)
                    end
                elseif Ga>=14757 then
                    if Ga>15334 then
                        if Ga<=15530 then
                            U=U+zc;
                            Ab=U
                            if U~=U then
                                Ga=T[-12627]or tc(18838,115246,-12627)
                            else
                                Ga=12567
                            end
                        else
                            zc=c
                            if U~=U then
                                Ga=T[-20301]or tc(23736,87590,-20301)
                            else
                                Ga=8552
                            end
                        end
                    elseif Ga>14812 then
                        Sa,Ob,Xc=za(Sa);
                        Ga=T[-16191]or tc(39343,28256,-16191)
                    elseif Ga<=14757 then
                        kb,uc=Sa(Ob,Xc);
                        Xc=kb
                        if Xc==nil then
                            Ga=T[14807]or tc(46190,64887,14807)
                        else
                            Ga=T[11199]or tc(58988,22384,11199)
                        end
                    else
                        Xc,Ga=Sa-1,T[-31273]or tc(20560,118768,-31273)
                    end
                elseif Ga>13403 then
                    if Ga<=14097 then
                        gb,Sa,Ob=Oc[8213],Oc[24414],Oc[52851];
                        Xc=Ma[Sa];
                        Ma[gb+1]=Xc;
                        Ma[gb]=Xc[Ob];
                        vc+=1;
                        Ga=T[-24413]or tc(59483,57049,-24413)
                    else
                        Ga,xb=T[-4079]or tc(25104,124698,-4079),gb+c-1
                    end
                elseif Ga>13254 then
                    vc-=1;
                    Ga,Qb[vc]=T[-26584]or tc(44031,40005,-26584),{[13991]=123,[8213]=L(Oc[8213],110),[31730]=L(Oc[31730],182),[24414]=0}
                elseif Ga<=12946 then
                    if Ua>234 then
                        Ga=T[-32655]or tc(9092,12102,-32655)
                        continue
                    else
                        Ga=T[24695]or tc(49431,102276,24695)
                        continue
                    end
                    Ga=T[-26769]or tc(31035,28665,-26769)
                else
                    if(Ha>=0 and c>U)or((Ha<0 or Ha~=Ha)and c<U)then
                        Ga=T[-18369]or tc(36244,47784,-18369)
                    else
                        Ga=9046
                    end
                end
            until Ga==46744
        end
        return function(...)
            local kc,sc,Ka,Ec,da,Fc,Zc,Lc,Kc,ib,Fb;
            Fb,ib={},function(Pa,ob,ea)
                Fb[ea]=La(ob,2923)-La(Pa,22420)
                return Fb[ea]
            end;
            Fc=Fb[-1307]or ib(7515,41808,-1307)
            while Fc~=27729 do
                if Fc>34839 then
                    if Fc>50221 then
                        Fc=Fb[-11076]or ib(41658,92692,-11076)
                        continue
                    elseif Fc>45047 then
                        return V(Ec,0)
                    else
                        Ec,Zc=da[2],nil;
                        Lc=Ec;
                        Zc=fb(Lc)==ca('\b\184\197\18\162\208','{\204\183')
                        if Zc==false then
                            Fc=Fb[-31827]or ib(41571,95589,-31827)
                            continue
                        end
                        Fc=50221
                    end
                elseif Fc>=29453 then
                    if Fc<32131 then
                        return Pb(da,2,Kc)
                    elseif Fc<=32131 then
                        da,Kc=ab(M(h,kc,C[51848],C[49992],sc))
                        if(da[1])then
                            Fc=Fb[-26477]or ib(7657,46817,-26477)
                            continue
                        else
                            Fc=Fb[20820]or ib(20387,49989,20820)
                            continue
                        end
                        Fc=55379
                    else
                        Fc,Ec=Fb[-26274]or ib(21846,52612,-26274),fb(Ec)
                    end
                elseif Fc<=23916 then
                    Ka,kc,sc=fa_(...),rc(C[12604]),{[9682]=0,[60532]={}};
                    Lb(Ka,1,C[54766],0,kc)
                    if C[54766]<Ka[ca('&','H')]then
                        Fc=Fb[26854]or ib(37682,81840,26854)
                        continue
                    end
                    Fc=Fb[13501]or ib(48972,93488,13501)
                else
                    da,Kc=C[54766]+1,Ka[ca('\143','\225')]-C[54766];
                    sc[9682]=Kc;
                    Lb(Ka,da,da+Kc-1,1,sc[60532]);
                    Fc=Fb[7456]or ib(10402,63442,7456)
                end
            end
        end
    end
    return aa(ya,Q)
end)
local Yb;
Yb,Nc={[0]=0},function()
    Yb[0]=Yb[0]+1
    return{[3]=Yb,[2]=Yb[0]}
end;
Oa=lb
return(function()
    return Oa(ad(P'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'),{})
end)()(...)
