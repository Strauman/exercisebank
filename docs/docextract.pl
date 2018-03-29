#!/usr/bin/perl
use strict;
use warnings;
# Examples:
#%\BDOC
#%\macroname[oarg]{marg}{marg}
#%Description goes
#%here and then you do
#%\EDOC
#%\BDOC
#%\begin{env}[oarg1]{marg}
#% This environment also does something
#% that is amazing!
#%\EDOC

# Config
my $output = "documentation.tex";
my $input = "$ARGV[0]";
my $macroTemplateFile = "templates/macrodef.tex";
my $skeletonTemplateFile = "templates/docskeleton.tex";
my $envTemplateFile = "templates/envdef.tex";
my $exampleTemplateFile = "templates/exampletemplate.tex";
my $toFile = 1;
# File loading
sub talk
{
  my ($words) = @_;
	# print STDERR "$words";
}

if ($toFile==1){
  open (my $OUTPUT, '>', "$output") or die $!;
  STDOUT->fdopen(\*$OUTPUT, 'w') or die $!;
}
# Template files
my $macroTemplate;
my $envTemplate;
my $exampleTemplate;
my $skeleton;
open(my $FILE, "<", $input) or die "could not open input file '$input'\n";
# Load template code

{
  local $/ = undef;
  open FILE, $macroTemplateFile or die "Couldn't open file: $!";
  binmode FILE;
  $macroTemplate = <FILE>;
  close FILE;
}
{
  local $/ = undef;
  open FILE, $envTemplateFile or die "Couldn't open file: $!";
  binmode FILE;
  $envTemplate = <FILE>;
  close FILE;
}
{
  local $/ = undef;
  open FILE, $exampleTemplateFile or die "Couldn't open file: $!";
  binmode FILE;
  $exampleTemplate = <FILE>;
  close FILE;
}
{
  local $/ = undef;
  open FILE, $skeletonTemplateFile or die "Couldn't open file: $!";
  binmode FILE;
  $skeleton = <FILE>;
  close FILE;
}

# Strings for output
my $docOutString="";
my $priorityOutString="";
my $currentTemplate="";
my $description="";
my $example="";
my $triggers="";
# States
my $capturestate=0; # \BDOC \EDOC
my $descriptionstate=0;
my $examplestate=0;
my $prioritystate=0;

# Patterns
my $pOarg=qr/(?:\[(?<oarg>.*?)\])?/;
my $pMargs=qr/(?=(?<margs>(?:{[^}]*})*))?/;
my $pStyleArgs=qr/(?:\[(?<styleArgs>.*?)\])?/;
# Macros
my $pMacro=qr/\\(?<macroname>[a-zA-Z]+)/;
my $macroPattern=qr/^[%]\s*+${pMacro}${pOarg}${pMargs}${pStyleArgs}/;
# Environment
my $pEnv=qr/\\\\begin\{(?<envname>[^\}]+)\}/;
my $envPattern=qr/^[%]\s*+${$pEnv}${pOarg}${pMargs}${pStyleArgs}/;
# Other globals
my $line;
# Replacing macros with \dac
my $dacSearch=qr/\\((?!(?:dac|oarg|marg|meta|refCom|refEnv|brackets))[a-zA-Z]+)/;
my $bracketSearch=qr/\\(?!(?:dac|oarg|marg|meta|refCom|refEnv|brackets))[a-zA-Z]+\K\{([^\}]+)\}/;

sub extractMacro
{
  # Look for macro syntax.
  # Macros containing @ is not included
  # /$macroPattern/;
  # talk "$+{macroname}\n";
  # talk "$+{oarg}\n";
  # talk "$+{margs}\n";
  my $margs = $+{margs};
  my $oargs = $+{oarg};
  my $macroname = $+{macroname};
  my $styleArgs = $+{styleArgs};
  $margs =~ s/(\{[^\}]*\})/\\marg$1/g;
  # talk "OA";
  # print $oargs;
  # talk ($oargs==0);
  if($oargs){
    $oargs = "\\oarg{$oargs}";
  }
  else{
    $oargs="";
  }
  $currentTemplate = $macroTemplate =~ s/§margs/$margs/r;
  $currentTemplate =~ s/§oargs/$oargs/;
  $currentTemplate =~ s/§mname/$macroname/;
  if(!$styleArgs){
    $styleArgs="";
  }
  $currentTemplate =~ s/§style/$styleArgs/;
  $descriptionstate=1;
}
sub extractEnv
{
  # Look for \newenvironment
  # Macros containing @ is not included
  # /$macroPattern/;
  # talk "$+{envname}\n";
  # talk "$+{oarg}\n";
  # talk "$+{margs}\n";
  my $margs = $+{margs};
  my $oargs = $+{oarg};
  my $envname = $+{envname};
  my $styleArgs = $+{styleArgs};
  if(!$styleArgs){
    $styleArgs="";
  }
  if(!$oargs){
    $oargs="";
  }else{
    $oargs = "\\oarg{$oargs}";
  }
  $margs =~ s/(\{[^\}]*\})/\\marg$1/g;
  $currentTemplate = $envTemplate =~ s/§margs/$margs/r;
  $currentTemplate =~ s/§oargs/$oargs/;
  $currentTemplate =~ s/§envname/$envname/;
  $currentTemplate =~ s/§style/$styleArgs/;
  $descriptionstate=1;
}
sub extractDesc
{
  if(/^[%]+\s*\\EDOC!?/){
    $capturestate=0;
    $descriptionstate=0;
    $currentTemplate =~ s/§description/$description/;
    if($prioritystate==1){
      $priorityOutString.=$currentTemplate;
    }else{
      $docOutString.=$currentTemplate;
    }
    $prioritystate=0;
    $currentTemplate="";
    $description="";
  }elsif(s/^[%]+(.*)//){
    $_= $line;
    s/$bracketSearch/\\\{$1\\\}/g;
    s/$dacSearch/\\dac{$1}/g;
    s/^\s*[%]+(.*)/$1/;
    $description.=$_;
  }
}
sub extractExample
{
  if(/^[%]+\s*\\EEX!?/){
    $examplestate=0;
    $currentTemplate = $exampleTemplate;
    $currentTemplate =~ s/§content/$example/;
    $currentTemplate =~ s/§style//;
    if($prioritystate==1){
      $priorityOutString.=$currentTemplate;
    }else{
      $docOutString.=$currentTemplate;
    }
    $prioritystate=0;
    $currentTemplate="";
    $example="";
  }elsif(s/^%(.*)//){
    $_= $line;
    s/^\s*[%]+(.*)/$1/;
    s/$bracketSearch/\\\{$1\\\}/g;
    s/$dacSearch/\\dac{$1}/g;
    # s/(?:\s|\})\K\{([^\}]+)\}/\\\{$1\\\}/g;
    $example.="$_\n";
  }
}
sub extractDoc
{
  if($descriptionstate==1){
    extractDesc();
  }
  elsif(/$macroPattern/){
    extractMacro();
  }
  elsif(/$envPattern/){
    extractEnv();
  }else{
    $currentTemplate = "§description\n";
    $descriptionstate=1;
    extractDesc();
  }
}
sub sumstates{
  $capturestate+$examplestate;
}

while ($line = <$FILE>) {
  $_=$line;
  # Ignore if line does not start with comment
  if(/^[^%]/){
    next;
  }
  if(/^[%]+\s*\\BDOC(?!!)/){
    $capturestate=1;
    $prioritystate=0;
    next;}
  elsif(/^[%]+\s*\\BDOC!/){
    $capturestate=1;
    $prioritystate=1;
    next;

  }elsif(/^[%]\s*\\BEX(?!!)/){
    $prioritystate=0;
    $examplestate=1;
    next;
  }
  elsif(/^[%]\s*\\BEX!/){
    $examplestate=1;
    $prioritystate=1;
    next;
  }
  elsif($capturestate==1){
    extractDoc();
  }elsif($examplestate==1){
    extractExample();
  }elsif(/^[ \s\t]*[%]+\s*\\Trigger\\([a-zA-Z]+):(.*)/){
    $triggers.="\\dac{At}\\dac{$1}\\\\ $2\\\\\n";
  }

}
$docOutString = "$priorityOutString\n$docOutString";
$docOutString =~ s/§triggers/$triggers/;
$docOutString = $skeleton =~ s/§content/$docOutString/r;

# talk "$docOutString\n";
print $docOutString;
