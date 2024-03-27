unit cbor.TestCase;

interface

uses
  TestFramework;

type
  TTestCase_cbor = class(TTestCase)
  private
  published
    procedure Test_Unsigned_0;
    procedure Test_Unsigned_8;
    procedure Test_Unsigned_16;
    procedure Test_Unsigned_32;
    procedure Test_Unsigned_64;

    procedure Test_Signed_0;
    procedure Test_Signed_8;
    procedure Test_Signed_16;
    procedure Test_Signed_32;
    procedure Test_Signed_64;

    procedure Test_ByteString_0;
    procedure Test_ByteString_1;
    procedure Test_ByteString_2;
    procedure Test_ByteString_3;
    procedure Test_ByteString_4;
    procedure Test_ByteString_5;
    procedure Test_ByteString_31;

    procedure Test_UTF8_0;
    procedure Test_UTF8_1;
    procedure Test_UTF8_2;
    procedure Test_UTF8_31;
    procedure Test_UTF8_31_1;
    procedure Test_UTF8_31_2;
    procedure Test_UTF8_31_255;

    procedure Test_Array_0;
    procedure Test_Array_1;
    procedure Test_Array_24;
    procedure Test_Array_31;

    procedure Test_Map_0;
    procedure Test_Map_1;
    procedure Test_Map_2;
    procedure Test_Map_24;
    procedure Test_Map_31;

    procedure Test_SemanticPositiveBigNum_0;

    procedure Test_EncodeUInt64_0;
    procedure Test_EncodeUInt64_1;
    procedure Test_EncodeUInt64_2;
    procedure Test_EncodeUInt64_3;
    procedure Test_TborUInt64_0;

    procedure Test_EncodeInt64_0;
    procedure Test_EncodeInt64_1;
    procedure Test_EncodeInt64_2;
    procedure Test_TCborInt64_0;

    procedure Test_EncodeByteString_0;
    procedure Test_EncodeByteString_1;
    procedure Test_EncodeByteString_2;
    procedure Test_EncodeByteString_3;

    procedure Test_EncodeUtf8_0;
    procedure Test_EncodeUtf8_1;
    procedure Test_TCborUTF8_0;

    procedure Test_EncodeArray_0;
    procedure Test_EncodeArray_1;
    procedure Test_EncodeArray_2;
    procedure Test_EncodeArray_3;

    procedure Test_EncodeMap_0;
    procedure Test_EncodeMap_1;
    procedure Test_EncodeMap_2;

    procedure Test_UInt64ToTBytes_0;
    procedure Test_UInt64ToTBytes_1;
    procedure Test_UInt64ToTBytes_2;
    procedure Test_UInt64ToTBytes_3;
  end;

implementation

uses
  Winapi.Windows, System.Generics.Collections, System.SysUtils,
  cbor;

procedure TTestCase_cbor.Test_SemanticPositiveBigNum_0;
begin
  var c : TCbor := TBytes.Create(
    $C2, $45, $01, $00, $70, $A0, $23
  );

  CheckTrue(c.Next);
  Check(cborSemantic = c.DataType);
  var ans := c.AsSemantic;
end;

procedure TTestCase_cbor.Test_Signed_16;
begin
  var c: TCbor := TBytes.Create($39, $d2, $6f, $39, $0a, $0f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals('-53872', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals('-2576', c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_UInt64ToTBytes_0;
begin
  var u := TBytes.Create($30, $3B);
  var d := UInt64ToTBytes(12347);
  for var i := 0 to Length(u)-1 do
    Check(u[i] = d[i]);
end;

procedure TTestCase_cbor.Test_UInt64ToTBytes_1;
begin
  var u := TBytes.Create($22, $D4, $45, $3D);
  var d := UInt64ToTBytes(584336701);
  for var i := 0 to Length(u)-1 do
    Check(u[i] = d[i]);
end;

procedure TTestCase_cbor.Test_UInt64ToTBytes_2;
begin
  var u := TBytes.Create($08, $1B, $FB, $22, $41, $FC, $FF, $B7);
  var d := UInt64ToTBytes(584336701229170615);
  for var i := 0 to Length(u)-1 do
    Check(u[i] = d[i]);
end;

procedure TTestCase_cbor.Test_UInt64ToTBytes_3;
begin
  var u := TBytes.Create($17);
  var d := UInt64ToTBytes(23);
  for var i := 0 to Length(u)-1 do
    Check(u[i] = d[i]);
end;

procedure TTestCase_cbor.Test_ByteString_0;
begin
  var c: TCbor := TBytes.Create($4b, $48, $65, $6c, $6c, $6f, $20, $57, $6f, $72, $6c, $64);

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(12, c.DataItemSize);
  CheckEquals('Hello World', c.AsByteString.aValue[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_1;
begin
  var c: TCbor := TBytes.Create($56, $41, $42, $43, $20, $44, $46, $0D, $0A, $4A, $4B, $20, $69, $73, $20, $74, $68, $65, $20, $62, $65, $73, $74);

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(23, c.DataItemSize);
  CheckEquals('''
  ABC DF
  JK is the best
  ''', c.AsByteString.aValue[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_2;
begin
  var c: TCbor := TBytes.Create(
    $58, $F5, $49, $6E, $20, $74, $68, $65, $20, $62, $65, $67, $69, $6E, $6E, $69
  , $6E, $67, $20, $47, $6F, $64, $20, $63, $72, $65, $61, $74, $65, $64, $20, $74
  , $68, $65, $20, $68, $65, $61, $76, $65, $6E, $73, $20, $61, $6E, $64, $20, $74
  , $68, $65, $20, $65, $61, $72, $74, $68, $2E, $0D, $0A, $4E, $6F, $77, $20, $74
  , $68, $65, $20, $65, $61, $72, $74, $68, $20, $77, $61, $73, $20, $66, $6F, $72
  , $6D, $6C, $65, $73, $73, $20, $61, $6E, $64, $20, $65, $6D, $70, $74, $79, $2C
  , $20, $64, $61, $72, $6B, $6E, $65, $73, $73, $20, $77, $61, $73, $20, $6F, $76
  , $65, $72, $20, $74, $68, $65, $20, $73, $75, $72, $66, $61, $63, $65, $20, $6F
  , $66, $20, $74, $68, $65, $20, $64, $65, $65, $70, $2C, $20, $61, $6E, $64, $20
  , $74, $68, $65, $20, $53, $70, $69, $72, $69, $74, $20, $6F, $66, $20, $47, $6F
  , $64, $20, $77, $61, $73, $20, $68, $6F, $76, $65, $72, $69, $6E, $67, $20, $6F
  , $76, $65, $72, $20, $74, $68, $65, $20, $77, $61, $74, $65, $72, $73, $2E, $0D
  , $0A, $41, $6E, $64, $20, $47, $6F, $64, $20, $73, $61, $69, $64, $2C, $20, $4C
  , $65, $74, $20, $74, $68, $65, $72, $65, $20, $62, $65, $20, $6C, $69, $67, $68
  , $74, $2C, $20, $61, $6E, $64, $20, $74, $68, $65, $72, $65, $20, $77, $61, $73
  , $20, $6C, $69, $67, $68, $74, $2E
  );

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(247, c.DataItemSize);
  CheckEquals('''
  In the beginning God created the heavens and the earth.
  Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.
  And God said, Let there be light, and there was light.
  '''
  , c.AsByteString.aValue[0]
  );

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_3;
begin
  var c: TCbor := TBytes.Create(
    $59, $03, $AD, $4C, $6F, $72, $65, $6D, $20, $69, $70, $73, $75, $6D, $20, $64,
    $6F, $6C, $6F, $72, $20, $73, $69, $74, $20, $61, $6D, $65, $74, $2C, $20, $63,
    $6F, $6E, $73, $65, $63, $74, $65, $74, $75, $72, $20, $61, $64, $69, $70, $69,
    $73, $63, $69, $6E, $67, $20, $65, $6C, $69, $74, $2E, $20, $4E, $75, $6C, $6C,
    $61, $20, $6E, $75, $6E, $63, $20, $6D, $61, $73, $73, $61, $2C, $20, $64, $69,
    $67, $6E, $69, $73, $73, $69, $6D, $20, $65, $75, $20, $6E, $69, $73, $69, $20,
    $76, $69, $74, $61, $65, $2C, $20, $63, $6F, $6E, $76, $61, $6C, $6C, $69, $73,
    $20, $66, $65, $72, $6D, $65, $6E, $74, $75, $6D, $20, $73, $61, $70, $69, $65,
    $6E, $2E, $20, $53, $75, $73, $70, $65, $6E, $64, $69, $73, $73, $65, $20, $63,
    $6F, $6E, $67, $75, $65, $20, $75, $72, $6E, $61, $20, $65, $75, $20, $65, $6C,
    $69, $74, $20, $63, $6F, $6E, $73, $65, $71, $75, $61, $74, $20, $65, $66, $66,
    $69, $63, $69, $74, $75, $72, $2E, $20, $51, $75, $69, $73, $71, $75, $65, $20,
    $73, $69, $74, $20, $61, $6D, $65, $74, $20, $61, $63, $63, $75, $6D, $73, $61,
    $6E, $20, $74, $65, $6C, $6C, $75, $73, $2E, $20, $4E, $75, $6C, $6C, $61, $20,
    $72, $68, $6F, $6E, $63, $75, $73, $20, $6E, $75, $6E, $63, $20, $72, $69, $73,
    $75, $73, $2C, $20, $61, $74, $20, $66, $61, $75, $63, $69, $62, $75, $73, $20,
    $65, $78, $20, $61, $6C, $69, $71, $75, $65, $74, $20, $61, $63, $2E, $20, $49,
    $6E, $20, $61, $63, $20, $6D, $61, $73, $73, $61, $20, $61, $72, $63, $75, $2E,
    $20, $4E, $75, $6C, $6C, $61, $6D, $20, $65, $66, $66, $69, $63, $69, $74, $75,
    $72, $20, $64, $69, $63, $74, $75, $6D, $20, $73, $65, $6D, $2C, $20, $71, $75,
    $69, $73, $20, $70, $65, $6C, $6C, $65, $6E, $74, $65, $73, $71, $75, $65, $20,
    $61, $72, $63, $75, $20, $76, $65, $6E, $65, $6E, $61, $74, $69, $73, $20, $61,
    $6C, $69, $71, $75, $61, $6D, $2E, $20, $50, $72, $6F, $69, $6E, $20, $72, $68,
    $6F, $6E, $63, $75, $73, $20, $61, $63, $20, $74, $65, $6C, $6C, $75, $73, $20,
    $65, $75, $20, $66, $65, $75, $67, $69, $61, $74, $2E, $20, $56, $69, $76, $61,
    $6D, $75, $73, $20, $62, $69, $62, $65, $6E, $64, $75, $6D, $20, $6F, $72, $6E,
    $61, $72, $65, $20, $6D, $61, $67, $6E, $61, $20, $61, $20, $69, $61, $63, $75,
    $6C, $69, $73, $2E, $20, $50, $72, $61, $65, $73, $65, $6E, $74, $20, $69, $6E,
    $20, $76, $65, $68, $69, $63, $75, $6C, $61, $20, $6C, $65, $6F, $2E, $20, $45,
    $74, $69, $61, $6D, $20, $64, $69, $63, $74, $75, $6D, $20, $65, $6E, $69, $6D,
    $20, $6E, $6F, $6E, $20, $64, $61, $70, $69, $62, $75, $73, $20, $66, $61, $75,
    $63, $69, $62, $75, $73, $2E, $0D, $0A, $0D, $0A, $56, $69, $76, $61, $6D, $75,
    $73, $20, $65, $74, $20, $6C, $6F, $72, $65, $6D, $20, $73, $69, $74, $20, $61,
    $6D, $65, $74, $20, $64, $6F, $6C, $6F, $72, $20, $6F, $72, $6E, $61, $72, $65,
    $20, $66, $65, $75, $67, $69, $61, $74, $2E, $20, $44, $6F, $6E, $65, $63, $20,
    $75, $74, $20, $61, $72, $63, $75, $20, $6E, $6F, $6E, $20, $6D, $65, $74, $75,
    $73, $20, $75, $6C, $74, $72, $69, $63, $65, $73, $20, $73, $6F, $64, $61, $6C,
    $65, $73, $20, $70, $68, $61, $72, $65, $74, $72, $61, $20, $71, $75, $69, $73,
    $20, $6C, $65, $6F, $2E, $20, $4D, $61, $65, $63, $65, $6E, $61, $73, $20, $6C,
    $61, $6F, $72, $65, $65, $74, $20, $64, $69, $61, $6D, $20, $6E, $6F, $6E, $20,
    $64, $6F, $6C, $6F, $72, $20, $73, $6F, $64, $61, $6C, $65, $73, $20, $74, $65,
    $6D, $70, $6F, $72, $2E, $20, $4E, $61, $6D, $20, $6E, $6F, $6E, $20, $76, $65,
    $68, $69, $63, $75, $6C, $61, $20, $74, $65, $6C, $6C, $75, $73, $2E, $20, $43,
    $75, $72, $61, $62, $69, $74, $75, $72, $20, $70, $6F, $72, $74, $74, $69, $74,
    $6F, $72, $20, $6E, $75, $6E, $63, $20, $65, $74, $20, $73, $75, $73, $63, $69,
    $70, $69, $74, $20, $64, $69, $63, $74, $75, $6D, $2E, $20, $49, $6E, $74, $65,
    $67, $65, $72, $20, $66, $69, $6E, $69, $62, $75, $73, $2C, $20, $76, $65, $6C,
    $69, $74, $20, $61, $63, $20, $70, $6F, $72, $74, $74, $69, $74, $6F, $72, $20,
    $62, $6C, $61, $6E, $64, $69, $74, $2C, $20, $6D, $61, $75, $72, $69, $73, $20,
    $65, $73, $74, $20, $6C, $75, $63, $74, $75, $73, $20, $73, $65, $6D, $2C, $20,
    $61, $20, $63, $6F, $6E, $67, $75, $65, $20, $73, $65, $6D, $20, $6E, $75, $6C,
    $6C, $61, $20, $69, $64, $20, $65, $73, $74, $2E, $20, $4D, $6F, $72, $62, $69,
    $20, $61, $74, $20, $64, $69, $67, $6E, $69, $73, $73, $69, $6D, $20, $6D, $69,
    $2E, $20, $4D, $61, $75, $72, $69, $73, $20, $66, $69, $6E, $69, $62, $75, $73,
    $20, $6F, $72, $63, $69, $20, $73, $65, $64, $20, $64, $69, $61, $6D, $20, $73,
    $65, $6D, $70, $65, $72, $2C, $20, $61, $74, $20, $61, $63, $63, $75, $6D, $73,
    $61, $6E, $20, $65, $72, $61, $74, $20, $68, $65, $6E, $64, $72, $65, $72, $69,
    $74, $2E, $20, $53, $75, $73, $70, $65, $6E, $64, $69, $73, $73, $65, $20, $76,
    $65, $6C, $20, $61, $6C, $69, $71, $75, $61, $6D, $20, $65, $72, $6F, $73, $2E,      // end of first payload
    $58, $79, $4D, $61, $65, $63, $65, $6E, $61, $73, $20, $66, $65, $72, $6D, $65,
    $6E, $74, $75, $6D, $20, $75, $72, $6E, $61, $20, $76, $69, $74, $61, $65, $20,
    $69, $70, $73, $75, $6D, $20, $74, $69, $6E, $63, $69, $64, $75, $6E, $74, $2C,
    $20, $73, $65, $64, $20, $69, $6E, $74, $65, $72, $64, $75, $6D, $20, $6A, $75,
    $73, $74, $6F, $20, $72, $68, $6F, $6E, $63, $75, $73, $2E, $0D, $0A, $49, $6E,
    $74, $65, $67, $65, $72, $20, $71, $75, $69, $73, $20, $73, $65, $6D, $20, $71,
    $75, $69, $73, $20, $74, $65, $6C, $6C, $75, $73, $20, $66, $61, $75, $63, $69,
    $62, $75, $73, $20, $74, $65, $6D, $70, $6F, $72, $2E
  );

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(944, c.DataItemSize);
  CheckEquals(AnsiString('''
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nunc massa, dignissim eu nisi vitae, convallis fermentum sapien. Suspendisse congue urna eu elit consequat efficitur. Quisque sit amet accumsan tellus. Nulla rhoncus nunc risus, at faucibus ex aliquet ac. In ac massa arcu. Nullam efficitur dictum sem, quis pellentesque arcu venenatis aliquam. Proin rhoncus ac tellus eu feugiat. Vivamus bibendum ornare magna a iaculis. Praesent in vehicula leo. Etiam dictum enim non dapibus faucibus.

  Vivamus et lorem sit amet dolor ornare feugiat. Donec ut arcu non metus ultrices sodales pharetra quis leo. Maecenas laoreet diam non dolor sodales tempor. Nam non vehicula tellus. Curabitur porttitor nunc et suscipit dictum. Integer finibus, velit ac porttitor blandit, mauris est luctus sem, a congue sem nulla id est. Morbi at dignissim mi. Mauris finibus orci sed diam semper, at accumsan erat hendrerit. Suspendisse vel aliquam eros.
  '''), c.AsByteString.aValue[0]);

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(123, c.DataItemSize);
  CheckEquals(AnsiString('''
  Maecenas fermentum urna vitae ipsum tincidunt, sed interdum justo rhoncus.
  Integer quis sem quis tellus faucibus tempor.
  ''' ), c.AsByteString.aValue[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_4;
begin
  var c : TCbor := TBytes.Create(
    $57, $49, $6E, $74, $65, $67, $65, $72, $20, $71, $75, $69, $73, $20, $73, $65,
    $6D, $20, $71, $75, $69, $73, $74, $2E
  );

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(24, c.DataItemSize);
  CheckEquals(AnsiString('Integer quis sem quist.'), c.AsByteString.aValue[0]);

  CheckFalse(c.Next);

end;

procedure TTestCase_cbor.Test_ByteString_5;
begin
  var c : TCbor := TBytes.Create(
    $44, $01, $02, $03, $04
  );

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(#$01#$02#$03#$04, c.AsByteString.aValue[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_0;
begin
  var c: TCbor_UInt64;
  c.aValue := 455;
  c.aType := cborUnsigned;
  c.aIsIndefiniteLength := false;

  var d := Encode_uint64(c);
  var ans := TBytes.Create($19, $01, $C7);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_1;
begin
  var c: TCbor_UInt64;
  c.aValue := 199709011230;
  c.aType := cborUnsigned;
  c.aIsIndefiniteLength := false;

  var d := Encode_uint64(c);
  var ans := TBytes.Create($1B, $00, $00, $00, $2E, $7F, $95, $AD, $1E);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_2;
begin
  var c: TCbor_UInt64;
  c.aValue := 1;
  c.aType := cborUnsigned;
  c.aIsIndefiniteLength := false;

  var d := Encode_uint64(c);
  var ans := TBytes.Create($01);
  CheckEquals(ans[0], d[0]);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_3;
begin
  var c:= TCbor_UInt64.Create(18446744073709551615);

  var d := Encode_uint64(c);
  var ans := TBytes.Create($1B, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_TborUInt64_0;
begin
  var c: TCbor := TBytes.Create($01);

  CheckTrue(c.Next);
  var ansUInt64 : TCbor_UInt64 := c.AsUInt64;
  CheckEquals(ansUInt64.aValue, 1);
  Check(ansUInt64.aType = cborUnsigned);

  var a : TCborItem_TBytes := ansUInt64;
  CheckEquals(a.aValue[0], $01);
  Check(a.aType = cborUnsigned);

  var ansUInt64_2 : TCbor_UInt64 := a;
  CheckEquals(ansUInt64_2.aValue, 1);
  Check(ansUInt64_2.aType = cborUnsigned);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_EncodeArray_0;
begin
  var c: TCbor_Array;
  c.aValue := [TCbor_Uint64.Create(1, cborUnsigned)] + [TCbor_UInt64.Create(2, cborUnsigned)] + [TCbor_UInt64.Create(3, cborUnsigned)];
  c.aType := cborArray;
  c.aIsIndefiniteLength := false;

  var d := TBytes.Create($83, $01, $02, $03);
  var e := Encode_Array(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_1;
begin
  var c: TCbor_Array;
  c.aValue := [TCbor_Uint64.Create(10220110, cborUnsigned)] + [TCbor_Uint64.Create(122, cborUnsigned)]
              + [TCbor_int64.Create('-3333333')] + [TCbor_utf8.Create(['Go reach out to get ya'])];
  c.aType := cborArray;
  c.aIsIndefiniteLength := false;

  var d  := TBytes.Create(
    $84, $1A, $00, $9B, $F2, $4E, $18, $7A, $3A, $00, $32, $DC, $D4, $76, $47, $6F,
    $20, $72, $65, $61, $63, $68, $20, $6F, $75, $74, $20, $74, $6F, $20, $67, $65,
    $74, $20, $79, $61
  );
  var e := Encode_Array(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_2;
begin
  var arr: TArray<TCborItem_TBytes> := [TCbor_ByteString.Create(['Return Value is a byte array containing ', 'the results of encoding the specified character sequence.'])]
              + [TCbor_Utf8.Create(['Provident neque ullam corporis sed.'])]
              + [TCbor_Uint64.Create(12123)] + [TCbor_Int64.Create('-789789')] + [TCbor_Int64.Create('-1')];

  var d  := TBytes.Create(
    $9F, $5F, $58, $28, $52, $65, $74, $75, $72, $6E, $20, $56, $61, $6C, $75, $65,
    $20, $69, $73, $20, $61, $20, $62, $79, $74, $65, $20, $61, $72, $72, $61, $79,
    $20, $63, $6F, $6E, $74, $61, $69, $6E, $69, $6E, $67, $20, $58, $39, $74, $68,
    $65, $20, $72, $65, $73, $75, $6C, $74, $73, $20, $6F, $66, $20, $65, $6E, $63,
    $6F, $64, $69, $6E, $67, $20, $74, $68, $65, $20, $73, $70, $65, $63, $69, $66,
    $69, $65, $64, $20, $63, $68, $61, $72, $61, $63, $74, $65, $72, $20, $73, $65,
    $71, $75, $65, $6E, $63, $65, $2E, $FF, $78, $23, $50, $72, $6F, $76, $69, $64,
    $65, $6E, $74, $20, $6E, $65, $71, $75, $65, $20, $75, $6C, $6C, $61, $6D, $20,
    $63, $6F, $72, $70, $6F, $72, $69, $73, $20, $73, $65, $64, $2E, $19, $2F, $5B,
    $3A, $00, $0C, $0D, $1C, $20, $FF
  );
  var e := Encode_Array(TCbor_Array.Create(arr, true));
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_3;
begin
  var arrNested: TArray<TCborItem_TBytes> :=  [TCbor_Uint64.Create(555)] + [TCbor_ByteString.Create(['Nested', 'arraY'])]
              + [TCbor_Map.Create([TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(6), TCbor_Uint64.Create(6))])];

  var arr: TArray<TCborItem_TBytes> := [TCbor_Uint64.Create(1)] + [TCbor_UTF8.Create(['lol'])]
              + [TCbor_Array.Create(arrNested, false)] + [TCbor_Int64.Create('-999')];

  var d  := TBytes.Create(
    $9F, $01, $63, $6C, $6F, $6C, $83, $19, $02, $2B, $5F, $46, $4E, $65, $73, $74,
    $65, $64, $45, $61, $72, $72, $61, $59, $FF, $A1, $06, $06, $39, $03, $E6, $FF
  );
  var e := Encode_Array(TCbor_Array.Create(arr, true));
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeInt64_0;
begin
  var c:= TCbor_Int64.Create('-55493');

  var d := Encode_int64(c);
  var ans := TBytes.Create($39, $D8, $C4);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]); 
end;

procedure TTestCase_cbor.Test_EncodeInt64_1;
begin
  var c:= TCbor_Int64.Create('-199709011230');

  var d := Encode_int64(c);
  var ans := TBytes.Create($3B, $00, $00, $00, $2E, $7F, $95, $AD, $1D);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeInt64_2;
begin
  var c:= TCbor_Int64.Create('-18446744073709551616');

  var d := Encode_int64(c);
  var ans := TBytes.Create($3B, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeMap_0;
begin
  var p : TArray<TPair<TCborItem_TBytes, TCborItem_TBytes>> :=
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(20, cborUnsigned), TCbor_ByteString.Create(['Twenty']))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(21, cborUnsigned), TCbor_ByteString.Create(['Twenty-One']))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Int64.Create('-22'), TCbor_UTF8.Create(['-Twenty-Two']))];

  var d := TBytes.Create(
    $A3, $14, $46, $54, $77, $65, $6E, $74, $79, $15, $4A, $54, $77, $65, $6E, $74,
    $79, $2D, $4F, $6E, $65, $35, $6B, $2D, $54, $77, $65, $6E, $74, $79, $2D, $54,
    $77, $6F);

  var e := Encode_Map(TCbor_Map.Create(p, false));
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeMap_1;
begin
  var arr : TArray<TCborItem_TBytes> := [TCbor_ByteString.Create(['L'])] + [TCbor_ByteString.Create(['E'])] + [TCbor_ByteString.Create(['V'])]
    + [TCbor_ByteString.Create(['E'])] + [TCbor_ByteString.Create(['L'])] + [TCbor_ByteString.Create(['I'])]
    + [TCbor_ByteString.Create(['N'])] + [TCbor_ByteString.Create(['G'])];

  var p : TArray<TPair<TCborItem_TBytes, TCborItem_TBytes>> :=
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_UTF8.Create(['!??']), TCbor_Int64.Create('-11111'))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_ByteString.Create(['...']),
      TCbor_Map.Create([TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_ByteString.Create(['.']), TCbor_Uint64.Create(666, cborUnsigned))], false))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(5010, cborUnsigned), TCbor_Array.Create(arr, false))];

  var d := TBytes.Create(
    $A3, $63, $21, $3F, $3F, $39, $2B, $66, $43, $2E, $2E, $2E, $A1, $41, $2E, $19,
    $02, $9A, $19, $13, $92, $88, $41, $4C, $41, $45, $41, $56, $41, $45, $41, $4C,
    $41, $49, $41, $4E, $41, $47);

  var e := Encode_Map(TCbor_Map.Create(p, false));
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeMap_2;
begin
  var arr : TArray<TCborItem_TBytes> := [TCbor_Uint64.Create(2, cborUnsigned)] + [TCbor_Uint64.Create(3, cborUnsigned)];

  var map : TArray<TPair<TCborItem_TBytes, TCborItem_TBytes>> :=
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(1, cborUnsigned), TCbor_Uint64.Create(1, cborUnsigned))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(2, cborUnsigned), TCbor_Uint64.Create(2, cborUnsigned))];


  var p : TArray<TPair<TCborItem_TBytes, TCborItem_TBytes>> :=
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(1, cborUnsigned), TCbor_UTF8.Create(['Hello', 'Just', 'Kidding']))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(2, cborUnsigned), TCbor_Array.Create(arr, true))] +
    [TPair<TCborItem_TBytes, TCborItem_TBytes>.Create(TCbor_Uint64.Create(3, cborUnsigned), TCbor_Map.Create(map, true))];

  var d := TBytes.Create(
    $BF, $01, $7F, $65, $48, $65, $6C, $6C, $6F, $64, $4A, $75, $73, $74, $67, $4B,
    $69, $64, $64, $69, $6E, $67, $FF, $02, $9F, $02, $03, $FF, $03, $BF, $01, $01,
    $02, $02, $FF, $FF);

  var e := Encode_Map(TCbor_Map.Create(p, true));
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_TCborInt64_0;
begin
  var c: TCbor := TBytes.Create($39, $d2, $6f);

  CheckTrue(c.Next);
  var ansInt64 : TCbor_Int64 := c.AsInt64;
  CheckEquals(ansInt64.aValue, '-53872');
  Check(ansInt64.aType = cborSigned);

  var a : TCborItem_TBytes := ansInt64;
  var b := TBytes.Create($39, $d2, $6f);
  for var i := Low(b) to High(b) do
    CheckEquals(b[i], a.aValue[i]);
  Check(a.aType = cborSigned);

  var ansInt64_2 : TCbor_Int64 := a;
  CheckEquals(ansInt64_2.aValue, '-53872');
  Check(ansInt64_2.aType = cborSigned);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_EncodeByteString_0;
begin
  var c:= TCbor_ByteString.Create(['W1073 Combining signed type and unsigned 64-bit type - treated as an unsigned type']);

  var d:= TBytes.Create(
    $58, $52, $57, $31, $30, $37, $33, $20, $43, $6F, $6D, $62, $69, $6E, $69, $6E,
    $67, $20, $73, $69, $67, $6E, $65, $64, $20, $74, $79, $70, $65, $20, $61, $6E,
    $64, $20, $75, $6E, $73, $69, $67, $6E, $65, $64, $20, $36, $34, $2D, $62, $69,
    $74, $20, $74, $79, $70, $65, $20, $2D, $20, $74, $72, $65, $61, $74, $65, $64,
    $20, $61, $73, $20, $61, $6E, $20, $75, $6E, $73, $69, $67, $6E, $65, $64, $20,
    $74, $79, $70, $65
  );
  var e:= Encode_ByteString(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_1;
begin
  var c:= TCbor_ByteString.Create(['hELlo w0rLd']);

  var d:= TBytes.Create($4B, $68, $45, $4C, $6C, $6F, $20, $77, $30, $72, $4C, $64);
  var e:= Encode_ByteString(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_2;
begin
  var c:= TCbor_ByteString.Create(['hello', '01', #$01#$02#$03#$04]);

  var d:= TBytes.Create($5F, $45, $68, $65, $6C, $6C, $6F, $42, $30, $31, $44, $01, $02, $03, $04, $FF);
  var e:= Encode_ByteString(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_3;
begin
  var c:= TCbor_ByteString.Create(['Return Value is a byte array containing ', 'the results of encoding the specified character sequence.']);

  var d:= TBytes.Create(
    $5F, $58, $28, $52, $65, $74, $75, $72, $6E, $20, $56, $61, $6C, $75, $65, $20,
    $69, $73, $20, $61, $20, $62, $79, $74, $65, $20, $61, $72, $72, $61, $79, $20,
    $63, $6F, $6E, $74, $61, $69, $6E, $69, $6E, $67, $20, $58, $39, $74, $68, $65,
    $20, $72, $65, $73, $75, $6C, $74, $73, $20, $6F, $66, $20, $65, $6E, $63, $6F,
    $64, $69, $6E, $67, $20, $74, $68, $65, $20, $73, $70, $65, $63, $69, $66, $69,
    $65, $64, $20, $63, $68, $61, $72, $61, $63, $74, $65, $72, $20, $73, $65, $71,
    $75, $65, $6E, $63, $65, $2E, $FF
  );
  var e:= Encode_ByteString(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeUtf8_0;
begin
  var c:= TCbor_UTF8.Create(['𝓱']);

  var d:= TBytes.Create($64, $F0, $9D, $93, $B1);
  var e:= Encode_utf8(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeUtf8_1;
begin
  var c:= TCbor_UTF8.Create(['Shine on me', 'Everything was going so well until I was accosted by a purple giraffe.', '𝓱𝓪𝓱𝓪']);

  var d:= TBytes.Create(
    $7F, $6B, $53, $68, $69, $6E, $65, $20, $6F, $6E, $20, $6D, $65, $78, $46, $45,
    $76, $65, $72, $79, $74, $68, $69, $6E, $67, $20, $77, $61, $73, $20, $67, $6F,
    $69, $6E, $67, $20, $73, $6F, $20, $77, $65, $6C, $6C, $20, $75, $6E, $74, $69,
    $6C, $20, $49, $20, $77, $61, $73, $20, $61, $63, $63, $6F, $73, $74, $65, $64,
    $20, $62, $79, $20, $61, $20, $70, $75, $72, $70, $6C, $65, $20, $67, $69, $72,
    $61, $66, $66, $65, $2E, $70, $F0, $9D, $93, $B1, $F0, $9D, $93, $AA, $F0, $9D,
    $93, $B1, $F0, $9D, $93, $AA, $FF);
  var e:= Encode_utf8(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_TCborUTF8_0;
begin
  var c: TCbor := TBytes.Create($62, $C3, $BC);

  CheckTrue(c.Next);
  var ansUTF8 : TCbor_UTF8 := c.AsUTF8;
  Check(cborUTF8 = ansUTF8.aType);
  CheckEquals('ü', ansUTF8.aValue[0]);

  var ansCbor : TCborItem_TBytes := ansUTF8;
  Check(cborUTF8 = ansCbor.aType);
  var d := TBytes.Create($62, $C3, $BC);
  for var i := Low(ansCbor.aValue) to High(ansCbor.aValue) do
    CheckEquals(ansCbor.aValue[i], d[i]);

  var ansUTF82 : TCbor_UTF8 := c.AsUTF8;
  Check(cborUTF8 = ansUTF82.aType);
  CheckEquals('ü', ansUTF82.aValue[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_31;
begin
   var c : TCbor := TBytes.Create(
    $5F, $44, $68, $69, $68, $69, $43, $42, $54, $53, $58, $79, $4D, $61, $65, $63,
    $65, $6E, $61, $73, $20, $66, $65, $72, $6D, $65, $6E, $74, $75, $6D, $20, $75,
    $72, $6E, $61, $20, $76, $69, $74, $61, $65, $20, $69, $70, $73, $75, $6D, $20,
    $74, $69, $6E, $63, $69, $64, $75, $6E, $74, $2C, $20, $73, $65, $64, $20, $69,
    $6E, $74, $65, $72, $64, $75, $6D, $20, $6A, $75, $73, $74, $6F, $20, $72, $68,
    $6F, $6E, $63, $75, $73, $2E, $0D, $0A, $49, $6E, $74, $65, $67, $65, $72, $20,
    $71, $75, $69, $73, $20, $73, $65, $6D, $20, $71, $75, $69, $73, $20, $74, $65,
    $6C, $6C, $75, $73, $20, $66, $61, $75, $63, $69, $62, $75, $73, $20, $74, $65,
    $6D, $70, $6F, $72, $2E, $FF // break
  );

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  var d := c.AsByteString;
  // CheckEquals(134, c.DataItemSize);
  CheckEquals('hihi', d.aValue[0]);
  CheckEquals('BTS', d.aValue[1]);
  CheckEquals('''
  Maecenas fermentum urna vitae ipsum tincidunt, sed interdum justo rhoncus.
  Integer quis sem quis tellus faucibus tempor.
  '''
  , d.aValue[2]
  );

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_UTF8_0;
begin
  var c: TCbor := TBytes.Create(
    $79, $02, $7F, $F0, $9D, $95, $B4, $F0, $9D, $96, $93, $20, $F0, $9D, $96, $99,
    $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $20, $F0, $9D, $96, $87, $F0, $9D, $96,
    $8A, $F0, $9D, $96, $8C, $F0, $9D, $96, $8E, $F0, $9D, $96, $93, $F0, $9D, $96,
    $93, $F0, $9D, $96, $8E, $F0, $9D, $96, $93, $F0, $9D, $96, $8C, $20, $F0, $9D,
    $95, $B2, $F0, $9D, $96, $94, $F0, $9D, $96, $89, $20, $F0, $9D, $96, $88, $F0,
    $9D, $96, $97, $F0, $9D, $96, $8A, $F0, $9D, $96, $86, $F0, $9D, $96, $99, $F0,
    $9D, $96, $8A, $F0, $9D, $96, $89, $20, $F0, $9D, $96, $99, $F0, $9D, $96, $8D,
    $F0, $9D, $96, $8A, $20, $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $F0, $9D, $96,
    $86, $F0, $9D, $96, $9B, $F0, $9D, $96, $8A, $F0, $9D, $96, $93, $F0, $9D, $96,
    $98, $20, $F0, $9D, $96, $86, $F0, $9D, $96, $93, $F0, $9D, $96, $89, $20, $F0,
    $9D, $96, $99, $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $20, $F0, $9D, $96, $8A,
    $F0, $9D, $96, $86, $F0, $9D, $96, $97, $F0, $9D, $96, $99, $F0, $9D, $96, $8D,
    $2E, $0D, $0A, $F0, $9D, $95, $B9, $F0, $9D, $96, $94, $F0, $9D, $96, $9C, $20,
    $F0, $9D, $96, $99, $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $20, $F0, $9D, $96,
    $8A, $F0, $9D, $96, $86, $F0, $9D, $96, $97, $F0, $9D, $96, $99, $F0, $9D, $96,
    $8D, $20, $F0, $9D, $96, $9C, $F0, $9D, $96, $86, $F0, $9D, $96, $98, $20, $F0,
    $9D, $96, $8B, $F0, $9D, $96, $94, $F0, $9D, $96, $97, $F0, $9D, $96, $92, $F0,
    $9D, $96, $91, $F0, $9D, $96, $8A, $F0, $9D, $96, $98, $F0, $9D, $96, $98, $20,
    $F0, $9D, $96, $86, $F0, $9D, $96, $93, $F0, $9D, $96, $89, $20, $F0, $9D, $96,
    $8A, $F0, $9D, $96, $92, $F0, $9D, $96, $95, $F0, $9D, $96, $99, $F0, $9D, $96,
    $9E, $2C, $20, $F0, $9D, $96, $89, $F0, $9D, $96, $86, $F0, $9D, $96, $97, $F0,
    $9D, $96, $90, $F0, $9D, $96, $93, $F0, $9D, $96, $8A, $F0, $9D, $96, $98, $F0,
    $9D, $96, $98, $20, $F0, $9D, $96, $9C, $F0, $9D, $96, $86, $F0, $9D, $96, $98,
    $20, $F0, $9D, $96, $94, $F0, $9D, $96, $9B, $F0, $9D, $96, $8A, $F0, $9D, $96,
    $97, $20, $F0, $9D, $96, $99, $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $20, $F0,
    $9D, $96, $98, $F0, $9D, $96, $9A, $F0, $9D, $96, $97, $F0, $9D, $96, $8B, $F0,
    $9D, $96, $86, $F0, $9D, $96, $88, $F0, $9D, $96, $8A, $20, $F0, $9D, $96, $94,
    $F0, $9D, $96, $8B, $20, $F0, $9D, $96, $99, $F0, $9D, $96, $8D, $F0, $9D, $96,
    $8A, $20, $F0, $9D, $96, $89, $F0, $9D, $96, $8A, $F0, $9D, $96, $8A, $F0, $9D,
    $96, $95, $2C, $20, $F0, $9D, $96, $86, $F0, $9D, $96, $93, $F0, $9D, $96, $89,
    $20, $F0, $9D, $96, $99, $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $20, $F0, $9D,
    $95, $BE, $F0, $9D, $96, $95, $F0, $9D, $96, $8E, $F0, $9D, $96, $97, $F0, $9D,
    $96, $8E, $F0, $9D, $96, $99, $20, $F0, $9D, $96, $94, $F0, $9D, $96, $8B, $20,
    $F0, $9D, $95, $B2, $F0, $9D, $96, $94, $F0, $9D, $96, $89, $20, $F0, $9D, $96,
    $9C, $F0, $9D, $96, $86, $F0, $9D, $96, $98, $20, $F0, $9D, $96, $8D, $F0, $9D,
    $96, $94, $F0, $9D, $96, $9B, $F0, $9D, $96, $8A, $F0, $9D, $96, $97, $F0, $9D,
    $96, $8E, $F0, $9D, $96, $93, $F0, $9D, $96, $8C, $20, $F0, $9D, $96, $94, $F0,
    $9D, $96, $9B, $F0, $9D, $96, $8A, $F0, $9D, $96, $97, $20, $F0, $9D, $96, $99,
    $F0, $9D, $96, $8D, $F0, $9D, $96, $8A, $20, $F0, $9D, $96, $9C, $F0, $9D, $96,
    $86, $F0, $9D, $96, $99, $F0, $9D, $96, $8A, $F0, $9D, $96, $97, $F0, $9D, $96,
    $98, $2E
  );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  CheckEquals(642, c.DataItemSize);
  CheckEquals('''
  𝕴𝖓 𝖙𝖍𝖊 𝖇𝖊𝖌𝖎𝖓𝖓𝖎𝖓𝖌 𝕲𝖔𝖉 𝖈𝖗𝖊𝖆𝖙𝖊𝖉 𝖙𝖍𝖊 𝖍𝖊𝖆𝖛𝖊𝖓𝖘 𝖆𝖓𝖉 𝖙𝖍𝖊 𝖊𝖆𝖗𝖙𝖍.
  𝕹𝖔𝖜 𝖙𝖍𝖊 𝖊𝖆𝖗𝖙𝖍 𝖜𝖆𝖘 𝖋𝖔𝖗𝖒𝖑𝖊𝖘𝖘 𝖆𝖓𝖉 𝖊𝖒𝖕𝖙𝖞, 𝖉𝖆𝖗𝖐𝖓𝖊𝖘𝖘 𝖜𝖆𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖘𝖚𝖗𝖋𝖆𝖈𝖊 𝖔𝖋 𝖙𝖍𝖊 𝖉𝖊𝖊𝖕, 𝖆𝖓𝖉 𝖙𝖍𝖊 𝕾𝖕𝖎𝖗𝖎𝖙 𝖔𝖋 𝕲𝖔𝖉 𝖜𝖆𝖘 𝖍𝖔𝖛𝖊𝖗𝖎𝖓𝖌 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖜𝖆𝖙𝖊𝖗𝖘.
  '''
  , c.AsUTF8.aValue[0]
  );

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_UTF8_1;
begin
  var c: TCbor := TBytes.Create(
    $78, $2D, $E2, $93, $89, $E2, $93, $9E, $20, $E2, $93, $9B, $E2, $93, $9E, $E2,
    $93, $A2, $E2, $93, $94, $20, $E2, $93, $A8, $E2, $93, $9E, $E2, $93, $A4, $E2,
    $93, $A1, $20, $E2, $93, $9F, $E2, $93, $90, $E2, $93, $A3, $E2, $93, $97, $78,
    $2D, $49, $73, $20, $CA, $87, $C9, $A5, $C7, $9D, $20, $CA, $8D, $C9, $90, $CA,
    $8E, $20, $CA, $87, $6F, $20, $C9, $9F, $E1, $B4, $89, $75, $70, $20, $CA, $87,
    $C9, $A5, $C9, $90, $CA, $87, $20, $64, $C9, $90, $CA, $87, $C9, $A5
  );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  CheckEquals(47, c.DataItemSize);
  CheckEquals('''
  Ⓣⓞ ⓛⓞⓢⓔ ⓨⓞⓤⓡ ⓟⓐⓣⓗ
  ''', c.AsUTF8.aValue[0]);

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  CheckEquals(47, c.DataItemSize);
  CheckEquals('''
  Is ʇɥǝ ʍɐʎ ʇo ɟᴉup ʇɥɐʇ dɐʇɥ
  ''', c.AsUTF8.aValue[0]);

  CheckFalse(c.Next);

end;

procedure TTestCase_cbor.Test_UTF8_2;
begin
  var c: TCbor := TBytes.Create($62, $22, $5C);

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals('"\', c.AsUTF8.aValue[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_UTF8_31;
begin
  var c: TCbor := TBytes.Create(
    $7F, $78, $25, $F0, $9F, $86, $83, $F0, $9F, $85, $B7, $F0, $9F, $86, $81, $F0,
    $9F, $85, $BE, $F0, $9F, $86, $86, $20, $F0, $9F, $85, $B0, $F0, $9F, $86, $86,
    $F0, $9F, $85, $B0, $F0, $9F, $86, $88, $78, $1D, $F0, $9F, $86, $83, $F0, $9F,
    $85, $B7, $F0, $9F, $85, $B4, $20, $F0, $9F, $85, $B5, $F0, $9F, $85, $B4, $F0,
    $9F, $85, $B0, $F0, $9F, $86, $81, $FF
  );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  var d:= c.AsUTF8;
//  CheckEquals(72, c.DataItemSize);
  CheckEquals('🆃🅷🆁🅾🆆 🅰🆆🅰🆈', d.aValue[0]);
  CheckEquals('🆃🅷🅴 🅵🅴🅰🆁', d.aValue[1]);

  CheckFalse(c.Next);

end;

procedure TTestCase_cbor.Test_UTF8_31_1;
begin
  var c: TCbor := TBytes.Create(
    $7F, $78, $25, $F0, $9F, $86, $83, $F0, $9F, $85, $B7, $F0, $9F, $86, $81, $F0,
    $9F, $85, $BE, $F0, $9F, $86, $86, $20, $F0, $9F, $85, $B0, $F0, $9F, $86, $86,
    $F0, $9F, $85, $B0, $F0, $9F, $86, $88, $78, $1D, $F0, $9F, $86, $83, $F0, $9F,
    $85, $B7, $F0, $9F, $85, $B4, $20, $F0, $9F, $85, $B5, $F0, $9F, $85, $B4, $F0,
    $9F, $85, $B0, $F0, $9F, $86, $81, $7F, $78, $25, $F0, $9F, $86, $83, $F0, $9F,
    $85, $B7, $F0, $9F, $86, $81, $F0, $9F, $85, $BE, $F0, $9F, $86, $86, $20, $F0,
    $9F, $85, $B0, $F0, $9F, $86, $86, $F0, $9F, $85, $B0, $F0, $9F, $86, $88, $78,
    $1D, $F0, $9F, $86, $83, $F0, $9F, $85, $B7, $F0, $9F, $85, $B4, $20, $F0, $9F,
    $85, $B5, $F0, $9F, $85, $B4, $F0, $9F, $85, $B0, $F0, $9F, $86, $81, $FF, $FF
    );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  var d := c.AsUTF8;
  CheckEquals('🆃🅷🆁🅾🆆 🅰🆆🅰🆈', d.aValue[0]);
  CheckEquals('🆃🅷🅴 🅵🅴🅰🆁', d.aValue[1]);
  CheckEquals('🆃🅷🆁🅾🆆 🅰🆆🅰🆈', d.aValue[2]);
  CheckEquals('🆃🅷🅴 🅵🅴🅰🆁', d.aValue[3]);
end;

procedure TTestCase_cbor.Test_UTF8_31_2;
begin
  var c: TCbor := TBytes.Create(
    $7F, $78, $37, $EF, $BE, $91, $E5, $88, $80, $64, $20, $EF, $BE, $98, $6F, $75,
    $27, $E5, $B0, $BA, $E4, $B9, $87, $20, $67, $6F, $E5, $88, $80, $E5, $88, $80,
    $EF, $BE, $91, $20, $E4, $B9, $83, $E4, $B9, $87, $20, $E3, $82, $93, $EF, $BE,
    $91, $EF, $BD, $B1, $EF, $BD, $B1, $EF, $BE, $98, $78, $6E, $F0, $9D, $93, $A8,
    $F0, $9D, $93, $B8, $F0, $9D, $93, $BE, $20, $F0, $9D, $93, $AA, $F0, $9D, $93,
    $BB, $F0, $9D, $93, $AE, $20, $F0, $9D, $93, $BD, $F0, $9D, $93, $B1, $F0, $9D,
    $93, $AE, $20, $F0, $9D, $93, $AC, $F0, $9D, $93, $AA, $F0, $9D, $93, $BE, $F0,
    $9D, $93, $BC, $F0, $9D, $93, $AE, $20, $F0, $9D, $93, $B8, $F0, $9D, $93, $AF,
    $20, $F0, $9D, $93, $B6, $F0, $9D, $94, $82, $20, $F0, $9D, $93, $94, $F0, $9D,
    $93, $BE, $F0, $9D, $93, $B9, $F0, $9D, $93, $B1, $F0, $9D, $93, $B8, $F0, $9D,
    $93, $BB, $F0, $9D, $93, $B2, $F0, $9D, $93, $AA, $FF
  );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  var d:= c.AsUTF8;
  CheckEquals('''
  ﾑ刀d ﾘou'尺乇 go刀刀ﾑ 乃乇 んﾑｱｱﾘ
  ''', d.aValue[0]);
  CheckEquals('𝓨𝓸𝓾 𝓪𝓻𝓮 𝓽𝓱𝓮 𝓬𝓪𝓾𝓼𝓮 𝓸𝓯 𝓶𝔂 𝓔𝓾𝓹𝓱𝓸𝓻𝓲𝓪', d.aValue[1]);
  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_UTF8_31_255;
begin
  var c: TCbor := TBytes.Create(
    $7F, $78, $FD, $E1, $8C, $8E, $E1, $8A, $AD, $20, $E1, $8D, $95, $E1, $8B, $98,
    $E1, $89, $BF, $20, $E1, $8B, $95, $E1, $88, $8D, $E1, $8B, $AA, $E1, $8C, $95,
    $20, $E1, $8B, $95, $E1, $88, $8D, $E1, $88, $A0, $E1, $8A, $AD, $2C, $20, $E1,
    $8A, $90, $E1, $8B, $A8, $E1, $8B, $AA, $E1, $89, $BF, $E1, $88, $8D, $E1, $8B,
    $95, $E1, $8C, $8E, $E1, $8A, $AD, $E1, $8A, $97, $20, $E1, $8D, $95, $E1, $8B,
    $AA, $E1, $89, $BF, $E1, $8C, $A0, $E1, $8C, $8C, $E1, $88, $A8, $E1, $8C, $8E,
    $E1, $8A, $AD, $E1, $8A, $97, $20, $E1, $88, $A0, $E1, $8C, $8E, $E1, $8A, $AD,
    $E1, $8A, $97, $E1, $8A, $90, $2E, $20, $E1, $8C, $95, $E1, $89, $BF, $E1, $89,
    $BF, $E1, $8B, $A8, $20, $E1, $8B, $90, $E1, $8A, $AD, $20, $E1, $8A, $90, $E1,
    $8B, $98, $E1, $8C, $8E, $E1, $8A, $AD, $E1, $8C, $8E, $E1, $8A, $AD, $E1, $8A,
    $97, $20, $E1, $8C, $A0, $E1, $88, $8D, $E1, $8C, $95, $E1, $89, $BF, $20, $E1,
    $8C, $8E, $E1, $8D, $95, $20, $E1, $8C, $8C, $E1, $8B, $AA, $E1, $8C, $8E, $E1,
    $8A, $97, $E1, $8B, $98, $E1, $8D, $95, $E1, $89, $BF, $E1, $8B, $AA, $20, $E1,
    $8D, $95, $E1, $8B, $98, $E1, $88, $8D, $E1, $8A, $AD, $20, $E1, $88, $8D, $20,
    $E1, $8A, $90, $E1, $8B, $A8, $E1, $8B, $90, $E1, $8D, $95, $E1, $88, $A8, $E1,
    $8C, $8E, $E1, $8A, $97, $E1, $8B, $98, $E1, $8D, $95, $2E, $2E, $2E, $2E, $2E,
    $72, $E1, $B4, $B0, $E1, $B4, $B1, $E1, $B4, $B8, $E1, $B4, $BE, $E1, $B4, $B4,
    $E1, $B4, $B5, $FF
  );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  var d := c.AsUTF8;
  CheckEquals('''
  ጎክ ፕዘቿ ዕልዪጕ ዕልሠክ, ነየዪቿልዕጎክኗ ፕዪቿጠጌረጎክኗ ሠጎክኗነ. ጕቿቿየ ዐክ ነዘጎክጎክኗ ጠልጕቿ ጎፕ ጌዪጎኗዘፕቿዪ ፕዘልክ ል ነየዐፕረጎኗዘፕ.....
  ''' , d.aValue[0]);
  CheckEquals('''
  ᴰᴱᴸᴾᴴᴵ
  ''', d.aValue[1]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Array_0;
begin
  var c: TCbor := TBytes.Create($82, $01, $45, $68, $65, $6C, $6C, $6F);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
  var ans : TCbor_Array := c.AsArray;
  Check(TCbor_Uint64(ans.aValue[0]).aValue = 1);
  Check(TCbor_ByteString(ans.aValue[1]).aValue[0] = 'hello');
end;

procedure TTestCase_cbor.Test_Array_1;
begin
  var c: TCbor := TBytes.Create($82, $01, $82, $02, $03);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
  var ans : TCbor_Array := c.AsArray;

  Check(TCbor_Uint64(ans.aValue[0]).aValue = 1);
  Check(TCbor_Uint64(TCbor_Array(ans.aValue[1]).aValue[0]).aValue = 2);
  Check(TCbor_Uint64(TCbor_Array(ans.aValue[1]).aValue[1]).aValue = 3);
end;

procedure TTestCase_cbor.Test_Array_24;
begin
  var c: TCbor := TBytes.Create(
    $98, $18, $01, $02, $03, $04, $05, $42, $68, $69, $66, $E4, $B9, $83, $E4, $B9,
    $87, $35, $38, $DD, $82, $01, $02, $19, $01, $2C, $19, $02, $58, $19, $03, $84,
    $39, $04, $AF, $43, $42, $54, $53, $42, $47, $6F, $44, $79, $6F, $75, $72, $43,
    $6F, $77, $6E, $43, $77, $61, $79, $84, $63, $50, $75, $74, $48, $77, $65, $61,
    $6B, $6E, $65, $73, $73, $64, $61, $77, $61, $79, $19, $07, $DD, $15, $16, $17,
    $18, $18
  );

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
  var ans := c.AsArray;
  Check(TCbor_UInt64(ans.aValue[0]).aValue = 1);
  Check(TCbor_UInt64(ans.aValue[1]).aValue = 2);
  Check(TCbor_UInt64(ans.aValue[2]).aValue = 3);
  Check(TCbor_UInt64(ans.aValue[3]).aValue = 4);
  Check(TCbor_UInt64(ans.aValue[4]).aValue = 5);
  Check(TCbor_ByteString(ans.aValue[5]).aValue[0] = 'hi');
  Check(TCbor_UTF8(ans.aValue[6]).aValue[0] = '乃乇');
  Check(TCbor_Int64(ans.aValue[7]).aValue = '-22');
  Check(TCbor_Int64(ans.aValue[8]).aValue = '-222');
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[9]).aValue[0]).aValue = 1);
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[9]).aValue[1]).aValue = 2);
  Check(TCbor_UInt64(ans.aValue[10]).aValue = 300);
  Check(TCbor_UInt64(ans.aValue[11]).aValue = 600);
  Check(TCbor_UInt64(ans.aValue[12]).aValue = 900);
  Check(TCbor_Int64(ans.aValue[13]).aValue = '-1200');
  Check(TCbor_ByteString(ans.aValue[14]).aValue[0] = 'BTS');
  Check(TCbor_ByteString(ans.aValue[15]).aValue[0] = 'Go');
  Check(TCbor_ByteString(ans.aValue[16]).aValue[0] = 'your');
  Check(TCbor_ByteString(ans.aValue[17]).aValue[0] = 'own');
  Check(TCbor_ByteString(ans.aValue[18]).aValue[0] = 'way');
  Check(TCbor_UTF8(TCbor_Array(ans.aValue[19]).aValue[0]).aValue[0] = 'Put');
  Check(TCbor_UTF8(TCbor_Array(ans.aValue[19]).aValue[1]).aValue[0] = 'weakness');
  Check(TCbor_UTF8(TCbor_Array(ans.aValue[19]).aValue[2]).aValue[0] = 'away');
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[19]).aValue[3]).aValue = 2013);
  Check(TCbor_UInt64(ans.aValue[20]).aValue = 21);
  Check(TCbor_UInt64(ans.aValue[21]).aValue = 22);
  Check(TCbor_UInt64(ans.aValue[22]).aValue = 23);
  Check(TCbor_UInt64(ans.aValue[23]).aValue = 24);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Array_31;
begin
  var c: TCbor := TBytes.Create(
    $9F, $01, $45, $68, $65, $6C, $6C, $6F, $82, $01, $02, $81, $9F, $01, $02, $FF, $FF
  );

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);

  var ans : TCbor_Array := c.AsArray;
  Check(TCbor_Uint64(ans.aValue[0]).aValue = 1);
  Check(TCbor_ByteString(ans.aValue[1]).aValue[0] = 'hello');
  Check(TCbor_Uint64(TCbor_Array(ans.aValue[2]).aValue[0]).aValue = 1);
  Check(TCbor_Uint64(TCbor_Array(ans.aValue[2]).aValue[1]).aValue = 2);
  Check(TCbor_Uint64(TCbor_Array(TCbor_Array(ans.aValue[3]).aValue[0]).aValue[0]).aValue = 1);
  Check(TCbor_Uint64(TCbor_Array(TCbor_Array(ans.aValue[3]).aValue[0]).aValue[1]).aValue = 2);

  CheckFalse(c.Next);

end;

procedure TTestCase_cbor.Test_Map_0;
begin
  var c: TCbor := TBytes.Create(
    $A2, $61, $74, $19, $04, $D2, $61, $6C, $19, $09, $29
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCbor_Map := c.AsMap;
  Check(TCbor_UTF8(ans.aValue[0].Key).aValue[0] = 't');
  Check(TCbor_UInt64(ans.aValue[0].Value).aValue = 1234);
  Check(TCbor_UTF8(ans.aValue[1].Key).aValue[0] = 'l');
  Check(TCbor_UInt64(ans.aValue[1].Value).aValue = 2345);
end;

procedure TTestCase_cbor.Test_Map_1;
begin
  var c: TCbor := TBytes.Create(
    $A4, $01, $63, $4A, $4A, $4B, $02, $3A, $00, $0F, $42, $3F, $43, $6B, $65, $79,
    $6F, $EF, $BD, $96, $EF, $BD, $81, $EF, $BD, $8C, $EF, $BD, $95, $EF, $BD, $85,
    $45, $61, $72, $72, $61, $79, $85, $01, $02, $03, $04, $05
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCbor_Map := c.AsMap;
  Check(TCbor_UInt64(ans.aValue[0].Key).aValue = 1);
  Check(TCbor_UTF8(ans.aValue[0].Value).aValue[0] = 'JJK');
  Check(TCbor_UInt64(ans.aValue[1].Key).aValue = 2);
  Check(TCbor_Int64(ans.aValue[1].Value).aValue = '-1000000');
  Check(TCbor_ByteString(ans.aValue[2].Key).aValue[0] = 'key');
  Check(TCbor_UTF8(ans.aValue[2].Value).aValue[0] = 'ｖａｌｕｅ');
  Check(TCbor_ByteString(ans.aValue[3].Key).aValue[0] = 'array');
  var a : TCbor_Array := ans.aValue[3].Value;
  Check(TCbor_UInt64(a.aValue[0]).aValue = 1);
  Check(TCbor_UInt64(a.aValue[1]).aValue = 2);
  Check(TCbor_UInt64(a.aValue[2]).aValue = 3);
  Check(TCbor_UInt64(a.aValue[3]).aValue = 4);
  Check(TCbor_UInt64(a.aValue[4]).aValue = 5);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Map_2;
begin
  var c: TCbor := TBytes.Create(
    $A3, $01, $02, $03, $A2, $18, $1F, $0D, $18, $20, $17, $04, $05
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCbor_Map := c.AsMap;
  Check(TCbor_UInt64(ans.aValue[0].Key).aValue = 1);
  Check(TCbor_UInt64(ans.aValue[0].Value).aValue = 2);
  Check(TCbor_UInt64(ans.aValue[1].Key).aValue = 3);
  Check(TCbor_UInt64(TCbor_Map(ans.aValue[1].Value).aValue[0].Key).aValue = 31);
  Check(TCbor_UInt64(TCbor_Map(ans.aValue[1].Value).aValue[0].Value).aValue = 13);
  Check(TCbor_UInt64(TCbor_Map(ans.aValue[1].Value).aValue[1].Key).aValue = 32);
  Check(TCbor_UInt64(TCbor_Map(ans.aValue[1].Value).aValue[1].Value).aValue = 23);
  Check(TCbor_UInt64(ans.aValue[2].Key).aValue = 4);
  Check(TCbor_UInt64(ans.aValue[2].Value).aValue = 5);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Map_24;
begin
  var c: TCbor := TBytes.Create(
    $B8, $23, $45, $4E, $6F, $2E, $20, $31, $65, $4E, $6F, $2E, $20, $31, $02, $02,
    $03, $03, $64, $6E, $61, $6D, $65, $6B, $45, $72, $6B, $69, $6E, $20, $51, $61,
    $64, $69, $72, $67, $69, $73, $6F, $43, $6F, $64, $65, $62, $41, $51, $63, $57,
    $48, $4F, $63, $4A, $6F, $65, $64, $57, $48, $41, $54, $63, $43, $61, $72, $66,
    $41, $4D, $4F, $55, $4E, $54, $14, $65, $66, $72, $75, $69, $74, $65, $41, $70,
    $70, $6C, $65, $64, $73, $69, $7A, $65, $65, $4C, $61, $72, $67, $65, $65, $63,
    $6F, $6C, $6F, $72, $63, $52, $65, $64, $43, $6B, $65, $79, $6F, $EF, $BD, $96,
    $EF, $BD, $81, $EF, $BD, $8C, $EF, $BD, $95, $EF, $BD, $85, $45, $61, $72, $72,
    $61, $79, $85, $01, $02, $03, $04, $05, $67, $6F, $70, $74, $69, $6F, $6E, $73,
    $84, $0A, $62, $31, $31, $42, $31, $32, $2C, $66, $61, $6E, $73, $77, $65, $72,
    $0C, $68, $6C, $61, $6E, $67, $75, $61, $67, $65, $66, $55, $79, $67, $68, $75,
    $72, $62, $69, $64, $70, $47, $56, $36, $54, $41, $31, $41, $41, $54, $5A, $59,
    $42, $4A, $33, $56, $52, $63, $62, $69, $6F, $76, $50, $68, $61, $73, $65, $6C,
    $6C, $75, $73, $20, $6D, $61, $73, $73, $61, $20, $6C, $69, $67, $75, $6C, $61,
    $67, $76, $65, $72, $73, $69, $6F, $6E, $03, $04, $04, $05, $05, $06, $06, $07,
    $07, $08, $08, $09, $09, $0A, $0A, $18, $64, $18, $64, $19, $03, $E8, $19, $03,
    $E8, $19, $27, $10, $19, $27, $10, $19, $07, $DD, $39, $02, $64, $19, $07, $CD,
    $39, $03, $84, $19, $07, $CB, $1A, $00, $BB, $B2, $D5, $19, $07, $CA, $1A, $00,
    $8B, $29, $DB, $19, $07, $C9, $19, $01, $35, $19, $07, $C8, $19, $04, $B4
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCbor_Map := c.AsMap;
  Check(TCbor_ByteString(ans.aValue[0].Key).aValue[0] = 'No. 1'); Check(TCbor_UTF8(ans.aValue[0].Value).aValue[0] = 'No. 1');
  Check(TCbor_UInt64(ans.aValue[1].Key).aValue = 2);              Check(TCbor_UInt64(ans.aValue[1].Value).aValue = 2);
  Check(TCbor_UInt64(ans.aValue[2].Key).aValue = 3);              Check(TCbor_UInt64(ans.aValue[2].Value).aValue = 3);
  Check(TCbor_UTF8(ans.aValue[3].Key).aValue[0] = 'name');        Check(TCbor_UTF8(ans.aValue[3].Value).aValue[0] = 'Erkin Qadir');
  Check(TCbor_UTF8(ans.aValue[4].Key).aValue[0] = 'isoCode');     Check(TCbor_UTF8(ans.aValue[4].Value).aValue[0] = 'AQ');
  Check(TCbor_UTF8(ans.aValue[5].Key).aValue[0] = 'WHO');         Check(TCbor_UTF8(ans.aValue[5].Value).aValue[0] = 'Joe');
  Check(TCbor_UTF8(ans.aValue[6].Key).aValue[0] = 'WHAT');        Check(TCbor_UTF8(ans.aValue[6].Value).aValue[0] = 'Car');
  Check(TCbor_UTF8(ans.aValue[7].Key).aValue[0] = 'AMOUNT');      Check(TCbor_UInt64(ans.aValue[7].Value).aValue = 20);
  Check(TCbor_UTF8(ans.aValue[8].Key).aValue[0] = 'fruit');       Check(TCbor_UTF8(ans.aValue[8].Value).aValue[0] = 'Apple');
  Check(TCbor_UTF8(ans.aValue[9].Key).aValue[0] = 'size');        Check(TCbor_UTF8(ans.aValue[9].Value).aValue[0] = 'Large');
  Check(TCbor_UTF8(ans.aValue[10].Key).aValue[0] = 'color');      Check(TCbor_UTF8(ans.aValue[10].Value).aValue[0] = 'Red');
  Check(TCbor_ByteString(ans.aValue[11].Key).aValue[0] = 'key');  Check(TCbor_UTF8(ans.aValue[11].Value).aValue[0] = 'ｖａｌｕｅ');
  Check(TCbor_ByteString(ans.aValue[12].Key).aValue[0] = 'array');
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[12].Value).aValue[0]).aValue = 1);
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[12].Value).aValue[1]).aValue = 2);
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[12].Value).aValue[2]).aValue = 3);
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[12].Value).aValue[3]).aValue = 4);
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[12].Value).aValue[4]).aValue = 5);
  Check(TCbor_UTF8(ans.aValue[13].Key).aValue[0] = 'options');
  Check(TCbor_UInt64(TCbor_Array(ans.aValue[13].Value).aValue[0]).aValue = 10);
  Check(TCbor_UTF8(TCbor_Array(ans.aValue[13].Value).aValue[1]).aValue[0] = '11');
  Check(TCbor_ByteString(TCbor_Array(ans.aValue[13].Value).aValue[2]).aValue[0] = '12');
  Check(TCbor_Int64(TCbor_Array(ans.aValue[13].Value).aValue[3]).aValue = '-13');
  Check(TCbor_UTF8(ans.aValue[14].Key).aValue[0] = 'answer');     Check(TCbor_UInt64(ans.aValue[14].Value).aValue = 12);
  Check(TCbor_UTF8(ans.aValue[15].Key).aValue[0] = 'language');   Check(TCbor_UTF8(ans.aValue[15].Value).aValue[0] = 'Uyghur');
  Check(TCbor_UTF8(ans.aValue[16].Key).aValue[0] = 'id');         Check(TCbor_UTF8(ans.aValue[16].Value).aValue[0] = 'GV6TA1AATZYBJ3VR');
  Check(TCbor_UTF8(ans.aValue[17].Key).aValue[0] = 'bio');        Check(TCbor_UTF8(ans.aValue[17].Value).aValue[0] = 'Phasellus massa ligula');
  Check(TCbor_UTF8(ans.aValue[18].Key).aValue[0] = 'version');    Check(TCbor_UInt64(ans.aValue[18].Value).aValue = 3);
  Check(TCbor_UInt64(ans.aValue[19].Key).aValue = 4);             Check(TCbor_UInt64(ans.aValue[19].Value).aValue = 4);
  Check(TCbor_UInt64(ans.aValue[20].Key).aValue = 5);             Check(TCbor_UInt64(ans.aValue[20].Value).aValue = 5);
  Check(TCbor_UInt64(ans.aValue[21].Key).aValue = 6);             Check(TCbor_UInt64(ans.aValue[21].Value).aValue = 6);
  Check(TCbor_UInt64(ans.aValue[22].Key).aValue = 7);             Check(TCbor_UInt64(ans.aValue[22].Value).aValue = 7);
  Check(TCbor_UInt64(ans.aValue[23].Key).aValue = 8);             Check(TCbor_UInt64(ans.aValue[23].Value).aValue = 8);
  Check(TCbor_UInt64(ans.aValue[24].Key).aValue = 9);             Check(TCbor_UInt64(ans.aValue[24].Value).aValue = 9);
  Check(TCbor_UInt64(ans.aValue[25].Key).aValue = 10);            Check(TCbor_UInt64(ans.aValue[25].Value).aValue = 10);
  Check(TCbor_UInt64(ans.aValue[26].Key).aValue = 100);           Check(TCbor_UInt64(ans.aValue[26].Value).aValue = 100);
  Check(TCbor_UInt64(ans.aValue[27].Key).aValue = 1000);          Check(TCbor_UInt64(ans.aValue[27].Value).aValue = 1000);
  Check(TCbor_UInt64(ans.aValue[28].Key).aValue = 10000);         Check(TCbor_UInt64(ans.aValue[28].Value).aValue = 10000);
  Check(TCbor_UInt64(ans.aValue[29].Key).aValue = 2013);          Check(TCbor_Int64(ans.aValue[29].Value).aValue = '-613');
  Check(TCbor_UInt64(ans.aValue[30].Key).aValue = 1997);          Check(TCbor_Int64(ans.aValue[30].Value).aValue = '-901');
  Check(TCbor_UInt64(ans.aValue[31].Key).aValue = 1995);          Check(TCbor_UInt64(ans.aValue[31].Value).aValue = 12301013);
  Check(TCbor_UInt64(ans.aValue[32].Key).aValue = 1994);          Check(TCbor_UInt64(ans.aValue[32].Value).aValue = 9120219);
  Check(TCbor_UInt64(ans.aValue[33].Key).aValue = 1993);          Check(TCbor_UInt64(ans.aValue[33].Value).aValue = 309);
  Check(TCbor_UInt64(ans.aValue[34].Key).aValue = 1992);          Check(TCbor_UInt64(ans.aValue[34].Value).aValue = 1204);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Map_31;
begin
  var c: TCbor := TBytes.Create(
    $BF, $01, $66, $4B, $4E, $6A, $4F, $6F, $4E, $02, $46, $4B, $73, $45, $4F, $6B,
    $4A, $03, $39, $02, $64, $19, $07, $CD, $39, $03, $84, $FF
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCbor_Map := c.AsMap;
  Check(TCbor_UInt64(ans.aValue[0].Key).aValue = 1);
  Check(TCbor_UTF8(ans.aValue[0].Value).aValue[0] = 'KNjOoN');
  Check(TCbor_UInt64(ans.aValue[1].Key).aValue = 2);
  Check(TCbor_ByteString(ans.aValue[1].Value).aValue[0] = 'KsEOkJ');
  Check(TCbor_UInt64(ans.aValue[2].Key).aValue = 3);
  Check(TCbor_Int64(ans.aValue[2].Value).aValue = '-613');
  Check(TCbor_UInt64(ans.aValue[3].Key).aValue = 1997);
  Check(TCbor_Int64(ans.aValue[3].Value).aValue = '-901');

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_0;
begin
  var c: TCbor := TBytes.Create($20, $21, $22, $37);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals('-1', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals('-2', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals('-3', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals('-24', c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_64;
begin
  var c: TCbor := TBytes.Create(
    $3b, $00, $00, $05, $55, $83, $80, $50, $1a
  , $3b, $00, $02, $8e, $9e, $bb, $b6, $c7, $4a
  );

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals('-5864836583451', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals('-719762358716235', c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_32;
begin
  var c: TCbor := TBytes.Create($3a, $00, $17, $79, $a7, $3a, $00, $31, $53, $3f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals('-1538472', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals('-3232576', c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_8;
begin
  var c: TCbor := TBytes.Create($38, $18, $38, $19);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals('-25', c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals('-26', c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_0;
begin
  var c: TCbor := TBytes.Create($00, $01, $17);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(0, c.AsUInt64.aValue);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(1, c.AsUInt64.aValue);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(23, c.AsUInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_8;
begin
  var c: TCbor := TBytes.Create($18, $EB);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(235, c.AsUInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_16;
begin
  var c: TCbor := TBytes.Create($19, $30, $3B);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(12347, c.AsUInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_32;
begin
  var c: TCbor := TBytes.Create($1A, $00, $03, $A9, $80);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(240000, c.AsUInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_64;
begin
  var c: TCbor := TBytes.Create($1B, $00, $1F, $E0, $22, $99, $A3, $8B, $8C);

  CheckTrue(c.Next);
  var ansUInt64 : TCbor_UInt64 := c.AsUInt64;
  CheckEquals(ansUInt64.aValue, 8972163489172364);
  Check(ansUInt64.aType = cborUnsigned);

  var a : TCborItem_TBytes := ansUInt64;
  var b := TBytes.Create($1B, $00, $1F, $E0, $22, $99, $A3, $8B, $8C);;
  for var i := Low(a.aValue) to High(a.aValue) do
    CheckEquals(b[i], a.aValue[i]);
  Check(a.aType = cborUnsigned);

  var ansUInt64_2 : TCbor_UInt64 := a;
  CheckEquals(ansUInt64_2.aValue, 8972163489172364);
  Check(ansUInt64_2.aType = cborUnsigned);

  CheckFalse(c.Next);
end;

initialization
  RegisterTest(TTestCase_cbor.Suite);
end.
