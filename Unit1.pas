unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls,IniFiles, ExtCtrls, jsMaxMem, Spin, Menus;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    jsMaxMem1: TjsMaxMem;
    Timer1: TTimer;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    DefragmentMem1: TMenuItem;
    Minimize1: TMenuItem;
    Maximize1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label8: TLabel;
    Panel3: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    procedure intervalle(temps:cardinal);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure jsMaxMem1BeforeDefrag(Sender: TObject);
    procedure jsMaxMem1AfterDefrag(Sender: TObject);
    procedure jsMaxMem1Progress(Sender: TObject; Progress: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label9MouseEnter(Sender: TObject);
    procedure Label9MouseLeave(Sender: TObject);
    procedure DefragmentMem1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  dhakera: integer;
  ramini :TIniFile;

implementation

uses shellapi;

{$R *.DFM}

procedure TForm1.intervalle(temps:Cardinal);
var
 tempsD: Cardinal;
begin
 tempsD:=GetTickCount;
 repeat
  Application.ProcessMessages;
 until ((GetTickCount -tempsD)>=Temps);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 if(spinedit2.value)<dhakera
 then jsMaxMem1.DefragAll
 else jsMaxMem1.DefragMemory(spinedit2.value);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
 jsMaxMem1.Abort;
end;

procedure TForm1.jsMaxMem1BeforeDefrag(Sender: TObject);
begin
 BitBtn1.Enabled:=False;
 BitBtn2.Enabled:=true;
 Timer1.Enabled:=False;
 ProgressBar1.Visible:=true;
end;

procedure TForm1.jsMaxMem1AfterDefrag(Sender: TObject);
begin
 Sleep(1000);
 BitBtn1.Enabled:=true;
 BitBtn2.Enabled:=False;
 Timer1.Enabled:=true;
 ProgressBar1.Position:=0;
end;

procedure TForm1.jsMaxMem1Progress(Sender: TObject; Progress: Integer);
begin
 ProgressBar1.Position:=Progress;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
 Wakt: Cardinal;
 sec,min,hour: integer;
 ssec,smin,shour: string;
begin
 Label4.caption:=Timetostr(Time);
 Wakt:=GetTickCount;
 sec:=Wakt div 1000 mod 60;
 min:=Wakt div 1000 div 60 mod 60;
 hour:=Wakt div 1000 div 60 div 60 mod 24;
 if sec>9
 then ssec:=inttostr(sec)
 else ssec:='0'+inttostr(sec);
 if min>9
 then smin:=inttostr(min)
 else smin:='0'+inttostr(min);
 if hour>9
 then shour:=inttostr(hour)
 else shour:='0'+inttostr(hour);
 Label3.caption:=shour+':'+smin+':'+ssec;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Dhakera:=jsMaxMem1.FreeMemory div (1024*1024) ;
 Label2.caption:=Format('%d KB',[jsMaxMem1.FreeMemory div 1024])+' ('+Floattostr(Int(100*(jsMaxMem1.FreeMemory /jsMaxMem1.TotalMemory)))+'%)';
 Label10.Caption:='Free memory: '+floattostr(round(Dhakera))+' MB.';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Form1.TabSheet1.Show;
 BitBtn2.Enabled:=False;
 RamIni:=TiniFile.Create(changeFileExt(Application.exename,'.ini'));
 try
  SpinEdit2.Value:=RamIni.ReadInteger('options','trytofree',64);
  SpinEdit3.Value:=RamIni.ReadInteger('Options','delay',20);
  CheckBox1.Checked:=RamIni.ReadBool('options','autodefrag',false) ;
 finally
  RamIni.Free;
 end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 RamIni:=TiniFile.Create(changeFileExt(Application.exename,'.ini'));
 try
  RamIni.writeInteger('options','trytofree',SpinEdit2.Value);
  RamIni.writeInteger('Options','delay',SpinEdit3.Value);
  RamIni.writeBool('options','autodefrag',checkbox1.checked) ;
 finally
  RamIni.Free;
 end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 if(checkBox1.Checked=true) and (round(dhakera)<spinedit2.value)
 then
  begin
   repeat
    jsMaxMem1.DefragMemory(spinEdit2.Value);
    Label10.Caption:='Free memory: '+floattostr(0)+' MB.';
   until true
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.Label9Click(Sender: TObject);
begin
 ShellExecute(handle,'open','mailto:zammel.ahmed@gnet.tn',nil,nil,SW_SHOW);
end;

procedure TForm1.Label9MouseEnter(Sender: TObject);
begin
 label9.Font.Color:=clblue;
end;

procedure TForm1.Label9MouseLeave(Sender: TObject);
begin
 label9.Font.Color:=clblack;
end;

procedure TForm1.DefragmentMem1Click(Sender: TObject);
begin
 if(spinedit2.value)<dhakera
 then
  begin
   jsMaxMem1.DefragAll;
   Label10.Caption:='Free memory: '+floattostr(0)+' MB.';
  end
 else
  begin
   jsMaxMem1.DefragMemory(spinedit2.value);
   Label10.Caption:='Free memory: '+floattostr(0)+' MB.';
  end;
end;

end.
