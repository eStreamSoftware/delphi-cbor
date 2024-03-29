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
    procedure Test_Signed_128;

    procedure Test_ByteString_0;
    procedure Test_ByteString_1;
    procedure Test_ByteString_2;
    procedure Test_ByteString_3;
    procedure Test_ByteString_4;
    procedure Test_ByteString_5;
    procedure Test_ByteString_6;
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
    procedure Test_Array_2;
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

    procedure Test_Special_0;
    procedure Test_Special_1;
    procedure Test_Special_2;

    procedure Test_Special_16Bit_0;
    procedure Test_Special_16Bit_1;
    procedure Test_Special_16Bit_2;
    procedure Test_Special_16Bit_3;
    procedure Test_Special_16Bit_4;
    procedure Test_Special_16Bit_5;
    procedure Test_Special_16Bit_6;
    procedure Test_Special_16Bit_7;
    procedure Test_Special_16Bit_8;
    procedure Test_Special_16Bit_9;
    procedure Test_Special_16Bit_10;
    procedure Test_Special_16Bit_11;

    procedure Test_Special_32BitFloat_0;
    procedure Test_Special_32BitFloat_1;
    procedure Test_Special_32BitFloat_2;
    procedure Test_Special_32BitFloat_3;
    procedure Test_Special_32BitFloat_4;
    procedure Test_Special_32BitFloat_5;
    procedure Test_Special_32BitFloat_6;
    procedure Test_Special_32BitFloat_7;

    procedure Test_Special_64BitFloat_0;
    procedure Test_Special_64BitFloat_1;
    procedure Test_Special_64BitFloat_2;
    procedure Test_Special_64BitFloat_3;
    procedure Test_Special_64BitFloat_4;
    procedure Test_Special_64BitFloat_5;
    procedure Test_Special_64BitFloat_6;
    procedure Test_Special_64BitFloat_7;
  end;

implementation

uses
  Winapi.Windows, System.Generics.Collections, System.SysUtils, System.Variants,
  Data.FMTBcd,
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

procedure TTestCase_cbor.Test_Signed_128;
begin
  var c: TCBor := TBytes.Create($3B, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(-1, c.AsInt64.Value);
  // ans = -18446744073709551615
  // overflow
end;

procedure TTestCase_cbor.Test_Signed_16;
begin
  var c: TCbor := TBytes.Create($39, $d2, $6f, $39, $0a, $0f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(-53872, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(-2576, c.AsInt64.Value);

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
  CheckEquals('Hello World', c.AsByteString.Value[0]);

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
  ''', c.AsByteString.Value[0]);

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
  , c.AsByteString.Value[0]
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
  '''), c.AsByteString.Value[0]);

  CheckTrue(c.Next);
  Check(cborByteString = c.DataType);
  CheckEquals(123, c.DataItemSize);
  CheckEquals(AnsiString('''
  Maecenas fermentum urna vitae ipsum tincidunt, sed interdum justo rhoncus.
  Integer quis sem quis tellus faucibus tempor.
  ''' ), c.AsByteString.Value[0]);

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
  CheckEquals(AnsiString('Integer quis sem quist.'), c.AsByteString.Value[0]);

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
  CheckEquals(#$01#$02#$03#$04, c.AsByteString.Value[0]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_ByteString_6;
begin
  var c: TCbor := TBytes.Create(
    $5F, $44, $68, $69, $68, $69, $43, $42, $54, $53, $4B, $68, $45, $4C, $6C, $6F,
    $20, $77, $30, $72, $4C, $64, $5F, $45, $68, $65, $6C, $6C, $6F, $42, $30, $31,
    $FF, $FF
  );

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  var ans := c.AsByteString.Value;
  CheckEquals('hihi', ans[0]);
  CheckEquals('BTS', ans[1]);
  CheckEquals('hELlo w0rLd', ans[2]);
  CheckEquals('hello01', ans[3]);
  // Expected ans := (_ 'hihi', 'BTS', 'hELlo w0rLd', 'hello01')
end;

procedure TTestCase_cbor.Test_EncodeUInt64_0;
begin
  var c := TCbor_UInt64.Create(455);

  var d := c.Encode_uint64;
  var ans := TBytes.Create($19, $01, $C7);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_1;
begin
  var c := TCbor_UInt64.Create(199709011230);

  var d := c.Encode_uint64;
  var ans := TBytes.Create($1B, $00, $00, $00, $2E, $7F, $95, $AD, $1E);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_2;
begin
  var c := TCbor_UInt64.Create(1);

  var d := c.Encode_uint64;
  var ans := TBytes.Create($01);
  CheckEquals(ans[0], d[0]);
end;

procedure TTestCase_cbor.Test_EncodeUInt64_3;
begin
  var c:= TCbor_UInt64.Create(18446744073709551615);

  var d := c.Encode_uint64;
  var ans := TBytes.Create($1B, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_TborUInt64_0;
begin
  var c: TCbor := TBytes.Create($01);

  CheckTrue(c.Next);
  var ansUInt64 : TCbor_UInt64 := c.AsUInt64;
  CheckEquals(ansUInt64.Value, 1);
  Check(ansUInt64.cborType = cborUnsigned);

  var a : TCborItem := ansUInt64;
  CheckEquals(a.Value[0], $01);
  Check(a.cborType = cborUnsigned);

  var ansUInt64_2 : TCbor_UInt64 := a;
  CheckEquals(ansUInt64_2.Value, 1);
  Check(ansUInt64_2.cborType = cborUnsigned);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_EncodeArray_0;
begin
  var c := TCbor_Array.Create([TCbor_Uint64.Create(1, cborUnsigned)] + [TCbor_UInt64.Create(2, cborUnsigned)] + [TCbor_UInt64.Create(3, cborUnsigned)], false);

  var d := TBytes.Create($83, $01, $02, $03);
  var e := c.Encode_Array;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_1;
begin
  var c := TCbor_Array.Create([TCbor_Uint64.Create(10220110, cborUnsigned)] + [TCbor_Uint64.Create(122, cborUnsigned)]
              + [TCbor_int64.Create(-3333333)] + [TCbor_utf8.Create(['Go reach out to get ya'])],  false);

  var d  := TBytes.Create(
    $84, $1A, $00, $9B, $F2, $4E, $18, $7A, $3A, $00, $32, $DC, $D4, $76, $47, $6F,
    $20, $72, $65, $61, $63, $68, $20, $6F, $75, $74, $20, $74, $6F, $20, $67, $65,
    $74, $20, $79, $61
  );
  var e := c.Encode_Array;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_2;
begin
  var arr: TArray<TCborItem> := [TCbor_ByteString.Create(['Return Value is a byte array containing ', 'the results of encoding the specified character sequence.'])]
              + [TCbor_Utf8.Create(['Provident neque ullam corporis sed.'])]
              + [TCbor_Uint64.Create(12123)] + [TCbor_Int64.Create(-789789)] + [TCbor_Int64.Create(-1)];

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
  var e := TCbor_Array.Create(arr, true).Encode_Array;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeArray_3;
begin
  var arrNested: TArray<TCborItem> :=  [TCbor_Uint64.Create(555)] + [TCbor_ByteString.Create(['Nested', 'arraY'])]
              + [TCbor_Map.Create([TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(6), TCbor_Uint64.Create(6))])];

  var arr: TArray<TCborItem> := [TCbor_Uint64.Create(1)] + [TCbor_UTF8.Create(['lol'])]
              + [TCbor_Array.Create(arrNested, false)] + [TCbor_Int64.Create(-999)];

  var d  := TBytes.Create(
    $9F, $01, $63, $6C, $6F, $6C, $83, $19, $02, $2B, $5F, $46, $4E, $65, $73, $74,
    $65, $64, $45, $61, $72, $72, $61, $59, $FF, $A1, $06, $06, $39, $03, $E6, $FF
  );
  var f := TCbor_Array.Create(arr, true);
  var e := f.Encode_Array;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeInt64_0;
begin
  var c:= TCbor_Int64.Create(-55493);

  var d := c.Encode_Int64;
  var ans := TBytes.Create($39, $D8, $C4);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeInt64_1;
begin
  var c:= TCbor_Int64.Create(-199709011230);

  var d := c.Encode_int64;
  var ans := TBytes.Create($3B, $00, $00, $00, $2E, $7F, $95, $AD, $1D);
  for var i := 0 to Length(ans)-1 do
    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeInt64_2;
begin
//  var c:= TCbor_Int64.Create(-18446744073709551615);
//  var d := c.Encode_int64;
//  var ans := TBytes.Create($3B, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
//  for var i := 0 to Length(ans)-1 do
//    CheckEquals(ans[i], d[i]);
end;

procedure TTestCase_cbor.Test_EncodeMap_0;
begin
  var p : TArray<TPair<TCborItem, TCborItem>> :=
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(20, cborUnsigned), TCbor_ByteString.Create(['Twenty']))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(21, cborUnsigned), TCbor_ByteString.Create(['Twenty-One']))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_Int64.Create(-22), TCbor_UTF8.Create(['-Twenty-Two']))];

  var d := TBytes.Create(
    $A3, $14, $46, $54, $77, $65, $6E, $74, $79, $15, $4A, $54, $77, $65, $6E, $74,
    $79, $2D, $4F, $6E, $65, $35, $6B, $2D, $54, $77, $65, $6E, $74, $79, $2D, $54,
    $77, $6F);

  var e := TCbor_Map.Create(p, false).Encode_Map;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeMap_1;
begin
  var arr : TArray<TCborItem> := [TCbor_ByteString.Create(['L'])] + [TCbor_ByteString.Create(['E'])] + [TCbor_ByteString.Create(['V'])]
    + [TCbor_ByteString.Create(['E'])] + [TCbor_ByteString.Create(['L'])] + [TCbor_ByteString.Create(['I'])]
    + [TCbor_ByteString.Create(['N'])] + [TCbor_ByteString.Create(['G'])];

  var p : TArray<TPair<TCborItem, TCborItem>> :=
    [TPair<TCborItem, TCborItem>.Create(TCbor_UTF8.Create(['!??']), TCbor_Int64.Create(-11111))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_ByteString.Create(['...']),
      TCbor_Map.Create([TPair<TCborItem, TCborItem>.Create(TCbor_ByteString.Create(['.']), TCbor_Uint64.Create(666, cborUnsigned))], false))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(5010, cborUnsigned), TCbor_Array.Create(arr, false))];

  var d := TBytes.Create(
    $A3, $63, $21, $3F, $3F, $39, $2B, $66, $43, $2E, $2E, $2E, $A1, $41, $2E, $19,
    $02, $9A, $19, $13, $92, $88, $41, $4C, $41, $45, $41, $56, $41, $45, $41, $4C,
    $41, $49, $41, $4E, $41, $47);

  var e := TCbor_Map.Create(p, false).Encode_Map;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeMap_2;
begin
  var arr : TArray<TCborItem> := [TCbor_Uint64.Create(2, cborUnsigned)] + [TCbor_Uint64.Create(3, cborUnsigned)];

  var map : TArray<TPair<TCborItem, TCborItem>> :=
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(1, cborUnsigned), TCbor_Uint64.Create(1, cborUnsigned))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(2, cborUnsigned), TCbor_Uint64.Create(2, cborUnsigned))];


  var p : TArray<TPair<TCborItem, TCborItem>> :=
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(1, cborUnsigned), TCbor_UTF8.Create(['Hello', 'Just', 'Kidding']))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(2, cborUnsigned), TCbor_Array.Create(arr, true))] +
    [TPair<TCborItem, TCborItem>.Create(TCbor_Uint64.Create(3, cborUnsigned), TCbor_Map.Create(map, true))];

  var d := TBytes.Create(
    $BF, $01, $7F, $65, $48, $65, $6C, $6C, $6F, $64, $4A, $75, $73, $74, $67, $4B,
    $69, $64, $64, $69, $6E, $67, $FF, $02, $9F, $02, $03, $FF, $03, $BF, $01, $01,
    $02, $02, $FF, $FF);

  var e := TCbor_Map.Create(p, true).Encode_Map;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_TCborInt64_0;
begin
  var c: TCbor := TBytes.Create($39, $d2, $6f);

  CheckTrue(c.Next);
  var ansInt64 : TCbor_Int64 := c.AsInt64;
  CheckEquals(ansInt64.Value, -53872);
  Check(ansInt64.cborType = cborSigned);

  var a : TCborItem := ansInt64;
  var b := TBytes.Create($39, $d2, $6f);
  for var i := Low(b) to High(b) do
    CheckEquals(b[i], a.Value[i]);
  Check(a.cborType = cborSigned);

  var ansInt64_2 : TCbor_Int64 := a;
  CheckEquals(ansInt64_2.Value, -53872);
  Check(ansInt64_2.cborType = cborSigned);

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
  var e:= c.Encode_ByteString;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_1;
begin
  var c:= TCbor_ByteString.Create(['hELlo w0rLd']);

  var d:= TBytes.Create($4B, $68, $45, $4C, $6C, $6F, $20, $77, $30, $72, $4C, $64);
  var e:= c.Encode_ByteString;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeByteString_2;
begin
  var c:= TCbor_ByteString.Create(['hello', '01', #$01#$02#$03#$04]);

  var d:= TBytes.Create($5F, $45, $68, $65, $6C, $6C, $6F, $42, $30, $31, $44, $01, $02, $03, $04, $FF);
  var e:= c.Encode_ByteString;
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
  var e:= c.Encode_ByteString;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_EncodeUtf8_0;
begin
  var c:= TCbor_UTF8.Create(['𝓱']);

  var d:= TBytes.Create($64, $F0, $9D, $93, $B1);
  var e:= c.Encode_utf8;
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
  var e:= c.Encode_utf8;
  for var i := Low(d) to High(d) do
    CheckEquals(d[i], e[i]);
end;

procedure TTestCase_cbor.Test_TCborUTF8_0;
begin
  var c: TCbor := TBytes.Create($62, $C3, $BC);

  CheckTrue(c.Next);
  var ansUTF8 : TCbor_UTF8 := c.AsUTF8;
  Check(cborUTF8 = ansUTF8.cborType);
  CheckEquals('ü', ansUTF8.Value[0]);

  var ansCbor : TCborItem := ansUTF8;
  Check(cborUTF8 = ansCbor.cborType);
  var d := TBytes.Create($62, $C3, $BC);
  for var i := Low(ansCbor.Value) to High(ansCbor.Value) do
    CheckEquals(ansCbor.Value[i], d[i]);

  var ansUTF82 : TCbor_UTF8 := c.AsUTF8;
  Check(cborUTF8 = ansUTF82.cborType);
  CheckEquals('ü', ansUTF82.Value[0]);

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
  CheckEquals('hihi', d.Value[0]);
  CheckEquals('BTS', d.Value[1]);
  CheckEquals('''
  Maecenas fermentum urna vitae ipsum tincidunt, sed interdum justo rhoncus.
  Integer quis sem quis tellus faucibus tempor.
  '''
  , d.Value[2]
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
  , c.AsUTF8.Value[0]
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
  ''', c.AsUTF8.Value[0]);

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  CheckEquals(47, c.DataItemSize);
  CheckEquals('''
  Is ʇɥǝ ʍɐʎ ʇo ɟᴉup ʇɥɐʇ dɐʇɥ
  ''', c.AsUTF8.Value[0]);

  CheckFalse(c.Next);

end;

procedure TTestCase_cbor.Test_UTF8_2;
begin
  var c: TCbor := TBytes.Create($62, $22, $5C);

  CheckTrue(c.Next);
  Check(cborUTF8 = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals('"\', c.AsUTF8.Value[0]);

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
  CheckEquals('🆃🅷🆁🅾🆆 🅰🆆🅰🆈', d.Value[0]);
  CheckEquals('🆃🅷🅴 🅵🅴🅰🆁', d.Value[1]);

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
  CheckEquals('🆃🅷🆁🅾🆆 🅰🆆🅰🆈', d.Value[0]);
  CheckEquals('🆃🅷🅴 🅵🅴🅰🆁', d.Value[1]);
  CheckEquals('🆃🅷🆁🅾🆆 🅰🆆🅰🆈', d.Value[2]);
  CheckEquals('🆃🅷🅴 🅵🅴🅰🆁', d.Value[3]);
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
  ''', d.Value[0]);
  CheckEquals('𝓨𝓸𝓾 𝓪𝓻𝓮 𝓽𝓱𝓮 𝓬𝓪𝓾𝓼𝓮 𝓸𝓯 𝓶𝔂 𝓔𝓾𝓹𝓱𝓸𝓻𝓲𝓪', d.Value[1]);
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
  ''', d.Value[0]);
  CheckEquals('''
  ᴰᴱᴸᴾᴴᴵ
  ''', d.Value[1]);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Array_0;
begin
  var c: TCbor := TBytes.Create($82, $01, $45, $68, $65, $6C, $6C, $6F);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
  var ans : TCbor_Array := c.AsArray;
  Check(TCbor_Uint64(ans.Value[0]).Value = 1);
  Check(TCbor_ByteString(ans.Value[1]).Value[0] = 'hello');
end;

procedure TTestCase_cbor.Test_Array_1;
begin
  var c: TCbor := TBytes.Create($82, $01, $82, $02, $03);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
  var ans : TCbor_Array := c.AsArray;

  Check(TCbor_Uint64(ans.Value[0]).Value = 1);
  Check(TCbor_Uint64(TCbor_Array(ans.Value[1]).Value[0]).Value = 2);
  Check(TCbor_Uint64(TCbor_Array(ans.Value[1]).Value[1]).Value = 3);
end;

procedure TTestCase_cbor.Test_Array_2;
begin
  var c: TCbor := TBytes.Create($80);

  CheckTrue(c.Next);
  Check(cborArray = c.DataType);
  var ans : TCbor_Array := c.AsArray;
  CheckEquals(Length(ans.Value), 0);

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
  Check(TCbor_UInt64(ans.Value[0]).Value = 1);
  Check(TCbor_UInt64(ans.Value[1]).Value = 2);
  Check(TCbor_UInt64(ans.Value[2]).Value = 3);
  Check(TCbor_UInt64(ans.Value[3]).Value = 4);
  Check(TCbor_UInt64(ans.Value[4]).Value = 5);
  Check(TCbor_ByteString(ans.Value[5]).Value[0] = 'hi');
  Check(TCbor_UTF8(ans.Value[6]).Value[0] = '乃乇');
  Check(TCbor_Int64(ans.Value[7]).Value = -22);
  Check(TCbor_Int64(ans.Value[8]).Value = -222);
  Check(TCbor_UInt64(TCbor_Array(ans.Value[9]).Value[0]).Value = 1);
  Check(TCbor_UInt64(TCbor_Array(ans.Value[9]).Value[1]).Value = 2);
  Check(TCbor_UInt64(ans.Value[10]).Value = 300);
  Check(TCbor_UInt64(ans.Value[11]).Value = 600);
  Check(TCbor_UInt64(ans.Value[12]).Value = 900);
  Check(TCbor_Int64(ans.Value[13]).Value = -1200);
  Check(TCbor_ByteString(ans.Value[14]).Value[0] = 'BTS');
  Check(TCbor_ByteString(ans.Value[15]).Value[0] = 'Go');
  Check(TCbor_ByteString(ans.Value[16]).Value[0] = 'your');
  Check(TCbor_ByteString(ans.Value[17]).Value[0] = 'own');
  Check(TCbor_ByteString(ans.Value[18]).Value[0] = 'way');
  Check(TCbor_UTF8(TCbor_Array(ans.Value[19]).Value[0]).Value[0] = 'Put');
  Check(TCbor_UTF8(TCbor_Array(ans.Value[19]).Value[1]).Value[0] = 'weakness');
  Check(TCbor_UTF8(TCbor_Array(ans.Value[19]).Value[2]).Value[0] = 'away');
  Check(TCbor_UInt64(TCbor_Array(ans.Value[19]).Value[3]).Value = 2013);
  Check(TCbor_UInt64(ans.Value[20]).Value = 21);
  Check(TCbor_UInt64(ans.Value[21]).Value = 22);
  Check(TCbor_UInt64(ans.Value[22]).Value = 23);
  Check(TCbor_UInt64(ans.Value[23]).Value = 24);

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
  Check(TCbor_Uint64(ans.Value[0]).Value = 1);
  Check(TCbor_ByteString(ans.Value[1]).Value[0] = 'hello');
  Check(TCbor_Uint64(TCbor_Array(ans.Value[2]).Value[0]).Value = 1);
  Check(TCbor_Uint64(TCbor_Array(ans.Value[2]).Value[1]).Value = 2);
  Check(TCbor_Uint64(TCbor_Array(TCbor_Array(ans.Value[3]).Value[0]).Value[0]).Value = 1);
  Check(TCbor_Uint64(TCbor_Array(TCbor_Array(ans.Value[3]).Value[0]).Value[1]).Value = 2);

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
  Check(TCbor_UTF8(ans.Value[0].Key).Value[0] = 't');
  Check(TCbor_UInt64(ans.Value[0].Value).Value = 1234);
  Check(TCbor_UTF8(ans.Value[1].Key).Value[0] = 'l');
  Check(TCbor_UInt64(ans.Value[1].Value).Value = 2345);
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
  Check(TCbor_UInt64(ans.Value[0].Key).Value = 1);
  Check(TCbor_UTF8(ans.Value[0].Value).Value[0] = 'JJK');
  Check(TCbor_UInt64(ans.Value[1].Key).Value = 2);
  Check(TCbor_Int64(ans.Value[1].Value).Value = -1000000);
  Check(TCbor_ByteString(ans.Value[2].Key).Value[0] = 'key');
  Check(TCbor_UTF8(ans.Value[2].Value).Value[0] = 'ｖａｌｕｅ');
  Check(TCbor_ByteString(ans.Value[3].Key).Value[0] = 'array');
  var a : TCbor_Array := ans.Value[3].Value;
  Check(TCbor_UInt64(a.Value[0]).Value = 1);
  Check(TCbor_UInt64(a.Value[1]).Value = 2);
  Check(TCbor_UInt64(a.Value[2]).Value = 3);
  Check(TCbor_UInt64(a.Value[3]).Value = 4);
  Check(TCbor_UInt64(a.Value[4]).Value = 5);

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
  Check(TCbor_UInt64(ans.Value[0].Key).Value = 1);
  Check(TCbor_UInt64(ans.Value[0].Value).Value = 2);
  Check(TCbor_UInt64(ans.Value[1].Key).Value = 3);
  Check(TCbor_UInt64(TCbor_Map(ans.Value[1].Value).Value[0].Key).Value = 31);
  Check(TCbor_UInt64(TCbor_Map(ans.Value[1].Value).Value[0].Value).Value = 13);
  Check(TCbor_UInt64(TCbor_Map(ans.Value[1].Value).Value[1].Key).Value = 32);
  Check(TCbor_UInt64(TCbor_Map(ans.Value[1].Value).Value[1].Value).Value = 23);
  Check(TCbor_UInt64(ans.Value[2].Key).Value = 4);
  Check(TCbor_UInt64(ans.Value[2].Value).Value = 5);

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
  Check(TCbor_ByteString(ans.Value[0].Key).Value[0] = 'No. 1'); Check(TCbor_UTF8(ans.Value[0].Value).Value[0] = 'No. 1');
  Check(TCbor_UInt64(ans.Value[1].Key).Value = 2);              Check(TCbor_UInt64(ans.Value[1].Value).Value = 2);
  Check(TCbor_UInt64(ans.Value[2].Key).Value = 3);              Check(TCbor_UInt64(ans.Value[2].Value).Value = 3);
  Check(TCbor_UTF8(ans.Value[3].Key).Value[0] = 'name');        Check(TCbor_UTF8(ans.Value[3].Value).Value[0] = 'Erkin Qadir');
  Check(TCbor_UTF8(ans.Value[4].Key).Value[0] = 'isoCode');     Check(TCbor_UTF8(ans.Value[4].Value).Value[0] = 'AQ');
  Check(TCbor_UTF8(ans.Value[5].Key).Value[0] = 'WHO');         Check(TCbor_UTF8(ans.Value[5].Value).Value[0] = 'Joe');
  Check(TCbor_UTF8(ans.Value[6].Key).Value[0] = 'WHAT');        Check(TCbor_UTF8(ans.Value[6].Value).Value[0] = 'Car');
  Check(TCbor_UTF8(ans.Value[7].Key).Value[0] = 'AMOUNT');      Check(TCbor_UInt64(ans.Value[7].Value).Value = 20);
  Check(TCbor_UTF8(ans.Value[8].Key).Value[0] = 'fruit');       Check(TCbor_UTF8(ans.Value[8].Value).Value[0] = 'Apple');
  Check(TCbor_UTF8(ans.Value[9].Key).Value[0] = 'size');        Check(TCbor_UTF8(ans.Value[9].Value).Value[0] = 'Large');
  Check(TCbor_UTF8(ans.Value[10].Key).Value[0] = 'color');      Check(TCbor_UTF8(ans.Value[10].Value).Value[0] = 'Red');
  Check(TCbor_ByteString(ans.Value[11].Key).Value[0] = 'key');  Check(TCbor_UTF8(ans.Value[11].Value).Value[0] = 'ｖａｌｕｅ');
  Check(TCbor_ByteString(ans.Value[12].Key).Value[0] = 'array');
  Check(TCbor_UInt64(TCbor_Array(ans.Value[12].Value).Value[0]).Value = 1);
  Check(TCbor_UInt64(TCbor_Array(ans.Value[12].Value).Value[1]).Value = 2);
  Check(TCbor_UInt64(TCbor_Array(ans.Value[12].Value).Value[2]).Value = 3);
  Check(TCbor_UInt64(TCbor_Array(ans.Value[12].Value).Value[3]).Value = 4);
  Check(TCbor_UInt64(TCbor_Array(ans.Value[12].Value).Value[4]).Value = 5);
  Check(TCbor_UTF8(ans.Value[13].Key).Value[0] = 'options');
  Check(TCbor_UInt64(TCbor_Array(ans.Value[13].Value).Value[0]).Value = 10);
  Check(TCbor_UTF8(TCbor_Array(ans.Value[13].Value).Value[1]).Value[0] = '11');
  Check(TCbor_ByteString(TCbor_Array(ans.Value[13].Value).Value[2]).Value[0] = '12');
  Check(TCbor_Int64(TCbor_Array(ans.Value[13].Value).Value[3]).Value = -13);
  Check(TCbor_UTF8(ans.Value[14].Key).Value[0] = 'answer');     Check(TCbor_UInt64(ans.Value[14].Value).Value = 12);
  Check(TCbor_UTF8(ans.Value[15].Key).Value[0] = 'language');   Check(TCbor_UTF8(ans.Value[15].Value).Value[0] = 'Uyghur');
  Check(TCbor_UTF8(ans.Value[16].Key).Value[0] = 'id');         Check(TCbor_UTF8(ans.Value[16].Value).Value[0] = 'GV6TA1AATZYBJ3VR');
  Check(TCbor_UTF8(ans.Value[17].Key).Value[0] = 'bio');        Check(TCbor_UTF8(ans.Value[17].Value).Value[0] = 'Phasellus massa ligula');
  Check(TCbor_UTF8(ans.Value[18].Key).Value[0] = 'version');    Check(TCbor_UInt64(ans.Value[18].Value).Value = 3);
  Check(TCbor_UInt64(ans.Value[19].Key).Value = 4);             Check(TCbor_UInt64(ans.Value[19].Value).Value = 4);
  Check(TCbor_UInt64(ans.Value[20].Key).Value = 5);             Check(TCbor_UInt64(ans.Value[20].Value).Value = 5);
  Check(TCbor_UInt64(ans.Value[21].Key).Value = 6);             Check(TCbor_UInt64(ans.Value[21].Value).Value = 6);
  Check(TCbor_UInt64(ans.Value[22].Key).Value = 7);             Check(TCbor_UInt64(ans.Value[22].Value).Value = 7);
  Check(TCbor_UInt64(ans.Value[23].Key).Value = 8);             Check(TCbor_UInt64(ans.Value[23].Value).Value = 8);
  Check(TCbor_UInt64(ans.Value[24].Key).Value = 9);             Check(TCbor_UInt64(ans.Value[24].Value).Value = 9);
  Check(TCbor_UInt64(ans.Value[25].Key).Value = 10);            Check(TCbor_UInt64(ans.Value[25].Value).Value = 10);
  Check(TCbor_UInt64(ans.Value[26].Key).Value = 100);           Check(TCbor_UInt64(ans.Value[26].Value).Value = 100);
  Check(TCbor_UInt64(ans.Value[27].Key).Value = 1000);          Check(TCbor_UInt64(ans.Value[27].Value).Value = 1000);
  Check(TCbor_UInt64(ans.Value[28].Key).Value = 10000);         Check(TCbor_UInt64(ans.Value[28].Value).Value = 10000);
  Check(TCbor_UInt64(ans.Value[29].Key).Value = 2013);          Check(TCbor_Int64(ans.Value[29].Value).Value = -613);
  Check(TCbor_UInt64(ans.Value[30].Key).Value = 1997);          Check(TCbor_Int64(ans.Value[30].Value).Value = -901);
  Check(TCbor_UInt64(ans.Value[31].Key).Value = 1995);          Check(TCbor_UInt64(ans.Value[31].Value).Value = 12301013);
  Check(TCbor_UInt64(ans.Value[32].Key).Value = 1994);          Check(TCbor_UInt64(ans.Value[32].Value).Value = 9120219);
  Check(TCbor_UInt64(ans.Value[33].Key).Value = 1993);          Check(TCbor_UInt64(ans.Value[33].Value).Value = 309);
  Check(TCbor_UInt64(ans.Value[34].Key).Value = 1992);          Check(TCbor_UInt64(ans.Value[34].Value).Value = 1204);

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
  Check(TCbor_UInt64(ans.Value[0].Key).Value = 1);
  Check(TCbor_UTF8(ans.Value[0].Value).Value[0] = 'KNjOoN');
  Check(TCbor_UInt64(ans.Value[1].Key).Value = 2);
  Check(TCbor_ByteString(ans.Value[1].Value).Value[0] = 'KsEOkJ');
  Check(TCbor_UInt64(ans.Value[2].Key).Value = 3);
  Check(TCbor_Int64(ans.Value[2].Value).Value = -613);
  Check(TCbor_UInt64(ans.Value[3].Key).Value = 1997);
  Check(TCbor_Int64(ans.Value[3].Value).Value = -901);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_0;
begin
  var c: TCbor := TBytes.Create($20, $21, $22, $37);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-1, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-2, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-3, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(-24, c.AsInt64.Value);

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
  CheckEquals(-5864836583451, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(9, c.DataItemSize);
  CheckEquals(-719762358716235, c.AsInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_32;
begin
  var c: TCbor := TBytes.Create($3a, $00, $17, $79, $a7, $3a, $00, $31, $53, $3f);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(-1538472, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(-3232576, c.AsInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Signed_8;
begin
  var c: TCbor := TBytes.Create($38, $18, $38, $19);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(-25, c.AsInt64.Value);

  CheckTrue(c.Next);
  Check(cborSigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(-26, c.AsInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Special_0;
begin
  var c: TCbor := TBytes.Create($F4);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  CheckFalse(c.AsSpecial);
end;

procedure TTestCase_cbor.Test_Special_1;
begin
   var c: TCbor := TBytes.Create($F5);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  CheckTrue(c.AsSpecial);
end;

procedure TTestCase_cbor.Test_Special_2;
begin
  var c: TCbor := TBytes.Create($F6);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var d : Variant := c.AsSpecial;
  Check(d = Null);
end;

procedure TTestCase_cbor.Test_Special_16Bit_0;
begin
  var c: TCbor := TBytes.Create($F9, $3E, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  CheckEquals(0, BcdCompare(1.5, b));
end;

procedure TTestCase_cbor.Test_Special_16Bit_1;
begin
  var c: TCbor := TBytes.Create($F9, $7C, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(1.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_2;
begin
  var c: TCbor := TBytes.Create($F9, $FC, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(-1.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_3;
begin
  var c: TCbor := TBytes.Create($F9, $80, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(-0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_4;
begin
  var c: TCbor := TBytes.Create($F9, $7E, $02);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(0.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_5;
begin
  var c: TCbor := TBytes.Create($F9, $CE, $1F);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  CheckEquals(0, BcdCompare(-24.484375, c.AsSpecial));
end;

procedure TTestCase_cbor.Test_Special_16Bit_6;
begin
  var c: TCbor := TBytes.Create($F9, $7B, $FF);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(65504.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_7;
begin
  var c: TCbor := TBytes.Create($F9, $00, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_8;
begin
  var c: TCbor := TBytes.Create($F9, $3C, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b :TBcd := c.AsSpecial;
  Check(1.0 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_9;
begin
  var c: TCbor := TBytes.Create($F9, $04, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(0.00006103515625 = b);
end;

procedure TTestCase_cbor.Test_Special_16Bit_10;
begin
  var c: TCbor := TBytes.Create($F9, $00, $01);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  var s := BcdToStr(b);
  CheckEquals(s, '0.000000059604644775390625');
//  CheckTrue(b = 0.000000059604644775390625);
//  CheckEquals(0, BcdCompare(b, 0.000000059604644775390625));
end;

procedure TTestCase_cbor.Test_Special_16Bit_11;
begin
  var c: TCbor := TBytes.Create($F9, $C4, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  CheckEquals(0, BcdCompare(-4.0, c.AsSpecial));
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_0;
begin
  var c: TCbor := TBytes.Create($FA, $7F, $80, $00, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(1.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_1;
begin
  var c: TCbor := TBytes.Create($FA, $FF, $80, $00, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(-1.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_2;
begin
  var c: TCbor := TBytes.Create($FA, $7F, $80, $08, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  Check(0.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_3;
begin
  var c: TCbor := TBytes.Create($FA, $9E, $8F, $88, $10);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b : TBcd := c.AsSpecial;
  CheckEquals('-0.0000000000000000000151969880632183667248523602222309847320502740330994129180908203125', BcdToStr(b));
//  CheckEquals(0, BcdCompare(-0.0000000000000000000151969880632183667248523602222309847320502740330994129180908203125, b));
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_4;
begin
   var c: TCbor := TBytes.Create($FA, $52, $E5, $8B, $9C);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var a := c.AsSpecial;
  var b : TBcd := a;
  CheckEquals('492944883712.0', BcdToStr(b));
//  Check(0 = BcdCompare(492944883712.0, b));

//Check(8388608 = pow(2, 23));
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_5;
begin
  var c: TCbor := TBytes.Create($FA, $12, $E5, $8B, $9C);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
//  Check(SameValue(1.44863481517551e-2, c.AsSpecial));
  CheckEquals(0.000000000000000000000000001448634815175513617983697764181463637879541776765091043444044771604239940643310546875, c.AsSpecial);
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_6;
begin
  var c: TCbor := TBytes.Create($FA, $47, $C3, $50, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  CheckEquals(100000.0, c.AsSpecial);
end;

procedure TTestCase_cbor.Test_Special_32BitFloat_7;
begin
  var c: TCbor := TBytes.Create($FA, $7F, $7F, $FF, $FF);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  CheckEquals(0, BcdCompare('340282346638528859811704183484516925440', c.AsSpecial));
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_0;
begin
  var c: TCbor := TBytes.Create($FB, $40, $09, $21, $FB, $54, $44, $2D, $18);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check('3.141592653589793' = b);
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_1;
begin
  var c: TCbor := TBytes.Create($FB, $7F, $F0, $00, $00, $00, $00, $00, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check(1.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_2;
begin
  var c: TCbor := TBytes.Create($FB, $FF, $F0, $00, $00, $00, $00, $00, $00);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check(-1.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_3;
begin
  var c: TCbor := TBytes.Create($FB, $FF, $F1, $29, $00, $0F, $41, $80, $09);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check(0.0/0.0 = b);
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_4;
begin
  var c: TCbor := TBytes.Create($FB, $81, $A2, $09, $10, $8E, $05, $D0, $09);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  var ans : TBcd := '-0.00000000000000000000000000000000000000000000000000000000000000000000000000000'
  + '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  + '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  + '000000000000000000000000000000084158954649921470919354930409190165333932896712318500663480181461'
  + '719627424334755743026253016865991704445867305798258518836357469501720753539830223832719145267936'
  + '857684371784260064816971573859977505100493559474588966730159633261110315685823077036969329988840'
  + '653884775780901050705791686569483469040189259994679023644183202678373144404471704770403935135697'
  + '400244287582025987164089401174368120054720639440782540737833925892432789399116756122882070587257'
  + '544807530257568519586687372318348576567329345198016672165758192688428112672941524829975161383474'
  + '818007219799618770869205307770087375393459198451970085272327109125318612594569114142214157756215'
  + '789141198113620441923344539649116050512419282005563472768041907820686653440844793294672854244709014892578125';
  Check(ans = b);
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_5;
begin
  var c: TCbor := TBytes.Create($FB, $3F, $F1, $99, $99, $99, $99, $99, $9A);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check(1.1 = b);
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_6;
begin
  var c: TCbor := TBytes.Create($FB, $7E, $37, $E4, $3C, $88, $00, $75, $9C);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check('1000000000000000052504760255204420248704468581108159154915854115511802457988908195786371375080447864043704443832883878176942523235360430575644792184786706982848387200926575803737830233794788090059368953234970799945081119038967640880074652742780142494579258788820056842838115669472196386865459400540160' = BcdToStr(b));
end;

procedure TTestCase_cbor.Test_Special_64BitFloat_7;
begin
  var c: TCbor := TBytes.Create($FB, $C0, $10, $66, $66, $66, $66, $66, $66);

  CheckTrue(c.Next);
  Check(cborSpecial = c.DataType);
  var b: TBcd := c.AsSpecial;
  Check(-4.1 = b);
end;

procedure TTestCase_cbor.Test_Unsigned_0;
begin
  var c: TCbor := TBytes.Create($00, $01, $17);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(0, c.AsUInt64.Value);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(1, c.AsUInt64.Value);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(1, c.DataItemSize);
  CheckEquals(23, c.AsUInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_8;
begin
  var c: TCbor := TBytes.Create($18, $EB);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(2, c.DataItemSize);
  CheckEquals(235, c.AsUInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_16;
begin
  var c: TCbor := TBytes.Create($19, $30, $3B);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(3, c.DataItemSize);
  CheckEquals(12347, c.AsUInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_32;
begin
  var c: TCbor := TBytes.Create($1A, $00, $03, $A9, $80);

  CheckTrue(c.Next);
  Check(cborUnsigned = c.DataType);
  CheckEquals(5, c.DataItemSize);
  CheckEquals(240000, c.AsUInt64.Value);

  CheckFalse(c.Next);
end;

procedure TTestCase_cbor.Test_Unsigned_64;
begin
  var c: TCbor := TBytes.Create($1B, $00, $1F, $E0, $22, $99, $A3, $8B, $8C);

  CheckTrue(c.Next);
  var ansUInt64 : TCbor_UInt64 := c.AsUInt64;
  CheckEquals(ansUInt64.Value, 8972163489172364);
  Check(ansUInt64.cborType = cborUnsigned);

  var a : TCborItem := ansUInt64;
  var b := TBytes.Create($1B, $00, $1F, $E0, $22, $99, $A3, $8B, $8C);;
  for var i := Low(a.Value) to High(a.Value) do
    CheckEquals(b[i], a.Value[i]);
  Check(a.cborType = cborUnsigned);

  var ansUInt64_2 : TCbor_UInt64 := a;
  CheckEquals(ansUInt64_2.Value, 8972163489172364);
  Check(ansUInt64_2.cborType = cborUnsigned);

  CheckFalse(c.Next);
end;

initialization
  RegisterTest(TTestCase_cbor.Suite);
end.
