function rb_C2M_DatSanCheck(INFO)

%sanity check
if ~isequal(length(INFO.NI.subsfolder.infants), length(INFO.NI.subsdata.infants)) || ~isequal(length(INFO.NI.subjname.infants), length(INFO.NI.subsdata.infants))
    error ('Not the same number of infants in NI information on subjects (subfolder, subjname or datafile)')
elseif ~isequal(length(INFO.UU.subsfolder.infants), length(INFO.UU.subsdata.infants)) || ~isequal(length(INFO.UU.subjname.infants), length(INFO.UU.subsdata.infants))
    error ('Not the same number of infants in UU information on subjects (subfolder, subjname or datafile)')
end