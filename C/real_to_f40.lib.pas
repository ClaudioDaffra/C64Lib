
unit MSBin;

interface
//
// The following are implementations of Microsoft RTL functions
// not include in the Borland RTL.
//
// Functions:
//     _fmsbintoieee()
//     _fieeetomsbin()
//     _dmsbintoieee()
//     _dieeetomsbin()
//
// These functions convert back and forth from Microsoft Binary
// Format to IEEE floating point format.
//
// As with the Microsoft RTL functions,
//
// The argument srcX points to the value to be converted and the
// result is stored at the location given at destX.
//
// These routines do not handle IEE NAN's and infinities.  IEEE
// denormals are treated as 0's.
//
// Return:
//
// These functions return 0 if the conversion is successful and 1
// if the conversion causes an overflow.
//
//
//
// Examples of the use of these functions can be found on-line as
// MSBIN.ZIP.
//


function _fmsbintoieee(const src4: Single; var dest4: Single): Integer;
function _fieeetomsbin(const src4: Single; var dest4: Single): Integer;
function _dmsbintoieee(const src8: Double; var dest8: Double): Integer;
function _dieeetomsbin(const src8: Double; var dest8: Double): Integer;

implementation



function _fmsbintoieee(const src4: Single; var dest4: Single): Integer;
var
  msbin: array[0..3] of Byte absolute src4;
  ieee: array[0..3] of Byte absolute dest4;
  sign: Byte;
  ieee_exp: Byte;
  i: Integer;
begin
  (* MS Binary Format                         *)
  (* byte order =>    m3 | m2 | m1 | exponent *)
  (* m1 is most significant byte => sbbb|bbbb *)
  (* m3 is the least significant byte         *)
  (*      m = mantissa byte                   *)
  (*      s = sign bit                        *)
  (*      b = bit                             *)
  sign := msbin[2] and $80;    (* 1000|0000b  *)
  (* IEEE Single Precision Float Format       *)
  (*    m3        m2        m1     exponent   *)
  (* mmmm|mmmm mmmm|mmmm emmm|mmmm seee|eeee  *)
  (*          s = sign bit                    *)
  (*          e = exponent bit                *)
  (*          m = mantissa bit                *)
  for i := 0 to 3 do
    ieee[i] := 0;
  (* any msbin w/ exponent of zero = zero *)
  if msbin[3] = 0 then
  begin
    Result := 0;
    Exit;
  end;
  ieee[3] := ieee[3] or sign;
  (* MBF is bias 128 and IEEE is bias 127. ALSO, MBF places   *)
  (* the decimal point before the assumed bit, while          *)
  (* IEEE places the decimal point after the assumed bit.     *)
  ieee_exp := msbin[3] - 2;   (* actually, msbin[3]-1-128+127 *)
  (* the first 7 bits of the exponent in ieee[3] *)
  ieee[3] := ieee[3] or (ieee_exp shr 1);
  (* the one remaining bit in first bin of ieee[2] *)
  ieee[2] := ieee[2] or (ieee_exp shl 7);
  (* 0111|1111b : mask out the msbin sign bit *)
  ieee[2] := ieee[2] or (msbin[2] and $7f);
  ieee[1] := msbin[1];
  ieee[0] := msbin[0];
  Result := 0;
end;



function _fieeetomsbin(const src4: Single; var dest4: Single): Integer;
var
  ieee: array[0..3] of Byte absolute src4;
  msbin: array[0..3] of Byte absolute dest4;
  sign: Byte;
  msbin_exp: Byte;
  i: Integer;
begin
  msbin_exp := 0;
  (* See _fmsbintoieee() for details of formats   *)
  sign := ieee[3] and $80;
  msbin_exp := msbin_exp or (ieee[3] shl 1);
  msbin_exp := msbin_exp or (ieee[2] shr 7);
  (* An ieee exponent of 0xfe overflows in MBF    *)
  if msbin_exp = $fe then
  begin
    Result := 1;
    Exit;
  end;
  msbin_exp := msbin_exp + 2; (* actually, -127 + 128 + 1 *)
  for i := 0 to 3 do
    msbin[i] := 0;
  msbin[3] := msbin_exp;
  msbin[2] := msbin[2] or sign;
  msbin[2] := msbin[2] or (ieee[2] and $7f);
  msbin[1] := ieee[1];
  msbin[0] := ieee[0];
  Result := 0;
end;



function _dmsbintoieee(const src8: Double; var dest8: Double): Integer;
var
  msbin: array[0..7] of Byte;
  ieee: array[0..7] of Byte absolute dest8;
  sign: Byte;
  ieee_exp: Byte;
  i: Integer;
begin
  (* A manipulatable copy of the msbin number     *)
  Move(src8, msbin, 8);
 
  sign := msbin[6] and $80;        (* 1000|0000b  *)
 
  for i := 0 to 7 do
    ieee[i] := 0;
  (* any msbin w/ exponent of zero = zero *)
  if msbin[7] = 0 then
  begin
    Result := 0;
    Exit;
  end;
  ieee[7] := ieee[7] or sign;
  (* MBF is bias 128 and IEEE is bias 1023. ALSO, MBF places  *)
  (* the decimal point before the assumed bit, while          *)
  (* IEEE places the decimal point after the assumed bit.     *)
  ieee_exp := msbin[7] - 128 - 1 + 1023;
  (* First 4 bits of the msbin exponent   *)
  (* go into the last 4 bits of ieee[7]   *)
  ieee[7] := ieee[7] or (ieee_exp shr 4);
  (* The last 4 bits of msbin exponent    *)
  (* go into the first 4 bits of ieee[6]  *)
  ieee[6] := ieee[6] or (ieee_exp shl 4);
 
  for i := 6 downto 1 do
  begin
    msbin[i] := msbin[i] shl 1;
    msbin[i] := msbin[i] or (msbin[i - 1] shr 7);
  end;
  msbin[0] := msbin[0] shl 1;
 
  for i := 6 downto 1 do
  begin
    ieee[i] := ieee[i] or (msbin[i] shr 4);
    ieee[i - 1] := ieee[i - 1] or (msbin[i] shl 4);
  end;
  ieee[0] := ieee[0] or (msbin[0] shr 4);
 
  if (msbin[0] and $0f) > 0 then
    Result := 1
  else
    Result := 0;
end;



function _dieeetomsbin(const src8: Double; var dest8: Double): Integer;
var
  ieee: array[0..7] of Byte;
  msbin: array[0..7] of Byte absolute dest8;
  sign: Byte;
  any_on: Byte;
  msbin_exp: SmallInt;
  i: Integer;
begin
  any_on := 0;
  (* Make a clobberable copy of the source number *)
  Move(src8, ieee, 8);
  for i := 0 to 7 do
	msbin[i] := 0;
  (* If all are zero in src8, the msbin should be zero *)
  for i := 0 to 7 do
	any_on := any_on or ieee[i];
  if any_on = 0 then
  begin
	Result := 0;
	Exit;
  end;
  sign := ieee[7] and $80;
  msbin[6] := msbin[6] or sign;
  msbin_exp := (ieee[7] and $7f) * $10;
  msbin_exp := msbin_exp + (ieee[6] shr 4);
  if (msbin_exp - $3ff) > $80 then
  begin
	Result := 1;
	Exit;
  end;
  msbin[7] := msbin_exp - $3ff + $80 + 1;
  (* The ieee mantissa must be shifted up 3 bits *)
  ieee[6] := ieee[6] and $0f; 
  (* mask out the exponent in the second byte *)
  for i := 6 downto 1 do
  begin
	msbin[i] := msbin[i] or (ieee[i] shl 3);
	msbin[i] := msbin[i] or (ieee[i - 1] shr 5);
  end;
  msbin[0] := msbin[0] or (ieee[0] shl 3);
  Result := 0;
end;

end.
