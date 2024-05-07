program cbor.test;

uses
  FastMM5,
  {$ifdef TestInsight}TestInsight.DUnit,{$endif}
  {$ifndef TestInsight}DUnitTestRunner,{$endif}
  cbor in '..\cbor.pas',
  cbor.TestCase in 'cbor.TestCase.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  RunRegisteredTests;
end.
