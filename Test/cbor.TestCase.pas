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
    procedure Test_TborUInt64_0;

    procedure Test_EncodeInt64_0;
    procedure Test_EncodeInt64_1;
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

    procedure Test_UInt64ToTBytes_0;
    procedure Test_UInt64ToTBytes_1;
    procedure Test_UInt64ToTBytes_2;
    procedure Test_UInt64ToTBytes_3;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils,
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
  CheckEquals(-53872, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(-2576, c.AsInt64.aValue);

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

procedure TTestCase_cbor.Test_TborUInt64_0;
begin
  var c: TCbor := TBytes.Create($01);

  CheckTrue(c.Next);
  var ansUInt64 : TCbor_UInt64 := c.AsUInt64;
  CheckEquals(ansUInt64.aValue, 1);
  Check(ansUInt64.aType = cborUnsigned);

  var ansTCborDataItem : TCborDataItem := ansUInt64;
  CheckEquals(ansTCborDataItem.aValue, '1');
  Check(ansTCborDataItem.aType = cborUnsigned);

  var ansUInt64_2 : TCbor_UInt64 := ansTCborDataItem;
  CheckEquals(ansUInt64_2.aValue, 1);
  Check(ansUInt64_2.aType = cborUnsigned);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_EncodeArray_0;
begin
  var c: TCbor_Array;
  c.aValue := [TCbor_Uint64.Create(1, false, cborUnsigned)] + [TCbor_UInt64.Create(2, false, cborUnsigned)] + [TCbor_UInt64.Create(3, false, cborUnsigned)];
  c.aType := cborArray;
  c.aIsIndefiniteLength := false;

  var d := TBytes.Create($83, $01, $02, $03);
  var e := c.EncodeArray;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_1;
begin
  var c: TCbor_Array;
  c.aValue := [TCbor_Uint64.Create(10220110, false, cborUnsigned)] + [TCbor_Uint64.Create(122, false, cborUnsigned)]
              + [TCbor_int64.Create(-3333333, false, cborSigned)] + [TCbor_utf8.Create(['Go reach out to get ya'], false, cborUTF8)];
  c.aType := cborArray;
  c.aIsIndefiniteLength := false;

  var d  := TBytes.Create(
    $84, $1A, $00, $9B, $F2, $4E, $18, $7A, $3A, $00, $32, $DC, $D4, $76, $47, $6F,
    $20, $72, $65, $61, $63, $68, $20, $6F, $75, $74, $20, $74, $6F, $20, $67, $65,
    $74, $20, $79, $61
  );
  var e := c.EncodeArray;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_2;
begin
  var c: TCbor_Array;
  c.aValue := [TCbor_ByteString.Create(['Return Value is a byte array containing ', 'the results of encoding the specified character sequence.'], true, cborByteString)] +
              [TCbor_Utf8.Create(['Provident neque ullam corporis sed.'], false, cborUTF8)]
              + [TCbor_Uint64.Create(12123, false, cborUnsigned)] + [TCbor_Int64.Create(-789789, false, cborSigned)] + [TCbor_Int64.Create(-1, false, cborSigned)];
  c.aType := cborArray;
  c.aIsIndefiniteLength := true;

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
  var e := c.EncodeArray;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeInt64_0;
begin
  var c:= TCbor_Int64.Create(-55493, false, cborSigned);

  var d := Encode_int64(c);
  var ans := TBytes.Create($39, $D8, $C4);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]); 
end;

procedure TTestCase_cbor.Test_EncodeInt64_1;
begin
  var c:= TCbor_Int64.Create(-199709011230, false, cborSigned);

  var d := Encode_int64(c);
  var ans := TBytes.Create($3B, $00, $00, $00, $2E, $7F, $95, $AD, $1D);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_TCborInt64_0;
begin
  var c: TCbor := TBytes.Create($39, $d2, $6f);

  CheckTrue(c.Next);
  var ansInt64 : TCbor_Int64 := c.AsInt64;
  CheckEquals(ansInt64.aValue, -53872);
  Check(ansInt64.aType = cborSigned);

  var ansTCborDataItem : TCborDataItem := ansInt64;
  CheckEquals(ansTCborDataItem.aValue, '-53872');
  Check(ansTCborDataItem.aType = cborSigned);

  var ansInt64_2 : TCbor_Int64 := ansTCborDataItem;
  CheckEquals(ansInt64_2.aValue, -53872);
  Check(ansInt64_2.aType = cborSigned);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_EncodeByteString_0;
begin
  var c:= TCbor_ByteString.Create(['W1073 Combining signed type and unsigned 64-bit type - treated as an unsigned type'], false, cborByteString);

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
  var c:= TCbor_ByteString.Create(['hELlo w0rLd'], false, cborByteString);

  var d:= TBytes.Create($4B, $68, $45, $4C, $6C, $6F, $20, $77, $30, $72, $4C, $64);
  var e:= Encode_ByteString(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_2;
begin
  var c:= TCbor_ByteString.Create(['hello', '01', #$01#$02#$03#$04], true, cborByteString);

  var d:= TBytes.Create($5F, $45, $68, $65, $6C, $6C, $6F, $42, $30, $31, $44, $01, $02, $03, $04, $FF);
  var e:= Encode_ByteString(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_3;
begin
  var c:= TCbor_ByteString.Create(['Return Value is a byte array containing ', 'the results of encoding the specified character sequence.'], true, cborByteString);

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
  var c:= TCbor_UTF8.Create(['𝓱'], false, cborUTF8);

  var d:= TBytes.Create($64, $F0, $9D, $93, $B1);
  var e:= Encode_utf8(c);
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeUtf8_1;
begin
  var c:= TCbor_UTF8.Create(['Shine on me', 'Everything was going so well until I was accosted by a purple giraffe.', '𝓱𝓪𝓱𝓪'], true, cborUTF8);

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
//  CheckEquals('''
//  ጎክ ፕዘቿ ዕልዪጕ ዕልሠክ, ነየዪቿልዕጎክኗ ፕዪቿጠጌረጎክኗ ሠጎክኗነ. ጕቿቿየ ዐክ ነዘጎክጎክኗ ጠልጕቿ ጎፕ ጌዪጎኗዘፕቿዪ ፕዘልክ ል ነየዐፕረጎኗዘፕ.....ᴰᴱᴸᴾᴴᴵ
//  ''', c.AsUTF8.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Array_0;
begin
  var c: TCbor := TBytes.Create($82, $01, $45, $68, $65, $6C, $6C, $6F);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
//  var ans : TCborArray := c.AsArray.aValue;
//  OutputDebugString(PChar(ans));
//  Check(ans[0] = 1);
//  Check(ans[1] = 'hello');
end;

procedure TTestCase_cbor.Test_Array_1;
begin
  var c: TCbor := TBytes.Create($82, $01, $82, $02, $03);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
//  var ans : TCborArray := c.AsArray;
//
//  Check(ans[0] = 1);
//  Check(ans[1][0] = 2);
//  Check(ans[1][1] = 3);
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
//  var ans : TCborArray := c.AsArray;
//  Check(ans[0] = 1);
//  Check(ans[1] = 2);
//  Check(ans[2] = 3);
//  Check(ans[3] = 4);
//  Check(ans[4] = 5);
//  Check(ans[5] = 'hi');
//  Check(ans[6] = '乃乇');
//  Check(ans[7] = -22);
//  Check(ans[8] = -222);
//  Check(ans[9][0] = 1);
//  Check(ans[9][1] = 2);
//  Check(ans[10] = 300);
//  Check(ans[11] = 600);
//  Check(ans[12] = 900);
//  Check(ans[13] = -1200);
//  Check(ans[14] = 'BTS');
//  Check(ans[15] = 'Go');
//  Check(ans[16] = 'your');
//  Check(ans[17] = 'own');
//  Check(ans[18] = 'way');
//  Check(ans[19][0] = 'Put');
//  Check(ans[19][1] = 'weakness');
//  Check(ans[19][2] = 'away');
//  Check(ans[19][3] = 2013);
//  Check(ans[20] = 21);
//  Check(ans[21] = 22);
//  Check(ans[22] = 23);
//  Check(ans[23] = 24);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Array_31;
begin
  var c: TCbor := TBytes.Create(
    $9F, $01, $45, $68, $65, $6C, $6C, $6F, $82, $01, $02, $81, $9F, $01, $02, $FF, $FF
  );

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);

//  var ans : TCborArray := c.AsArray;
//  Check(ans[0] = 1);
//  Check(ans[1] = 'hello');
//  Check(ans[2][0] = 1);
//  Check(ans[2][1] = 2);
//  Check(ans[3][0][0] = 1);
//  Check(ans[3][0][1] = 2);

  CheckFalse(c.Next);

end;

procedure TTestCase_cbor.Test_Map_0;
begin
  var c: TCbor := TBytes.Create(
    $A2, $61, $74, $19, $04, $D2, $61, $6C, $19, $09, $29
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCborMap := c.AsMap;
  Check(ans[0].bKey = 't');
  Check(ans[0].bValue = 1234);
  Check(ans[1].bKey = 'l');
  Check(ans[1].bValue = 2345);
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

  var ans : TCborMap := c.AsMap;
  Check(ans[0].bKey = 1);
  Check(ans[0].bValue = 'JJK');
  Check(ans[1].bKey = 2);
  Check(ans[1].bValue = -1000000);
  Check(ans[2].bKey = 'key');
  Check(ans[2].bValue = 'ｖａｌｕｅ');
  Check(ans[3].bKey = 'array');
  Check(ans[3].bValue[0] = 1);
  Check(ans[3].bValue[1] = 2);
  Check(ans[3].bValue[2] = 3);
  Check(ans[3].bValue[3] = 4);
  Check(ans[3].bValue[4] = 5);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Map_2;
begin
  var c: TCbor := TBytes.Create(
//    $A3, $65, $48, $65, $6C, $6C, $6F, $67, $49, $74, $27, $73, $20, $6D, $65, $49,
//    $4C, $65, $74, $20, $69, $74, $20, $67, $6F, $A2, $6E, $4C, $65, $74, $20, $69,
//    $74, $20, $67, $6F, $6F, $6F, $6F, $6F, $6F, $78, $1A, $43, $61, $6E, $27, $74,
//    $20, $68, $6F, $6C, $64, $20, $69, $74, $20, $62, $61, $63, $6B, $20, $61, $6E,
//    $79, $6D, $6F, $72, $65, $6C, $4C, $65, $74, $20, $69, $74, $20, $67, $6F, $2E,
//    $2E, $2E, $71, $4C, $45, $54, $20, $49, $54, $20, $67, $4F, $6F, $4F, $6F, $4F,
//    $6F, $4F, $6F, $4F, $68, $53, $74, $61, $6E, $64, $69, $6E, $67, $6B, $4E, $65,
//    $78, $74, $20, $74, $6F, $20, $79, $6F, $75
    $A3, $01, $02, $03, $A2, $18, $1F, $0D, $18, $20, $17, $04, $05
  );

  CheckTrue(c.Next);
  Check(cborMap = c.DataType);

  var ans : TCborMap := c.AsMap;
  Check(ans[0].bKey = 1);
  Check(ans[0].bValue = 2);
  Check(ans[1].bKey = 3);
  Check(ans[1].bValue[0].bKey = 31);
  Check(ans[1].bValue[0].bValue = 13);
  Check(ans[1].bValue[1].bKey = 32);
  Check(ans[1].bValue[1].bValue = 23);
  Check(ans[2].bKey = 4);
  Check(ans[2].bValue = 5);

//  Check(ans[0].bKey = 'Hello');
//  Check(ans[0].bValue = '''
//  It's me
//  ''');
//  Check(ans[1].bKey = 'Let it go');
//  Check(ans[1].bValue[0].bKey = 'Let it goooooo');
//  Check(ans[1].bValue[0].bValue = '''
//  Can't hold it back anymore
//  ''');
//  Check(ans[1].bValue[1].bKey = 'Let it go...');
//  Check(ans[1].bValue[1].bValue = 'LET IT gOoOoOoOoO');
//  Check(ans[2].bKey = 'Standing');
//  Check(ans[2].bValue = 'Next to you');

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

  var ans : TCborMap := c.AsMap;
  Check(ans[0].bKey = 'No. 1'); Check(ans[0].bValue = 'No. 1');
  Check(ans[1].bKey = 2); Check(ans[1].bValue = 2);
  Check(ans[2].bKey = 3); Check(ans[2].bValue = 3);
  Check(ans[3].bKey = 'name'); Check(ans[3].bValue = 'Erkin Qadir');
  Check(ans[4].bKey = 'isoCode'); Check(ans[4].bValue = 'AQ');
  Check(ans[5].bKey = 'WHO'); Check(ans[5].bValue = 'Joe');
  Check(ans[6].bKey = 'WHAT');  Check(ans[6].bValue = 'Car');
  Check(ans[7].bKey = 'AMOUNT'); Check(ans[7].bValue = 20);
  Check(ans[8].bKey = 'fruit');  Check(ans[8].bValue = 'Apple');
  Check(ans[9].bKey = 'size'); Check(ans[9].bValue = 'Large');
  Check(ans[10].bKey = 'color');  Check(ans[10].bValue = 'Red');
  Check(ans[11].bKey = 'key');  Check(ans[11].bValue = 'ｖａｌｕｅ');
  Check(ans[12].bKey = 'array');
  Check(ans[12].bValue[0] = 1);
  Check(ans[12].bValue[1] = 2);
  Check(ans[12].bValue[2] = 3);
  Check(ans[12].bValue[3] = 4);
  Check(ans[12].bValue[4] = 5);
  Check(ans[13].bKey = 'options');
  Check(ans[13].bValue[0] = 10);
  Check(ans[13].bValue[1] = '11');
  Check(ans[13].bValue[2] = '12');
  Check(ans[13].bValue[3] = -13);
  Check(ans[14].bKey = 'answer'); Check(ans[14].bValue = 12);
  Check(ans[15].bKey = 'language'); Check(ans[15].bValue = 'Uyghur');
  Check(ans[16].bKey = 'id'); Check(ans[16].bValue = 'GV6TA1AATZYBJ3VR');
  Check(ans[17].bKey = 'bio');  Check(ans[17].bValue = 'Phasellus massa ligula');
  Check(ans[18].bKey = 'version');  Check(ans[18].bValue = 3);
  Check(ans[19].bKey = 4);  Check(ans[19].bValue = 4);
  Check(ans[20].bKey = 5);  Check(ans[20].bValue = 5);
  Check(ans[21].bKey = 6);  Check(ans[21].bValue = 6);
  Check(ans[22].bKey = 7);  Check(ans[22].bValue = 7);
  Check(ans[23].bKey = 8);  Check(ans[23].bValue = 8);
  Check(ans[24].bKey = 9);  Check(ans[24].bValue = 9);
  Check(ans[25].bKey = 10);  Check(ans[25].bValue = 10);
  Check(ans[26].bKey = 100);  Check(ans[26].bValue = 100);
  Check(ans[27].bKey = 1000);  Check(ans[27].bValue = 1000);
  Check(ans[28].bKey = 10000);  Check(ans[28].bValue = 10000);
  Check(ans[29].bKey = 2013);  Check(ans[29].bValue = -613);
  Check(ans[30].bKey = 1997);  Check(ans[30].bValue = -901);
  Check(ans[31].bKey = 1995);  Check(ans[31].bValue = 12301013);
  Check(ans[32].bKey = 1994);  Check(ans[32].bValue = 9120219);
  Check(ans[33].bKey = 1993);  Check(ans[33].bValue = 309);
  Check(ans[34].bKey = 1992);  Check(ans[34].bValue = 1204);

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

  var ans : TCborMap := c.AsMap;
  Check(ans[0].bKey = 1);
  Check(ans[0].bValue = 'KNjOoN');
  Check(ans[1].bKey = 2);
  Check(ans[1].bValue = 'KsEOkJ');
  Check(ans[2].bKey = 3);
  Check(ans[2].bValue = -613);
  Check(ans[3].bKey = 1997);
  Check(ans[3].bValue = -901);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_0;
begin
  var c: TCbor := TBytes.Create($20, $21, $22, $37);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-1, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-2, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-3, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-24, c.AsInt64.aValue);

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
  CheckEquals(-5864836583451, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals(-719762358716235, c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_32;
begin
  var c: TCbor := TBytes.Create($3a, $00, $17, $79, $a7, $3a, $00, $31, $53, $3f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(-1538472, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(-3232576, c.AsInt64.aValue);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_8;
begin
  var c: TCbor := TBytes.Create($38, $18, $38, $19);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(-25, c.AsInt64.aValue);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(-26, c.AsInt64.aValue);

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

//  CheckTrue(c.Next);
//  Check(cborUnsigned = c.DataType);
//  CheckEquals(9, c.DataItemSize);
//  CheckEquals(8972163489172364, c.AsUInt64.aValue);

  CheckTrue(c.Next);
  var ansUInt64 : TCbor_UInt64 := c.AsUInt64;
  CheckEquals(ansUInt64.aValue, 8972163489172364);
  Check(ansUInt64.aType = cborUnsigned);

  var ansTCborDataItem : TCborDataItem := ansUInt64;
  CheckEquals(ansTCborDataItem.aValue, '8972163489172364');
  Check(ansTCborDataItem.aType = cborUnsigned);

  var ansUInt64_2 : TCbor_UInt64 := ansTCborDataItem;
  CheckEquals(ansUInt64_2.aValue, 8972163489172364);
  Check(ansUInt64_2.aType = cborUnsigned);

  CheckFalse(c.Next);
end;

initialization
  RegisterTest(TTestCase_cbor.Suite);
end.
